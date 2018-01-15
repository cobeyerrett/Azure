# To create and assign a tag-matching policy definition on a subscription
# This will enforce a 8 digit project code of 4 letters and 4 numbers as a tag to the environment Key


$policydefname = "Matching Billto Tag"
$policydisplayname = "Matching Tag"
$description = "This policy enforces a 4-digit project code to be added as a tag value for the Billto tag key"
## The pattern matching sequence is located in this JSON
$policyURI = "https://samplesazure.blob.core.windows.net/templates/matchingtagrule.json"
$PolicyParamsURI = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/TextPatterns/enforce-tag-match-pattern/azurepolicy.parameters.json"

$assignmentname = "Project Code Tag Matching"
# Enter the mandatory tags and values you want to enforce below
$tagName = "Project"

# Enter the Sandbox resource group name you want to exclude from the policy assignment
$ExclusionRG = "Sandbox-RG"
# This will apply the policy to the first subscription retrieved by the cmdlet
$AzureSub = Get-AzureRmSubscription
$subscope = "/subscriptions/" + $AzureSub[0].SubscriptionId
$notscope = $subscope + "/resourceGroups/" + $ExclusionRG

$definition = New-AzureRmPolicyDefinition -Name $policydefname -DisplayName $policydisplayname -description $description -Policy $policyURI  -Parameter $PolicyParamsURI -Mode All
$definition
$skutable = @{"Name" = "A1"; "Tier" = "Standard"}
$assignment = New-AzureRMPolicyAssignment -Name $assignmentname -Scope $subscope -PolicyDefinition $definition -Sku $skutable -NotScope $notscope
$assignment
