$creds = Get-Credential
$tabservers = Get-ADComputer -Filter * -SearchBase "ou=Serveur,dc=contoso,dc=com"
foreach ($computerName in $tabservers.DNSHostName) {
 if (Test-Connection -ComputerName $computerName -Quiet) { 
        Write-Host "$computerName : Connexion OK" 
        Invoke-Command -ComputerName $computerName -Credential $creds -ScriptBlock {
            $InterfaceObject = $null  
            $InterfaceObject = Get-DnsClientServerAddress | where-object { $_.ServerAddresses -contains "172.16.100.16" }
            if ($interfaceObeject -ne $null) { set-DnsClientServerAddress -InterfaceIndex $interfaceObject.InterfaceIndex -ServerAddress 192.168.129.16, 192.168.129.17 }
        }
    }
  
  else { Write-Host -BackgroundColor "Gray" -ForegroundColor "Red" "$computerName : Connexion KO" }

  }