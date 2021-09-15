﻿function New-SPOContentType{
	param(
		[Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
		[Parameter(Mandatory=$true,Position=2)]
		$AdminPassword,
		[Parameter(Mandatory=$true,Position=3)]
		[string]$Url
	)

	  $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($Url)
	  $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $AdminPassword)
	  $ctx.ExecuteQuery()


	  $lci =New-Object Microsoft.SharePoint.Client.ContentTypeCreationInformation
	  $lci.Description="Description"
	  $lci.Name="Powershell Content Type222Task Based"
	  #$lci.ID="0x0108009e862727eed04408b2599b25356e7914"
	  $lci.ParentContentType=$ctx.Web.ContentTypes.GetById("0x01")
	  $lci.Group="List Content Types"

	  $ContentType = $ctx.Web.ContentTypes.Add($lci)
	  $ctx.Load($contentType)
	  
	try{
	   $ctx.ExecuteQuery()
	   Write-Host "Content Type " $Title " has been added to " $Url
	}
	catch [Net.WebException]{ 
	   Write-Host $_.Exception.ToString()
	}
}



  # Paths to SDK. Please verify location on your computer.
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll" 

# Insert the credentials and the name of the admin site
$Username="admin@tenant.onmicrosoft.com"
$AdminPassword=Read-Host -Prompt "Password" -AsSecureString
$AdminUrl="https://tenant.sharepoint.com/sites/teamsitewithlibraries"


New-SPOContentType -Username $Username -AdminPassword $AdminPassword -Url $AdminUrl
