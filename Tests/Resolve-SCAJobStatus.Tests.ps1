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

Describe 'Resolve-SCAJobStatus' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'job_id' = 'SomeJob'; 'status' = 'Success' }
        }

        InModuleScope -ModuleName $Script:SCAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.sca.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

    }

    It 'requests the status of a job reported in the jobId field' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $null = Resolve-SCAJobStatus -Result ([pscustomobject]@{ jobId = 'SomeJob' })
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/integrations/status?jobId=SomeJob'
        } -Times 1 -Exactly -Scope It
    }

    It 'requests the status of a job reported in the job_id field' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $null = Resolve-SCAJobStatus -Result ([pscustomobject]@{ job_id = 'SomeOtherJob' })
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/integrations/status?jobId=SomeOtherJob'
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the job status' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            (Resolve-SCAJobStatus -Result ([pscustomobject]@{ jobId = 'SomeJob' })).status | Should -Be 'Success'
        }
    }

    It 'accepts pipeline input' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            ([pscustomobject]@{ jobId = 'SomeJob' } | Resolve-SCAJobStatus).job_id | Should -Be 'SomeJob'
        }
    }

    It 'returns a response with no job identifier unaltered' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Resolve-SCAJobStatus -Result ([pscustomobject]@{ someOtherField = 'SomeValue' })
            $Result.someOtherField | Should -Be 'SomeValue'
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -Times 0 -Exactly -Scope It
    }

    It 'returns a response with an empty job identifier unaltered' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Result = Resolve-SCAJobStatus -Result ([pscustomobject]@{ jobId = ''; someOtherField = 'SomeValue' })
            $Result.someOtherField | Should -Be 'SomeValue'
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -Times 0 -Exactly -Scope It
    }

}
