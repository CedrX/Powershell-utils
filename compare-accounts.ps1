function Remove-accent([string]$string)
{
   $objD = $string.Normalize([Text.NormalizationForm]::FormD)
   $sb = New-Object Text.StringBuilder

   for($i = 0; $i -lt $objD.Length; $i++) {
       $c = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($objD[$i])
       if($c -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
         [void]$sb.Append($objD[$i])
       }
   }
   return "$sb".Normalize([Text.NormalizationForm]::FormC)
}


$rootdn = "DC=ads,dc=contoso,dc=com"
$dn = "OU=inist,$rootdn"
$domain = "LDAP://petra.ads.contoso.com:389/$dn"
$useragent = "ADS\adm"
$userpass = 'pa$$w0rd'
$auth = [System.DirectoryServices.AuthenticationTypes]::FastBind
$Filter = "(&(objectClass=user)(objectCategory=person)(!(objectClass=contact))(physicalDeliveryofficeName=*))"
$root = New-Object -TypeName System.DirectoryServices.DirectoryEntry($domain, $useragent, $userpass, $auth)
$query = New-Object System.DirectoryServices.DirectorySearcher($root,$Filter)
$query.Asynchronous = $true
$objClass = ($query.findall())
write-Host $objClass.Count

$RootLdapDN = "dc=contoso,dc=com"
$LdapDN = "ou=people,$RootLdapDN"
$LdapDomain = "LDAP://ldap.contoso.com:389/$LdapDN"
$useragent = 'cn=appli_ldap,ou=administrateur,dc=contoso,dc=com'
$userpass = 'ldappasswd'
$LdapDEntry = New-Object -TypeName System.DirectoryServices.DirectoryEntry($LdapDomain, $useragent, $userpass, $auth)
#searcher.SearchScope = System.DirectoryServices.SearchScope.Subtree

foreach($entity in $objClass) {
    $CN_Normalized = $entity.Properties.cn
    $CN_Normalized = $CN_Normalized -replace ","," "
    $Filter = "(&(cn="+$CN_Normalized+"))"
    #write-Host $Filter
    $LdapQuery = New-Object System.DirectoryServices.DirectorySearcher($LdapDEntry,$Filter)
    $LdapQuery.Asynchronous = $true
    $objLdapClass = ($LdapQuery.Findall())
    if($objLdapClass.Count -eq 0) { Write-Host $entity.Properties.cn}
    
}