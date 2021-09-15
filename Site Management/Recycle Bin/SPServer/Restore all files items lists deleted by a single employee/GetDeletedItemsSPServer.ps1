﻿function Get-DeletedItems
{
param (
  [Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
		[Parameter(Mandatory=$true,Position=2)]
		$AdminPassword,
        [Parameter(Mandatory=$true,Position=3)]
		[string]$Url,
        [Parameter(Mandatory=$true,Position=4)]
		[string]$UserUpn,
        [Parameter(Mandatory=$true)]
		[string]$CSVPath
)
#$password = ConvertTo-SecureString -string $AdminPassword -AsPlainText -Force
  #$ctx=New-Object Microsoft.SharePoint.Client.ClientContext($Url)
  #$ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $AdminPassword)
  $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
  $ctx.Credentials = New-Object System.Net.NetworkCredential($Username, $AdminPassword)
try
{
$ctx.ExecuteQuery()
} catch [Net.WebException] 
        {
            
            Write-Host $Url " failed to connect to the site" $_.Exception.Message.ToString() -ForegroundColor Red
}

 $ctx.Load($ctx.Site)
  $ctx.Load($ctx.Web.Webs)
  $rb=$ctx.Site.RecycleBin
$ctx.Load($rb)
try
{
$ctx.ExecuteQuery()
Write-Host $ctx.Site.Url " Items in the recycle bin: " $rb.Count.ToString()
} catch [Net.WebException] 
        {
            
            Write-Host $ctx.Site.Url " failed" $_.Exception.Message.ToString() -ForegroundColor Red

}

$myarray=@()
for($i=0;$i -lt $rb.Count ;$i++)
{
        
        $ctx.Load($rb[$i].Author)
        $ctx.Load($rb[$i].DeletedBy)
        $ctx.ExecuteQuery()
        $obj = $rb[$i]
        $obj | Add-Member NoteProperty AuthorLoginName($rb[$i].Author.LoginName)
        $obj | Add-Member NoteProperty DeletedByLoginName($rb[$i].DeletedBy.LoginName)
        $myarray+=$obj
Export-CSV -InputObject $obj -LiteralPath $csvPath -Append
}

Write-Host "Items to process: " $myarray.Count
#Export-CSV -InputObject $myarray -LiteralPath $csvPath -Append
$ProceedToRestore=Read-Host "Proceed to restore? y/n"

    if($ProceedToRestore -eq "y")
    {
        for($i=0;$i -lt $myarray.Count ; $i++)
        {
        
            if($myarray[$i].DeletedByLoginName -eq $UserUpn )
            {
                $myarray[$i].Restore()
                try
                {            
                    $ctx.ExecuteQuery()
                    Write-Host $myarray[$i].LeafName " restored" -ForegroundColor Green
                }
                catch [Net.WebException]
                {
                    Write-Host $myarray[$i].LeafName " failed" $_.Message.ToString() -ForegroundColor Red
                }
            }
        }

    }
    elseif($ProceedToRestore -match "n")
    {
        Write-Host "Not restoring"

    }
    else
    {
        Write-Host "Not recognized"
    }


}




# Paths to SDK. Please verify location on your computer.
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll" 
Add-PSSnapin Microsoft.SharePoint.PowerShell

# Insert the credentials and the name of the admin site
$Username="CORPO\Administrator"
$AdminPassword=Read-Host -Prompt "Password" -AsSecureString

$csvPath="C:\Users\Public\expo3.csv"
$userupn="i:0#.w|corpo\administrator"
#Connect-SPOService -Url $adminUrl
$sites=(Get-SPSite -Limit All).Url

foreach($site in $sites)
{

 Get-DeletedItems -Username $Username -AdminPassword $AdminPassword -Url $site -UserUpn $userupn -CSVPath $csvPath

}



