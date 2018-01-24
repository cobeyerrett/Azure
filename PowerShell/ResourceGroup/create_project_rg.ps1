
$subscription = read-host -Prompt "Enter the subscription to place the resource group"

try {
    $sub = Get-AzureRmSubscription -SubscriptionName $subscription -ErrorAction Stop   
    Set-AzureRmContext -Subscription $sub -ErrorAction Stop
}
catch {
    Write-Host "No Such Subscription found" -ForegroundColor Yellow
}


$rg_name = read-Host -Prompt "Enter the resource group name" 
$pe = read-host -Prompt "Enter the PE for the resource group"

$ad_group = read-host -Prompt "Enter the AAD group name"

if ((Get-AzureRmADGroup -SearchString $ad_group) -eq $null)
{
    Write-Host "No Such AD Group Found" -ForegroundColor Red
    Break
}
else
{
    $ad_objid = Get-AzureRmADGroup -SearchString $ad_group
}


#Creates the resource group in the Canadian Data Centre
$rg = New-AzureRmResourceGroup -Name $rg_name -Location "canadaeast" -Tag @{Billto=$pe}

#adds group to the contributor role within the Resource Group
New-AzureRmRoleAssignment -ObjectId $ad_objid.Id -ResourceGroupName $rg.ResourceGroupName -RoleDefinitionName Contributor

#Gets the Enforce Tag Builtin Poicy
$policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62 

#sets parameters for the Policy
$param = @{"tagName"="billto";"tagValue"=$pe.ToString()}

#Applies the policy to the resource group
New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param