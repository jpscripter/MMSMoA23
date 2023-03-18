#region Minimum Class Declaration
class ExampleClass {
    [string]$ExampleProperty
}
$Example = [ExampleClass]::new()
#endregion

#region Example with multiple constructors
class ExampleClass2 {
    [string]$Type
    [int]$Value
    [char]$Letter
    [boolean]$Set

    ExampleClass2() {
        $this.Type = "Blank"
        $this.Value = $null
        $this.Letter = $null
        $this.Set = $false
    }

    ExampleClass2([int]$Value) {
        $this.Type = "Integer Only"
        $this.Value = $Value
        $this.Letter = $null
        $this.Set = $false
    }

    ExampleClass2([char]$Letter) {
        $this.Type = "Letter"
        $this.Value = $null
        $this.Letter = $Letter
        $this.Set = $false
    }

    ExampleClass2([int]$Value, [char]$Letter, [boolean]$Set) {
        $this.Type = "Everything"
        $this.Value = $Value
        $this.Letter = $Letter
        $this.Set = $Set
    }
}

$Example2a = [ExampleClass2]::new()
$Example2b = [ExampleClass2]::new(1337)
$Example2c = [ExampleClass2]::new([Char]'c')
$Example2d = [ExampleClass2]::new(1337, 'd', $true)
#endregion

#region Exmaple with multiple constructors and safeguards
class ExampleClass3 {
    [string]$Type
    [Int32]$Value
    [char]$Letter
    [boolean]$Set

    ExampleClass3() {
        $this.Type = "Blank"
        $this.Value = $null
        $this.Letter = $null
        $this.Set = $false
    }

    ExampleClass3([string]$Value) {
        $Invalid = $true
        try {
            $this.Value = [System.Convert]::ToInt32($Value)
            $this.Type = "Integer Only"
            $this.Letter = $null
            $this.Set = $false
            $Invalid = $false
        } catch [System.Management.Automation.MethodInvocationException] {}
        try {
            $this.Letter = [System.Convert]::ToChar($Value)
            $this.Type = "Character"
            $this.Value = $null
            $this.Set = $false
            $Invalid = $false
        } catch [System.Management.Automation.MethodInvocationException] {}
        if ($Invalid) {
            throw [System.Management.Automation.MethodInvocationException]
        }
    }

    ExampleClass3([int]$Value, [char]$Letter, [boolean]$Set) {
        $this.Type = "Everything"
        $this.Value = $Value
        $this.Letter = $Letter
        $this.Set = $Set
    }
}

$Example3a = [ExampleClass3]::new('1234')
$Example3a
$Exmaple3b = [ExampleClass3]::new(12345)
$Exmaple3b
$Example3c = [ExampleClass3]::new('x')
$Example3c
$Example3d = [ExampleClass3]::new('xyz')
$Example3d
#endregion