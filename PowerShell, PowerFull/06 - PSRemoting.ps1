# As Admin
$Cred = Get-Credential -UserName Corp\LabAdmin
$PSSession = New-PSSession -VMName HYD-CM1 -Credential $Cred
$PSSession.Runspace
$PSSession.Runspace.OriginalConnectionInfo.Credential


$powershell = [Powershell]::Create()
$Powershell.Runspace = $PSSession.Runspace
$Powershell.Commands.AddScript('Whoami; $Env:computername',$True)
$powershell.Invoke()

invoke-command -Session $PSSession -ScriptBlock {
    $Using:cred|gm
    $testcred = $Using:cred
}
Enter-PSSession -Session $PSSession

Copy-Item -Path C:\Users\jpscr\Repos\WindowManagement\ -Recurse -Destination c:\repos\ -ToSession $PSSession


$PSSessionGW = New-PSSession -VMName HYD-GW1 -Credential $Cred
invoke-command -Session $PSSessionGW -ScriptBlock {
    $json = get-content -path C:\Windows\Temp\CMScriptConnection.txt -Raw
    $connectionDetails = convertfrom-json $json
    Enter-PSHostProcess -Id $connectionDetails.pid
    #Get-Runspace
    #Debug-Runspace -Id $connectionDetails.runspace
}
Enter-PSSession -Session $PSSessionGW
