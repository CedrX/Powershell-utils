
write-Host "("
for($i=1;$i -lt 16; $i++) {
    $macString = "08002701"
    $macdhcp = "08-00-27-01"
    $stringIP = (Get-DnsServerResourceRecord -ComputerName tikal -ZoneName "ads.intra.inist.fr" -Name "form$i").RecordData.IPV4address.IPAddressToString
    #$stringIP
    $tabIPv4 = $stringIP.split('.')
    
    for($j=2;$j -lt $tabIPV4.Length;$j++) {
        $octet = [System.Convert]::ToInt32($tabIPv4[$j])
        if($octet -lt 16) {
            $macString += "0"+ [System.convert]::ToString($octet,16)
            $macdhcp += "-0"+[System.convert]::ToString($octet,16)
        }
        else {
            $macString += [System.convert]::ToString($octet,16)
            $macdhcp += "-"+[System.convert]::ToString($octet,16)
        }
    }
    #write-host $macstring
    write-Host "$macdhcp,"
    #$endIP = [System.convert]::ToString($i,10)
    #if($i -lt 10) {
    #    $endIP = "0"+$endIP
    #}
        
    #write-Host "Add-DhcpServerv4Reservation -ScopeId 172.16.96.0 -IPAddress "172.16.105.1$endIP" -Name "VKFORM$i.ads.intra.inist.fr" -Type Both -ClientId "3C-97-0E-E4-B2-75" -ComputerName vpads-dc1"
}
write-Host ")"

