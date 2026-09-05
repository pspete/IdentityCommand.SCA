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

Describe 'ConvertFrom-SCAApiValue' {

    It 'returns the name and description of policy status <Value>' -TestCases @(
        @{ Value = 1; Name = 'Active'; Description = 'The policy is active' }
        @{ Value = 3; Name = 'Expired'; Description = 'The policy has expired' }
        @{ Value = 4; Name = 'Error'; Description = 'There is an error in the policy' }
        @{ Value = 6; Name = 'Validating'; Description = 'The policy is currently being validated' }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Value = $Value; Name = $Name; Description = $Description } {
            $Result = ConvertFrom-SCAApiValue -Name PolicyStatus -Value $Value
            $Result.Value | Should -Be $Value
            $Result.Name | Should -Be $Name
            $Result.Description | Should -Be $Description
        }
    }

    It 'returns the name of a cloud provider value' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            (ConvertFrom-SCAApiValue -Name CloudProvider -Value 4).Name | Should -Be 'AZURE_ENTRA_ID'
        }
    }

    It 'returns the value with no name for a value it has no definition for' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = ConvertFrom-SCAApiValue -Name PolicyStatus -Value 99
            $Result.Value | Should -Be 99
            $Result.Name | Should -BeNullOrEmpty
            $Result.Description | Should -BeNullOrEmpty
        }
    }

    It 'accepts pipeline input' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            (1, 6 | ConvertFrom-SCAApiValue -Name PolicyStatus).Name | Should -Be @('Active', 'Validating')
        }
    }

    It 'round trips a value converted with ConvertTo-SCAApiValue' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Value = ConvertTo-SCAApiValue -Name PolicyStatus -Value Expired
            (ConvertFrom-SCAApiValue -Name PolicyStatus -Value $Value).Name | Should -Be 'Expired'
        }
    }

}
