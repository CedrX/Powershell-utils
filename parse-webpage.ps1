$url = "https://the.earth.li/~sgtatham/putty/latest/w64/"

$webproxy = "http://proxyout.contoso.com:8080"
$proxy = new-object System.Net.WebProxy
$proxy.Address = $webproxy

$request = [System.Net.WebRequest]::Create($url)
$request.Method="Get"
$reponse = $request.GetResponse()
$reponseStream = $reponse.GetResponseStream()
$readstream = new-object System.IO.StreamReader($reponseStream);
$pageContent = $readstream.ReadToEnd()
$pageContent.GetType()
$pageContent | select-string -Pattern ".msi"


