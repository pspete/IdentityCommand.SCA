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

Describe 'Get-SCAPolicyTextPattern' {

    It 'returns a pattern for <Name>' -TestCases @(
        @{ Name = 'Name' }
        @{ Name = 'Description' }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Name = $Name } {
            Get-SCAPolicyTextPattern -Name $Name | Should -Not -BeNullOrEmpty
        }
    }

    It 'returns a pattern which is a valid regular expression for <Name>' -TestCases @(
        @{ Name = 'Name' }
        @{ Name = 'Description' }
    ) {
        #A single backslash in place of the API's escaped pair makes the expression unusable
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Name = $Name } {
            { 'Finance' -cmatch $(Get-SCAPolicyTextPattern -Name $Name) } | Should -Not -Throw
        }
    }

    It 'accepts <Character> in a policy name' -TestCases @(
        @{ Character = ' ' }
        @{ Character = '-' }
        @{ Character = '_' }
        @{ Character = '.' }
        @{ Character = '@' }
        @{ Character = '!' }
        @{ Character = '+' }
        @{ Character = ',' }
        @{ Character = '/' }
        @{ Character = ':' }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Character = $Character } {
            "Policy$Character" | Should -MatchExactly $(Get-SCAPolicyTextPattern -Name Name)
        }
    }

    It 'rejects <Character> in a policy name' -TestCases @(
        @{ Character = '(' }
        @{ Character = ')' }
        @{ Character = '&' }
        @{ Character = "'" }
        @{ Character = '"' }
        @{ Character = '%' }
        @{ Character = '{' }
        @{ Character = "`t" }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Character = $Character } {
            "Policy$Character" | Should -Not -MatchExactly $(Get-SCAPolicyTextPattern -Name Name)
        }
    }

    It 'accepts <Character> in a policy description, which a policy name does not' -TestCases @(
        @{ Character = '{' }
        @{ Character = '}' }
        @{ Character = '$' }
        @{ Character = ']' }
        @{ Character = '^' }
    ) {
        InModuleScope -ModuleName $Script:SCAModuleName -Parameters @{ Character = $Character } {
            "Policy$Character" | Should -MatchExactly $(Get-SCAPolicyTextPattern -Name Description)
            "Policy$Character" | Should -Not -MatchExactly $(Get-SCAPolicyTextPattern -Name Name)
        }
    }

    It 'requires a policy name to have a value' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            '' | Should -Not -MatchExactly $(Get-SCAPolicyTextPattern -Name Name)
        }
    }

    It 'allows a policy description to be empty' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            '' | Should -MatchExactly $(Get-SCAPolicyTextPattern -Name Description)
        }
    }

    It 'rejects an unknown field' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Get-SCAPolicyTextPattern -Name SomeField } | Should -Throw
        }
    }

}
