# As Admin
$Cred = Get-Credential -UserName Corp\LabAdmin
$PSSession = New-PSSession -VMName HYD-CM1 -Credential $Cred
