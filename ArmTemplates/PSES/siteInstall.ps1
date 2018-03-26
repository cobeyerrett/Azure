$iisAppPoolName = "pses"
$iisAppPoolDotNetVersion = "v4.0"
$iisAppName = "pses"
$directoryPath = "c:\inetpub\wwwroot"
$hostName = "hranalytics-analytiquerh.cloud.statcan.ca"

$SiteFolder = Join-Path -Path $directoryPath -ChildPath $iisAppName

New-WebSite -Name $iisAppName -PhysicalPath $SiteFolder -Force
$iisSite = "IIS:\Sites\$SiteName"
Set-ItemProperty $iisSite -Name Bindings -value @{protocol="http";bindingInformation="*:80:$HostName"}