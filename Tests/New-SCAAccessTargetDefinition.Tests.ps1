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

Describe 'New-SCAAccessTargetDefinition' {

    It 'returns an object with the expected type' {
        (New-SCAAccessTargetDefinition -workspaceId SomeWorkspace -roleId SomeRole).PSObject.TypeNames |
            Should -Contain 'IdCmd.SCA.Definition.Access.Target'
    }

    It 'returns a target identified by role id' {
        $Target = New-SCAAccessTargetDefinition -workspaceId SomeWorkspace -roleId SomeRole
        $Target.workspaceId | Should -Be 'SomeWorkspace'
        $Target.roleId | Should -Be 'SomeRole'
        $Target.Keys | Should -Not -Contain 'roleName'
    }

    It 'returns a target identified by role name' {
        $Target = New-SCAAccessTargetDefinition -workspaceId SomeWorkspace -roleName SomeRole
        $Target.roleName | Should -Be 'SomeRole'
        $Target.Keys | Should -Not -Contain 'roleId'
    }

    It 'does not accept both a role id and a role name' {
        { New-SCAAccessTargetDefinition -workspaceId SomeWorkspace -roleId SomeRole -roleName SomeRole } |
            Should -Throw
    }

    It 'appends to a previous definition' {
        $Targets = New-SCAAccessTargetDefinition -workspaceId SomeWorkspace -roleId SomeRole
        $Targets = New-SCAAccessTargetDefinition -Definition $Targets -workspaceId SomeOtherWorkspace -roleName SomeRole

        @($Targets).Count | Should -Be 2
        @($Targets)[1].workspaceId | Should -Be 'SomeOtherWorkspace'
    }

}
