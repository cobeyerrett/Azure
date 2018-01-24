




function Show-Menu
{
     param (
           [string]$Title = 'My Menu'
     )
     Clear-Host
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to update existing RBAC Role."
     Write-Host "2: Press '2' to make new RBAC role."
     Write-Host "3: Press '3' query all Custom RBAC roles."
     Write-Host "4: Press '4' query all Built-In RBAC roles."
     Write-Host "5: Press '5' query roles for specific RBAC role."
     Write-Host "6: Press '6' to export role to JSON format"
     Write-Host "q: Press 'q' to quit."
}

do{
    Show-Menu -Title "RBAC"
    $input = Read-host "Please make a selection"
    switch ($input)
    {
        '1'{
            try {
                $role_definition_file = read-host -prompt "Enter the JSON file with the role definition"
                Set-AzureRmRoleDefinition -InputFile $role_definition_file
            }
            catch {
                Write-host -ForegroundColor Red "File not found or incorrect ID specified in JSON. Please check your JSON file"
            }

             
        }
        '2'{
            Clear-Host
            $role_definition_file = read-host -prompt "Enter the JSON file with the role definition"
            New-AzureRmRoleDefinition -InputFile $role_definition_file
        }
        '3'{
            Get-AzureRmRoleDefinition | where-object {$_.IsCustom -eq $true} | Select Name, Description, Actions, NotActions | Out-GridView
        }
        '4'{
            Get-AzureRmRoleDefinition | where-object {$_.IsCustom -eq $false} | Select Name, Description, Actions, NotActions | Out-GridView
        }
        '5'{
            $roleName = Read-host -Prompt "Enter the role name"
            try {
                Write-host -ForegroundColor Yellow "Allowed Actions"
                (Get-AzureRmRoleDefinition $roleName).Actions
                Write-Host -ForegroundColor Yellow "Not-Allowed Actions"
                (Get-AzureRmRoleDefinition $roleName).NotActions

            }
            catch {
                Write-host -ForegroundColor Red "Could not find Role specified"
            }
        }
        '6'{
            try {
                $roleName = Read-Host -Prompt "Enter the role you want to get JSON file"    
                Get-AzureRmRoleDefinition $roleName | ConvertTo-Json | out-file "$rolename.json"
            }
            catch {
                Write-host -ForegroundColor Red "Could not find role name"
            }
            
        }
        'q'{
            return
        }
    }
    Pause
}
until ($input -eq 'q')

