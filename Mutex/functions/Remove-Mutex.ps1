function Remove-Mutex {
    <#
    .SYNOPSIS
        Removes a mutex from the list of available mutexes.
    
    .DESCRIPTION
        Removes a mutex from the list of available mutexes.
        Only affects mutexes owned and managed by this module.
        Will silently return on unknown mutexes, not throw an error.
    
    .PARAMETER Name
        Name of the mutex to remove.
        Must be an exact, case-insensitive match.
    
    .EXAMPLE
        PS C:\> Get-Mutex | Remove-Mutex

        Clear all mutex owned by the current runspace managed by this module.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Name
    )
	
    process {
        foreach ($mutexName in $Name) {
            if (-not $script:mutexes[$mutexName]) { continue }
            Unlock-Mutex -Name $mutexName
            $script:mutexes[$mutexName].Dispose()
            $script:mutexes.Remove($mutexName)
        }
    }
}