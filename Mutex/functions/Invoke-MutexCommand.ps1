function Invoke-MutexCommand {
    <#
	.SYNOPSIS
		Execute a scriptblock after acquiring a mutex lock and safely releasing it after.
	
	.DESCRIPTION
		Execute a scriptblock after acquiring a mutex lock and safely releasing it after.
	
	.PARAMETER Name
		Name of the mutex lock to acquire.
	
	.PARAMETER ErrorMessage
		The error message to generate when mutex lock acquisition fails.
	
	.PARAMETER ScriptBlock
		The scriptblock to execute after the lock is acquired.
	
	.PARAMETER Timeout
		How long to wait for mutex lock acquisition.
		This is incurred when another process in the same computer already holds the mutex of the same name.
		Defaults to 30s

    .PARAMETER ArgumentList
        Arguments to pass to the scriptblock being invoked.

    .PARAMETER Stream
        Return data as it arrives.
        This disables caching of data being returned by the scriptblock executed within the mutex lock.
        When used as part of a pipeline, output produced will pause the current command and pass the object down the pipeline directly.
        This enables memory optimization, as for example not all content of a large file needs to be stored in memory at the same time, but might cause conflicts with mutex locks, if multiple commands in the pipeline need distinct locks to be applied.

    .PARAMETER Temporary
        Remove all mutexes from management that did not exist before invokation.
	
	.EXAMPLE
		PS C:\> Invoke-MutexCommand "PS.Roles.$System.$Name" -ErrorMessage "Failed to acquire file access lock" -ScriptBlock $ScriptBlock
	
		Executes the provided scriptblock after locking execution behind the mutex named "PS.Roles.$System.$Name".
		If the lock fails, the error message "Failed to acquire file access lock" will be displayed and no action taken.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name,
		
        [string]
        $ErrorMessage = 'Failed to acquire mutex lock',
		
        [Parameter(Mandatory = $true)]
        [scriptblock]
        $ScriptBlock,
		
        [TimeSpan]
        $Timeout = '00:00:30',

        [Parameter(ValueFromPipeline = $true)]
        $ArgumentList,

        [switch]
        $Stream,

        [switch]
        $Temporary
    )
	
    process {
        $existedBefore = (Get-Mutex -Name $Name) -as [bool]
        if (-not (Lock-Mutex -Name $Name -Timeout $Timeout)) {
            Write-Error $ErrorMessage
            return
        }
        try {
            if ($Stream) {
                if ($PSBoundParameters.ContainsKey('ArgumentList')) { & $ScriptBlock $ArgumentList }
                else { & $ScriptBlock }
                Unlock-Mutex -Name $Name
                if ($Temporary -and -not $existedBefore) { Remove-Mutex -Name $Name }
            }
            else {
                # Store results and return after Mutex completes to avoid deadlock in pipeline scenarios
                if ($PSBoundParameters.ContainsKey('ArgumentList')) { $results = & $ScriptBlock $ArgumentList }
                else { $results = & $ScriptBlock }
                
                Unlock-Mutex -Name $Name
                if ($Temporary -and -not $existedBefore) { Remove-Mutex -Name $Name }
                $results
            }
        }
        catch {
            Unlock-Mutex -Name $Name
            if ($Temporary -and -not $existedBefore) { Remove-Mutex -Name $Name }
            $PSCmdlet.WriteError($_)
        }
    }
}