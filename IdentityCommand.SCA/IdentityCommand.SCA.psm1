#region Loader
<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>
[CmdletBinding()]
param(

    [bool]$DotSourceModule = $false

)

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.ps1xml' |

    ForEach-Object {

        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }

#endregion Loader

#Copy IdentityCommand's private helpers into this module: this module's functions call them, and
#the argument completer registrations below do so at import time.
#Each copy is created from the function definition, so it runs in this module's scope and uses this
#module's $ISPSSSession, whether IdentityCommand loaded from source or from its combined psm1.
#Resolve a single IdentityCommand module: with more than one version loaded, Get-Module returns
#an array.
$Module = Get-Module -Name IdentityCommand | Sort-Object Version -Descending | Select-Object -First 1

if ($null -eq $Module) {
    throw 'The IdentityCommand module is not loaded. Import IdentityCommand and try again.'
}

& $Module { Get-ChildItem -Path Function: } |

    Where-Object { $_.ModuleName -eq $Module.Name -and -not $Module.ExportedFunctions.ContainsKey($_.Name) } |

    ForEach-Object {

        . ([scriptblock]::Create("function $($_.Name) {$($_.Definition)}"))

    }

#region Registration

$SCAPolicyIdCompleter = Get-ArgumentCompleter -RetrievalCommand 'Get-SCAPolicy' -ValueProperty 'policyId' -LabelProperty 'name'

Register-ArgumentCompleter -ParameterName 'policy_id' -ScriptBlock $SCAPolicyIdCompleter -CommandName @(
    'Get-SCAPolicy'
    'Set-SCAPolicy'
    'Remove-SCAPolicy'
    'Get-SCAPolicyStatus'
)

#Test-SCAPolicy takes the policy id under the API's body field name.
Register-ArgumentCompleter -ParameterName 'policyId' -ScriptBlock $SCAPolicyIdCompleter -CommandName 'Test-SCAPolicy'

Register-ArgumentCompleter -ParameterName 'sessionIds' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SCASession' -ValueProperty 'sessionId' -LabelProperty 'userId'
) -CommandName 'Revoke-SCASession'

#The workspace types the API supports differ by cloud provider, so these are offered as completions
#rather than enforced with a ValidateSet.
$SCAWorkspaceType = [ordered]@{
    'account'          = 'AWS - required only for IAM Identity Center'
    'directory'        = 'Azure - Microsoft Entra ID directory'
    'management_group' = 'Azure - management group'
    'subscription'     = 'Azure - subscription'
    'resource_group'   = 'Azure - resource group'
    'resource'         = 'Azure - resource'
    'gcp_organization' = 'Google Cloud - organization'
    'folder'           = 'Google Cloud - folder'
    'project'          = 'Google Cloud - project'
}

Register-ArgumentCompleter -ParameterName 'workspaceType' -CommandName 'New-SCAPolicyRoleDefinition' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    #Standard ArgumentCompleter parameters that are not otherwise referenced.
    $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters

    $Word = "$wordToComplete".Trim("'`"")

    $SCAWorkspaceType.Keys | Where-Object { $PSItem -like "$Word*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($PSItem, $PSItem, 'ParameterValue', $SCAWorkspaceType[$PSItem])
    }

}.GetNewClosure()

#endregion

# Script scope session object for session data
$ISPSSSession = [ordered]@{
    tenant_url         = $null
    User               = $null
    TenantId           = $null
    SessionId          = $null
    WebSession         = $null
    StartTime          = $null
    ElapsedTime        = $null
    LastCommand        = $null
    LastCommandTime    = $null
    LastCommandResults = $null
    LastError          = $null
    LastErrorTime      = $null
} | Add-CustomType -Type IdCmd.Session

New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
