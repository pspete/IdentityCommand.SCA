function ConvertFrom-SCAApiValue {
    <#
    .SYNOPSIS
    Translates a numeric value returned by the SCA API to its name and meaning.

    .DESCRIPTION
    The reverse of ConvertTo-SCAApiValue. Given a numeric value from an API response, returns the
    friendly name and the description of what the value means, as defined by Get-SCAApiValueMap.

    A value the module has no definition for is not an error - the returned object reports a null name
    and description, so an enumeration extended by the API does not break the calling command.

    .PARAMETER Name
    The enumeration to look the value up in.

    .PARAMETER Value
    The numeric value returned by the API.

    .EXAMPLE
    ConvertFrom-SCAApiValue -Name PolicyStatus -Value 1

    Returns an object reporting Value 1, Name 'Active' and Description 'The policy is active'.
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateSet('CloudProvider', 'PolicyStatus')]
        [string]$Name,

        [parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true
        )]
        [int]$Value
    )

    begin {

        $Map = Get-SCAApiValueMap -Name $Name

    }#begin

    process {

        $MemberName = $Map.Keys | Where-Object { $Map[$PSItem]['Value'] -eq $Value } | Select-Object -First 1

        if ($null -eq $MemberName) {

            Write-Verbose "$Value is not a $Name value defined by this module"

        }

        [pscustomobject]@{
            Value       = $Value
            Name        = $MemberName
            Description = if ($null -ne $MemberName) { $Map[$MemberName]['Description'] } else { $null }
        }

    }#process

}
