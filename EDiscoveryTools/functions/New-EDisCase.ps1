function New-EDisCase
{
<#
	.SYNOPSIS
		Creates a new eDiscovery case.
	
	.DESCRIPTION
		Creates a new eDiscovery case.
		Provides a streamlined user experience with simplified search creation over the default command.
	
	.PARAMETER Name
		The name of the case to create.
	
	.PARAMETER CaseID
		The external case identifying ID.
	
	.PARAMETER SearchName
		The name of the search to create.
		If this parameter is omitted, no search will be created.
	
	.PARAMETER SearchTag
		Any search tags to apply.
		Tags are a simplified way to limit searches by distribution group members.
		See description of Register-EDisSearchTag for details.
	
	.PARAMETER CaseType
		Whether this is a basic eDiscovery case, or an advanced eDiscovery case.
		Note: Only basic cases support having searches created for them.
	
	.PARAMETER EnableException
		This parameters disables user-friendly warnings and enables the throwing of exceptions.
		This is less user friendly, but allows catching exceptions in calling scripts.
	
	.PARAMETER Confirm
		If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.
	
	.PARAMETER WhatIf
		If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.
	
	.EXAMPLE
		PS C:\> New-EDisCase -Name 'Fabrikam vs. Contoso' -CaseID '1234567' -SearchName 'CourtExport' -Searchtag NorthAmerica, SouthAmerica, Emea
	
		Creates the new case "Fabrikam vs. Contoso" for the case id 1234567
		Also creates an associated search named 'CourtExport' and constrains the search to the groups behind the specified labels.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]
		$Name,
		
		[Parameter(Mandatory = $true, Position = 0)]
		[string]
		$CaseID,
		
		[string]
		$SearchName,
		
		[string[]]
		$SearchTag,
		
		[ValidateSet('Basic', 'Advanced')]
		[string]
		$CaseType = 'Basic',
		
		[switch]
		$EnableException
	)
	
	begin
	{
		Assert-Connection
		$paramsCase = @{
			Name	   = $Name
			ExternalID = $CaseID
			CaseType   = 'eDiscovery'
		}
		if ($CaseType -eq 'Advanced') { $paramsCase['CaseType'] = 'AdvancedEdiscovery' }
		
		$paramsSearch = @{
			Name		    = $SearchName
			Case		    = $Name
			EnableException = $EnableException
		}
		if ($SearchTag) { $paramsSearch['SearchTag'] = $SearchTag }
	}
	process
	{
		Invoke-PSFProtectedCommand -ActionString 'New-EDisCase.Case.Create' -Target $Name -ScriptBlock {
			$null = New-ComplianceCase @paramsCase -ErrorAction Stop
		} -EnableException $EnableException -PSCmdlet $PSCmdlet
		if (Test-PSFFunctionInterrupt) { return }
		
		if ($SearchName)
		{
			if ($CaseType -eq 'Advanced')
			{
				Stop-PSFFunction -String 'New-EDisCase.AdvancedSearch.NotSupported' -EnableException $EnableException -Target $Name -Cmdlet $PSCmdlet
				return
			}
			try { $null = New-EDisSearch @paramsSearch }
			catch { throw }
		}
	}
}