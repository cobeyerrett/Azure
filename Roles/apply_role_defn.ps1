


$role_definition_file = read-host -prompt "Enter the JSON file with the role definition"

function Show-Menu
{
     param (
           [string]$Title = 'My Menu'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to update existing RBAC Role."
     Write-Host "2: Press '2' to make new RBAC role."
     Write-Host "3: Press '3' query all RBAC roles."
     Write-Host "q: Press 'q' to quit."
}

do{
    Show-Menu
    $input = Read-host "Please make a selection"
    switch ($input)
    {
        '1'{
            Set-AzureRmRoleDefinition -InputFile $role_definition_file 
        }
        '2'{
            Clear-Host
            New-AzureRmRoleDefinition -InputFile $role_definition_file
        }
        '3'{
            Get-AzureRmRoleDefinition | Format-Table Operation, OperationName 
        }
        'q'{
            return
        }
    }
    Pause
}
until ($input -eq 'q')

