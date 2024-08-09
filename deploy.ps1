<#
.SYNOPSIS
    Performs a deployment of the Acvitity Log Alerts in the subscription.

.DESCRIPTION
    Use this for manual deployments only.
    If using a CI/CD pipeline, specify the necessary parameters in the pipeline definition.

.PARAMETER TemplateParameterFile
    The path to the template parameter file in bicepparam format.

.PARAMETER Location
    The Azure region to deploy the resources to.

.PARAMETER Environment
    The Azure environment (Public, Government, etc.) to deploy the resources to. Default is 'AzureCloud'.

.PARAMETER DeleteJsonParameterFileAfterDeployment
    A switch to delete the JSON parameter file after the deployment. Default is $true.

.EXAMPLE
    ./deploy.ps1 -TemplateParameterFile '.\main.bicepparam' -Location 'eastus' 

.EXAMPLE
    ./deploy.ps1 '.\main.bicepparam' 'eastus'
#>

# LATER: Be more specific about the required modules; it will speed up the initial call
#Requires -Modules "Az"
#Requires -PSEdition Core

[CmdletBinding()]
Param(
    [Parameter()]
    [string]$TemplateParameterFile = './main.bicepparam',
    [Parameter(Mandatory, Position = 1)]
    [string]$Location,
    [Parameter(Position = 2)]
    [string]$Environment = 'AzureCloud'
)

# Define common parameters for the New-AzDeployment cmdlet
[hashtable]$CmdLetParameters = @{
    TemplateFile          = './main.bicep'
    TemplateParameterFile = $TemplateParameterFile
    Location              = $Location
    DeploymentName        = "main-ActivityLogAlerts-$(Get-Date -Format 'yyyyMMddThhmmssZ' -AsUTC)"
}

# Execute the deployment
$DeploymentResult = New-AzDeployment @CmdLetParameters

# Evaluate the deployment results
if ($DeploymentResult.ProvisioningState -eq 'Succeeded') {
    Write-Host "🔥 Deployment succeeded."

    $DeploymentResult.Outputs | Format-Table -Property Key, @{Name = 'Value'; Expression = { $_.Value.Value } }
}
else {
    $DeploymentResult
}
