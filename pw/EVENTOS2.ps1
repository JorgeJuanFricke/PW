$hosts = 'localhost'
foreach ($host1 in $hosts) {
    Get-WinEvent -computername $host1 -Logname 'security' -Maxevents 100 -FilterXPath '*[system[EventID=4625]]'
}
