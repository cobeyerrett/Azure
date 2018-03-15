$RGName = "RDS-Management-rg"
$VMName = "rdsh-0"

$AADClientID = "75ba599a-1372-4f3a-b44b-072edf25ab61"
$AADClientSecret = "fa487395-08b2-4bfa-8008-6c35800ce9f9"
$VaultName= "VMDiskEncryption"
$KeyVault = Get-AzureRmKeyVault -VaultName $VaultName -ResourceGroupName "DiskEncryption-Management-rg"
$DiskEncryptionKeyVaultUrl = $KeyVault.VaultUri
$KeyVaultResourceId = $KeyVault.ResourceId
Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $RGName -VMName $VMName -AadClientID $AADClientID -AadClientSecret $AADClientSecret -DiskEncryptionKeyVaultUrl $DiskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId