param
    (
        [Parameter(Mandatory=$true)]
        [string] $Subscription = "",

        [Parameter(Mandatory=$true)]
        [string] $VMsName = "",

        [Parameter(Mandatory=$false)]
        [string] $ResourceGroup = ""
    )

    $conn = Get-AutomationConnection -Name 'AzureRunAsConnection'

    $acc = Add-AzureRmAccount `
		-ApplicationId $conn.ApplicationId `
		-CertificateThumbprint $conn.CertificateThumbprint `
		-ServicePrincipal `
		-TenantId $conn.TenantId

    Select-AzureRmSubscription -SubscriptionName $Subscription
        
    $AllVMs = Get-AzureRmVM -WarningAction SilentlyContinue

    
        Write-Output ((Get-Date -Format "HH:mm:ss") + " - Stopping VMs sequentially:")
        $vmList = $VMsName.Split(",")
        foreach ($vmName in $vmList)
        {
            $vm = $AllVMs | Where-Object {$_.Name.ToLower() -eq $vmName.ToLower()}
            if ($vm.Name -ne $null)
            {
                Write-Output ((Get-Date -Format "HH:mm:ss") + " - " + $vm.Name)
                if ($ResourceGroup -eq $null)
                {
                    Stop-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force
                }
                else {
                    Stop-AzureRmVM -Name $vm.Name -ResourceGroupName $ResourceGroup -Force
                }

                
            }
        }
    

    Write-Output (" ")

    Write-Output ((Get-Date -Format "HH:mm:ss") + " - The following VMs were stopped:")
    
    $issue = $false
    $vmList = @()
    if ($VMsName -ne "") {$vmList += $vmList1}
    foreach ($vmName in ($vmList)) 
    {
        $VMs = $AllVMs | where-object {$_.Name -like $vmName}
        foreach ($vm in $VMs)
        {
            if ($vm.Name -eq $null)
            {
                $issue = $true
            }
            elseif ((Get-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status).Statuses[1].DisplayStatus -eq "VM deallocated") 
            {
                Write-Output ($vm.Name)
            }
            else {$issue = $true}
        }
    }

    if ($issue -eq $true)
    {
        Write-Output (" ")
        Write-Output ("There was an issue stopping the following VMs:")
        foreach ($vmName in ($vmList)) 
        {
            $VMs = $AllVMs | where {$_.Name -like $vmName}
            foreach ($vm in $VMs)
            {
                if ($vm.Name -eq $null)
                {
                    Write-Output ($vmName + " (invalid name or pattern)")
                }
                elseif ((Get-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status).Statuses[1].DisplayStatus -ne "VM deallocated") 
                {
                    Write-Output ($vm.Name + " (" + (Get-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status).Statuses[1].DisplayStatus + ")")
                }
            }
        }
    }