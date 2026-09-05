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

Describe 'ConvertTo-SCAJsonBody' {

    It 'serialises an object to JSON' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            (ConvertTo-SCAJsonBody -Body @{ name = 'SomeName' } | ConvertFrom-Json).name | Should -Be 'SomeName'
        }
    }

    It 'preserves a single element collection as an array' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Json = ConvertTo-SCAJsonBody -Body @{ sessionIds = @('SomeSession') }
            $Json | Should -Match '"sessionIds":\s*\['
        }
    }

    It 'preserves property order' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Json = ConvertTo-SCAJsonBody -Body ([ordered]@{ csp = 'AWS'; name = 'SomeName' })
            ($Json | ConvertFrom-Json).PSObject.Properties.Name | Should -Be @('csp', 'name')
        }
    }

    It 'emits compact JSON when requested' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            ConvertTo-SCAJsonBody -Body @{ name = 'SomeName' } -Compress | Should -Be '{"name":"SomeName"}'
        }
    }

}
