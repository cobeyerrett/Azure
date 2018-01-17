#Login-AzureRmAccount

$location = "canadaeast"
$notallowed_definition = Get-AzureRmPolicyDefinition -Id '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'


#Getting the name of the subscription
$subname = Read-Host -Prompt "Enter the name of the Subscription"

#Selecting the Azure Subscription
try {
    $subscription = Get-AzureRmSubscription -SubscriptionName $subname    
    Select-AzureRmSubscription -SubscriptionObject $subscription
    $subscope = "/subscriptions/$subscription"
}
catch {
    Write-Host "Could not find subscription"
    Exit    
}



#Creating Base Resource Groups in the selected subscription
Write-Host 'Creating Network Resource Group ' 
    $rg = "network-$subname-rg"
    New-AzureRmResourceGroup -Name $rg -Location $location 
    New-AzureRmResourceLock -LockLevel CanNotDelete -ResourceGroupName $rg -LockName "Cannot delete $rg resources" -Force 
   # New-AzureRMPolicyAssignment -Name "Limit VNet creation - $subname" -Scope $subscope -NotScope "$subscope/resourceGroups/$rg" -PolicyDefinition $notallowed_definition -PolicyParameterObject @{"listOfResourceTypesNotAllowed"=@('Microsoft.Network/virtualnetwork')} 

Write-Host 'Creating Public IP Resource Group ' 
Try
{
    $rg = "publicIP-$subname-rg"
    New-AzureRmResourceGroup -Name $rg -Location $location 
    New-AzureRmResourceLock -LockLevel CanNotDelete -ResourceGroupName $rg -LockName "Cannot delete $rg resources" -Force 
}
Catch
{
    Write-host 'Error occured when creating' + $rg
}
Write-Host 'Creating NSG Resource Group ' 
Try
{
    $rg = "nsg-$subname-rg"
    New-AzureRmResourceGroup -Name $rg -Location $location 
    New-AzureRmResourceLock -LockLevel CanNotDelete -ResourceGroupName $rg -LockName "Cannot delete $rg resources" -Force 
}
Catch
{
    Write-host 'Error occured when creating' + $rg
}
   


