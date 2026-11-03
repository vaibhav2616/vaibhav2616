param(
    [Parameter(Position=0)]
    [ValidateSet("burgundy", "cyber", "status", "toggle")]
    [string]$Theme = "toggle"
)

$repoDir = $PSScriptRoot
if (-not $repoDir) { $repoDir = "." }
Set-Location $repoDir

$currentContent = Get-Content -Raw "README.md"
$isCyber = $currentContent -match "id-dashboard-stack-cyber\.svg"

if ($Theme -eq "status") {
    if ($isCyber) {
        Write-Host "[STATUS] Active theme: CYBER (Blue & Red Neon Edition)" -ForegroundColor Cyan
    } else {
        Write-Host "[STATUS] Active theme: BURGUNDY (Velvet Plum Edition)" -ForegroundColor Magenta
    }
    return
}

if ($Theme -eq "toggle") {
    if ($isCyber) {
        $Theme = "burgundy"
    } else {
        $Theme = "cyber"
    }
}

if ($Theme -eq "cyber") {
    Write-Host ">> Switching to CYBER Theme (Blue & Red Neon)..." -ForegroundColor Cyan
    Copy-Item -Force "README_CYBER.md" "README.md"
    $commitMsg = "Switch active profile theme to Cyber Edition (Blue & Red Neon)"
} elseif ($Theme -eq "burgundy") {
    Write-Host ">> Switching to BURGUNDY Theme (Velvet Plum & Rose Champagne)..." -ForegroundColor Magenta
    Copy-Item -Force "README_BURGUNDY.md" "README.md"
    $commitMsg = "Switch active profile theme to Burgundy Edition (Velvet Plum)"
}

git add README.md
$status = git status --porcelain
if ($status) {
    git commit -m $commitMsg
    Write-Host ">> Pushing update to GitHub..." -ForegroundColor Yellow
    git push origin main
    Write-Host "[SUCCESS] Theme switched to $Theme and deployed live to GitHub!" -ForegroundColor Green
} else {
    Write-Host "[INFO] README.md is already set to the $Theme theme." -ForegroundColor Yellow
}
