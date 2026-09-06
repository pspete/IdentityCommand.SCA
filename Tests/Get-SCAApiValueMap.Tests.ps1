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

Describe 'Get-SCAApiValueMap' {

    It 'defines the value of cloud provider <Member> as <Value>' -TestCases @(
        @{ Member = 'AWS'; Value = 0 }
        @{ Member = 'GCP'; Value = 1 }
        @{ Member = 'AZURE'; Value = 2 }
        @{ Member = 'AWS_IDC'; Value = 3 }
        @{ Member = 'AZURE_ENTRA_ID'; Value = 4 }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Member = $Member; Value = $Value } {
            (Get-SCAApiValueMap -Name CloudProvider)[$Member]['Value'] | Should -Be $Value
        }
    }

    It 'defines the value of policy status <Member> as <Value>' -TestCases @(
        @{ Member = 'Active'; Value = 1 }
        @{ Member = 'Expired'; Value = 3 }
        @{ Member = 'Error'; Value = 4 }
        @{ Member = 'Warning'; Value = 5 }
        @{ Member = 'Validating'; Value = 6 }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Member = $Member; Value = $Value } {
            (Get-SCAApiValueMap -Name PolicyStatus)[$Member]['Value'] | Should -Be $Value
        }
    }

    It 'describes every member of every enumeration' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            foreach ($Name in 'CloudProvider', 'PolicyStatus') {
                $Map = Get-SCAApiValueMap -Name $Name
                foreach ($Member in $Map.Keys) {
                    $Map[$Member]['Description'] | Should -Not -BeNullOrEmpty
                }
            }
        }
    }

    It 'rejects an unknown enumeration' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Get-SCAApiValueMap -Name SomeEnumeration } | Should -Throw
        }
    }

}
