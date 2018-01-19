# To create and assign a tag-matching policy definition on a subscription
# This will enforce a 4 numbers as a tag to the billto Tag


$policydefname = "Matching Billto Tag"
$policydisplayname = "Matching Tag"
$description = "This policy enforces a 4-digit project code to be added as a tag value for the Billto tag key"
## The pattern matching sequence is located in this JSON
$policyURI = "matchingtagrule.json"


$assignmentname = "Project Code Tag Matching"


# This will apply the policy to the first subscription retrieved by the cmdlet
$AzureSub = Get-AzureRmSubscription



foreach ($sub in $AzureSub)
{
    Select-AzureRmSubscription -SubscriptionObject $sub
    
    $subscope = "/subscriptions/" + $sub.Id
    $assignmentdesc = "This assignment enforces a 4-digit code be added as a tag value for the Billto tag key"

    $definition = New-AzureRmPolicyDefinition -Name $policydefname -DisplayName $policydisplayname -description $description -Policy $policyURI -Mode All 
    $definition
    $assignment = New-AzureRMPolicyAssignment -Name $assignmentname -Description $assignmentdesc -Scope $subscope -PolicyDefinition $definition 
    $assignment
    
}
