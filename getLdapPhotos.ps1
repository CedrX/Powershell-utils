function ToSimpleString([string]$value, [bool]$trim = $true, [bool]$removeSpaces = $true, [bool]$toLower = $true)
{
    if ($value -eq $null) { return [System.String]::Empty; }

    if ($trim)
    {
        $value = $value.Trim();
    }

    if ($removeSpaces)
    {
        $value = $value.Replace(" ", "-");
    }

    if ($toLower)
    {
        $value = $value.ToLower();
    }

    return $value;
}


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

$RootLdapDN = "dc=contoso,dc=com"
$LdapDN = "ou=people,$RootLdapDN"
$LdapDomain = "LDAP://ldap.intra.contoso.com:389/$LdapDN"
$useragent = 'cn=appli_ldap,ou=admcontosorateur,dc=contoso,dc=com'
$userpass = 'EAtnCL3'
$auth = [System.DirectoryServices.AuthenticationTypes]::FastBind
$LdapDEntry = New-Object -TypeName System.DirectoryServices.DirectoryEntry($LdapDomain, $useragent, $userpass, $auth)
#searcher.SearchScope = System.DirectoryServices.SearchScope.Subtree
$Filter = "(&(objectClass=contosoPerson)(employeeType=personnel))"



$LdapQuery = New-Object System.DirectoryServices.DirectorySearcher($LdapDEntry,$Filter)
$LdapQuery.Asynchronous = $true
$LdapQuery.PageSize = 1000
$objLdapClass = ($LdapQuery.Findall())

#$objLdapClass
$i = 0
foreach($result in $objLdapClass) {
    $arrayBytePhoto = $result.Properties.jpegphoto.Item(0)
    $userName = (ToSimpleString -value $result.Properties.cn);
    $userName = (Remove-accent -string $userName)
    $fileName = $userName + ".jpg"
    Write-Host "Fichier destination : $fileName"
    $fullpath = "D:\tintin\Pictures\ldappictures\"
    $fullpathFileName = $fullpath + $fileName
    Write-Host "Destination folder : $fullpathFileName"
    [System.Io.File]::WriteAllBytes($fullpathFileName, $arrayBytePhoto)
}

