param (
    [string]$yamlFileInput,
    [string]$vsPath,
    [string]$mekikiProject,
    [string]$logDir,
    [string]$baseResultsDir,
    [string]$timestamp,
    [string]$dateSuffix
)

# YAMLファイル読み込み用関数
function Read-YamlFile {
    param ($yamlFilePath)
    $yamlContent = Get-Content $yamlFilePath | Out-String
    $yamlContent | ConvertFrom-Yaml
}

# YAMLファイルパスの生成
$yamlFilePath = "$env:yaml_settings_dir/$yamlFileInput.yml"
if (-Not (Test-Path $yamlFilePath)) {
    throw "YAMLファイル '$yamlFilePath' が存在しません。"
    Add-Content -Path $env:GITHUB_ENV -Value "TEST_RESULT=0"
    exit 1
}

# YAMLファイルから設定を読み込む
$processSettings = Read-YamlFile -yamlFilePath $yamlFilePath

# Mekikiアプリケーションの起動確認
Write-Output "Starting Mekiki application..."
if (-Not (Test-Path $vsPath)) {
    Write-Error "Visual Studio のパスが見つかりません。"
    Add-Content -Path $env:GITHUB_ENV -Value "TEST_RESULT=0"
    exit 1
}

Write-Output "Checking if Mekiki process is alive..."
$processName = "Hutzper.Project.Mekiki"
$startTime = Get-Date
$endTime = $startTime.AddMinutes(1)

Start-Process -FilePath $vsPath -ArgumentList "`"$mekikiProject`" /Run" -NoNewWindow -PassThru | Out-Null
Start-Sleep -Seconds 5

while ((Get-Date) -lt $endTime) {
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Output "$processName is running."
        break
    }
    Start-Sleep -Seconds 5
}

if (-Not $process) {
    Write-Output "$processName has stopped within the 1-minute check period."
    Add-Content -Path $env:GITHUB_ENV -Value "TEST_RESULT=0"
    exit 1
}

# 日付ごとのフォルダを作成
$dateFolder = "$baseResultsDir/$dateSuffix"
if (-Not (Test-Path $dateFolder)) {
    New-Item -Path $dateFolder -ItemType Directory | Out-Null
}

# testごとのフォルダ作成
$testsFolder = "$dateFolder/$timestamp"
if (-Not (Test-Path $testsFolder)) {
    New-Item -Path $testsFolder -ItemType Directory | Out-Null
}

# 結果ファイルパスの設定
$resultsFilePath = "$testsFolder/test_results_$timestamp.txt"
$logResultsFilePath = "$testsFolder/log_results_$timestamp.txt"

# 各プロセスのテストを実行
$results = @()
$logResults = @()

foreach ($test in $processSettings.tests) {
    Write-Output "プロセス: $($test.name)"
    Write-Output "テスト時間: $($test.duration_minutes) 分"
    $startTime = Get-Date
    $endTime = $startTime.AddMinutes($test.duration_minutes)
    
    Write-Output "プロセス $($test.name) のテストを開始します"
    $processStopped = $false
    
    while ((Get-Date) -lt $endTime) {
        Start-Sleep -Seconds 5
        
        $logContent = Get-Content "$logDir/$(Get-Date -Format yyyyMMdd).log" -Raw
        $logLines = $logContent -split "`n"
        $filteredLines = @()
        
        foreach ($line in $logLines) {
            if ($line -match "^\d{2}:\d{2}:\d{2}\.\d{3}") {
                $lineTimestamp = $matches[0]
                $lineTime = [datetime]::ParseExact($lineTimestamp, "HH:mm:ss.fff", $null)

                if ($lineTime -gt [datetime]::ParseExact($timestamp, "yyyyMMdd-HHmmss", $null)) {
                    $filteredLines += $line
                }
            }
        }
        
        $logResults = $filteredLines
        
        $deadTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        if ($filteredLines -match "異常") {
            Write-Output "$($deadTime): $($test.name)テスト中に異常を検知しました"
            $errorLines = $filteredLines | Select-String "異常" | ForEach-Object { $_.Line }
            $results += "$($test.name): Failure"
            $errorLines | Out-File -FilePath $resultsFilePath -Append
            $logResults | Out-File -FilePath $logResultsFilePath -Append
            Write-Output "結果が 'test_results_$($timestamp).txt' に保存されました"
            Write-Output "ログが 'log_results_$($timestamp).txt' に保存されました"

            Add-Content -Path $env:GITHUB_ENV -Value "TEST_RESULT=0"
            exit 1
        } else {
            Write-Output "$($deadTime): $($test.name)は動作しています"
        }
    }

    if (-Not $processStopped) {
        Write-Output "$($test.name) のテストが成功しました"
        $results += "$($test.name): Success"
    }
}
# 結果をファイルに保存
$results | Out-File -FilePath $resultsFilePath -Append
Write-Output "結果が 'test_results_$($timestamp).txt' に保存されました"
$logResults | Out-File -FilePath $logResultsFilePath -Append
Write-Output "ログが 'log_results_$($timestamp).txt' に保存されました"

Add-Content -Path $env:GITHUB_ENV -Value "TEST_RESULT=1"
