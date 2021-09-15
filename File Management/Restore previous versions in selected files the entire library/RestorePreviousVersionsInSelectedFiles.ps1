﻿function Get-SPOFolderFiles
{
param (
        [Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
		[Parameter(Mandatory=$true,Position=2)]
		[string]$Url,
        [Parameter(Mandatory=$true,Position=3)]
		$password,
        [Parameter(Mandatory=$true,Position=4)]
		[string]$ListTitle
		)


  $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($Url)
  $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $password)
  $ctx.Load($ctx.Web)
  $ctx.ExecuteQuery()
  $ll=$ctx.Web.Lists.GetByTitle($ListTitle)
  $ctx.Load($ll)
  $ctx.ExecuteQuery()
  $spqQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
 $spqQuery.ViewXml ="<View Scope='RecursiveAll' /><Where><Eq><FieldRef Name='ServerRelativeUrl'/><Value Type='Text'>/VersionTest/Folder2/FolderWithinFolder</Value></Eq></Where>";
   $itemki=$ll.GetItems($spqQuery)
   $ctx.Load($itemki)
  $ctx.ExecuteQuery()

  foreach($item in $itemki)
  {
    
    
      #  Write-Host $item["FileRef"] -ForegroundColor DarkGreen
        $file =
        $ctx.Web.GetFileByServerRelativeUrl($item["FileRef"]);
        $ctx.Load($file)
        $ctx.Load($file.Versions)
        try{
        $ctx.ExecuteQuery() }
        catch
        {
        continue;
        }
        
        #$file.TimeLastModified
        $date=Get-Date ("2/12/2017")
        
        if($file.TimeLastModified -gt $date)
        {
        
        Write-host $file.Name -ForegroundColor Green 
        if ($file.Versions.Count -eq 0)
        {
          $obj=New-Object PSObject
          $obj | Add-Member NoteProperty ServerRelativeUrl($file.ServerRelativeUrl)
          $obj | Add-Member NoteProperty FileLeafRef($item["FileLeafRef"])
          $obj | Add-Member NoteProperty Versions("No Versions Available")

          #$obj | export-csv -Path $CSVPath -Append

          Write-Output $obj
        }
        elseif($file.TypedObject.ToString() -eq "Microsoft.SharePoint.Client.File")
        {
          
          foreach ($vv in $file.Versions){
          Write-Host $vv.Created $vv.Size $vv.VersionLabel $vv.IsCurrentVersion  $file.Versions.Count
          
         # Write-Output $vv
          
          }
          if($file.Versions[($file.Versions.Count-1)].IsCurrentVersion)
          { 
          $vLabel=$file.Versions[($file.Versions.Count-2)].VersionLabel
          Write-Host "Version to be restored: " $vLabel
          }
          else{ $vLabel=$file.Versions[($file.Versions.Count-1)].VersionLabel
          Write-Host "Version to be restored: " $vLabel  }
          $file.Versions.RestoreByLabel($vLabel)
          $ctx.ExecuteQuery()
          }

        else
        {
$obj = New-Object PSObject
$obj| Add-Member NoteProperty FileLeafRef($item["FileLeafRef"])
          $obj | Add-Member NoteProperty Versions("No Versions Available")
  Write-Output $obj
  }

        
        }

        
  }



        
        


}

#Paths to SDK
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"  
 
#Enter the data
$AdminPassword=Read-Host -Prompt "Enter password" -AsSecureString
$username="t@testova365.onmicrosoft.com"
$Url="https://testova365.sharepoint.com/sites/STS"
$ListTitle="VersionTest"



Get-sPOFolderFiles -Username $username -Url $Url -password $AdminPassword -ListTitle $ListTitle 