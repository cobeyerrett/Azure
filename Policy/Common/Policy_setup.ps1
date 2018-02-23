#Login-AzureRmAccount

$subscriptions = Get-AzureRmSubscription


$cdn_definition = Get-AzureRmPolicyDefinition -Id '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
$notallowed_definition = Get-AzureRmPolicyDefinition -Id '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'

foreach ($sub in $subscriptions)
{
    $subscope = "/subscriptions/$sub"

    #Set policy to only allow Canadian data Centers
    New-AzureRmPolicyassignment -Name "Canadian Data Centers" -Scope /subscriptions/$sub  -PolicyDefinition $cdn_definition -listOfAllowedLocations canadaeast,canadacentral
    
    
   

}



