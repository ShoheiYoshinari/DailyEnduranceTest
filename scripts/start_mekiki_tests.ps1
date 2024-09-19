param (
    [string]$yamlFileInput,
    [string]$vsPath,
    [string]$mekikiProject,
    [string]$logDir,
    [string]$baseResultsDir,
    [string]$timestamp,
    [string]$dateSuffix
)

function Read-YamlFile {
    param ($yamlFilePath)
    $yamlContent = Get-Content $yamlFilePath | Out-String
    $yamlContent | ConvertFrom-Yaml
}

$yamlFilePath = "$env:yaml_settings_dir/$yamlFileInput.yml"
if (-Not (Test-Path $yamlFilePath)) {
    throw "YAMLファイル '$yamlFilePath' が存在しません。"
}

$processSettings = Read-YamlFile -yamlFilePath $yamlFilePath

Write-Output "Starting Mekiki application..."
if (-Not (Test-Path $vsPath)) {
    Write-Error "Visual Studio のパスが見つかりません。"
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

$resultsFilePath = "$testsFolder/test_results_$timestamp.txt"
$logResultsFilePath = "$testsFolder/log_results_$timestamp.txt"

./scripts/test_abnormality.ps1 -processSettings $processSettings -logFilePath "$logDir/$(Get-Date -Format yyyyMMdd).log" -resultsFilePath $resultsFilePath -logResultsFilePath $logResultsFilePath -timestamp $timestamp