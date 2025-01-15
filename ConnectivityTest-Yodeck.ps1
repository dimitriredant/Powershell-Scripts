<#

Yodeck requires some URLs on HTTP(s) to be reacheable from the network the raspberry pi is within.
In order to check this there is this small checking script written.

hub.dsbackend.com	443/TCP	[Required] IoT hub used for communication with Players from the Yodeck Platform
repo.dsbackend.com	80/TCP	[Required]Software Updates repository – no HTTPS required since packages are digitally signed
dsbackend.s3.amazonaws.com 443/TCP	[Required] Scheduling Information and Media Downloads
assets.dsbackend.com	443/TCP	[Required] Scheduling Information and Media Downloads
remote.dsbackend.com	1194/TCP	[Optional] Used by our Support Team for advanced remote troubleshooting
widgets.dsbackend.com	443/TCP	[Optional] Used by some of our Apps requiring online info (Weather, etc.)

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

Test-TCPConnectivity -url "hub.dsbackend.com" -port 443
Test-TCPConnectivity -url "repo.dsbackend.com" -port 80
Test-TCPConnectivity -url "dsbackend.s3.amazonaws.com" -port 443
Test-TCPConnectivity -url "assets.dsbackend.com" -port 443
Test-TCPConnectivity -url "widgets.dsbackend.com" -port 443