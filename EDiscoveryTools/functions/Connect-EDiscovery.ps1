function Connect-EDiscovery
{
<#
	.SYNOPSIS
		Connects to the Office 365 Compliance Center.
	
	.DESCRIPTION
		Connects to the Office 365 Compliance Center.
		This uses modern authentication to ensure continued functionality.
	
		Behind the scenes, this uses the ExchangeOnlineManagement module to ensure continued support.
		Functionally, this establishes a PowerShell remoting session to the destination endpoint and imports the required commands.
	
		Note: Due to implementation details of EOM, using other PowerShell remoting sessions in the same runspace is not supported at the current time.
	
	.PARAMETER Credential
		Credentials to use for authentication.
		Cannot be used for MFA bound accounts.
	
	.PARAMETER Uri
		A custom URI to use when connecting to the service.
		Generally needs not be changed.
	
	.PARAMETER Confirm
		If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.
	
	.PARAMETER WhatIf
		If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.
	
	.EXAMPLE
		PS C:\> Connect-EDiscovery
	
		Connects to the Office 365 Compliance Center, prompting for user credentials.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[System.Management.Automation.PSCredential]
		$Credential,
		
		[string]
		$Uri = (Get-PSFConfigValue -FullName 'EDiscoveryTools.Connection.Uri')
	)
	
	begin
	{
		$params = @{
			ConnectionUri = $Uri
			WarningAction = 'SilentlyContinue'
		}
		if ($Credential) { $params['Credential'] = $Credential }
		
		if (-not $script:defaultGroupMappingDataImported)
		{
			if (Get-PSFConfigValue -FullName 'EDiscoveryTools.Search.Config.Path') { Import-EDisSearchTag }
			else { Write-PSFMessage -Level Warning -String 'Connect-EDiscovery.Config.NoSearchPath' -Once 'Search' }
		}
	}
	process
	{
		Invoke-PSFProtectedCommand -ActionString 'Connect-EDiscovery.Connecting' -Target 'Compliance Center' -ScriptBlock {
			Connect-ExchangeOnline @params -ErrorAction Stop
			$script:connected = $true
		} -EnableException $true -PSCmdlet $PSCmdlet
	}
}