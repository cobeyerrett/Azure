

$policyFile = Read-Host "Path to json policy file";
#Check if json file exists
if (!(test-path $policyFile))
{
    Write-Host "Json file not found"
    Exit
}

$policyName = Read-Host "Specify the name of the policy";
$policyDescription = Read-Host "Specify the description of the policy"
 
#Check if json file exists
if (!(test-path $policyFile))
{
    Write-Host "Json filenot found"
    Exit
}

#Login to the Azure Resource Management Account
if (!Get-AzureRmContext)
{
    Login-AzureRmAccount    
}

 
#Let the user choose the right subscrition
Write-Host "---------------------------------------------------------------------"
Write-Host "Your current subscriptions: " -ForegroundColor Yellow
Get-AzureRMSubscription
Write-Host "Enter the Subscription ID to deploy to: " -ForegroundColor Green
$sub = Read-Host
Set-AzureRmContext -SubscriptionId $sub

 
$subId = (Get-AzureRmContext).Subscription.SubscriptionId
$subName = (Get-AzureRmContext).Subscription.SubscriptionName
 
Write-Host "Policy is applied to the subscription: $subName"
$policy = New-AzureRmPolicyDefinition -Name $policyName -Description $policyDescription -Policy $policyFile;
 
#Assign the Azure Policy
New-AzureRmPolicyAssignment -Name $policyName -Description $policyDescription -PolicyDefinition $policy -Scope "/subscriptions/$sub"
