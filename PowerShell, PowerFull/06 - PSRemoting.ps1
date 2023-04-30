# As Admin
$Cred = Get-Credential -UserName Corp\LabAdmin
$PSSession = New-PSSession -VMName HYD-CM1 -Credential $Cred
$PSSession.Runspace
import-module C:\Users\jpscr\Repos\WindowManagement\WindowManagement.psd1
$powershell = [Powershell]::Create()
$Powershell.Runspace = $PSSession.Runspace
$Powershell.Commands.AddScript('Whoami; $Env:computername',$True)
$powershell.Invoke()

invoke-command -Session $PSSession -ScriptBlock {$Using:cred|gm}

Enter-PSSession -Session $PSSession