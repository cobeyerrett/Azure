$policyNames = @( "Canadian Data Centers")

$Target=@()

$policyNames | 
    ForEach-Object {
        $policyDefinitionId = (Get-AzureRmPolicyDefinition -Name $_ | Select-Object -ExpandProperty PolicyDefinitionId)
        $TargetObject = New-Object PSObject –Property @{policyDefinitionId=$policyDefinitionId}
        $Target +=  $TargetObject
    }
$policySetDefinition = $Target | ConvertTo-Json

$subscriptions = Get-AzureRmSubscription

foreach ($sub in $subscriptions)
{
    New-AzureRmPolicySetDefinition -Name $sub.Name -PolicyDefinition $policySetDefinition -WhatIf 
}