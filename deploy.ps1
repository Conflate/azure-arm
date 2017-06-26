﻿<#
.SYNOPSIS
    Standard ARM deployment from given template
.DESCRIPTION
    Deploy an ARM template to Azure in given location & subscription
    Additional input parameter file is expected, but the script will look for <template>.parameters.json 
.NOTES
    Author:   Ben Coleman
    Date/Ver: June 2017, v2.5
#>

# Change as required!
param(
    [string]$subname     = "Microsoft Azure Internal Consumption",
    [Parameter(Mandatory=$true)]
    [string]$group, 
    [string]$loc         = "westeurope",
    [Parameter(Mandatory=$true)]
    [string]$template, 
    [string]$paramFile,
    [string]$pubKey,
    [string]$params
)

# Can override template parameters in the param file by providing them as a string, e.g. "foo=bar"
$paramHash = ConvertFrom-StringData -StringData $params

# Try to guess param file if not supplied, with the filename <template>.parameters.json 
if(!$paramFile) {
    $paramFile = ($template.substring(0, $template.length - 5)) + ".parameters.json"
}

# Standard Azure login
try {
    Select-AzureRmProfile -Path "$env:userprofile\.azureprof.json" -ErrorAction Stop
    Get-AzureRmSubscription -ErrorAction SilentlyContinue | Out-Null
} catch {
    Login-AzureRmAccount -ErrorAction Stop
    Save-AzureRmProfile -Path "$env:userprofile\.azureprof.json"
}

# Select which Azure subscription
Select-AzureRmSubscription -SubscriptionName $subname -ErrorAction Stop

# Create the resource goup
New-AzureRmResourceGroup -Name $group -Location $loc -Force

$timestamp = ((Get-Date).ToUniversalTime()).ToString('yyyy-MM-dd_HH.mm')

# Start the deployment, give the deployment a name with date/time stamp
# Change mode as required, default & safe is 'Incremental'
if($pubKey) {
    $pub_key_data = Get-Content -Path $pubKey
    New-AzureRmResourceGroupDeployment -ResourceGroupName $group `
                                   -Name "deployment_$($timestamp)" `
                                   -TemplateFile $template `
                                   -TemplateParameterFile $paramFile `
                                   -Mode Incremental -Verbose @paramHash -sshKey $pub_key_data 
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $group `
                                   -Name "deployment_$($timestamp)" `
                                   -TemplateFile $template `
                                   -TemplateParameterFile $paramFile `
                                   -Mode Incremental -Verbose @paramHash
}