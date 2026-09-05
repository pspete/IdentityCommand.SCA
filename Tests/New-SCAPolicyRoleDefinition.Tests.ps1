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

Describe 'New-SCAPolicyRoleDefinition' {

    It 'returns an object with the expected type' {
        (New-SCAPolicyRoleDefinition -entityId SomeRole -entitySourceId SomeSource).PSObject.TypeNames |
            Should -Contain 'IdCmd.SCA.Definition.Policy.Role'
    }

    It 'returns the supplied values' {
        $Role = New-SCAPolicyRoleDefinition -entityId SomeRole -entitySourceId SomeSource -workspaceType account -organizationId SomeOrg
        $Role.entityId | Should -Be 'SomeRole'
        $Role.entitySourceId | Should -Be 'SomeSource'
        $Role.workspaceType | Should -Be 'account'
        $Role.organizationId | Should -Be 'SomeOrg'
    }

    It 'returns the properties in the order the API expects' {
        $Role = New-SCAPolicyRoleDefinition -entityId SomeRole -entitySourceId SomeSource -workspaceType account -organizationId SomeOrg
        @($Role.Keys) | Should -Be @('entityId', 'workspaceType', 'entitySourceId', 'organizationId')
    }

    It 'omits values which were not supplied' {
        $Role = New-SCAPolicyRoleDefinition -entityId SomeRole -entitySourceId SomeSource
        $Role.Keys | Should -Not -Contain 'workspaceType'
        $Role.Keys | Should -Not -Contain 'organizationId'
    }

    It 'appends to a previous definition' {
        $Roles = New-SCAPolicyRoleDefinition -entityId SomeRole -entitySourceId SomeSource
        $Roles = New-SCAPolicyRoleDefinition -Definition $Roles -entityId SomeOtherRole -entitySourceId SomeSource

        @($Roles).Count | Should -Be 2
        @($Roles)[0].entityId | Should -Be 'SomeRole'
        @($Roles)[1].entityId | Should -Be 'SomeOtherRole'
    }

    It 'requires a definition of the expected type' {
        { New-SCAPolicyRoleDefinition -Definition ([pscustomobject]@{ entityId = 'SomeRole' }) -entityId SomeOtherRole -entitySourceId SomeSource } |
            Should -Throw
    }

}
