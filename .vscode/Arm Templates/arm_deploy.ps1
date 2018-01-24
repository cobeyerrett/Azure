Select-AzureRmSubscription -SubscriptionName "Management"



$rg = New-AzureRmResourceGroup -Name "RDS-t-rg" -Location "canadaeast"
New-AzureRmResourceGroupDeployment -Name RDSDeploy -ResourceGroupName $rg.ResourceGroupName -TemplateUri https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/rds-deployment-existing-ad/azuredeploy.json