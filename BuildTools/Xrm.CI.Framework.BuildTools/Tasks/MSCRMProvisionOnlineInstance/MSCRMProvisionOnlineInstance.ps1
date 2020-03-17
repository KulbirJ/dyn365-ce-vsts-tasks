[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMProvisionOnlineInstance.ps1'

#Get Parameters
$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$domainName = Get-VstsInput -Name domainName -Require
$friendlyName = Get-VstsInput -Name friendlyName -Require
$purpose = Get-VstsInput -Name purpose
$initialUserEmail = Get-VstsInput -Name initialUserEmail -Require
$instanceType = Get-VstsInput -Name instanceType -Require
$serviceVersion = Get-VstsInput -Name serviceVersion -Require
$sales = Get-VstsInput -Name sales -AsBool
$customerService = Get-VstsInput -Name customerService -AsBool
$fieldService = Get-VstsInput -Name fieldService -AsBool
$projectService = Get-VstsInput -Name projectService -AsBool
$languageId = Get-VstsInput -Name languageId -AsInt
$currencyCode = Get-VstsInput -Name currencyCode
$currencyName = Get-VstsInput -Name currencyName
$currencyPrecision = Get-VstsInput -Name currencyPrecision -AsInt
$currencySymbol = Get-VstsInput -Name currencySymbol
$securityGroupId = Get-VstsInput -Name securityGroupId
$securityGroupName = Get-VstsInput -Name securityGroupName
$waitForCompletion = Get-VstsInput -Name waitForCompletion -AsBool
$sleepDuration = Get-VstsInput -Name sleepDuration -AsInt

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

$azureAD = 'AzureAD'
$azureADInfo = Get-MSCRMToolInfo -toolName $azureAD
$azureADPath = "$($azureADInfo.Path)"
Require-ToolVersion -toolName $azureAD -version $azureADInfo.Version -minVersion '2.0.2.52'
Use-MSCRMTool -toolName $azureAD -version $azureADInfo.Version

$templateNames = [string[]] @()
if ($sales)
{
    $templateNames += "D365_Sales"
}
if ($customerService)
{
    $templateNames += "D365_CustomerService"
}
if ($fieldService)
{
    $templateNames += "D365_FieldService"
}
if ($projectService)
{
    $templateNames += "D365_ProjectServiceAutomation"
}


& "$mscrmToolsPath\xRMCIFramework\9.0.0\ProvisionOnlineInstance.ps1" -ApiUrl $apiUrl -Username $username -Password $password  -DomainName $domainName -FriendlyName $friendlyName -Purpose $purpose -InitialUserEmail $initialUserEmail -InstanceType $instanceType -ReleaseId $serviceVersion -TemplateNames $templateNames -LanguageId $languageId -CurrencyCode $currencyCode -CurrencyName $currencyName -CurrencyPrecision $currencyPrecision -CurrencySymbol $currencySymbol -SecurityGroupId $securityGroupId -SecurityGroupName "$securityGroupName" -PSModulePath "$onlineAPIPath" -azureADModulePath "$azureADPath" -WaitForCompletion $WaitForCompletion -SleepDuration $sleepDuration

Write-Verbose 'Leaving MSCRMProvisionOnlineInstance.ps1'
