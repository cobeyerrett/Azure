

$PublicSettings = @{"workspaceId" = "ebded10c-b5d2-4cb7-bea8-dae110aa94b1"}
$ProtectedSettings = @{"workspaceKey" = "33VmPs33/COEXjM0LAjCeWzNE7enK+acszbbeqDf2BvW+VWrHT++6Hef23docvTMxfJVAE39IYtGsAeRLuGCLQ=="}


$vms = Get-AzureRmVm

foreach ($vm in $vms)
{
    Set-AzureRmVMExtension -ExtensionName "Microsoft.EnterpriseCloud.Monitoring" `
    -ResourceGroupName $vm.ResourceGroupName `
    -VMName $vm `
    -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
    -ExtensionType "MicrosoftMonitoringAgent" `
    -TypeHandlerVersion 1.0 `
    -Settings $PublicSettings `
    -ProtectedSettings $ProtectedSettings `
    -Location CanadaCentral 
}


 