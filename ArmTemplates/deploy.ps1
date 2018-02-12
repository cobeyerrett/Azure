
param(
    [Parameter(Mandatory=$true,HelpMessage="Subscription Name")]
    [string]
    $subscription,
    [Parameter(Mandatory=$true,HelpMessage="Resource Group Name")]
    [string]
    $rg_name,
    [Parameter(Mandatory=$true,HelpMessage="JSON ARM Template File Path")]
    [string]
    $filepath,
    [Parameter(Mandatory=$true,HelpMessage="Azure Data Center Location")]
    [string]
    $location="canadaeast"

)


$deploymentName = 

#Validate that user is logged into Azure 
$needLogin = $true
Try 
    {
        $content = Get-AzureRmContext
        if ($content) 
        {
            $needLogin = ([string]::IsNullOrEmpty($content.Account))
        } 
    } 
    Catch 
    {
        if ($_ -like "*Login-AzureRmAccount to login*") 
        {
            $needLogin = $true
        } 
        else 
        {
            throw
        }
    }

if ($needLogin)
    {
        Login-AzureRmAccount
    }



#Validate the Subsc
try {
    Select-AzureRmSubscription -Name $subscription  
}
catch {
    Write-Host -ForegroundColor Red "Could not find subscription with that Name"
    Exit
}


try {
    Get-AzureRmResourceGroup -Name $rg_name
    Write-Host -ForegroundColor Yellow "Resource Group exists"
}
catch {
    Write-Host -ForegroundColor Yellow "Creating the Resource Group"
    New-AzureRmResourceGroup -Name $rg_name -Location $location
}


#Deploy the ARM Template
Write-Host -ForegroundColor Yellow "Deploying $"