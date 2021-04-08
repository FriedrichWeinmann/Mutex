# Mutex

## Introduction

The Mutex module is designed as a minimal wrapper around the .NET mutex functionality.
It is designed to synchronize resource access across process boundaries within the same host.

Are plainly put, it is used to prevent access conflicts.
For examples from writing to the same file.

## Installation

The module has been published to the PowerShell Gallery.
To install it, run:

```powershell
Install-Module Mutex
```

## Use

This will create a lock on the mutex "Task.User.Creation", then write to the "newusers.csv" file before releasing the lock again.
Any other thread / process doing the same thing and using the same mutex is going to wait for this to complete before being able to gain the same lock and do its part.

```powershell
try {
    Lock-Mutex -Name Task.User.Creation
    $result | Export-Csv -Path .\newusers.csv -Append
}
finally {
    Unlock-Mutex -Name Task.User.Creation
}
```

If all access to "newusers.csv" is gated around this mutex, write conflict can be avoided without any concerns.

> The finally block guarantees that no matter the error, the lock is going to be released, thus avoiding a deadlock scenario.
