function Unlock-Mutex {
    <#
    .SYNOPSIS
        Release the lock on a mutex you manage.

    .DESCRIPTION
        Release the lock on a mutex you manage.
        Will silently return if the mutex does not exist.

    .PARAMETER Name
        The name of the mutex to release the lock on.

    .PARAMETER UnlockOnlyOnce
        If the mutex has been locked multiple times using this parameter only unlocks it once.
        The LockCount of a mutex can be viewed by Get-Mutex

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
        $Name,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
        [switch]$UnlockOnlyOnce
    )

    process {
        foreach ($mutexName in $Name) {
            if (-not $script:mutexes[$mutexName]) { return }
            $mutex = $script:mutexes[$mutexName]

            if ($mutex.Status -eq "Open" -and $mutex.LockCount -le 0) { return }
            if ($UnlockOnlyOnce) { $unLockCycleCount = 1 }else { $unLockCycleCount = $mutex.LockCount }
            for ($iteration = 0; $iteration -lt $unLockCycleCount; $iteration++) {
                try {
                    $mutex.Object.ReleaseMutex()
                    $mutex.LockCount--
                }
                catch { $PSCmdlet.WriteError($_) }
            }

            if ($mutex.LockCount -le 0) {
                $mutex.Status = 'Open'
            }
        }
    }
}