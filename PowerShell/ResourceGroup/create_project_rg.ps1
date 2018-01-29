Param(
    [Parameter(Mandatory=$true)]   
    [string]$subscription,
    [Parameter(Mandatory=$true)]   
    [string]$projectName,
    [Parameter(Mandatory=$true)]   
    [string]$projectOwner,
    [Parameter(Mandatory=$true)]   
    [string]$ad_group,
    [Parameter(Mandatory=$true)]   
    [string]$pe,
    [string]$location="canadaeast"
  
)

#Defines the Resource Group Name 
$rg_name = "$projectName-$subscription-rg"

function Check-ResourceGroup
{        
        [CmdletBinding()]
        [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $ResourceGroupName,
        [string]
        $Location,
        [bool]
        $add = $false
    )
    $ResourceGroups = Get-AzureRmResourceGroup 

    $MatchRgLocation = $ResourceGroups | where { $_.Location -like $Location} | 
                        where {$_.ResourceGroupName -like $ResourceGroupName} 
    if ($MatchRgLocation.Count -eq 0) { 

            $MatchRgLocation = $ResourceGroups | 
                        where {$_.ResourceGroupName -like $ResourceGroupName} 
        if ($MatchRgLocation.Count -eq 0)  {
            Write-Verbose "$ResourceGroupName does not exist" 
            return $false

        } else {
            Write-Verbose "$ResourceGroupName exists in alternative location" 
            return $false
        }
    } else {
    if ($add)  { 
            Write-Verbose "$ResourceGroupName exists in location -Add is set to $true" 
            return $true
        } else {
            Write-Verbose "$ResourceGroupName exists in location -Add is not set" 
            return $false 
        }
    } 
}

try {
    $sub = Get-AzureRmSubscription -SubscriptionName $subscription -ErrorAction Stop   
    Set-AzureRmContext -Subscription $sub -ErrorAction Stop
}
catch {
    Write-Host "No Such Subscription found" -ForegroundColor Yellow
    exit
}

#Check if resource exists
Check-ResourceGroup -ResourceGroupName $rg_name -Location $location -Verbose





Get-AzureRmResourceGroup -Name $rg_name -ev notPresent -ea 0 

if ($notPresent)
{
    # ResourceGroup doesn't exist
}
else
{
    # ResourceGroup exist
}



#Creates the resource group in the Canadian Data Centre
$rg = New-AzureRmResourceGroup -Name $rg_name -Location $location -Tag @{Billto=$pe;ProjectName=$projectName;ProjectOwner=$projectOwner}

#adds group to the contributor role within the Resource Group
New-AzureRmRoleAssignment -ObjectId $ad_objid.Id -ResourceGroupName $rg.ResourceGroupName -RoleDefinitionName Contributor

#Gets the Enforce Tag Builtin Poicy
$policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62 

#sets parameters for the Policy
$param = @{"tagName"="billto";"tagValue"=$pe.ToString()}

#Applies the policy to the resource group
New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param