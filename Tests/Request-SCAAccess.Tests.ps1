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

Describe 'Request-SCAAccess' {

    It 'rejects more targets than the API accepts' {
        $Targets = 1..6 | ForEach-Object { New-SCAAccessTargetDefinition -workspaceId "Workspace$PSItem" -roleId "Role$PSItem" }
        { Request-SCAAccess -csp AWS -targets $Targets -Confirm:$false } | Should -Throw
    }


    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'response' = [pscustomobject]@{ 'csp' = 'AWS' } }
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

        $Targets = New-SCAAccessTargetDefinition -workspaceId '123451234567' -roleName examplerole

        $Script:response = Request-SCAAccess -csp AWS -organizationId '098765432109' -targets $Targets
    }

    It 'sends request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/elevate'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
    }

    It 'sends the expected request body' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $Content = $Body | ConvertFrom-Json
            ($Content.csp -eq 'AWS') -and ($Content.organizationId -eq '098765432109') -and ($Content.targets[0].workspaceId -eq '123451234567') -and ($Content.targets[0].roleName -eq 'examplerole')
        } -Times 1 -Exactly -Scope It
    }

    It 'sends targets as an array' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            @(($Body | ConvertFrom-Json).targets).Count -eq 1
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the response' {
        $Script:response.csp | Should -Be 'AWS'
    }

}
