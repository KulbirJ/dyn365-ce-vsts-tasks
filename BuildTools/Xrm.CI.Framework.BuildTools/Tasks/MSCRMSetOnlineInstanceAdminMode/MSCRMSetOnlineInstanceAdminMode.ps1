[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMSetOnlineInstanceAdminMode.ps1'

#Get Parameters
$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$instanceName = Get-VstsInput -Name instanceName -Require
$enable = Get-VstsInput -Name enable -Require -AsBool
$allowBackgroundOperations = Get-VstsInput -Name allowBackgroundOperations -AsBool
$notificationText = Get-VstsInput -Name notificationText

#Print Verbose
Write-Verbose "apiUrl = $apiUrl"
Write-Verbose "username = $username"
Write-Verbose "instanceName = $instanceName"
Write-Verbose "Enable = $enable"
Write-Verbose "AllowBackgroundOperations = $allowBackgroundOperations"
Write-Verbose "NotificationText = $notificationText"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$onlineAPI = 'Microsoft.Xrm.OnlineManagementAPI'
$onlineAPIInfo = Get-MSCRMToolInfo -toolName $onlineAPI
$onlineAPIPath = "$($onlineAPIInfo.Path)"
Require-ToolVersion -toolName $onlineAPI -version $onlineAPIInfo.Version -minVersion '1.2.0.1'
Use-MSCRMTool -toolName $onlineAPI -version $onlineAPIInfo.Version

& "$mscrmToolsPath\xRMCIFramework\9.0.0\SetOnlineInstanceAdminMode.ps1" -ApiUrl $apiUrl -Username $username -Password $password -InstanceName $instanceName  -Enable $enable -AllowBackgroundOperations $allowBackgroundOperations -NotificationText $notificationText -PSModulePath $onlineAPIPath -WaitForCompletion $true -SleepDuration 5

Write-Verbose 'Leaving MSCRMSetOnlineInstanceAdminMode.ps1'
