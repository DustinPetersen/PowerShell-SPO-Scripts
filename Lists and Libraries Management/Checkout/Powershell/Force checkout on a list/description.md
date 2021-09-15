Powershell module.

After import you will have a new cmdlet available which allows you to enable or disable Checkout Requirement for a single list.

It corresponds to the following GUI option:



 

The Set-ListCheckout cmdlet takes the following parameters:
```powershell
 [string]$Username
 ```
The string specifies admin of a given site collection where you want to enforce or disable the enforcement
```powershell
[string]$Url
```
Specifies the url of a site where you have the list
```powershell
[string]$AdminPassword,       
```
Admin's password
```powershell
[bool]$ForceCheckout=$true
```
Specifies whether the documents should be checked out ($true) or disables the Checkout Requirement ($false).
```powershell
[string]$ListName
```
Specifies the title of the list where you want to change the settings.

<hr>

## *Example:*

**PS C:\Windows\system32**> **Import-Module d:\Powershell\ListFunctionsCheckout1.psm1**

**PS C:\Windows\system32**> **Set-ListCheckout -Username trial@trialtrial123.onmicrosoft.com -Url https://trialtrial123.sharepoint.com -ListName doc -AdminPassword Password -ForceCheckout $trueDonePS**
 

 

It uses the following prerequisites. If those libraries are in different location on your computer, please edit the ```.psm1``` file!

 

```PowerShell
# Paths to SDK. Please verify location on your computer. 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"  
 
``` 

 

If you need to change the setting for several lists, you can use CSV file with their titles and loop through them with the cmdlet!


 <br/><br/>
<b>Enjoy and please share your comments and questions!</b>
