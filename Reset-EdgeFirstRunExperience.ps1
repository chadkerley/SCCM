# ---Reset Edge First Run Experience (FRE)---
#
# Define LocalAppData Folder
$LocalAppData = $null; if ( $env:localappdata -ne $null) { $LocalAppData = $env:localappdata }
# Config: Which Edge Branch? => "Edge Beta" or "Edge" or "Edge Dev"
$EdgeBranch="Edge"
# Edge-Settings, starting with empty Hash - Import existing Settings if present
$data = @{} 

if (Test-Path $LocalAppData) {
$JSON_File_Path = "$LocalAppData\Microsoft\$EdgeBranch\User Data"; if (!(Test-Path $JSON_File_Path)) { "Creating ""$EdgeBranch"" Profile-Directory: ""$JSON_File_Path""" | Out-String; New-Item -ItemType Directory -Path $JSON_File_Path | Out-Null }
$JSON_File_Path = "$JSON_File_Path\Local State"
} 
else { "ERROR: LocalAppData: ""$LocalAppData"" missing!" | Out-String; exit 1; }
if   (!(Test-Path -Path $JSON_File_Path)) { "Edge-Settings-File ""$JSON_File_Path"" does not exist, starting empty." | Out-String }
else { "Reading existing Settings-File: $JSON_File_Path" | Out-String 
    $data = Get-content $JSON_File_Path -Encoding Default | ConvertFrom-Json
}

if ($data.Count -gt 0) {
    "# --- Existing Edge Settings --- " | Out-String
    $data | Out-String
    "-------------------------------- " | Out-String
}

if ($data.fre -eq $null) {  "# --- FRE node doesn't exist, do nothing --- " | Out-String }
# Node "fre" is present, delete it
else { $data.PSObject.Members.Remove('fre')}    
"Writing Settings-File: $JSON_File_Path" | Out-String 
$data | ConvertTo-Json -Depth 99 | Out-File -FilePath $JSON_File_Path -Encoding default            
# Remove files that block FRE
$FileName1 = "$LocalAppData\Microsoft\$EdgeBranch\User Data\First Run"
    if (Test-Path $FileName1) {
    Remove-Item $FileName1 -Force
    }
$FileName2 = "$LocalAppData\Microsoft\$EdgeBranch\User Data\FirstLaunchAfterInstallation"
    if (Test-Path $FileName2) {
    Remove-Item $FileName2 -Force
    }
