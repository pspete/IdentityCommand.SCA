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

Describe 'Select-SCARequestProperty' {

    It 'returns only the supplied properties' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Select-SCARequestProperty -Property @('name', 'description') -BoundParameter @{ name = 'SomeName' }
            @($Result.Keys) | Should -Be @('name')
        }
    }

    It 'returns the properties in the requested order' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Select-SCARequestProperty -Property @('csp', 'name', 'description') -BoundParameter @{ description = 'd'; name = 'n'; csp = 'AWS' }
            @($Result.Keys) | Should -Be @('csp', 'name', 'description')
        }
    }

    It 'ignores parameters which are not expected properties' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Select-SCARequestProperty -Property @('name') -BoundParameter @{ name = 'SomeName'; policy_id = 'SomePolicy' }
            $Result.Keys | Should -Not -Contain 'policy_id'
        }
    }

    It 'returns an empty set when no parameters were supplied' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            (Select-SCARequestProperty -Property @('name') -BoundParameter $null).Count | Should -Be 0
        }
    }

}
