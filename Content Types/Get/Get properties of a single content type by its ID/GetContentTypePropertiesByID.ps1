function Get-SPOContentType{ 
	param (
		[Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
		[Parameter(Mandatory=$true,Position=2)]
		$AdminPassword,
		[Parameter(Mandatory=$true,Position=3)]
		[string]$Url,
		[Parameter(Mandatory=$true,Position=4)]
		[string]$CTID
	)

	  $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($Url)
	  $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $AdminPassword)
	  $ctx.ExecuteQuery() 

	  $ctx.Load($ctx.Web)
	  $cc=$ctx.Web.ContentTypes.GetById($CTID)
	  $ctx.Load($cc)
	  $ctx.ExecuteQuery()

	     $ctx.Load($cc.FieldLinks)
	     $ctx.Load($cc.Fields)
	     $ctx.Load($cc.WorkflowAssociations)
	     $ctx.ExecuteQuery()
	     $cc | Add-Member NoteProperty Web($url)

	foreach($field in $cc.Fields){
	      $PropertyName="Field"+$field.ID
	      $cc | Add-Member NoteProperty $PropertyName($field.Title)
	}

	foreach($fieldlink in $cc.FieldLinks){
	      $PropertyName="Fieldlink"+$fieldlink.ID
	      $cc | Add-Member NoteProperty $PropertyName($fieldlink.Name)
	}

	foreach($workflow in $cc.WorkflowAssociations){
	      $PropertyName="Workflow"+$workflow.ID
	      $cc | Add-Member NoteProperty $PropertyName($workflow.Name)
	}
	     Write-Output $cc
}


  # Paths to SDK. Please verify location on your computer.
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll" 

# Insert the credentials and the name of the admin site
$Username="admin@tenant.onmicrosoft.com"
$AdminPassword=Read-Host -Prompt "Password" -AsSecureString
$AdminUrl="https://tenant.sharepoint.com/sites/teamsitewithlibraries"
$CTID="0x00A7470EADF4194E2E9ED1031B61DA0884"



Get-SPOContentType -Username $Username -AdminPassword $AdminPassword -Url $AdminUrl -CTID $CTID
