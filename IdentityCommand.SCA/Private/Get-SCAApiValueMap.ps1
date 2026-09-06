function Get-SCAApiValueMap {
    <#
    .SYNOPSIS
    Returns the definition of an SCA API numeric enumeration.

    .DESCRIPTION
    A handful of SCA fields are numeric enumerations - the cloud provider a policy or scan applies to, and
    the status of a policy. This helper is the single definition of those enumerations: the friendly name
    of each member, the numeric value the API uses for it, and a description of what it means.

    ConvertTo-SCAApiValue translates a friendly name to the numeric value for a request; and
    ConvertFrom-SCAApiValue translates a numeric value from a response back to its name and description.

    .PARAMETER Name
    The enumeration to return.

    .EXAMPLE
    (Get-SCAApiValueMap -Name PolicyStatus)['Active'].Value

    Returns 1

    .EXAMPLE
    (Get-SCAApiValueMap -Name CloudProvider).Keys

    Returns the supported cloud provider names.
    #>
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateSet('CloudProvider', 'PolicyStatus')]
        [string]$Name
    )

    $Map = @{

        'CloudProvider' = [ordered]@{
            'AWS'            = [ordered]@{ Value = 0; Description = 'Amazon Web Services (IAM)' }
            'GCP'            = [ordered]@{ Value = 1; Description = 'Google Cloud' }
            'AZURE'          = [ordered]@{ Value = 2; Description = 'Azure (resource)' }
            'AWS_IDC'        = [ordered]@{ Value = 3; Description = 'Amazon Web Services (IAM Identity Center)' }
            'AZURE_ENTRA_ID' = [ordered]@{ Value = 4; Description = 'Azure (Microsoft Entra ID)' }
        }

        'PolicyStatus'  = [ordered]@{
            'Active'     = [ordered]@{ Value = 1; Description = 'The policy is active' }
            'Expired'    = [ordered]@{ Value = 3; Description = 'The policy has expired' }
            'Error'      = [ordered]@{ Value = 4; Description = 'There is an error in the policy' }
            'Warning'    = [ordered]@{ Value = 5; Description = 'The policy is active, with a warning' }
            'Validating' = [ordered]@{ Value = 6; Description = 'The policy is currently being validated' }
        }

    }

    $Map[$Name]

}
