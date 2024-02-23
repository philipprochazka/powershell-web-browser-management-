# PowerShell: Export-StartLayout to xml

reference: https://learn.microsoft.com/en-us/powershell/module/startlayout/export-startlayout?view=windowsserver2022-ps

`powershell`
Export-StartLayout -Path C:\backup\Windows\StartLayout.xml
    [-Path] <String>
      [-UseDesktopApplicationID]
      [-WhatIf]
      [-Confirm]
      [<CommonParameters>]
``
`powershell`
Export-StartLayout
      -LiteralPath <String>
      [-UseDesktopApplicationID]
      [-WhatIf]
      [-Confirm]
      [<CommonParameters>]
``
##flag options 
-Confirm
Prompts you for confirmation before running the cmdlet.

-LiteralPath
Specifies a literal path to a layout file. Include the file .xml file name extension. This parameter does not accept the wildcard character (*). If the path includes an escape character (\), enclose the string in single quotes (').

-Path
Specifies an absolute path to a layout file.

-UseDesktopApplicationID

Specifies that the layout file should export the DesktopApplicationID value instead of DesktopApplicationLinkPath which is the default. DesktopApplicationID is the application's ID and DesktopApplicationLinkPath is a path to a shortcut link (.lnk file) to a Windows desktop application.

-WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

