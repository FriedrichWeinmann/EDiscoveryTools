function Assert-Connection
{
<#
	.SYNOPSIS
		Ensures a connection to the Office 365 Compliance Center has been established.
	
	.DESCRIPTION
		Ensures a connection to the Office 365 Compliance Center has been established.
	
	.EXAMPLE
		PS C:\> Assert-Connection
	
		Ensures a connection to the Office 365 Compliance Center has been established.
#>
	[CmdletBinding()]
	Param (
	
	)
	
	process
	{
		if (-not $script:connected)
		{
			Connect-EDiscovery
		}
	}
}