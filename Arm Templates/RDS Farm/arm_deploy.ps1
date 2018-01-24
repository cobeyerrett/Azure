

Select-AzureRmSubscription -SubscriptionName "Management"

$rg_name = read-host -Prompt "Enter the resource group name for RDS"
$rg_management = read-host -Prompt "Enter the name of the RG with the Management network" 

$location = "canadaeast"
$management_Vnet = "Management-VNet"
$rds_VnetName = "RDS-VNet"

$networktemplatefile = "rdsnetwork.json"
$rdstemplatefile = "rdsdeploy.json"
$templateparam = "rdsdeploy.parameters.json"

#Create new resource group for RDS deployment
New-AzureRmResourceGroup -Name $rg_name -Location $location

#Creating the VNet for RDS
New-AzureRmResourceGroupDeployment -Name RDS_network -ResourceGroupName $rg_name -TemplateFile $networktemplatefile

$vnet_man = Get-AzureRmVirtualNetwork -Name $management_Vnet -ResourceGroupName $rg_management
$vnet_rds = Get-AzureRmVirtualNetwork -Name $rds_VnetName -ResourceGroupName $rg_name

#Peer RDS to Management
Add-AzureRmVirtualNetworkPeering -Name "RDS-Management" -VirtualNetwork $vnet_man -RemoteVirtualNetworkId $vnet_rds.Id

#Peer Management to RDS
Add-AzureRmVirtualNetworkPeering -Name "Management-RDS" -VirtualNetwork $vnet_rds -RemoteVirtualNetworkId $vnet_man.Id

#Creating the RDS resources
New-AzureRmResourceGroupDeployment -name RDS -ResourceGroupName $rg_name -TemplateFile $rdstemplatefile -TemplateParameterFile $templateparam