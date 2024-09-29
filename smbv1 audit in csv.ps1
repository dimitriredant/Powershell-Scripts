
# This powershell is to be executed on a server to have a CSV containing all systems that are using SMBv1 protocol to connect.
# It is a way in analysing the impact before removing legacy SMBv1 from a server.

# a CSV that is created for saving log from SMBv1
$path = "SMBv1-log.csv"
Add-Content -Value "clientIP,clientName,clientos,server,TimeCreated" -Path $path
$Events = Get-WinEvent -LogName Microsoft-Windows-SMBServer/Audit
ForEach ($Event in $Events) {
    $eventXML = $Event.ToXml()
    $xml = [xml]$eventXML
    $clientIP = $xml.Event.SelectSingleNode("//*[@Name='ClientName']") | select -ExpandProperty '#text'
    $clientName = ([system.net.dns]::GetHostByAddress($clientIP )).hostname 
    $clientOS = Get-ADComputer $clientName.TrimEnd("<your FQDN>") -Properties OperatingSystem | Select-Object OperatingSystem
    $server = $Event.MachineName
    $TimeCreated = $Event.TimeCreated
    Add-Content -Value "$clientIP,$clientName,$clientOS,$server,$TimeCreated" -Path $path
}