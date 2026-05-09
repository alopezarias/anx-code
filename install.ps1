param(
    [ValidateSet("base", "webstorm", "rider", "pycharm", "datagrip", "all")]
    [string]$Profile = "base"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$failedExtensions = New-Object System.Collections.Generic.List[string]
$warnedExtensions = New-Object System.Collections.Generic.List[string]

function Assert-CodeCli {
    $code = Get-Command code -ErrorAction SilentlyContinue

    if (-not $code) {
        Write-Error "The 'code' command was not found. Make sure VS Code is installed and available in PATH."
        exit 1
    }
}

function Install-ExtensionsFromFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Error "Extension file not found: $Path"
        exit 1
    }

    foreach ($line in Get-Content $Path) {
        $extension = $line.Trim()

        if ($extension -and -not $extension.StartsWith("#")) {
            Write-Host "Installing extension: $extension"

            $output = & code --install-extension $extension 2>&1

            if ($LASTEXITCODE -eq 0) {
                $output | ForEach-Object { Write-Host $_ }
                continue
            }

            $outputText = ($output | Out-String)
            $output | ForEach-Object { Write-Host $_ }

            if ($outputText.Contains("already installed") -or $outputText.Contains("cannot be downgraded")) {
                Write-Warning "Skipping non-fatal extension conflict: $extension"
                $script:warnedExtensions.Add($extension) | Out-Null
                continue
            }

            $script:failedExtensions.Add($extension) | Out-Null
        }
    }
}

Assert-CodeCli

Write-Host "Installing base extensions..."
Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/base.txt")

switch ($Profile) {
    "base" {
    }
    "webstorm" {
        Write-Host "Installing WebStorm-like extensions..."
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/webstorm.txt")
    }
    "rider" {
        Write-Host "Installing Rider-like extensions..."
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/rider.txt")
    }
    "pycharm" {
        Write-Host "Installing PyCharm-like extensions..."
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/pycharm.txt")
    }
    "datagrip" {
        Write-Host "Installing DataGrip-like extensions..."
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/datagrip.txt")
    }
    "all" {
        Write-Host "Installing all profile extensions..."
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/webstorm.txt")
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/rider.txt")
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/pycharm.txt")
        Install-ExtensionsFromFile (Join-Path $scriptDir "extensions/datagrip.txt")
    }
}

if ($failedExtensions.Count -gt 0) {
    Write-Error ("Failed extensions: " + ($failedExtensions -join ", "))
    exit 1
}

if ($warnedExtensions.Count -gt 0) {
    Write-Warning ("Skipped extensions with existing VS Code conflicts: " + ($warnedExtensions -join ", "))
}

Write-Host "Done."
