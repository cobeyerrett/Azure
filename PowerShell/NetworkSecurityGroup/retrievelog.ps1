# The SubscriptionID to use
$subscriptionId = "b73ce7d3-fd70-4018-9bc6-5d160c574707"

# Resource group that contains the Network Security Group
$resourceGroupName = "NSG-MANAGEMENT-RG"

# The name of the Network Security Group
$nsgName = "GoCPartnerGatewaySN-nsg"

# The storage account name that contains the NSG logs
$storageAccountName = "managementnetworkstatcan" 

#The resource group that contains the Storage account
$rgStorage = "network-Management-rg"

# The date and time for the log to be queried, logs are stored in hour intervals.
[datetime]$logtime = "04/13/2018 07:00"

# Retrieve the primary storage account key to access the NSG logs
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgStorage -Name $storageAccountName).Value[0]

# Setup a new storage context to be used to query the logs
$ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

# Container name used by NSG flow logs
$ContainerName = "insights-logs-networksecuritygroupflowevent"

# The MAC Address of the Network Interface
$macAddress = "0004FF9D9F8E"

# Name of the blob that contains the NSG flow log
$BlobName = "resourceId=/SUBSCRIPTIONS/${subscriptionId}/RESOURCEGROUPS/${resourceGroupName}/PROVIDERS/MICROSOFT.NETWORK/NETWORKSECURITYGROUPS/${nsgName}/y=$($logtime.Year)/m=$(($logtime).ToString("MM"))/d=$(($logtime).ToString("dd"))/h=$(($logtime).ToString("HH"))/m=00/macAddress=$($macAddress)/PT1H.json"

# Gets the storage blog
$Blob = Get-AzureStorageBlob -Context $ctx -Container $ContainerName -Blob $BlobName

# Gets the block blog of type 'Microsoft.WindowsAzure.Storage.Blob.CloudBlob' from the storage blob
$CloudBlockBlob = [Microsoft.WindowsAzure.Storage.Blob.CloudBlockBlob] $Blob.ICloudBlob

# Stores the block list in a variable from the block blob.
$blockList = $CloudBlockBlob.DownloadBlockList()