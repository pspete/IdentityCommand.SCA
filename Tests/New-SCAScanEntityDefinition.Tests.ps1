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

Describe 'New-SCAScanEntityDefinition' {

    It 'returns an object with the expected type' {
        (New-SCAScanEntityDefinition -account_id '123456789012').PSObject.TypeNames |
            Should -Contain 'IdCmd.SCA.Definition.Scan.EntityId'
    }

    It 'returns the supplied values' {
        $Entity = New-SCAScanEntityDefinition -org_id '098765432109' -account_id '123456789012'
        $Entity.org_id | Should -Be '098765432109'
        $Entity.account_id | Should -Be '123456789012'
    }

    It 'omits the organization id for a standalone account' {
        $Entity = New-SCAScanEntityDefinition -account_id '123456789012'
        $Entity.Keys | Should -Not -Contain 'org_id'
    }

    It 'appends to a previous definition' {
        $Entities = New-SCAScanEntityDefinition -account_id '123456789012'
        $Entities = New-SCAScanEntityDefinition -Definition $Entities -account_id '210987654321'

        @($Entities).Count | Should -Be 2
        @($Entities)[1].account_id | Should -Be '210987654321'
    }

}
