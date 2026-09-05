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

Describe 'Get-SCAModuleData' {

    BeforeEach {

        InModuleScope -ModuleName $Script:SCAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url  = 'https://somedomain.sca.cyberark.cloud'
                User        = 'SomeUser'
                TenantId    = 'SomeTenant'
                SessionId   = 'SomeSession'
                WebSession  = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                StartTime   = $null
                ElapsedTime = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Get-SCAModuleData
    }

    It 'returns the session data' {
        $Script:response.tenant_url | Should -Be 'https://somedomain.sca.cyberark.cloud'
        $Script:response.User | Should -Be 'SomeUser'
    }

    It 'returns an object with the expected type' {
        $Script:response.PSObject.TypeNames | Should -Contain 'IdCmd.Session'
    }

    It 'reports no elapsed time when the session has no start time' {
        $Script:response.ElapsedTime | Should -BeNullOrEmpty
    }

    It 'calculates elapsed time from the session start time' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url  = 'https://somedomain.sca.cyberark.cloud'
                StartTime   = (Get-Date).AddHours(-1)
                ElapsedTime = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        (Get-SCAModuleData).ElapsedTime | Should -Match '^\d{2}:\d{2}:\d{2}$'
    }

}
