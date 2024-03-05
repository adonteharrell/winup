#Start-Process rundll32.exe -ArgumentList "user32.dll,LockWorkStation"
# Check for available updates

$directoryPath = "C:\temp\WindowsUpdates"
# Check if the directory already exists
if (-not (Test-Path $directoryPath -PathType Container)) {
    # If not, create the directory
    New-Item -ItemType Directory -Path $directoryPath -Force

    Write-Host "Directory created: $directoryPath"
} else {
    Write-Host "Directory already exists: $directoryPath"
}

try {
    # Install NuGet provider
    Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force -Scope CurrentUser -ErrorAction Stop

    # If the installation is successful, you can continue with the script logic here

} catch {
    # Handle errors and write to a log file
    $errorMessage = "$((Get-Date) -f 'yyyy-MM-dd HH:mm:ss') - Error: $_"
    Write-Host $errorMessage

    $logFilePath = "C:\temp\WindowsUpdates\ErrorLog.txt"
    $errorMessage | Out-File -FilePath $logFilePath -Append -Encoding UTF8

    exit 1  # Exit the script with a non-zero status code
}

try {
    # Install PSWindowsUpdate module
    Install-Module PSWindowsUpdate -Force -Scope CurrentUser -ErrorAction Stop

    # If the installation is successful, you can continue with the script logic here

} catch {
    # Handle errors and write to a log file
    $errorMessage = "$((Get-Date) -f 'yyyy-MM-dd HH:mm:ss') - Error: $_"
    Write-Host $errorMessage

    $logFilePath = "C:\temp\WindowsUpdates\ErrorLog.txt"
    $errorMessage | Out-File -FilePath $logFilePath -Append -Encoding UTF8

    exit 1  # Exit the script with a non-zero status code
}

try {
    # Import PSWindowsUpdate module
    Import-Module -Name PSWindowsUpdate -ErrorAction Stop

    # If the import is successful, you can continue with the script logic here

} catch {
    # Handle errors and write to a log file
    $errorMessage = "$((Get-Date) -f 'yyyy-MM-dd HH:mm:ss') - Error: $_"
    Write-Host $errorMessage

    $logFilePath = "C:\temp\WindowsUpdates\ErrorLog.txt"
    $errorMessage | Out-File -FilePath $logFilePath -Append -Encoding UTF8

    exit 1  # Exit the script with a non-zero status code
}


$updateCount = (Get-WindowsUpdate).Count
$currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm"

if ($updateCount -gt 0) {
    # Updates are available, install them
    Write-Host "Found $updateCount updates. Installing Windows updates..."
    Install-WindowsUpdate -AcceptAll -AutoReboot | Out-File "c:\temp\WindowsUpdates\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -Append -force 
    Write-Host "Updates installed successfully."
} else {
    # No updates available, close the shell
    Write-Host "No updates available. Closing the shell." 
    "$currentDateTime - No updates available. Closing the shell." | Out-File "c:\temp\WindowsUpdates\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -Append
    exit 1
}
