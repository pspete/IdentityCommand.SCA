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

Describe 'New-SCAPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'jobId' = 'SomeJob' }
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

        $Roles = New-SCAPolicyRoleDefinition -entityId 'arn:aws:iam::123451234567:role/examplerole' -entitySourceId '123451234567'
        $Identities = New-SCAPolicyIdentityDefinition -entityName 'John.D@company.com' -entitySourceId 'A1B2C3D4' -entityClass user
        $AccessRules = New-SCAPolicyAccessRuleDefinition -days Monday -maxSessionDuration 2 -timeZone 'Europe/London'

        $Script:response = New-SCAPolicy -csp AWS -name SomePolicy -description SomeDescription -startDate '2099-07-12' -roles $Roles -identities $Identities -accessRules $AccessRules
    }

    It 'sends request to the create-policy endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies/create-policy'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
    }

    It 'requests version 2.0 of the policies API' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $Headers['X-API-Version'] -eq '2.0'
        } -Times 1 -Exactly -Scope It
    }

    It 'sends the expected policy properties' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $Content = $Body | ConvertFrom-Json
            ($Content.csp -eq 'AWS') -and ($Content.name -eq 'SomePolicy') -and ($Content.description -eq 'SomeDescription')
        } -Times 1 -Exactly -Scope It
    }

    It 'sends roles and identities as arrays' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $Content = $Body | ConvertFrom-Json
            (@($Content.roles).Count -eq 1) -and (@($Content.identities).Count -eq 1) -and ($Content.roles[0].entitySourceId -eq '123451234567')
        } -Times 1 -Exactly -Scope It
    }

    It 'sends the start date in ISO format' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            #Asserted against the JSON text - ConvertFrom-Json revives an ISO string as a [datetime]
            $Body -match '"startDate":\s*"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z"'
        } -Times 1 -Exactly -Scope It
    }

    It 'omits properties which were not supplied' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            ($Body | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'endDate'
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the result' {
        $Script:response.jobId | Should -Be 'SomeJob'
    }

}
