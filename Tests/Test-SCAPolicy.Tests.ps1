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

Describe 'Test-SCAPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'jobId' = 'SomeJob' }
        }

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'job_id' = 'SomeJob'; 'operation' = 'SomeOperation'; 'status' = 'Success' }
        } -ParameterFilter { $URI -match 'integrations/status' }

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

        $Script:response = Test-SCAPolicy -policyId SomePolicy
    }

    It 'sends request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies/validate'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
    }

    It 'sends the policy id in the request body' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            ($Body | ConvertFrom-Json).policyId -eq 'SomePolicy'
        } -Times 1 -Exactly -Scope It
    }

    It 'reports the status of the job which was started' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/integrations/status?jobId=SomeJob'
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the job status in place of the job id' {
        $Script:response.status | Should -Be 'Success'
        $Script:response.job_id | Should -Be 'SomeJob'
    }

}
