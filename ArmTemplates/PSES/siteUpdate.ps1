# Define the script for your Custom Script Extension to run

# Parameter help description
param(
    [Parameter(Mandatory=$true,HelpMessage="URI for Web Deploy package")]
    [string]
    $webDeployURI,
    [Parameter(Mandatory=$true,HelpMessage="Powershell File to Run")]
    [string]
    $filename,
    [Parameter(Mandatory=$true,HelpMessage="Resource Group Name")]
    [string]
    $rg_name,
    [Parameter(Mandatory=$true,HelpMessage="Scale Set Name")]
    [string]
    $scaleSetName

)



$customConfig = @{
    "fileUris" = (,$webDeployURI);
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File $filename"
}

#Get information about the scale set
$vmss = get-AzureRMVmss -ResourceGroupName $rgName -VMScaleSetName $scaleSetName

$vmss = Add-AzureRmVmssExtension `
    -VirtualMachineScaleSet $vmss `
    -Name "SiteDeploy" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.0 `
    -Setting $customConfig

Update-AzureRmVmss `
    -ResourceGroupName $vmss.ResourceGroupName
    -VMScaleSetName $vmss.Name
    -VirtualMachineScaleSet $vmss
    