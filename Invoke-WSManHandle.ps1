function Invoke-WSManHandle {
    [CmdletBinding()]
    param()
    BEGIN{}
    PROCESS{
        while ($true) {
            $input = Read-Host "WSManHandle> "  # Custom prompt
            if ($input.Equals("exit") -or $input.Equals("q")) { break }  # Exit condition
            if ($input.Equals("")){

            }
            try {
                Invoke-Expression $input  # Execute input
            } catch {
                Write-Host "Error: $_"
            }
        }
    }
    END{}

}


$PSHosts = Get-PSHostProcessInfo

[System.Management.Automation.Runspaces.NamedPipeConnectionInfo[]]$namedPipeConnectionInfoArray = @()

write-host "Creating NamedPipeConnectionInfo Objects"
foreach($PSHost in $PSHosts){
    if($PSHost.ProcessId -ne $pid){
        $namedPipeConnectionInfo = new-object System.Management.Automation.Runspaces.NamedPipeConnectionInfo
        $namedPipeConnectionInfo.ProcessId = $PSHost.ProcessId
        $namedPipeConnectionInfo.AppDomainName = $PSHost.AppDomainName
        $namedPipeConnectionInfoArray += $namedPipeConnectionInfo
    }
}
write-host "NamedPipeConnectionInfo Objects Created"

#$namedPipeConnectionInfoArray

write-host "Creating Runspaces"
[System.Management.Automation.Runspaces.Runspace[]]$runspaceArray = @()
foreach($namedPipeConnectionInfo in $namedPipeConnectionInfoArray){
    $runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($namedPipeConnectionInfo)
    $runspace.Open()
    $runspaceArray += $runspace
}
write-host "Runspaces Created"

write-host "Creating Powershell Objects"
$pshellArray = @()
foreach ($runspace in $runspaceArray){
    $psh = [System.Management.Automation.PowerShell]::create()
    $psh.Runspace = $runspace
    $pshellArray += $psh

}
write-host "Powershell Objects Created"

Write-Host "Now run whatever you want!"
#write-host "Enumerating Runspaces in each Powershell instance"
$pshostRunspaces = [System.Collections.ArrayList]@()
foreach($psh in $pshellArray){
    $psh.AddScript({$pid})
    $results = [PSCustomObject]@{
        psh = $psh;
        async = $psh.BeginInvoke();
        results = $null;
    }
    $pshostRunspaces.Add($results) | Out-Null

}


foreach($pshostrunspace in $pshostRunspaces){
    $pshostrunspace.results = $pshostrunspace.psh.EndInvoke($pshostrunspace.async)
    $pshostrunspace.psh.runspace.close()
    $pshostrunspace.psh.runspace.dispose()
}

$pshostRunspaces.results
