# ========================================================
# measure.ps1 — Yosys synthesis sweep for adders (PowerShell)
# Author: Daniel Grib
# ========================================================
# This script synthesizes RCA, CLA, and Prefix adders at
# multiple bit-widths, logs synthesis statistics, and
# generates a summary CSV of area and timing.
# ========================================================

Set-Location $PSScriptRoot
$resultsDir = Join-Path $PSScriptRoot "..\results"
New-Item -ItemType Directory -Force -Path $resultsDir | Out-Null

$widths = @(8, 16, 32, 64)
$adders = @("rca", "cla", "prefix")

$outCsv = Join-Path $resultsDir "results.csv"
"Adder,Width,NumCells,Delay_ns,Est_Fmax_MHz" | Out-File $outCsv -Encoding ASCII

foreach ($adder in $adders) {
    foreach ($width in $widths) {
        Write-Host "====================================="
        Write-Host "Synthesizing $adder (WIDTH=$width)"
        Write-Host "====================================="

        $logFile = Join-Path $resultsDir "$adder`_$width.log"

        # --- Run Yosys ---
        & "yosys.exe" -qp "
            read_verilog -sv ../adder_rtl/${adder}.sv
            chparam -set WIDTH $width ${adder}
            synth -top ${adder}
            stat
        " *> $logFile

        # --- Parse results ---
        $cells = Select-String -Path $logFile -Pattern 'Number of cells' | ForEach-Object {
            ($_ -split '\s+')[-1]
        }

        if (-not $cells) { $cells = "0" }

        $delay = Select-String -Path $logFile -Pattern 'Delay' | Select-Object -First 1 | ForEach-Object {
            ($_ -split '\s+')[-1]
        }

        if (-not $delay) { $delay = "N/A" }

        if ($delay -ne "N/A") {
            $fmax = [math]::Round(1000 / [double]$delay, 1)
        } else {
            $fmax = "N/A"
        }

        "$adder,$width,$cells,$delay,$fmax" | Out-File $outCsv -Append -Encoding ASCII

        Write-Host "  → Logged to $logFile"
        Write-Host ""
    }
}

Write-Host "✅ All synthesis runs complete."
Write-Host "Results saved to: $outCsv"
