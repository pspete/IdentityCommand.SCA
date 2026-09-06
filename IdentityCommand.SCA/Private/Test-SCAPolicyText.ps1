function Test-SCAPolicyText {
    <#
    .SYNOPSIS
    Validates a policy name or description against the characters the SCA API accepts.

    .DESCRIPTION
    Used as the ValidateScript for the policy -name and -description parameters. The API rejects a
    value containing an unsupported character, so this catches it before the request is sent, and
    reports which characters were at fault - a plain ValidatePattern would show the caller nothing
    but the raw expression.

    Returns $true when the value is acceptable, and throws otherwise, as ValidateScript requires.

    .PARAMETER Value
    The value supplied for the parameter.

    .PARAMETER ParameterName
    The name of the parameter being validated, used in the error message.

    .PARAMETER Pattern
    The pattern the value must match, from Get-SCAPolicyTextPattern.

    .EXAMPLE
    Test-SCAPolicyText -Value 'End of year' -ParameterName name -Pattern (Get-SCAPolicyTextPattern -Name Name)

    Returns $true.
    #>
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [AllowEmptyString()]
        [string]$Value,

        [parameter(
            Mandatory = $true,
            Position = 1
        )]
        [string]$ParameterName,

        [parameter(
            Mandatory = $true,
            Position = 2
        )]
        [string]$Pattern
    )

    if ($Value -cmatch $Pattern) { return $true }

    #Report the offending characters rather than the expression which rejected them
    $Unsupported = ([char[]]$Value | Where-Object { "$PSItem" -cnotmatch $Pattern } | Select-Object -Unique) -join ''

    if ([string]::IsNullOrEmpty($Unsupported)) {

        throw "The policy $ParameterName is not an accepted length."

    }

    throw "The policy $ParameterName contains characters the SCA API does not accept: $Unsupported"

}
