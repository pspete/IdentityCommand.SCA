# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAPolicyAccessRuleDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [OutputType('IdCmd.SCA.Definition.Policy.AccessRule')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        [String[]]$days,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidatePattern('^([01]\d|2[0-3]):([0-5]\d)(:([0-5]\d))?$')]
        [String]$fromTime,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidatePattern('^([01]\d|2[0-3]):([0-5]\d)(:([0-5]\d))?$')]
        [String]$toTime,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(1, 24)]
        [int]$maxSessionDuration,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$timeZone
    )

    begin {

        $ExpectedProperties = @('days', 'fromTime', 'toTime', 'maxSessionDuration', 'timeZone')

    }#begin

    process {

        $boundParameters = $PSBoundParameters | Get-Parameter

        $AccessRule = Select-RequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        #The API expects an array of day names, which a single supplied day must not collapse to a string.
        $AccessRule['days'] = @($days)

        $AccessRule | Add-CustomType -Type IdCmd.SCA.Definition.Policy.AccessRule

    }#process

    end { }#end

}
