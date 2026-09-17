param([switch]$Elevated)

$ErrorActionPreference = 'Stop'

# Symlinks need elevation unless Developer Mode is on. Bypass execution policy on the relaunch, since the script may be started from a host that blocks unsigned files.
$identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Start-Process powershell.exe -Verb RunAs -ArgumentList '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"", '-Elevated'
	exit
}

$sourceDir = (Resolve-Path "$PSScriptRoot\..\symlinks").Path
$targetDir = Join-Path $env:USERPROFILE '.claude'

Write-Host "Installing symlinks from $sourceDir to $targetDir"
Write-Host ''

foreach ($item in Get-ChildItem -LiteralPath $sourceDir -Force) {
	$linkPath = Join-Path $targetDir $item.Name
	$existing = Get-Item -LiteralPath $linkPath -Force -ErrorAction Ignore

	# Remove-Item -Recurse follows a directory symlink and wipes what it points at, so drop reparse points through the entry itself.
	if ($existing -and ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { $existing.Delete() }
	elseif ($existing) { Remove-Item -LiteralPath $linkPath -Recurse -Force }

	New-Item -ItemType SymbolicLink -Path $linkPath -Target $item.FullName | Out-Null
	Write-Host "  $($item.Name) -> $($item.FullName)"
}

Write-Host ''
Write-Host 'Done.'

if ($Elevated) { Read-Host 'Press Enter to close' | Out-Null }
