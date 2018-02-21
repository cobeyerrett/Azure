$sub = "Management"
$projectname = "CobeyDelete21"
$projectowner = "Cobey Errett"
$pe = "0001"

$webhookURI = "https://prod-15.canadaeast.logic.azure.com:443/workflows/e6d0673f43dd408e94bda72b132734b1/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=-q2UqBMT3sze-ofwb3gEGApBKuPBZdwsZWV90QEYGuk"

$params = @{"subscription"=$sub; "ProjectName"=$projectname; "ProjectOwner"=$projectowner; "pe"=$pe}

$body = ConvertTo-Json -InputObject $params
Invoke-WebRequest -Method Post -Uri $webhookURI -Body $body

