
$customRoles = get-AzRoleDefinition -Custom

foreach ($role in $customRoles) {
    $jsonFile = $role.Name +".json"
    $jsonFile
    $role | ConvertTo-Json | out-file $jsonFile
}