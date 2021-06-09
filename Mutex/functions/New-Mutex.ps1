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
        All mutexes with the same name block each other, across all processes on the current host/user.
        If the mutex should be globally valid on a multi user system
        prefix the name with "Global\". Otherwise it is assumed that it belongs only to the current
        user session (equals the prefix "Local\").

    .PARAMETER Access
        Which set of permissions to apply to the mutex.
        - default: The system default permissions for mutexes. The creator and the system will have access.
        - anybody: Any authenticated person on the system can obtain mutex lock.
        - admins: Any process running with elevation can obtain mutex lock.

    .PARAMETER Security
        Provide a custom mutex security object, governing access to the mutex.

    .PARAMETER CaseSpecific
        Create the mutex with the specified name casing.
        By default, mutexes managed by this module are lowercased to guarantee case-insensitivity across all PowerShell executions.
        This however would potentially affect interoperability with other tools & languages, hence this parameter to enable casing fidelity at the cost of case sensitivity.

        Note: Even when enabling this, only one instance of name (compared WITHOUT case sensitivity) can be stored within this module!
        For example, the mutexes "Example" and "eXample" could not coexist within the Mutex PowerShell module, even though they are distinct from each other and even when using the -CaseSpecific parameter.

    .EXAMPLE
        PS C:\> New-Mutex -Name MyModule.LogFile

        Create a new, unlocked mutex named 'MyModule.LogFile'
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'securitySet')]
    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'securitySet')]
        [ValidateSet('default', 'anybody', 'admins')]
        [string]
        $Access = $script:mutexDefaultAccess,

        [Parameter(ParameterSetName = 'object')]
        [System.Security.AccessControl.MutexSecurity]
        $Security = $script:mutexDefaultSecurity,

        [switch]
        $CaseSpecific
    )

    process {
        $newName = $Name.ToLower()
        if ($CaseSpecific) { $newName = $Name }

        if ($script:mutexes[$newName]) { return }

        #region Generate Mutex object & Security
        if ($Access -ne "default") {
            $securityObject = [System.Security.AccessControl.MutexSecurity]::New()
            $securityObject.SetOwner([System.Security.Principal.WindowsIdentity]::GetCurrent().User)
            switch ($Access) {
                'anybody' {
                    $rules = @(
                        [System.Security.AccessControl.MutexAccessRule]::new(([System.Security.Principal.SecurityIdentifier]'S-1-5-11'), 'FullControl', 'Allow')
                        [System.Security.AccessControl.MutexAccessRule]::new(([System.Security.Principal.SecurityIdentifier]'S-1-5-18'), 'FullControl', 'Allow')
                        [System.Security.AccessControl.MutexAccessRule]::new([System.Security.Principal.WindowsIdentity]::GetCurrent().User, 'FullControl', 'Allow')
                    )
                    foreach ($rule in $rules) { $securityObject.AddAccessRule($rule) }
                }
                'admins' {
                    $rules = @(
                        [System.Security.AccessControl.MutexAccessRule]::new(([System.Security.Principal.SecurityIdentifier]'S-1-5-32-544'), 'FullControl', 'Allow')
                        [System.Security.AccessControl.MutexAccessRule]::new(([System.Security.Principal.SecurityIdentifier]'S-1-5-18'), 'FullControl', 'Allow')
                        [System.Security.AccessControl.MutexAccessRule]::new([System.Security.Principal.WindowsIdentity]::GetCurrent().User, 'FullControl', 'Allow')
                    )
                    foreach ($rule in $rules) { $securityObject.AddAccessRule($rule) }
                }
            }
        }
        if ($Security -and -not $PSBoundParameters.ContainsKey('Access')) { $securityObject = $Security }
        if ($securityObject) {
            if ($PSVersionTable.PSVersion.Major -gt 5) {
                $mutex = [System.Threading.Mutex]::new($false, $newName)
                [System.Threading.ThreadingAclExtensions]::SetAccessControl($mutex, $securityObject)
            }
            else {
                $mutex = [System.Threading.Mutex]::new($false, $newName, [ref]$null, $securityObject)
            }
        }
        else {
            $mutex = [System.Threading.Mutex]::new($false, $newName)
        }
        #endregion Generate Mutex object & Security

        $script:mutexes[$newName] = [PSCustomObject]@{
            Name      = $newName
            Status    = "Open"
            Object    = $mutex
        }
    }
}