---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAWebApp

## SYNOPSIS
Creates a web app for a cloud environment

## SYNTAX

```
New-SCAWebApp [-appType] <String> [-appName] <String> [-workspaceId] <String> [[-establishAutoTrust] <Boolean>]
 [[-useIdentityAsIdp] <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates the Idira web app users connect to a cloud environment through. Web apps can be created for a standalone AWS account, multiple AWS accounts in an AWS organization, AWS IAM Identity Center, Azure Microsoft Entra ID and Google Cloud.

The operation is asynchronous. The status of the job which was started is returned; pass its job_id to Get-SCAJobStatus to check on it again later.

## EXAMPLES

### Example 1
```powershell
New-SCAWebApp -appType 'AWS IAM' -appName 'SA AWS Account 1234567890' -workspaceId '1234567890'
```

Creates a web app for a standalone AWS account.

### Example 2
```powershell
New-SCAWebApp -appType 'AWS IAM' -appName 'AWS Organization' -workspaceId '1234567890' -establishAutoTrust $true
```

Creates a web app for an AWS organization, automatically establishing trust between Idira and AWS.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -appName
A unique name for the web app, as it appears on the user's Applications page.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -appType
The type of web app to create.

Supported values: AWS IAM, AWS IdC, Azure, GCP.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS IAM, AWS IdC, Azure, GCP

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -establishAutoTrust
Specify $true to automatically establish trust between Idira and AWS. Relevant for AWS IAM only.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -useIdentityAsIdp
Specify $true to use Idira as the identity provider. Relevant for AWS IAM Identity Center and Google Cloud only.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -workspaceId
The workspace the web app connects to.

AWS IAM: the AWS organization (management account) ID or AWS account ID.
AWS IdC: the AWS IAM Identity Center management account ID.
Azure: the Microsoft Entra ID directory (tenant) ID.
GCP: the Google Cloud organization ID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Boolean

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
