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

Describe 'New-SCAPolicyAccessRuleDefinition' {

    It 'returns an object with the expected type' {
        (New-SCAPolicyAccessRuleDefinition -days Monday -maxSessionDuration 1 -timeZone 'Europe/London').PSObject.TypeNames |
            Should -Contain 'IdCmd.SCA.Definition.Policy.AccessRule'
    }

    It 'returns the supplied values' {
        $Rule = New-SCAPolicyAccessRuleDefinition -days Monday, Tuesday -fromTime '08:00' -toTime '17:00' -maxSessionDuration 2 -timeZone 'Europe/London'
        $Rule.fromTime | Should -Be '08:00'
        $Rule.toTime | Should -Be '17:00'
        $Rule.maxSessionDuration | Should -Be 2
        $Rule.timeZone | Should -Be 'Europe/London'
    }

    It 'returns a single day as an array' {
        $Rule = New-SCAPolicyAccessRuleDefinition -days Monday -maxSessionDuration 1 -timeZone 'Europe/London'
        , $Rule.days | Should -BeOfType [array]
        @($Rule.days).Count | Should -Be 1
    }

    It 'accepts a seconds component in the time values' {
        $Rule = New-SCAPolicyAccessRuleDefinition -days Monday -fromTime '07:00:00' -maxSessionDuration 1 -timeZone 'Europe/London'
        $Rule.fromTime | Should -Be '07:00:00'
    }

    It 'rejects an invalid time value' {
        { New-SCAPolicyAccessRuleDefinition -days Monday -fromTime '25:00' -maxSessionDuration 1 -timeZone 'Europe/London' } |
            Should -Throw
    }

    It 'rejects a session duration outside the supported range' {
        { New-SCAPolicyAccessRuleDefinition -days Monday -maxSessionDuration 25 -timeZone 'Europe/London' } |
            Should -Throw
    }

    It 'omits values which were not supplied' {
        $Rule = New-SCAPolicyAccessRuleDefinition -days Monday -maxSessionDuration 1 -timeZone 'Europe/London'
        $Rule.Keys | Should -Not -Contain 'fromTime'
    }

}
