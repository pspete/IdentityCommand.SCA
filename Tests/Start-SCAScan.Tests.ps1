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

Describe 'Start-SCAScan' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'jobId' = 'SomeJob'; 'operation' = 'Rescan' }
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

        $Script:response = Start-SCAScan -cloudProvider AWS -accountType All
    }

    It 'sends request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/cloud/rescan'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
    }

    It 'sends the numeric value of the cloud provider' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'POST') { return $false }
            $Content = $Body | ConvertFrom-Json
            ($Content.cloudProvider -eq 0) -and ($Content.accountType -eq 'All')
        } -Times 1 -Exactly -Scope It
    }

    It 'omits the entity ids when none are supplied' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'POST') { return $false }
            ($Body | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'entityIds'
        } -Times 1 -Exactly -Scope It
    }

    It 'sends supplied entity ids' {
        $Entities = New-SCAScanEntityDefinition -org_id '098765432109' -account_id '123456789012'
        $null = Start-SCAScan -cloudProvider AZURE -accountType Specific -entityIds $Entities
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'POST') { return $false }
            $Content = $Body | ConvertFrom-Json
            ($Content.cloudProvider -eq 2) -and ($Content.entityIds[0].account_id -eq '123456789012')
        } -Times 1 -Exactly -Scope It
    }

    It 'returns the result' {
        $Script:response.jobId | Should -Be 'SomeJob'
    }

}
