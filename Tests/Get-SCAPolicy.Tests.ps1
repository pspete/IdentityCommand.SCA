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

Describe 'Get-SCAPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'hits' = 'value' }
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

    }

    Context 'List' {

        BeforeEach {
            $Script:response = Get-SCAPolicy
        }

        It 'sends request to the policies endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'GET' } -Times 1 -Exactly -Scope It
        }

        It 'requests version 2.0 of the policies API' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $Headers['X-API-Version'] -eq '2.0'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request with no body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $null -eq $Body } -Times 1 -Exactly -Scope It
        }

        It 'returns the hits collection' {
            $Script:response | Should -Be 'value'
        }

    }

    Context 'Filters' {

        It 'sends the numeric value of the status filter' {
            $null = Get-SCAPolicy -status Validating
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -match 'status=6'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the numeric value of the cloud provider filter' {
            $null = Get-SCAPolicy -cloud_provider AZURE
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -match 'cloud_provider=2'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the free text filter' {
            $null = Get-SCAPolicy -free_text SomeText
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -match 'free_text=SomeText'
            } -Times 1 -Exactly -Scope It
        }

    }

    Context 'By id' {

        It 'sends request to the by-id endpoint and returns the full result' {
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith { [pscustomobject]@{ policyId = 'SomePolicy' } }
            $Result = Get-SCAPolicy -policy_id SomePolicy
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies/SomePolicy'
            } -Times 1 -Exactly -Scope It
            $Result.policyId | Should -Be 'SomePolicy'
        }

    }

}
