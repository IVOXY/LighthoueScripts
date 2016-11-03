
#Remove Old Adapters: Done

get-vmhostnetworkadapter -name vmk3 | remove-vmhostnetworkadapter
#get-vmhostnetworkadapter -name vmk4 | remove-vmhostnetworkadapter


# Add new VMKernel Adapter



$vs = Get-VirtualSwitch -Name "dSwitch0"
$pg = Get-VirtualPortGroup -Name "VLAN57*"
$startip = 120




ForEach ($esxhost in get-vmhost) {

   $ip = "10.6.126.$startip"
   
   new-vmhostnetworkadapter -vmhost $esxhost -PortGroup $pg -VirtualSwitch $vs -VMotionEnabled:$true
   
   $startip++
}

