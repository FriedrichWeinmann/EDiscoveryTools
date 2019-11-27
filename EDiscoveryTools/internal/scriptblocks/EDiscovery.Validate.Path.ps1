Set-PSFScriptblock -Name 'EDiscovery.Validate.Path' -Scriptblock {
	try { Resolve-PSFPath -Path $_ -Provider FileSystem -SingleItem }
	catch { $false }
}