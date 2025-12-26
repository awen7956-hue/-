# 將每個 Batch 資料夾壓縮成 ZIP 檔案
$sourceFolder = "c:\Users\user\Downloads\Photos-1-001"

# 取得所有 Batch 資料夾
$batchFolders = Get-ChildItem -Path $sourceFolder -Directory | Where-Object { $_.Name -like "Batch_*" } | Sort-Object Name

Write-Host "找到 $($batchFolders.Count) 個批次資料夾需要壓縮"
Write-Host ""

foreach ($folder in $batchFolders) {
    $zipPath = Join-Path $sourceFolder "$($folder.Name).zip"
    
    Write-Host "正在壓縮 $($folder.Name)..."
    
    # 壓縮資料夾
    Compress-Archive -Path "$($folder.FullName)\*" -DestinationPath $zipPath -Force
    
    # 取得 ZIP 檔案的大小
    $zipSize = (Get-Item $zipPath).Length
    $zipSizeMB = [math]::Round($zipSize / 1024 / 1024, 2)
    
    Write-Host "  已建立: $($folder.Name).zip (${zipSizeMB}MB)"
}

Write-Host ""
Write-Host "所有批次已成功壓縮！"
