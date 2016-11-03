add-pssnapin VMware.VimAutomation.Core
add-pssnapin VMware.DeployAutomation
add-pssnapin VMware.ImageBuilder

$dvswitch = "dswitch0"

$csv = Import-Csv "C:\Users\ChrisCrow\dropbox\scripts\lighthouse\VLAN List.csv"
foreach ($line in $csv) {

 Get-VDSwitch -Name $dvswitch | New-VDPortgroup -Name $line.desc -NumPorts 8 -VLanId $line.vlan

}
