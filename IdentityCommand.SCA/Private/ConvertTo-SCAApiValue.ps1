function ConvertTo-SCAApiValue {
    <#
    .SYNOPSIS
    Translates a friendly value to the numeric value the SCA API expects.

    .DESCRIPTION
    A handful of SCA fields are numeric enumerations - the cloud provider a policy or scan applies to,
    and the status a policy query filters on. Commands take the readable name from the caller and
    convert it here, against the enumeration defined by Get-SCAApiValueMap.

    .PARAMETER Name
    The enumeration to look the value up in.

    CloudProvider - AWS = 0, GCP = 1, AZURE = 2, AWS_IDC = 3, AZURE_ENTRA_ID = 4
    PolicyStatus  - Active = 1, Expired = 3, Error = 4, Validating = 6

    .PARAMETER Value
    The friendly value to translate. Matched case-insensitively.

    .EXAMPLE
    ConvertTo-SCAApiValue -Name CloudProvider -Value AWS

    Returns 0

    .EXAMPLE
    ConvertTo-SCAApiValue -Name PolicyStatus -Value Validating

    Returns 6
    #>
    [OutputType([int])]
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
        [string]$Value
    )

    begin {

        $Map = Get-SCAApiValueMap -Name $Name

    }#begin

    process {

        $Member = $Map[$Value]

        if ($null -eq $Member) {

            throw "'$Value' is not a supported $Name value. Expected one of: $(($Map.Keys | Sort-Object) -join ', ')"

        }

        $Member['Value']

    }#process

}
