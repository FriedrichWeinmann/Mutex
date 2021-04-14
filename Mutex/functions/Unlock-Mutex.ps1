function Unlock-Mutex {
    <#
    .SYNOPSIS
        Release the lock on a mutex you manage.
    
    .DESCRIPTION
        Release the lock on a mutex you manage.
        Will silently return if the mutex does not exist.
    
    .PARAMETER Name
        The name of the mutex to release the lock on.
    
    .EXAMPLE
        PS C:\> Unlock-Mutex -Name MyModule.LogFile

        Release the lock on the mutex 'MyModule.LogFile'

    .EXAMPLE
        PS C:\> Get-Mutex | Release-Mutex

        Release the lock on all mutexes managed.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name
    )
	
    process {
        foreach ($mutexName in $Name) {
            if (-not $script:mutexes[$mutexName]) { return }
            if ($script:mutexes[$mutexName].Status -eq "Open") { return }
            try { $script:mutexes[$mutexName].Object.ReleaseMutex() }
            catch { $PSCmdlet.WriteError($_) }
            $script:mutexes[$mutexName].Status = 'Open'
        }
    }
}