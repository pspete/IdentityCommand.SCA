#The completer helper functions this file used to define now live in IdentityCommand's
#Private folder, which the psm1 loads into this module's scope.

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
