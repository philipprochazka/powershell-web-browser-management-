Set-Variable -Name "ChocolateyInstall" -Value (Read-Host -Prompt "Install location")
New-Item $ChocolateyInstall -Type Directory -Force
[Environment]::SetEnvironmentVariable("ChocolateyInstall", $ChocolateyInstall, "User")
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))