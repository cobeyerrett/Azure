
$deploymentName = "devtestlab"
$RGName = "Cobey1-Workstations-rg"
$billto = "0001"
$projectname = "Cobey13"
$projectowner = "Cobey Errett"
$vhdstorageaccount = "acloudteam5245"


$parameters = @{
    Billto = $billto
    TennantID = "258f1f99-ee3d-42c7-bfc5-7af1b2343e02"
    ProjectName = $projectname
    ProjectOwner = $projectowner
    VHDStrgAccnt = $vhdstorageaccount
}

$id = New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $RGName -TemplateFile .\cobeytemplate.json -TemplateParameterObject $parameters

$lab = get-azurermresource -ResourceId ($id.Outputs.labID.Value)
<#
$labstorageAccount = Get-AzureRmResource -ResourceId $lab.Properties.defaultStorageAccount
$labStorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $labStorageAccount.ResourceGroupName -Name $labStorageAccount.ResourceName)[0].Value

$vhduri = "https://acloudteam5245.blob.core.windows.net/uploads/packerWin10-osDisk.0eb7a4cf-4348-4a83-ba04-0ff1fe9ebeea.vhd"

$srcStorageAccount = Get-AzureRmStorageAccount -Name acloudteam5245 -ResourceGroupName CloudDTL1-Workstations-rg
$srcStorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $srcStorageAccount.ResourceGroupName -Name $srcStorageAccount.StorageAccountName)[0].Value
$customImageName = 'PackerWindows10'
$customImageDescription = 'Windows 10 Packer Image'

$parameters = @{existingLabName = "$($lab.Name)"; existingVhdUri = $vhdUri; imageOsType = 'windows'; isVhdSysPrepped = $true; imageName = $customImageName; imageDescription = $customImageDescription}

New-AzureRmResourceGroupDeployment -ResourceGroupName $lab.ResourceGroupName -Name CreateCustomImage -TemplateUri 'https://raw.githubusercontent.com/Azure/azure-devtestlab/master/Samples/201-dtl-create-customimage-from-vhd/azuredeploy.json' -TemplateParameterObject $parameters
#>
