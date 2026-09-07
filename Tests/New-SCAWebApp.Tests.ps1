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

Describe 'New-SCAWebApp' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ 'job_id' = 'SomeJob' }
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

        $Script:response = New-SCAWebApp -appType 'AWS IAM' -appName 'SA AWS Account 1234567890' -workspaceId '1234567890' -establishAutoTrust $false
    }

    It 'sends request to the expected endpoint' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/onboarding/apps'
        } -Times 1 -Exactly -Scope It
    }

    It 'uses expected method' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
    }

    It 'sends the workspace details in a nested appMetadata object' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'POST') { return $false }
            $Content = $Body | ConvertFrom-Json
            ($Content.appType -eq 'AWS IAM') -and ($Content.appName -eq 'SA AWS Account 1234567890') -and ($Content.appMetadata.workspaceId -eq '1234567890') -and ($Content.appMetadata.establishAutoTrust -eq $false)
        } -Times 1 -Exactly -Scope It
    }

    It 'omits metadata values which were not supplied' {
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            if ($Method -ne 'POST') { return $false }
            ($Body | ConvertFrom-Json).appMetadata.PSObject.Properties.Name -notcontains 'useIdentityAsIdp'
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

    It 'sends the appType casing the API expects' {
        New-SCAWebApp -appType 'AWS IdC' -appName 'IAM Identity Center' -workspaceId '1234567890'
        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            ($Body | ConvertFrom-Json).appType -ceq 'AWS IdC'
        } -Times 1 -Exactly -Scope It
    }

}
