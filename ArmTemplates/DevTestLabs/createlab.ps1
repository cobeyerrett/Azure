param(
    [Parameter(Mandatory=$true,HelpMessage="Subscription Name")]
    [string]
    $deploymentName,
    [Parameter(Mandatory=$true,HelpMessage="Resource Group Name")]
    [string]
    $RGName
)



New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $RGName -TemplateFile .\azuredeploy.json 

