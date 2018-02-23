
$subscriptionname = "Management"
$location = "canadaeast"
#Setting the billTo PE tag
$billto = "0001"

#Network Resource GRoup
$vnet_rg = 'network-'+$subscriptionname+'-rg'

#Network Security Group (NSG) Resource Group
$nsg_rg = 'nsg-'+$subscriptionname+'-rg'

#Define the CIDR Block for the Network and the Subnets

$vnet_cidr = "172.20.48.0/21"
$vnet_name = "DevTest-Vnet"
$sn = @{}
$cidr_blocks=@{}

$cidr_blocks["Gateway"] = "172.20.52.0/24"
$cidr_blocks["NVA"] = "172.20.48.16/28"
$cidr_blocks["AAD-DS"] = "172.20.48.0/28"
$cidr_blocks["OZ"] = "172.20.51.0/24"
$cidr_blocks["MAZ"] = "172.20.50.0/24"



#Verify the subscription
Try{
    Select-AzureRmSubscription -Name $subscriptionname   
} Catch{
    Write-Output "Could not find subscription of that name"
    Exit
}



$vnet = New-AzureRmVirtualNetwork -Name $vne/t_name -ResourceGroupName $vnet_rg -Location $location -AddressPrefix $vnet_cidr -Subnet $sn -Tag @{Billto=$billto} 


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


