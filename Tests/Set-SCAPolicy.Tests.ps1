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

Describe 'Set-SCAPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{
                'policyId'    = 'SomePolicy'
                'name'        = 'ExistingName'
                'description' = 'ExistingDescription'
                'startDate'   = $null
                'endDate'     = $null
                'roles'       = @([pscustomobject]@{ entityId = 'SomeRole' })
                'identities'  = @([pscustomobject]@{ entityName = 'SomeUser' })
                'accessRules' = $null
            }
        }

        InModuleScope -ModuleName $Script:SCAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.sca.cyberark.cloud'
                User       = $null
                TenantId   = 'SomeTenant'
                SessionId  = 'SomeSession'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Set-SCAPolicy -policy_id SomePolicy -name NewName
    }

    It 'queries the existing policy before updating it' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            ($Method -eq 'GET') -and ($URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies/SomePolicy')
        } -Times 1 -Exactly -Scope It
    }

    It 'sends update request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            ($Method -eq 'PUT') -and ($URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies/SomePolicy')
        } -Times 1 -Exactly -Scope It
    }

    It 'requests version 2.0 of the policies API' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            ($Method -eq 'PUT') -and ($Headers['X-API-Version'] -eq '2.0')
        } -Times 1 -Exactly -Scope It
    }

    It 'sends the updated value' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'PUT') { return $false }
            ($Body | ConvertFrom-Json).name -eq 'NewName'
        } -Times 1 -Exactly -Scope It
    }

    It 'preserves values which were not supplied' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'PUT') { return $false }
            $Content = $Body | ConvertFrom-Json
            ($Content.description -eq 'ExistingDescription') -and ($Content.roles[0].entityId -eq 'SomeRole')
        } -Times 1 -Exactly -Scope It
    }

    It 'does not send the cloud provider' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'PUT') { return $false }
            ($Body | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'csp'
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the result' {
        $Script:response.policyId | Should -Be 'SomePolicy'
    }

    It 'accepts a name made of characters the API allows' {
        { Set-SCAPolicy -policy_id SomePolicy -name 'Finance end of year' -description 'Roll {up} $100 - see note [1]' } | Should -Not -Throw
    }

    It 'rejects a <Field> containing characters the API does not accept' -TestCases @(
        @{ Field = 'name'; Arguments = @{ name = 'Finance (EOY)' } }
        @{ Field = 'name'; Arguments = @{ name = "Finance`tEOY" } }
        @{ Field = 'description'; Arguments = @{ description = 'End of year (EOY)' } }
    ) {
        { Set-SCAPolicy -policy_id SomePolicy @Arguments } | Should -Throw
    }

}
