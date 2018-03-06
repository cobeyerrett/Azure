#Creates a KeyVault for the Deployment of ARM templates

param(
    # Subscition Name 
    [Parameter(Mandatory=$true)]
    [String]
    $KeyVaultSubscriptionName,
    # KeyVaultName
    [Parameter(Mandatory=$true)]
    [string]
    $keyVaultName,
    # KeyVault Resource Group
    [Parameter(Mandatory=$true)]
    [String]
    $resourceGroupName,
    # The subscription that the ARM templates will be deployed
    [Parameter(Mandatory=$true)]
    [String]
    $subscription,
    # Object ID fro the group/application/user that has full access to the Key Vaults 
    [Parameter(Mandatory=$true)]
    [String]
    $accessgroupID



)

#Selects the subscription where the Key Vault is to be stored
Select-AzureRmSubscription $KeyVaultSubscriptionName

try {
    $rg = Get-AzureRmResourceGroup -Name $resourceGroupName
    $location = $rg.Location
}
catch {
    Write-Error "The Resource Group does not exist"
    
}


#creating the Key Vault for Template deployment
$kv = New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -Location $location -EnabledForTemplateDeployment

Set-AzureRmKeyVaultAccessPolicy -VaultName $kv.VaultName -ObjectId $accessgroupID -PermissionsToSecrets all -PermissionsToKeys all -PermissionsToCertificates all


#creating a dummy value for the Subnet Ref
$subnetrefSecret = ConvertTo-SecureString -String 'SubnetRef' -AsPlainText -Force

Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name frontSubnetRef -SecretValue $subnetrefSecret
Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name midSubnetRef -SecretValue $subnetrefSecret
Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name backSubnetRef -SecretValue $subnetrefSecret

$subId = (Get-AzureRmSubscription -SubscriptionName $subscription).Id
$subSecret = ConvertTo-SecureString -String $subId -AsPlainText -Force

set-azureKeyVaultSecret -VaultName $kv.VaultName -Name subscriptionId -SecretValue $subSecret

$admin = Read-Host "VM Local Admin" 
$adminsecret = ConvertTo-SecureString -String $admin -AsPlainText -Force
$password = Read-Host "VM Local Admin Password" -AsSecureString

Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name vmadmin -SecretValue $adminsecret
Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name vmpasswd -SecretValue $password

$workspaceIDsecret = Get-AzureKeyVaultSecret -VaultName cloudadmin -Name OMSWorkspaceID
Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name OMSWorkspaceID -SecretValue $workspaceIDsecret

$workspaceKey = Get-AzureKeyVaultSecret -VaultName cloudadmin -Name OMSWorkspaceKey
$workspaceSecondary = Get-AzureKeyVaultSecret -VaultName cloudadmin -Name OMSWorkspaceKeySecondary