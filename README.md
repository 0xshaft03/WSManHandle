# WSManHandle

Invoke-WSManHandle is a lateral movement techique that hijacks open wsman/winrm sessions. It does this by abusing PowerShell runspace debugging.

I was going down a PowerShell runspaces rabbit hole and found out that Jake from State Farm (tm?) had already beat me to 90% of the way there with this:
https://engineering.statefarm.com/runspace-debugging-finding-creative-opportunities-for-code-execution-and-lateral-movement-bb1f58f7de17

Once you are "debugging" a runspace, if that runspace has an open pssession, you can simply create a new PowerShell object with [System.Management.Automation.PowerShell]::Create() and add a scriptblock to it.
Next, set that object's runspace property to the runspace property of whatever pssession that you want to run your scriptblock in.
????
Profit
