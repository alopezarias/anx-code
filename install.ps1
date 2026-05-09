param(
    [ValidateSet("base", "webstorm", "rider", "pycharm", "datagrip", "all")]
    [string]$Profile = "base"
)

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

    Get-Content $Path | ForEach-Object {
        $extension = $_.Trim()

        if ($extension -and -not $extension.StartsWith("#")) {
            Write-Host "Installing extension: $extension"
            code --install-extension $extension --force
        }
    }
}

Assert-CodeCli

Write-Host "Installing base extensions..."
Install-ExtensionsFromFile ".\extensions\base.txt"

switch ($Profile) {
    "base" {
    }
    "webstorm" {
        Write-Host "Installing WebStorm-like extensions..."
        Install-ExtensionsFromFile ".\extensions\webstorm.txt"
    }
    "rider" {
        Write-Host "Installing Rider-like extensions..."
        Install-ExtensionsFromFile ".\extensions\rider.txt"
    }
    "pycharm" {
        Write-Host "Installing PyCharm-like extensions..."
        Install-ExtensionsFromFile ".\extensions\pycharm.txt"
    }
    "datagrip" {
        Write-Host "Installing DataGrip-like extensions..."
        Install-ExtensionsFromFile ".\extensions\datagrip.txt"
    }
    "all" {
        Write-Host "Installing all profile extensions..."
        Install-ExtensionsFromFile ".\extensions\webstorm.txt"
        Install-ExtensionsFromFile ".\extensions\rider.txt"
        Install-ExtensionsFromFile ".\extensions\pycharm.txt"
        Install-ExtensionsFromFile ".\extensions\datagrip.txt"
    }
}

Write-Host "Done."