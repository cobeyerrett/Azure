# Specifies a path to one or more locations. Unlike the Path parameter, the value of the LiteralPath parameter is
# used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters,
# enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
# characters as escape sequences.
param(
    [Parameter(Mandatory=$true,HelpMessage="Subscription Name")]
    [string]
    $sub,
    [Parameter(Mandatory=$true,HelpMessage="Resource Group Name")]
    [string]
    $defn_file
   
  

)


$sub = "Management"
$defn_file = ".\rg_billto.json"
$param_file = ".\rg_billto.parameters.json"
$pol_name = "Enforce-resourcegroup-tags"
$dis_name = "This policy enforces that all resource groups created have a 4 digit PE code."

try {
    Test-Path $defn_file
}
catch {
    Write-Host -ForegroundColor RED "Could not find the file specified"
    exit
}


try {
    $subscription = Select-AzureRmSubscription $sub
    $subId = $subscription.Subscription.Id
    
}
catch {
    Write-Host "Not a valid subscription name"
    Exit
}

$subscription = Select-AzureRmSubscription $sub
$subId = $subscription.Subscription.Id

$definition = New-AzureRmPolicyDefinition -Policy $defn_file -Name $pol_name -Description $dis_name  -mode All
$assignment = New-AzureRmPolicyAssignment -Name $pol_name -Scope "/subscriptions/$subid"