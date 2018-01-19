

$policyFile = Read-Host "Path to json policy file";
#Check if json file exists
if (!(test-path $policyFile))
{
    Write-Host "Json file not found"
    Exit
}

$policyName = Read-Host "Specify the name of the policy";
$policyDescription = Read-Host "Specify the description of the policy"
 

#Login to the Azure Resource Management Account
if (!(Get-AzureRmContext))
{
    Login-AzureRmAccount    
}

 
#Let the user choose the right subscrition
Write-Host "---------------------------------------------------------------------"
Write-Host "Your current subscriptions: " -ForegroundColor Yellow
$subscriptions = Get-AzureRMSubscription

foreach ($sub in $subscriptions)
{
     

    $subId = $sub.SubscriptionId
    $subName = $sub.Name

    Set-AzureRmContext -SubscriptionId $subId
    
    Write-Host "Policy is applied to the subscription: $subName"
    $policy = New-AzureRmPolicyDefinition -Name $policyName -Description $policyDescription -Policy $policyFile 
    

    #Assign the Azure Policy
    New-AzureRmPolicyAssignment -Name $policyName -Description $policyDescription -PolicyDefinition $policy -Scope "/subscriptions/$sub"
    

}

