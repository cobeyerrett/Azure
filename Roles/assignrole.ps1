

Select-AzureRmSubscription Management

$role = "ProjectNetwork"
$adgroup = "ProjectNetwork"
$rg = "network-management-rg"

#Get the azure ad group
$group = Get-AzureRmADGroup -SearchString $adgroup

$rg_scope = (Get-AzureRmResourceGroup -Name $rg).

New-AzureRmRoleAssignment -RoleDefinitionName $role -ObjectId $group.Id -Scope 
