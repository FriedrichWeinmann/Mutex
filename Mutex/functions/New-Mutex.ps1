function New-Mutex {
    <#
    .SYNOPSIS
        Create a new mutex managed by this module.
    
    .DESCRIPTION
        Create a new mutex managed by this module.
        The mutex is created in an unacquired state.
        Use Lock-Mutex to acquire the mutex.

        Note: Calling Lock-Mutex without first calling New-Mutex will implicitly call New-Mutex.
        
    .PARAMETER Name
        Name of the mutex to create.
        The name is what the system selects for when marshalling access:
        All mutexes with the same name block each other, across all processes on the current host.
    
    .EXAMPLE
        PS C:\> New-Mutex -Name MyModule.LogFile

        Create a new, unlocked mutex named 'MyModule.LogFile'
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )
	
    process {
        if ($script:mutexes[$Name]) { return }
        $script:mutexes[$Name] = [PSCustomObject]@{
            Name   = $Name
            Status = "Open"
            Object = [System.Threading.Mutex]::new($false, $Name)
        }
    }
}
