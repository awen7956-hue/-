# 設定來源資料夾和目標大小 (25MB = 25 * 1024 * 1024 位元組)
$sourceFolder = "c:\Users\user\Downloads\Photos-1-001"
$targetSizeMB = 25
$targetSizeBytes = $targetSizeMB * 1024 * 1024

# 取得所有圖片和影片檔案，排除腳本本身和壓縮檔
$files = Get-ChildItem -Path $sourceFolder -File | Where-Object { 
    $_.Name -ne "organize_photos.ps1" -and 
    $_.Extension -ne ".zip" 
} | Sort-Object Name

Write-Host "找到 $($files.Count) 個檔案"

# 初始化變數
$folderIndex = 1
$currentSize = 0
$currentFolderPath = $null
$filesMoved = 0

foreach ($file in $files) {
    # 如需要則建立新資料夾
    if ($currentSize -eq 0 -or ($currentSize + $file.Length) -gt $targetSizeBytes) {
        $folderName = "Batch_$($folderIndex.ToString('D3'))"
        $currentFolderPath = Join-Path $sourceFolder $folderName
        
        # 建立資料夾
        if (-not (Test-Path $currentFolderPath)) {
            New-Item -ItemType Directory -Path $currentFolderPath | Out-Null
            Write-Host "已建立資料夾: $folderName"
        }
        
        $folderIndex++
        $currentSize = 0
    }
    
    # 移動檔案
    $destPath = Join-Path $currentFolderPath $file.Name
    Move-Item -Path $file.FullName -Destination $destPath
    $currentSize += $file.Length
    $filesMoved++
    
    $sizeMB = [math]::Round($currentSize / 1024 / 1024, 2)
    Write-Host "已移動: $($file.Name) (資料夾大小: ${sizeMB}MB)"
}

Write-Host ""
Write-Host "完成！已將 $filesMoved 個檔案移至 $($folderIndex - 1) 個資料夾"
