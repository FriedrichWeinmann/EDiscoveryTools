function New-EDisSearch
{
<#
	.SYNOPSIS
		Creates a new eDiscovery Search.
	
	.DESCRIPTION
		Creates a new eDiscovery Search.
	
	.PARAMETER Name
		The name of the search to create.
	
	.PARAMETER Case
		The case to which to attach the search.
		Only basic eDiscovery cases are supported at the moment.
	
	.PARAMETER Description
		The description to add to the search.
	
	.PARAMETER SearchTag
		Any search tags to include in the search.
		Search tags apply distribution group based filters to the search.
		See description of Register-EDisSearch for details.
	
	.PARAMETER EnableException
		This parameters disables user-friendly warnings and enables the throwing of exceptions.
		This is less user friendly, but allows catching exceptions in calling scripts.
	
	.PARAMETER Confirm
		If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.
	
	.PARAMETER WhatIf
		If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.
	
	.EXAMPLE
		PS C:\> New-EDisSearch -Name newSearch -Case LatestCase
	
		Creates an unfiltered search against the case "LatestCase".
	
	.EXAMPLE
		PS C:\> New-ADisSearch -Name CourtExport -Case "Fabrikam vs. Contoso" -SearchTag NorthAmerica, SouthAmerica, Emea
	
		Creates a new search named CourtExport for the case "Fabrikam vs. Contoso"
		It then applies a distribution group based filter from the specified tags.
		Note: The tags and their DG mapping must first have been registered/imported.
#>
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,
		
		[Parameter(Mandatory = $true)]
		[string]
		$Case,
		
		[string]
		$Description,
		
		[string[]]
		$SearchTag,
		
		[switch]
		$EnableException
	)
	
	begin
	{
		Assert-Connection
	}
	process
	{
		$params = $PSBoundParameters | ConvertTo-PSFHashtable -Include Name, Case, Description
		if ($SearchTag)
		{
			$groups = foreach ($tag in $SearchTag)
			{
				if (-not $script:searchGroupMappingData[$tag])
				{
					Stop-PSFFunction -String 'New-EDisSearch.Tag.Invalid' -StringValues $tag -EnableException $EnableException -Cmdlet $PSCmdlet -Continue
				}
				$script:searchGroupMappingData[$tag]
			}
			$groupsUnique = $groups | Select-Object -Unique
			$params['ExchangeLocation'] = $groupsUnique
		}
		#Invoke-PSFProtectedCommand -ActionString 'New-EDisSearch.Execute' -ActionStringValues $Case -Target $Name -ScriptBlock {
			New-ComplianceSearch @params -ErrorAction Stop
		#} -EnableException $EnableException -PSCmdlet $PSCmdlet
	}
}