BeforeAll {
    $Script:SCAModuleName = 'IdentityCommand.SCA'

    #Get Current Directory
    $Here = Split-Path -Parent $PSCommandPath

    #Resolve Path to Module Directory
    $ModulePath = Resolve-Path "$Here\..\$Script:SCAModuleName"

    #Define Path to Module Manifest
    $ManifestPath = Join-Path "$ModulePath" "$Script:SCAModuleName.psd1"

    if ( -not (Get-Module -Name $Script:SCAModuleName -All)) {

        Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

    }
}

Describe 'Merge-SCAParameter' {

    It 'takes the value of a supplied parameter' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Merge-SCAParameter -Template ([ordered]@{ name = $null }) -BoundParameter @{ name = 'SomeName' }
            $Result['name'] | Should -Be 'SomeName'
        }
    }

    It 'falls back to the template default' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Merge-SCAParameter -Template ([ordered]@{ name = 'DefaultName' }) -BoundParameter @{ }
            $Result['name'] | Should -Be 'DefaultName'
        }
    }

    It 'falls back to the supplied object' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Merge-SCAParameter -Template ([ordered]@{ name = 'DefaultName' }) -BoundParameter @{ } -Fallback ([pscustomobject]@{ name = 'ExistingName' })
            $Result['name'] | Should -Be 'ExistingName'
        }
    }

    It 'preserves the order of the template keys' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Merge-SCAParameter -Template ([ordered]@{ name = $null; description = $null; endDate = $null }) -BoundParameter @{ description = 'SomeDescription' }
            @($Result.Keys) | Should -Be @('name', 'description', 'endDate')
        }
    }

}
