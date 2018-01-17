# To create and assign a tag-matching policy definition on a subscription
# This will enforce a 8 digit project code of 4 letters and 4 numbers as a tag to the environment Key


$policydefname = "Matching Billto Tag"
$policydisplayname = "Matching Tag"
$description = "This policy enforces a 4-digit project code to be added as a tag value for the Billto tag key"
## The pattern matching sequence is located in this JSON
$policyURI = "matchingtagrule.json"


$assignmentname = "Project Code Tag Matching"
# Enter the mandatory tags and values you want to enforce below
$tagName = "Project"

# This will apply the policy to the first subscription retrieved by the cmdlet
$AzureSub = Get-AzureRmSubscription
$subscope = "/subscriptions/" + $AzureSub[0].SubscriptionId
$notscope = $subscope + "/resourceGroups/" + $ExclusionRG

$definition = New-AzureRmPolicyDefinition -Name $policydefname -DisplayName $policydisplayname -description $description -Policy $policyURI -Mode All
$definition

$assignment = New-AzureRMPolicyAssignment -Name $assignmentname -Scope $subscope -PolicyDefinition $definition -NotScope $notscope
$assignment
