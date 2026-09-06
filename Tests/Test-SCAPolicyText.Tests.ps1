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

Describe 'Test-SCAPolicyText' {

    It 'returns true for an accepted value' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Test-SCAPolicyText -Value 'Finance end of year' -ParameterName name -Pattern $(Get-SCAPolicyTextPattern -Name Name) | Should -BeTrue
        }
    }

    It 'throws for a value containing an unsupported character' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Test-SCAPolicyText -Value 'Finance (EOY)' -ParameterName name -Pattern $(Get-SCAPolicyTextPattern -Name Name) } | Should -Throw
        }
    }

    It 'reports the unsupported characters rather than the pattern' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Test-SCAPolicyText -Value 'Finance (EOY) & R&D' -ParameterName name -Pattern $(Get-SCAPolicyTextPattern -Name Name) } |
                Should -Throw -ExpectedMessage '*does not accept: ()&'
        }
    }

    It 'names the parameter in the error message' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Test-SCAPolicyText -Value 'End of year (EOY)' -ParameterName description -Pattern $(Get-SCAPolicyTextPattern -Name Description) } |
                Should -Throw -ExpectedMessage '*policy description*'
        }
    }

    It 'reports each unsupported character once' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Test-SCAPolicyText -Value 'R&D&D&D' -ParameterName name -Pattern $(Get-SCAPolicyTextPattern -Name Name) } |
                Should -Throw -ExpectedMessage '*does not accept: &'
        }
    }

    It 'reports a length failure when every character is supported' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            { Test-SCAPolicyText -Value '' -ParameterName name -Pattern $(Get-SCAPolicyTextPattern -Name Name) } |
                Should -Throw -ExpectedMessage '*not an accepted length*'
        }
    }

    It 'accepts an empty description' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            Test-SCAPolicyText -Value '' -ParameterName description -Pattern $(Get-SCAPolicyTextPattern -Name Description) | Should -BeTrue
        }
    }

}
