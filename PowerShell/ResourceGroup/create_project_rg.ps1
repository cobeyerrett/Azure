
function create-resourceGroup
{
    Param(
    [Parameter(Mandatory=$true)]   
    [string]$subscription,
    [Parameter(Mandatory=$true)]   
    [string]$projectName,
    [Parameter(Mandatory=$true)]   
    [string]$projectOwner,
    [Parameter(Mandatory=$true)]   
    [string]$pe,
    [string]$location="canadaeast"
    )
    
    #Defines the Resource Group Name 
    $num = 1
    

    try {
        $sub = Get-AzureRmSubscription -SubscriptionName $subscription -ErrorAction Stop   
        Set-AzureRmContext -Subscription $sub -ErrorAction Stop
    }
    catch {
        Write-Host "No Such Subscription found" -ForegroundColor Yellow
        exit
    }
    
    $created = $false    

    while (!$created) {
        $rg_name = "$projectName$num-$subscription-rg"
        if (!(Check-ResourceGroup -ResourceGroupName $rg_name -Location $location)) {
            Write-Host -ForegroundColor Yellow "The RG does not exist.  Creating"
            #creates new resource group 
            $rg = New-AzureRmResourceGroup -Name $rg_name -Location $location -Tag @{Billto=$pe;ProjectName=$projectName;ProjectOwner=$projectOwner}
            $created = $true
        }
        else {
            Write-Host -ForegroundColor Yellow "The RG $rg_name exists"
            $num+=1
        }
    }
    #sets parameters for the Policy
    $param = @{"tagName"="billto";"tagValue"=$pe.ToString()}

    #Gets the Enforce Tag Builtin Policy
    $policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62 

    #Applies the policy to the resource group
    New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param

    #Geta the Apply Tag Builtin Policy
    $policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/2a0e14a6-b0a6-4fab-991a-187a4f81c498
    #Applies the policy to the resource group
    New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param
}





#adds group to the contributor role within the Resource Group
New-AzureRmRoleAssignment -ObjectId $ad_objid.Id -ResourceGroupName $rg.ResourceGroupName -RoleDefinitionName Owner

#sets parameters for the Policy
$param = @{"tagName"="billto";"tagValue"=$pe.ToString()}

#Gets the Enforce Tag Builtin Policy
$policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62 

#Applies the policy to the resource group
New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param

#Geta the Apply Tag Builtin Policy
$policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/2a0e14a6-b0a6-4fab-991a-187a4f81c498
#Applies the policy to the resource group
New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param
 

