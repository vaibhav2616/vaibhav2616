param(
    [Parameter(Position=0)]
    [ValidateSet("burgundy", "cyber", "status", "toggle")]
    [string]$Theme = "toggle"
)

$repoDir = $PSScriptRoot
if (-not $repoDir) { $repoDir = "." }
Set-Location $repoDir

$currentContent = Get-Content -Raw "README.md"
$isCyber = $currentContent -match "assets/cyber/"

if ($Theme -eq "status") {
    if ($isCyber) {
        Write-Host "[STATUS] Active theme: CYBER (100% Cyber Blue & Red Neon Assets)" -ForegroundColor Cyan
    } else {
        Write-Host "[STATUS] Active theme: BURGUNDY (100% Velvet Plum & Rose Champagne Assets)" -ForegroundColor Magenta
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
    Write-Host ">> Switching to CYBER Theme (All 19 Assets in Blue & Red Neon)..." -ForegroundColor Cyan
    Copy-Item -Force "README_CYBER.md" "README.md"
    $commitMsg = "Switch active profile theme to Cyber Edition (All assets blue/red neon)"
} elseif ($Theme -eq "burgundy") {
    Write-Host ">> Switching to BURGUNDY Theme (All 19 Assets in Velvet Plum & Rose Champagne)..." -ForegroundColor Magenta
    Copy-Item -Force "README_BURGUNDY.md" "README.md"
    $commitMsg = "Switch active profile theme to Burgundy Edition (All assets velvet plum)"
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
