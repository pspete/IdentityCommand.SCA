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

Describe 'Get-SCAPagedResult' {

    BeforeEach {

        InModuleScope -ModuleName $Script:SCAModuleName {
            $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.sca.cyberark.cloud' }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

    }

    It 'returns the initial items when there is no continuation token' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith { }

        InModuleScope -ModuleName $Script:SCAModuleName {
            $Initial = [pscustomobject]@{ response = @('one', 'two') }
            Get-SCAPagedResult -InitialResult $Initial -URI 'https://somedomain.sca.cyberark.cloud/api/access/sessions' |
                Should -Be @('one', 'two')
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -Times 0 -Exactly -Scope It
    }

    It 'follows the continuation token until it is empty' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ response = @('two'); nextToken = $null }
        }

        InModuleScope -ModuleName $Script:SCAModuleName {
            $Initial = [pscustomobject]@{ response = @('one'); nextToken = 'SomeToken' }
            Get-SCAPagedResult -InitialResult $Initial -URI 'https://somedomain.sca.cyberark.cloud/api/access/sessions' |
                Should -Be @('one', 'two')
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/sessions?nextToken=SomeToken'
        } -Times 1 -Exactly -Scope It
    }

    It 'stops when a page returns no items' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ response = @(); nextToken = 'SomeToken' }
        }

        InModuleScope -ModuleName $Script:SCAModuleName {
            $Initial = [pscustomobject]@{ response = @('one'); nextToken = 'SomeToken' }
            Get-SCAPagedResult -InitialResult $Initial -URI 'https://somedomain.sca.cyberark.cloud/api/access/sessions' |
                Should -Be @('one')
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -Times 1 -Exactly -Scope It
    }

    It 'preserves query parameters already on the URI' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{ response = @('two'); nextToken = $null }
        }

        InModuleScope -ModuleName $Script:SCAModuleName {
            $Initial = [pscustomobject]@{ response = @('one'); nextToken = 'SomeToken' }
            $null = Get-SCAPagedResult -InitialResult $Initial -URI 'https://somedomain.sca.cyberark.cloud/api/access/sessions?limit=1'
        }

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SCAModuleName -ParameterFilter {
            $URI -eq 'https://somedomain.sca.cyberark.cloud/api/access/sessions?limit=1&nextToken=SomeToken'
        } -Times 1 -Exactly -Scope It
    }

}
