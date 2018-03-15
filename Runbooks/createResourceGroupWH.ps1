workflow createResourceGroupWH {
    param (
        [System.Object]$WebHookData
    )
    
    #{"subscription":"Managment", "projectName":"CobeyTestDelete", "projectOwner":"Cobey Errett","pe":"0001"}
    if ($WebHookData -ne $null){
        $WebHookName = $WebHookData.WebHookName
        $WebHookHeaders = $WebHookData.RequestHeader
        $WebHookBody = $WebHookData.RequestBody
        
        $param = ConvertFrom-Json -InputObject $WebHookBody
        Write-Output $param
    }
    else {
        Write-Error "Runbook meant to be run from a WebHook"
    }

    $conn = Get-AutomationConnection -Name 'AzureRunAsConnection'

    $acc = Add-AzureRmAccount `
	    -ApplicationId $conn.ApplicationId `
	    -CertificateThumbprint $conn.CertificateThumbprint `
	    -ServicePrincipal `
	    -TenantId $conn.TenantId
            

    select-azurermsubscription $subscription

    $rg_name = "$projectName$num-$subscription-rg"
    Write-Output "Creating the ResourceGroup $rg_name" 

    $rg = New-AzureRmResourceGroup -Name $rg_name -Location $location -Tag @{Billto=$pe;ProjectName=$projectName;ProjectOwner=$projectOwner}
         
    #sets parameters for the Policy
    $param = @{"tagName"="billto";"tagValue"=$pe.ToString()}
    
    #Gets the Apply Tag Builtin Policy
    $policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/2a0e14a6-b0a6-4fab-991a-187a4f81c498
    #Applies the policy to the resource group
    New-AzureRmPolicyAssignment -Name BilltoApply -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param
        
    #Gets the Enforce Tag Builtin Policy
    Write-Output "Adding the Enforce Tag to $rg_name"  
    $policy = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62 
    
    #Applies the policy to the resource group
    Write-Output "Adding the Apply Tag to $rg_name"  
    New-AzureRmPolicyAssignment -Name BilltoEnforce -Scope $rg.ResourceId -PolicyDefinition $policy -PolicyParameterObject $param
    
}