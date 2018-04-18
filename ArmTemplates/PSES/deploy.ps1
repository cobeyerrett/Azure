param(
    [Parameter(Mandatory=$true,HelpMessage="Subscription Name")]
    [string]
    $SubName,
    [Parameter(Mandatory=$true,HelpMessage="ResourceGroup Name for Deployment")]
    [string]
    $rgName,
    [Parameter(Mandatory=$true,HelpMessage="Deployment Name")]
    [string]
    $deploymentName
)


Login-AzureRmAccount

Select-AzureRmSubscription $SubName

New-AzureRmResourceGroupDeployment `
    -Name $deploymentName `
    -ResourceGroupName $rgName `
    -TemplateFile .\azuredeploy.json `
    -TemplateParameterFile .\azuredeploy.parameters.json
