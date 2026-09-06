# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Initial command set for the CyberArk/Idira **Secure Cloud Access** API.
- Session: `Connect-SCATenant` (existing `IdentityCommand` session, or `-Credential` / `-Credential -PlatformToken` / `-SAMLResponse` authentication with URL discovery from a subdomain or tenant url), `Get-SCAModuleData`.
- Policies: `Get-SCAPolicy`, `New-SCAPolicy`, `Set-SCAPolicy`, `Remove-SCAPolicy`, `Get-SCAPolicyStatus`, `Test-SCAPolicy`, `Start-SCADiscovery`. Version 2.0 of the Policies API is used throughout.
- Policy and request definition helpers: `New-SCAPolicyRoleDefinition`, `New-SCAPolicyIdentityDefinition`, `New-SCAPolicyAccessRuleDefinition`, `New-SCAAccessTargetDefinition`, `New-SCAScanEntityDefinition`. The role, identity, target and entity helpers accept a previous definition, so several can be chained onto one another.
- Access: `Get-SCAEligibleTarget`, `Get-SCAEligibleGroup`, `Request-SCAAccess`, `Request-SCAGroupMembership`, `Get-SCASession`, `Revoke-SCASession`. List results are automatically paginated - every page is returned.
- Cloud scan, jobs and onboarding: `Start-SCAScan`, `Get-SCAJobStatus`, `New-SCAWebApp`.
- On-demand approvals: `Get-SCAOnDemandConfig`, `Set-SCAOnDemandConfig`.
- `Get-SCAPolicyStatus` returns the status integer reported by the API alongside its name and meaning (1 Active, 3 Expired, 4 Error, 5 Warning, 6 Validating), as an `IdCmd.SCA.Policy.Status` object.
- Tab-completion for policy and session id parameters.
- Commands which call an endpoint supporting the API's `debug` query parameter send `debug=true` when run with `-Debug`, returning the API's extended troubleshooting detail on an error.
- Friendly values are accepted where the API expects a numeric enumeration - `-status` (`Active`, `Expired`, `Error`, `Validating`) and `-cloud_provider` / `-cloudProvider` (`AWS`, `GCP`, `AZURE`, `AWS_IDC`, `AZURE_ENTRA_ID`).
- Parameters are validated against the limits the API publishes - up to 5 targets for `Request-SCAAccess`, 5 groups for `Request-SCAGroupMembership`, 100 session ids for `Revoke-SCASession`, and a `-limit` of 1 to 50 for `Get-SCASession`.
- Policy `-name` and `-description` are checked against the character set the API accepts, reporting which characters were rejected rather than the expression which rejected them. Note that `(`, `)`, `&` and `'` are not accepted in either.
- Tab-completion for `New-SCAPolicyRoleDefinition -workspaceType`, offering the workspace types supported by each cloud provider.
- Help describes the per-provider meaning of the scan entity, discovery and web app parameters, the shape of the objects `Get-SCAEligibleTarget` returns, and the revocation states `Revoke-SCASession` reports.
- Policy commands note that the vendor has documented the API they use as due for deprecation.
