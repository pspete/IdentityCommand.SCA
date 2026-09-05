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

Describe 'New-SCAPolicyIdentityDefinition' {

    It 'returns an object with the expected type' {
        (New-SCAPolicyIdentityDefinition -entityName SomeUser -entitySourceId SomeSource -entityClass user).PSObject.TypeNames |
            Should -Contain 'IdCmd.SCA.Definition.Policy.Identity'
    }

    It 'returns the supplied values' {
        $Identity = New-SCAPolicyIdentityDefinition -entityName SomeUser -entitySourceId SomeSource -entityClass group
        $Identity.entityName | Should -Be 'SomeUser'
        $Identity.entitySourceId | Should -Be 'SomeSource'
        $Identity.entityClass | Should -Be 'group'
    }

    It 'rejects an unsupported entity class' {
        { New-SCAPolicyIdentityDefinition -entityName SomeUser -entitySourceId SomeSource -entityClass computer } |
            Should -Throw
    }

    It 'appends to a previous definition' {
        $Identities = New-SCAPolicyIdentityDefinition -entityName SomeUser -entitySourceId SomeSource -entityClass user
        $Identities = New-SCAPolicyIdentityDefinition -Definition $Identities -entityName SomeGroup -entitySourceId SomeSource -entityClass group

        @($Identities).Count | Should -Be 2
        @($Identities)[1].entityClass | Should -Be 'group'
    }

}
