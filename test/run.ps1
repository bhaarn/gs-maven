# PowerShell equivalent of run.sh
# Navigate to the script directory
Set-Location -Path $PSScriptRoot

# Change to the complete directory
Set-Location -Path "..\complete"

# Run Maven clean package
Write-Host "Running Maven clean package..."
& ".\mvnw.cmd" clean package
$ret = $LASTEXITCODE
if ($ret -ne 0) {
    exit $ret
}

# Run the jar file and capture the last line to actual.txt
Write-Host "Running the application..."
$output = & "C:/Bharani/jdk-17.0.2/bin/java" -jar "target\gs-maven-0.1.0.jar"
$lastLine = $output | Select-Object -Last 1
$lastLine | Out-File -FilePath "target\actual.txt" -Encoding UTF8

# Display the results
$actualContent = Get-Content "target\actual.txt" -Raw
$expectedContent = Get-Content "..\test\expected.txt" -Raw

Write-Host "Let's look at the actual results: $actualContent"
Write-Host "And compare it to: $expectedContent"

# Compare the files (ignoring whitespace differences)
$actualTrimmed = $actualContent.Trim()
$expectedTrimmed = $expectedContent.Trim()

if ($actualTrimmed -eq $expectedTrimmed) {
    Write-Host "SUCCESS"
    $ret = 0
} else {
    Write-Host "FAIL"
    Write-Host "Expected: '$expectedTrimmed'"
    Write-Host "Actual: '$actualTrimmed'"
    $ret = 255
    exit $ret
}

# Remove target directory
Remove-Item -Path "target" -Recurse -Force -ErrorAction SilentlyContinue

# Change to initial directory
Set-Location -Path "..\initial"

# Run Maven clean compile
Write-Host "Running Maven clean compile in initial directory..."
& ".\mvnw.cmd" clean compile
$ret = $LASTEXITCODE
if ($ret -ne 0) {
    exit $ret
}

# Remove target directory
Remove-Item -Path "target" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Script completed successfully"
exit 0

