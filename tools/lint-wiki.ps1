# tools/lint-wiki.ps1
# Native PowerShell Wiki Health & Graph Audit Script

$wikiDir = "wiki"
$files = Get-ChildItem -Path $wikiDir -Filter "*.md" -Recurse

Write-Host "==============================" -ForegroundColor Cyan
Write-Host " LLM WIKI GRAPH LINT REPORT" -ForegroundColor Cyan
Write-Host " Total Wiki Pages: $($files.Count)" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$fileStems = @{}
$inboundLinks = @{}
foreach ($f in $files) {
    $fileStems[$f.BaseName] = $f.FullName
    $inboundLinks[$f.BaseName] = 0
}

$brokenLinks = @()
$frontmatterErrors = @()
$requiredKeys = @("title", "category", "evidence_tier", "last_updated")

foreach ($f in $files) {
    $content = Get-Content -Path $f.FullName -Raw -Encoding UTF8

    # 1. Frontmatter check (skip INDEX and LOG)
    if ($f.BaseName -ne "INDEX" -and $f.BaseName -ne "LOG") {
        if ($content -match "(?s)^---\s*\r?\n(.*?)\r?\n---") {
            $fmText = $matches[1]
            foreach ($key in $requiredKeys) {
                if ($fmText -notmatch "(?m)^$key\s*:") {
                    $frontmatterErrors += "$($f.Name): Missing required key '$key'"
                }
            }
        } else {
            $frontmatterErrors += "$($f.Name): Missing YAML frontmatter"
        }
    }

    # 2. Extract Wikilinks [[target]]
    $matchesWikilinks = [regex]::Matches($content, "\[\[(.*?)\]\]")
    foreach ($m in $matchesWikilinks) {
        $rawTarget = $m.Groups[1].Value.Trim()
        if ($rawTarget.StartsWith("raw/")) {
            continue
        }
        $targetStem = [System.IO.Path]::GetFileNameWithoutExtension($rawTarget.Split("|")[0].Split("#")[0].Trim())
        if ($fileStems.ContainsKey($targetStem)) {
            $inboundLinks[$targetStem]++
        } else {
            $brokenLinks += "$($f.Name) -> [[$rawTarget]]"
        }
    }
}

# 1. Report Frontmatter
Write-Host "[1] Frontmatter Schema Compliance:" -ForegroundColor Yellow
if ($frontmatterErrors.Count -eq 0) {
    Write-Host "  [OK] All pages strictly adhere to the AGENTS.md schema." -ForegroundColor Green
} else {
    foreach ($err in $frontmatterErrors) {
        Write-Host "  [ERR] $err" -ForegroundColor Red
    }
}

# 2. Report Broken Links
Write-Host "`n[2] Wikilink Integrity Check:" -ForegroundColor Yellow
if ($brokenLinks.Count -eq 0) {
    Write-Host "  [OK] Zero broken links detected. All target files exist." -ForegroundColor Green
} else {
    foreach ($err in $brokenLinks) {
        Write-Host "  [ERR] Broken link in $err" -ForegroundColor Red
    }
}

# 3. Report Orphans
$orphans = @()
foreach ($stem in $inboundLinks.Keys) {
    if ($inboundLinks[$stem] -eq 0 -and $stem -ne "INDEX" -and $stem -ne "LOG") {
        $orphans += "$stem.md"
    }
}

Write-Host "`n[3] Graph Orphan Check:" -ForegroundColor Yellow
if ($orphans.Count -eq 0) {
    Write-Host "  [OK] Zero orphan pages. Every concept and protocol is cross-linked." -ForegroundColor Green
} else {
    Write-Host "  [WARN] Found $($orphans.Count) orphan pages (0 inbound links):" -ForegroundColor Magenta
    foreach ($o in $orphans) {
        Write-Host "    - $o" -ForegroundColor Magenta
    }
}

Write-Host "`n==============================" -ForegroundColor Cyan
if ($brokenLinks.Count -eq 0 -and $frontmatterErrors.Count -eq 0) {
    Write-Host " Audit Complete: Status HEALTHY" -ForegroundColor Green
} else {
    Write-Host " Audit Complete: Status WARNING" -ForegroundColor Red
}
Write-Host "==============================`n" -ForegroundColor Cyan
