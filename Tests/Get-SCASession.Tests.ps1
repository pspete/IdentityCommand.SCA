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

Describe 'Get-SCASession' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'response' = @('value'); 'total' = 1 }
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

    Context 'All sessions' {

        BeforeEach {
            $Script:response = Get-SCASession
        }

        It 'sends request to the expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/sessions'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'GET' } -Times 1 -Exactly -Scope It
        }

        It 'returns the response collection' {
            $Script:response | Should -Be 'value'
        }

        It 'sends the cloud provider filter as a query parameter' {
            $null = Get-SCASession -csp AZURE
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/sessions?csp=AZURE'
            } -Times 1 -Exactly -Scope It
        }

    }

    Context 'By user' {

        It 'sends request to the user sessions endpoint' {
            $null = Get-SCASession -userId my
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/users/my/sessions'
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send the user id as a query parameter' {
            $null = Get-SCASession -userId SomeUser -limit 10
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/users/SomeUser/sessions?limit=10'
            } -Times 1 -Exactly -Scope It
        }

    }

}
