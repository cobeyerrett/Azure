
$subscriptions = Get-AzureRmSubscription

foreach ($sub in $subscriptions)
{
    Set-AzureRmContext -Subscription $sub

    Get-AzureRmVirtualNetwork | ForEach-Object {
        $_.DhcpOptions.DnsServers = "172.20.48.5"
        $_.DhcpOptions.DnsServers = "172.20.48.4" 
    }


}