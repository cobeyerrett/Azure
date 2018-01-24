$vnet = Get-AzureRmVirtualNetwork -Name Management-VNet -ResourceGroupName network-Management-rg

$vnet.SubnetsText