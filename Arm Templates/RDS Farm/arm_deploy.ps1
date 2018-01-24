

Select-AzureRmSubscription -SubscriptionName "Management"

$rg_name = read-host -Prompt "Enter the resource group name for RDS"

$rdstemplatefile = "rdsdeploy.json"
$templateparam = "rdsdeploy.parameters.json"

#Creating the RDS resources
New-AzureRmResourceGroupDeployment -name RDS -ResourceGroupName $rg_name -TemplateFile $rdstemplatefile -TemplateParameterFile $templateparam