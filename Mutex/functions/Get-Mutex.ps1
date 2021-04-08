function Get-Mutex {
    <#
    .SYNOPSIS
        Get currently defined Mutexes.
    
    .DESCRIPTION
        Get currently defined Mutexes.
        Only returns mutexes owned and managed by this module.
    
    .PARAMETER Name
        Name of the mutex to retrieve.
        Supports wildcards, defaults to '*'
    
    .EXAMPLE
        PS C:\> Get-Mutex

        Return all mutexes.

    .EXAMPLE
        PS C:\> Get-Mutex -Name MyModule.LogFile

        Returns the mutex named "MyModule.LogFile"
    #>
    [CmdletBinding()]
    Param (
        [string]
        $Name = '*'
    )
	
    process {
        $script:mutexes.Values | Where-Object Name -like $Name
    }
}
