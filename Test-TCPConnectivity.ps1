<#

.Synopsis
    Test TCP port Connectivity for all IP's behind a DNS
.DESCRIPTION
    Combining Resolve-DNSName and Test-Netconnection to have a check on tcp port connectivty for all IP's behind a DNS
.EXAMPLE
    Test-TCPConnectivity -url "hub.dsbackend.com" -port 443
.NOTES
    Created by Dimitri Redant - January 15, 2025
    Version 1.0
#>

Function Test-TCPConnectivity {

    param (
        [string]$url,
        [int]$port
    )

    $IPs = Resolve-DnsName $url | Select-Object IPAddress

    Foreach ($IP in $IPs) {
        Try {
            Test-NetConnection $IP.IPAddress -Port $port -WarningAction SilentlyContinue | Select-Object SourceAddress, RemoteAddress, TcpTestSucceeded
        } Catch {}
    }
}