$ad_group = read-host -Prompt "Enter the AAD group name"

if ((Get-AzureRmADGroup -SearchString $ad_group) -eq $null)
{
    Write-Host "No Such AD Group Found" -ForegroundColor Red
    Break
}
else
{
    $ad_objid = Get-AzureRmADGroup -SearchString $ad_group
}
