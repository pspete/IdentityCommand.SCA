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

Describe 'Resolve-SCAServiceUrl' {

    BeforeEach {

        Mock -CommandName Find-SharedServicesURL -ModuleName $Script:SCAModuleName -MockWith {
            [pscustomobject]@{
                sca                  = [pscustomobject]@{ api = 'https://sometenant.sca.cyberark.cloud/api' }
                identity_user_portal = [pscustomobject]@{ api = 'https://sometenant.id.cyberark.cloud/' }
            }
        }
    }

    Context 'Subdomain parameter set' {

        It 'queries platform discovery by subdomain' {
            InModuleScope -ModuleName $Script:SCAModuleName {
                $null = Resolve-SCAServiceUrl -Subdomain 'sometenant'
            }
            Should -Invoke -CommandName Find-SharedServicesURL -ModuleName $Script:SCAModuleName -ParameterFilter {
                $subdomain -eq 'sometenant'
            } -Times 1 -Exactly
        }

        It 'returns the SCA tenant URL with any trailing /api removed' {
            InModuleScope -ModuleName $Script:SCAModuleName {
                (Resolve-SCAServiceUrl -Subdomain 'sometenant').SCAUrl |
                    Should -Be 'https://sometenant.sca.cyberark.cloud'
            }
        }

        It 'returns the CyberArk Identity URL with any trailing slash removed' {
            InModuleScope -ModuleName $Script:SCAModuleName {
                (Resolve-SCAServiceUrl -Subdomain 'sometenant').IdentityUrl |
                    Should -Be 'https://sometenant.id.cyberark.cloud'
            }
        }
    }

    Context 'URL parameter set' {

        It 'queries platform discovery by url' {
            InModuleScope -ModuleName $Script:SCAModuleName {
                $null = Resolve-SCAServiceUrl -Url 'https://sometenant.sca.cyberark.cloud'
            }
            Should -Invoke -CommandName Find-SharedServicesURL -ModuleName $Script:SCAModuleName -ParameterFilter {
                $url -eq 'https://sometenant.sca.cyberark.cloud'
            } -Times 1 -Exactly
        }

        It 'resolves both URLs from a supplied url' {
            InModuleScope -ModuleName $Script:SCAModuleName {
                $result = Resolve-SCAServiceUrl -Url 'https://sometenant.sca.cyberark.cloud'
                $result.SCAUrl | Should -Be 'https://sometenant.sca.cyberark.cloud'
                $result.IdentityUrl | Should -Be 'https://sometenant.id.cyberark.cloud'
            }
        }
    }

    Context 'Error handling' {

        It 'wraps a discovery failure in a descriptive error' {
            Mock -CommandName Find-SharedServicesURL -ModuleName $Script:SCAModuleName -MockWith {
                throw 'boom'
            }
            InModuleScope -ModuleName $Script:SCAModuleName {
                { Resolve-SCAServiceUrl -Subdomain 'sometenant' } |
                    Should -Throw "*Unable to resolve CyberArk shared services URLs from 'sometenant'*boom*"
            }
        }

        It 'throws when the discovery response has no identity_user_portal URL' {
            Mock -CommandName Find-SharedServicesURL -ModuleName $Script:SCAModuleName -MockWith {
                [pscustomobject]@{
                    sca                  = [pscustomobject]@{ api = 'https://sometenant.sca.cyberark.cloud/api' }
                    identity_user_portal = [pscustomobject]@{ api = '' }
                }
            }
            InModuleScope -ModuleName $Script:SCAModuleName {
                { Resolve-SCAServiceUrl -Url 'https://sometenant.sca.cyberark.cloud' } |
                    Should -Throw "*identity_user_portal*not found*"
            }
        }
    }
}
