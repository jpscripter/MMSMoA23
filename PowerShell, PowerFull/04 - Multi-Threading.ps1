# Order and race conditions

# Parallel
1..10 | ForEach-Object -Parallel {
    $random = Get-Random -Minimum 1 -Maximum 5
    Start-Sleep -second $random
    Write-Host "Processing $Pid $_"
} 

$ScriptBlock = 
{
param($times)
    For($i = 0; $i -lt $times;$i++){
        [double] $halfpi=1
        [int] $num=1
        [double] $factorial=1
        [double] $oddfactorial=1
        [double] $pi = 1
        [double] $previouspi = 0
        while ($previouspi -ne $pi) {
            $previouspi = $pi
            $factorial *= $num
            $oddfactorial *= (($num*2)+1)
            $halfpi += $factorial / $oddfactorial
            $pi = 2 * $halfpi
            $num++
        }
    }
}

## more threads might not mean faster
foreach ($Threads in (2..20)){
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $initialSessionState = [initialsessionstate]::CreateDefault() # Enter PSSnapins here
    $MINRunspaces = 1
    $MAXRunspaces = $Threads
    $RunSpacePool = [RunspaceFactory]::CreateRunspacePool($minRunspaces,$MAXRunspaces,$initialSessionState,$Host)
    #$RunSpacePool.ApartmentState = "MTA" # Thread safe com object coding
    $RunSpacePool.Open()
    $times = 10000/$Threads
    $PowershellArray = @()
    For ($Counter = 0; $Counter -lt 10; $counter++){
        $PowerShell = [PowerShell]::Create()
        $PowerShell.Runspacepool = $RunSpacePool
        $Null = $PowerShell.AddScript($ScriptBlock)
        $Null = $PowerShell.AddParameter('Times',$times)
        $Null = $PowerShell.BeginInvoke()
        $PowershellArray += $powershell
    }
    Start-sleep -Seconds 1
    While ($PowershellArray.InvocationStateInfo.State -contains 'Running'){
    }
    $stopwatch.Stop()
    "$Threads - $($Stopwatch.Elapsed)"
}


#Synchronized hashtables
$hash = [hashtable]::Synchronized(@{})

$initialSessionState = [initialsessionstate]::CreateDefault() # Enter PSSnapins here
$MINRunspaces = 1
$MAXRunspaces = 2
$RunSpacePool = [RunspaceFactory]::CreateRunspacePool($minRunspaces,$MAXRunspaces,$initialSessionState,$Host)
$RunSpacePool.Open()
$ScriptBlock = {
    param(
        $hash
    )
    $testVariable = $true
    $hash.add('New',$true)
}
$PowerShell = [PowerShell]::Create()
$PowerShell.Runspacepool = $RunSpacePool
$Null = $PowerShell.AddScript($ScriptBlock)
$Null = $PowerShell.AddParameter('hash',$hash)
$Null = $PowerShell.Invoke()

$testVariable
$hash