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

Describe 'ConvertTo-SCADateString' {

    It 'formats a date as an ISO 8601 UTC string' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            ConvertTo-SCADateString -Date ([datetime]::new(2022, 7, 12, 14, 30, 0, [System.DateTimeKind]::Utc)) |
                Should -Be '2022-07-12T14:30:00.000Z'
        }
    }

    It 'converts a local time to UTC' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            $Local = [datetime]::new(2022, 7, 12, 14, 30, 0, [System.DateTimeKind]::Local)
            ConvertTo-SCADateString -Date $Local | Should -Be "$($Local.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fff'))Z"
        }
    }

    It 'accepts pipeline input' {
        InModuleScope -ModuleName $Script:SCAModuleName {
            ([datetime]::new(2022, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc) | ConvertTo-SCADateString) |
                Should -Be '2022-01-01T00:00:00.000Z'
        }
    }

}
