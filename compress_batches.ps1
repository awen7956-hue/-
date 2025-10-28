# Compress each Batch folder into a ZIP file
$sourceFolder = "c:\Users\user\Downloads\Photos-1-001"

# Get all Batch folders
$batchFolders = Get-ChildItem -Path $sourceFolder -Directory | Where-Object { $_.Name -like "Batch_*" } | Sort-Object Name

Write-Host "Found $($batchFolders.Count) batch folders to compress"
Write-Host ""

foreach ($folder in $batchFolders) {
    $zipPath = Join-Path $sourceFolder "$($folder.Name).zip"
    
    Write-Host "Compressing $($folder.Name)..."
    
    # Compress the folder
    Compress-Archive -Path "$($folder.FullName)\*" -DestinationPath $zipPath -Force
    
    # Get the size of the ZIP file
    $zipSize = (Get-Item $zipPath).Length
    $zipSizeMB = [math]::Round($zipSize / 1024 / 1024, 2)
    
    Write-Host "  Created: $($folder.Name).zip (${zipSizeMB}MB)"
}

Write-Host ""
Write-Host "All batches compressed successfully!"
