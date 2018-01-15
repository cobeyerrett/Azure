Login-AzureRmAccount


#Getting the name of the subscription
$subname = Read-Host -Prompt "Enter the name of the Subscription"

#Setting the Resource Group Names

$resourcegroups = @(
    'network-' + $subname + '-rg';
    'nsg-' + $subname + '-rg';
    'publicIP-' + $subname + '-rg';
)

#Selecting the Azure Subscription
$subscription = Get-AzureRmSubscription -SubscriptionName $subname
Select-AzureRmSubscription -SubscriptionObject $subscription

#Creating Base Resource Groups in the selected subscription
foreach ($rg in $resourcegroups)
{
    Write-Host 'Creating Resource Group ' $rg
    Try{
        New-AzureRmResourceGroup -Name $rg -Location canadaeast 
}
    Catch{
    Write-host 'Error occured when creating' + $rg
}
}   

