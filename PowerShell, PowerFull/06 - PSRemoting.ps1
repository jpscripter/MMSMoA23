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

