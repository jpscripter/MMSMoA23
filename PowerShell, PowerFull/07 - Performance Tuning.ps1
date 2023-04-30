Import-Module "PerformanceTests.psm1" -Force
#region Typecasting
$Services = Get-Service

$BaselineCode = {
    foreach ($svc in $Services) {
        if ($svc.Status -eq 'Running' -and $Svc.StartupType -eq 'Automatic') {
            Write-Output $svc.Name
        }
    }
}

$OptimizedCode = {
    foreach ($svc in $Services) {
        if ($svc.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running -and $Svc.StartupType -eq [System.ServiceProcess.ServiceStartMode]::Automatic) {
            Write-Output $svc.Name
        }
    }
}

$Baseline = Test-Performance -Count 10 -ScriptBlock $BaselineCode
$WithEnum = Test-Performance -Count 10 -ScriptBlock $OptimizedCode
Get-Winner -AName 'Baseline' -AValue $Baseline.Median -BName "Enumerated" -BValue $WithEnum.Median

Test-MemoryImpact -ScriptBlock $BaselineCode
Test-MemoryImpact -ScriptBlock $OptimizedCode
#endregion

#region .NET Types
$ArrayCode = {
    $Array = @()
    for ($i = 0; $i -lt 10000; $i++) {
        $Array += $i
    }
}

$ListCode = {
    [System.Collections.Generic.List[Object]]$List = [System.Collections.Generic.List[Object]]::new()
    for ($i = 0; $i -lt 10000; $i++) {
        [void]$List.Add($i)
    }
}

$ArrayRun = Test-Performance -Count 5 -ScriptBlock $ArrayCode
$ListRun = Test-Performance -Count 5 -ScriptBlock $ListCode
Get-Winner -AName 'Array' -AValue $ArrayRun.Median -BName 'List' -BValue $ListRun.Median

Test-MemoryImpact -ScriptBlock $ArrayCode
Test-MemoryImpact -ScriptBlock $ListCode
#endregion

#region Avoiding Output
$Output = {
    $bits = 0..999
    for ($i = 0; $i -lt 1000; $i++) {
        $bits[$i]++
        Write-Output "`$bits[$($i)] is now $($bits[$i])"
    }
}

$NoOutput = {
    $pieces = 0..999
    $InformationPreference = 'SilentlyContinue'
    for ($p = 0; $p -lt 1000; $p++) {
        $pieces[$p]++
        Write-Output "`$pieces[$($p)] is now $($pieces[$p])"
    }
}

$OutputRun = Test-Performance -Count 5 -ScriptBlock $Output
$NoOutputRun = Test-Performance -Count 5 -ScriptBlock $NoOutput
Get-Winner -AName "Output" -AValue $OutputRun.Median -BName "No Output" -BValue $NoOutputRun.Median

Test-MemoryImpact -ScriptBlock $Output
Test-MemoryImpact -ScriptBlock $NoOutput
#endregion

#region Trace-Command
$ScriptBlock = {
    $Services = Get-Service -ErrorAction SilentlyContinue
    $Services[5].Status -eq 'Running'
}

Write-Output (Get-Date -f "yyyy-MM-dd HH:mm:ss.ffff")
Trace-Command -ListenerOption DateTime -Expression $ScriptBlock -Option All -Name * -PSHost
Write-Output (Get-Date -f "yyyy-MM-dd HH:mm:ss.ffff")

$ScriptBlock = {
    $Services = Get-Service -ErrorAction ([System.Management.Automation.ActionPreference]::SilentlyContinue)
    $Services[5].Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running
}

function BPEFunction {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [Int32]$Current
    )
    Begin {
        Write-Output "Start Processing $($Current.Count) Items"
    }
    Process {
        Write-Output "Processing $($Current)"
    }
    End {
        Write-Output "Finished Processing"
    }
}

$ScriptBlock = {
        1..25 | BPEFunction
}

$ScriptBlock = {
    $Arr = 1..25
    foreach ($item in $Arr) {
        BPEFunction -Current $item
    }
}

#endregion