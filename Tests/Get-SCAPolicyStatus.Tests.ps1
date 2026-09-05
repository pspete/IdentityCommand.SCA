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

Describe 'Get-SCAPolicyStatus' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            1
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

        $Script:response = Get-SCAPolicyStatus -policy_id SomePolicy
    }

    It 'sends request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/policies/SomePolicy/status?policy_id=SomePolicy'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'GET' } -Times 1 -Exactly -Scope It
    }

    It 'returns the policy id alongside the status' {
        $Script:response.policyId | Should -Be 'SomePolicy'
    }

    It 'returns the status value reported by the API' {
        $Script:response.status | Should -Be 1
    }

    It 'returns an object with the expected type' {
        $Script:response.PSObject.TypeNames | Should -Contain 'IdCmd.SCA.Policy.Status'
    }

    It 'reports the meaning of status <Status> as <Name>' -TestCases @(
        @{ Status = 1; Name = 'Active'; Description = 'The policy is active' }
        @{ Status = 3; Name = 'Expired'; Description = 'The policy has expired' }
        @{ Status = 4; Name = 'Error'; Description = 'There is an error in the policy' }
        @{ Status = 6; Name = 'Validating'; Description = 'The policy is currently being validated' }
    ) {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith { $Status }.GetNewClosure()

        $Result = Get-SCAPolicyStatus -policy_id SomePolicy

        $Result.status | Should -Be $Status
        $Result.statusName | Should -Be $Name
        $Result.description | Should -Be $Description
    }

    It 'reports the status of a text response' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith { '6' }

        (Get-SCAPolicyStatus -policy_id SomePolicy).statusName | Should -Be 'Validating'
    }

    It 'returns the raw value of a status it has no definition for' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith { 99 }

        $Result = Get-SCAPolicyStatus -policy_id SomePolicy

        $Result.status | Should -Be 99
        $Result.statusName | Should -BeNullOrEmpty
        $Result.description | Should -BeNullOrEmpty
    }

}
