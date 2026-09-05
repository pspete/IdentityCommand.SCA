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

Describe 'ConvertTo-SCAApiValue' {

    It 'returns the numeric value of <Value> as <Expected>' -TestCases @(
        @{ Name = 'CloudProvider'; Value = 'AWS'; Expected = 0 }
        @{ Name = 'CloudProvider'; Value = 'GCP'; Expected = 1 }
        @{ Name = 'CloudProvider'; Value = 'AZURE'; Expected = 2 }
        @{ Name = 'CloudProvider'; Value = 'AWS_IDC'; Expected = 3 }
        @{ Name = 'CloudProvider'; Value = 'AZURE_ENTRA_ID'; Expected = 4 }
        @{ Name = 'PolicyStatus'; Value = 'Active'; Expected = 1 }
        @{ Name = 'PolicyStatus'; Value = 'Expired'; Expected = 3 }
        @{ Name = 'PolicyStatus'; Value = 'Error'; Expected = 4 }
        @{ Name = 'PolicyStatus'; Value = 'Validating'; Expected = 6 }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Name = $Name; Value = $Value; Expected = $Expected } {
            ConvertTo-SCAApiValue -Name $Name -Value $Value | Should -Be $Expected
        }
    }

    It 'matches the value case-insensitively' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            ConvertTo-SCAApiValue -Name CloudProvider -Value 'azure' | Should -Be 2
        }
    }

    It 'throws for an unsupported value' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { ConvertTo-SCAApiValue -Name CloudProvider -Value 'ORACLE' } | Should -Throw
        }
    }

}
