$oldPrefix = "C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe"
$newPrefix = "$Env:Programfiles\Google\Chrome\Application\Chrome.exe"
$searchPath = "C:\Users\"
$dryRun = $true
$shell = new-object -com wscript.shell
$logDir = "C:\temp"

$exists = Test-Path -Path $logDir
if (!$exists) {$null = New-Item -Path $logDir -Force }

if (Test-Path $Env:Programfiles\Google\Chrome\Application\Chrome.exe) {
    if ( $dryRun ) {
        Write-Host "Executing dry run" -foregroundcolor green -backgroundcolor black
        } else {
        Write-Host "Executing real run" -foregroundcolor red -backgroundcolor black
        }

        dir $searchPath -filter *.lnk -recurse | foreach {
        $lnk = $shell.createShortcut( $_.fullname )
        $oldPath= $lnk.targetPath

        $lnkRegex = "^" + [regex]::escape( $oldPrefix ) 

        if ( $oldPath -match $lnkRegex ) {
            $newPath = $oldPath -replace $lnkRegex, $newPrefix

            Write-Host "Found: " + $_.fullname -foregroundcolor yellow -backgroundcolor black
            Write-Host " Replace: " + $oldPath
            Write-Host " With:    " + $newPath

            if ( !$dryRun ) {
                $lnk.targetPath = $newPath
                $lnk.Save()
            }
        }
    }
} else {
    Write-Host "ERROR: Chrome.exe doesn't exist in native Program Files dir" -foregroundcolor red -backgroundcolor black
}

Stop-Transcript
