#Requires -RunAsAdmin
## If Chrome x64 is moved out of the Program Files (x86) directory it can break user created shortcuts to sites
## This will search for existing Chrome.exe .lnk shortcut files pointing to the old directory and modify them to point
## to Chrome.exe in the native Program Files directory

$oldPrefix = "C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe"
$newPrefix = "$Env:Programfiles\Google\Chrome\Application\Chrome.exe"
$searchPath = "C:\Users\"
$dryRun = $true
$shell = new-object -com wscript.shell
$logDir = "C:\temp"

if (Test-Path $logDir) {
    Start-Transcript -Path $logDir\Fix-ChromeShortcuts.log
    Write-Host "Log dir exists"
} else {
    New-Item $logDir -ItemType Directory
    Start-Transcript -Path $logDir\Fix-ChromeShortcuts.log
    Write-Host "Log dir created"
}

if (Test-Path $Env:Programfiles\Google\Chrome\Application\Chrome.exe) {
    if ( $dryRun ) {
        write-host "Executing dry run" -foregroundcolor green -backgroundcolor black
        } else {
        write-host "Executing real run" -foregroundcolor red -backgroundcolor black
        }

        dir $searchPath -filter *.lnk -recurse | foreach {
        $lnk = $shell.createShortcut( $_.fullname )
        $oldPath= $lnk.targetPath

        $lnkRegex = "^" + [regex]::escape( $oldPrefix ) 

        if ( $oldPath -match $lnkRegex ) {
            $newPath = $oldPath -replace $lnkRegex, $newPrefix

            write-host "Found: " + $_.fullname -foregroundcolor yellow -backgroundcolor black
            write-host " Replace: " + $oldPath
            write-host " With:    " + $newPath

            if ( !$dryRun ) {
                $lnk.targetPath = $newPath
                $lnk.Save()
            }
        }
    }
}

Stop-Transcript
