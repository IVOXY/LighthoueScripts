add-pssnapin VMware.VimAutomation.Core


function Get-FolderPath{
  param($FolderMoRef,$Path='')
 
  $Folder = Get-View -Id $FolderMoRef
    if($Folder.Name -ne 'vm'){
      if($Path -eq '\'){
        $currentPath = "$Path$($Folder.Name)"
      }
      else{
        $currentPath = "$Path\$($Folder.Name)"
      }
    }
    else{
      $currentPath = '\'
    }
    $vmIds = $Folder.ChildEntity | where {$_.Type -eq 'VirtualMachine'}
    if($vmIds){
      $vms = Get-View -Id $vmIds
      New-Object PSObject -Property @{
        FolderPath =  $currentPath
        '#VM' = $vms.Count
        '#vCPU' = $vms | %{$_.Config.Hardware.NumCPU} | Measure-Object -Sum | select -ExpandProperty Sum
        'vRAM GB' = [math]::Round(($vms | %{$_.Config.Hardware.MemoryMB} |
                                  Measure-Object -Sum | Select -ExpandProperty Sum)/1KB,1)
      }
    }
    else{
      New-Object PSObject -Property @{
        FolderPath =  $currentPath
        '#VM' = 0
        '#vCPU' = 0
        'vRAM GB' = 0
      }
     
    }
    $folderIds = $Folder.ChildEntity | where {$_.Type -eq 'Folder'}
    if($folderIds){
      $folderIds | %{
        Get-FolderPath -Folder $_ -Path $currentPath
      }
    }
#  }
}
 
$dcName = 'LDT-Datacenter'
$root = Get-Datacenter -Name $dcName | Get-Folder -Name 'vm'
 
Get-FolderPath -FolderMoRef $root.ExtensionData.Moref |
Select FolderPath,'#VM','#vCPU','vRAM GB' |
Export-Csv z:\dropbox\desktop\vm-folder-report.csv -NoTypeInformation -UseCulture