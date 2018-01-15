Login-AzureRmAccount

$subscriptions = Get-AzureRmSubscription

foreach ($sub in $subscriptions)
{
#Set policy to only allow Canadian data Centers
$definition = Get-AzureRmPolicyDefinition -Id '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
New-AzureRmPolicyassignment -Name "Canadian Data Centers" -Scope /subscriptions/$subid  -PolicyDefinition $definition -listOfAllowedLocations canadaeast,canadacentral

}



