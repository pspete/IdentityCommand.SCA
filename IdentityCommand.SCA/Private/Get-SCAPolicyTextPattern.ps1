function Get-SCAPolicyTextPattern {
    <#
    .SYNOPSIS
    Returns the pattern the SCA API accepts for a policy name or description.

    .DESCRIPTION
    The API constrains the characters allowed in a policy name and description, and publishes a
    regular expression for each. Both are reproduced here verbatim, as the single definition used by
    Test-SCAPolicyText.

    Each pattern contains a character range rather than the list of literal characters its layout
    suggests, so the accepted set is wider than it appears. Neither accepts tab, newline or any
    non-ASCII character, and both reject the quote, bracket and ampersand characters commonly used
    in free text.

    .PARAMETER Name
    The policy field to return the pattern for.

    .EXAMPLE
    Get-SCAPolicyTextPattern -Name Name

    Returns the pattern a policy name must match.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateSet('Name', 'Description')]
        [string]$Name
    )

    $Pattern = @{
        #Accepts a space and ! + , - . / 0-9 : ; < = > ? @ A-Z [ \ _ a-z
        'Name'        = '^[A-Za-z0-9-@ _!.+-\\s]{1,200}$'
        #As Name, and additionally $ ] ^ { }
        'Description' = '^[A-Za-z0-9-@ _!^[{}.+-\]$\\s]{0,200}$'
    }

    $Pattern[$Name]

}
