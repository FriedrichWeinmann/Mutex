function Lock-Mutex {
    <#
    .SYNOPSIS
        Acquire a lock on a mutex.

    .DESCRIPTION
        Acquire a lock on a mutex.
        Implicitly calls New-Mutex if the mutex hasn't been taken under the management of the current process yet.

    .PARAMETER Name
        Name of the mutex to acquire a lock on. If the mutex should be globally valid on a multi user system
        prefix the name with "Global\". Otherwise it is assumed that it belongs only to the current
        user session (equals the prefix "Local\").

    .PARAMETER Timeout
        How long to wait for acquiring the mutex, before giving up with an error.

    .EXAMPLE
        PS C:\> Lock-Mutex -Name MyModule.LogFile

        Acquire a lock on the mutex 'MyModule.LogFile'
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Name,

        [timespan]
        $Timeout
    )

    process {
        foreach ($mutexName in $Name) {
            if (-not $script:mutexes[$mutexName]) { New-Mutex -Name $mutexName }
            if (-not $Timeout) { $script:mutexes[$mutexName].Object.WaitOne() }
            else {
                try { $script:mutexes[$mutexName].Object.WaitOne($Timeout) }
                catch {
                    Write-Error $_
                    continue
                }
            }
            $script:mutexes[$mutexName].Status = 'Locked'
        }
    }
}