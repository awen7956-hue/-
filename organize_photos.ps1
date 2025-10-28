# Set source folder and target size (25MB = 25 * 1024 * 1024 bytes)
$sourceFolder = "c:\Users\user\Downloads\Photos-1-001"
$targetSizeMB = 25
$targetSizeBytes = $targetSizeMB * 1024 * 1024

# Get all image and video files, exclude script itself and zip files
$files = Get-ChildItem -Path $sourceFolder -File | Where-Object { 
    $_.Name -ne "organize_photos.ps1" -and 
    $_.Extension -ne ".zip" 
} | Sort-Object Name

Write-Host "Found $($files.Count) files"

# Initialize variables
$folderIndex = 1
$currentSize = 0
$currentFolderPath = $null
$filesMoved = 0

foreach ($file in $files) {
    # Create new folder if needed
    if ($currentSize -eq 0 -or ($currentSize + $file.Length) -gt $targetSizeBytes) {
        $folderName = "Batch_$($folderIndex.ToString('D3'))"
        $currentFolderPath = Join-Path $sourceFolder $folderName
        
        # Create folder
        if (-not (Test-Path $currentFolderPath)) {
            New-Item -ItemType Directory -Path $currentFolderPath | Out-Null
            Write-Host "Created folder: $folderName"
        }
        
        $folderIndex++
        $currentSize = 0
    }
    
    # Move file
    $destPath = Join-Path $currentFolderPath $file.Name
    Move-Item -Path $file.FullName -Destination $destPath
    $currentSize += $file.Length
    $filesMoved++
    
    $sizeMB = [math]::Round($currentSize / 1024 / 1024, 2)
    Write-Host "Moved: $($file.Name) (Folder size: ${sizeMB}MB)"
}

Write-Host ""
Write-Host "Done! Moved $filesMoved files to $($folderIndex - 1) folders"
