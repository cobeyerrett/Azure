Select-AzureRmSubscription -SubscriptionId a01ce86a-fe6b-4426-91fe-1696885f35d2

$subscriptionname = "DevTest"
$location = "canadaeast"
#Setting the billTo PE tag
$billto = "0001"

#Network Resource GRoup
$vnet_rg = 'network-'+$subscriptionname+'-rg'

#Network Security Group (NSG) Resource Group
$nsg_rg = 'nsg-'+$subscriptionname+'-rg'

#Define the CIDR Block for the Network and the Subnets

$vnet_cidr = "172.20.0.0/20"
$vnet_name = "DevTest-Vnet"
$sn = @{}
$cidr_blocks=@{}

$cidr_blocks["FrontDev"] = "172.20.0.0/23"
$cidr_blocks["MidDev"] = "172.20.2.0/23"
$cidr_blocks["BackDev"] = "172.20.4.0/23"
$cidr_blocks["FrontTest"] = "172.20.8.0/23"
$cidr_blocks["MidTest"] = "172.20.10.0/23"
$cidr_blocks["BackTest"] = "172.20.12.0/23"


$vnet = New-AzureRmVirtualNetwork -Name $vnet_name -ResourceGroupName $vnet_rg -Location $location -AddressPrefix $vnet_cidr -Subnet $sn -Tag @{Billto=$billto} 


#Creating all Subnet configurations
$cidr_blocks.Keys | % {
    $subnetname = $_
    Write-Output $subnetname
    $cidr = $cidr_blocks.Item($_)
    $nsg_name = $subnetname+'SN-nsg'
    
    $nsg = New-AzureRmNetworkSecurityGroup -Name $nsg_name -ResourceGroupName $nsgrg -Location $location -Tag @{Billto=$billto} 
    add-AzureRmVirtualNetworkSubnetConfig -Name $subnetname -AddressPrefix $cidr -NetworkSecurityGroup $nsg -VirtualNetwork $vnet
    $vnet | Set-AzureRmVirtualNetwork
}



