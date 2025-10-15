# WSManHandle

Invoke-WSManHandle is a lateral movement techique that hijacks open wsman/winrm sessions. It does this by abusing PowerShell runspace debugging.

I was going down a PowerShell runspaces rabbit hole and found out that Jake from State Farm (tm?) had already beat me to 90% of the way there with this:
https://engineering.statefarm.com/runspace-debugging-finding-creative-opportunities-for-code-execution-and-lateral-movement-bb1f58f7de17


