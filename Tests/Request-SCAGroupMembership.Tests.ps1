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

Describe 'Request-SCAGroupMembership' {

    It 'rejects more groups than the API accepts' {
        { Request-SCAGroupMembership -directoryId 'SomeDirectory' -groupId (1..6 | ForEach-Object { "Group$PSItem" }) -Confirm:$false } | Should -Throw
    }


    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'directoryId' = 'SomeDirectory' }
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

        $Script:response = Request-SCAGroupMembership -directoryId SomeDirectory -groupId SomeGroup
    }

    It 'sends request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/elevate/groups'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
    }

    It 'sends each group id as a target' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $Content = $Body | ConvertFrom-Json
            ($Content.directoryId -eq 'SomeDirectory') -and ($Content.csp -eq 'AZURE') -and (@($Content.targets).Count -eq 1) -and ($Content.targets[0].groupId -eq 'SomeGroup')
        } -Times 1 -Exactly -Scope It
    }

    It 'sends a target for every group id supplied' {
        $null = Request-SCAGroupMembership -directoryId SomeDirectory -groupId SomeGroup, SomeOtherGroup
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            @(($Body | ConvertFrom-Json).targets).Count -eq 2
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the result' {
        $Script:response.directoryId | Should -Be 'SomeDirectory'
    }

}
