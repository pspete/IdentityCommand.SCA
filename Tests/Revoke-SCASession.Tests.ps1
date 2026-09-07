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

Describe 'Revoke-SCASession' {

    It 'rejects more session ids than the API accepts' {
        { Revoke-SCASession -sessionIds (1..101 | ForEach-Object { "Session$PSItem" }) -Confirm:$false } | Should -Throw
    }


    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'response' = @([pscustomobject]@{ 'sessionId' = 'SomeSession'; 'revocationStatus' = 'SUCCESSFULLY_REVOKED' }) }
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

    Context 'By session id' {

        BeforeEach {
            $Script:response = Revoke-SCASession -sessionIds SomeSession
        }

        It 'sends request to the expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/sessions/revoke'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
        }

        It 'sends the session ids as an array' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                if ($Method -ne 'POST') { return $false }
                @(($Body | ConvertFrom-Json).sessionIds).Count -eq 1
            } -Times 1 -Exactly -Scope It
        }

        It 'returns the revocation results' {
            $Script:response.revocationStatus | Should -Be 'SUCCESSFULLY_REVOKED'
        }

    }

    Context 'By user' {

        BeforeEach {
            $Script:response = Revoke-SCASession -userId my
        }

        It 'sends request to the user revoke endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/users/my/sessions/revoke'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request with no body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $null -eq $Body } -Times 1 -Exactly -Scope It
        }

    }

}
