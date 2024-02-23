<#
.SYNOPSIS
This script does List all installed Packages on your local machine.

.DESCRIPTION
This script does List all installed Packages on your local machine at least all those with valid RegistryHive entries for LocalMachine & CurrentUser
after the Process finishes it will list:
"ComputerName ; Name ; SystemComponent ; ParentKeyName ; Version ; UninstallCommand ; InstallDate ; RegPath"
Import it to your powershell profile.ps1 for your System user.
"Common location" = "C:\Program Files\PowerShell\7\profile.ps1"
.PARAMETER Name
Parameter description
Value From Pipeline filtered by PropertyName 

.EXAMPLE
An example:
Get-InstalledSoftware 
Get-InstalledSoftware -Outfile C:\*\yourPath\here*
Get-InstalledSoftware | Get-Content .... | Tee-Object C:\*\yourPath\here*
Get-InstalledSoftware -Outfile C:\*\yourPath\here* | Get-Content \Your\Outfile\Path\*.md
Get-InstalledSoftware | fzf... | Tee-Object C:\*\yourPath\here*
Get-InstalledSoftware -Outfile C:\*\yourPath\here* | fzf...

.NOTES

Output
------------------------------------------------------------------------
Name             : XAMPP
Version          : 8.2.12-0
ComputerName     : {YourMachine}
InstallDate      : 20231129
UninstallCommand : "C:\xampp\uninstall.exe"
RegPath          : HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\xampp

Name             : Yarn
Version          : 1.22.19
ComputerName     : {YourMachine}
InstallDate      : 20220802
UninstallCommand : MsiExec.exe /X{C719DC4C-8FB0-4BB1-B622-A165776D8AF8}
RegPath          : HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{C719DC4C-8FB0-4BB1-B622-A165776D8AF8}

And so it follows......

you should get your own idea at tis point. feel free to rewrite to fit your needs, or pass no args to List all.
#>
Function Get-InstalledSoftware {
  Param(
      [Alias('Computer', 'ComputerName', 'HostName')]
      [Parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $true, Mandatory = $false, Position = 1)]
      [string[]]$Name = $env:COMPUTERNAME
  )
  Begin {
      $lmKeys = 'Software\Microsoft\Windows\CurrentVersion\Uninstall', 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
      $lmReg = [Microsoft.Win32.RegistryHive]::LocalMachine
      $cuKeys = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'
      $cuReg = [Microsoft.Win32.RegistryHive]::CurrentUser
  }
  Process {
      if (!(Test-Connection -ComputerName $Name -Count 1 -Quiet)) {
          Write-Error -Message "Unable to contact $Name. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
          Break
      }
      $masterKeys = @()
      $remoteCURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($cuReg, $Name)
      $remoteLMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($lmReg, $Name)
      foreach ($key in $lmKeys) {
          $regKey = $remoteLMRegKey.OpenSubkey($key)
          foreach ($subName in $regKey.GetSubkeyNames()) {
              foreach ($sub in $regKey.OpenSubkey($subName)) {
                  $masterKeys += (New-Object PSObject -Property @{
                          'ComputerName'     = $Name
                          'Name'             = $sub.GetValue('displayname')
                          'SystemComponent'  = $sub.GetValue('systemcomponent')
                          'ParentKeyName'    = $sub.GetValue('parentkeyname')
                          'Version'          = $sub.GetValue('DisplayVersion')
                          'UninstallCommand' = $sub.GetValue('UninstallString')
                          'InstallDate'      = $sub.GetValue('InstallDate')
                          'RegPath'          = $sub.ToString()
                      })
              }
          }
      }
      foreach ($key in $cuKeys) {
          $regKey = $remoteCURegKey.OpenSubkey($key)
          if ($regKey -ne $null) {
              foreach ($subName in $regKey.getsubkeynames()) {
                  foreach ($sub in $regKey.opensubkey($subName)) {
                      $masterKeys += (New-Object PSObject -Property @{
                              'ComputerName'     = $Computer
                              'Name'             = $sub.GetValue('displayname')
                              'SystemComponent'  = $sub.GetValue('systemcomponent')
                              'ParentKeyName'    = $sub.GetValue('parentkeyname')
                              'Version'          = $sub.GetValue('DisplayVersion')
                              'UninstallCommand' = $sub.GetValue('UninstallString')
                              'InstallDate'      = $sub.GetValue('InstallDate')
                              'RegPath'          = $sub.ToString()
                          })
                  }
              }
          }
      }
      $woFilter = { $null -ne $_.name -AND $_.SystemComponent -ne '1' -AND $null -eq $_.ParentKeyName }
      $props = 'Name', 'Version', 'ComputerName', 'Installdate', 'UninstallCommand', 'RegPath'
      $masterKeys = ($masterKeys | Where-Object $woFilter | Select-Object $props | Sort-Object Name)
      $masterKeys
  }
  End {}
}