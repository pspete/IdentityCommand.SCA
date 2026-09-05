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

Describe 'Add-SCAQueryString' {

    It 'returns the URI unaltered when there is nothing to append' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies'
        }
    }

    It 'appends a query string' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -Parameter @{ limit = 10 } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?limit=10'
        }
    }

    It 'joins to an existing query string' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies?limit=10' -Parameter @{ nextToken = 'SomeToken' } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?limit=10&nextToken=SomeToken'
        }
    }

    It 'drops null and empty values' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -Parameter @{ limit = $null; free_text = '' } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies'
        }
    }

    It 'escapes values' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -Parameter @{ free_text = 'some text' } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?free_text=some%20text'
        }
    }

    It 'does not request debug information by default' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -SupportsDebug |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies'
        }
    }

    It 'requests debug information when the debug preference is set' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $DebugPreference = 'Continue'
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -SupportsDebug |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?debug=true'
        }
    }

    It 'does not request debug information for an endpoint which does not support it' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $DebugPreference = 'Continue'
            Add-SCAQueryString -URI 'https://somedomain.sca.cyberark.cloud/api/access/sessions' |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/access/sessions'
        }
    }

}
