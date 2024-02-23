$apps =
@{
    create_desktop_shortcut  = $true
    create_taskbar_shortcut = $true
    default_launch_container = "window"  
    url                      = "https://twitter.com/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://twitch.tv/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://sledovani.tv/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://netflix.com/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://udemy.com/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://lichess.org/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://marketplace.visualstudio.com/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://www.powershellgallery.com/packages/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://www.github.com/"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://github.com/trending"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://github.com/philipprochazka"
},
@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://www.schemastore.org/json/"
},

@{
  create_desktop_shortcut  = $true
  create_taskbar_shortcut = $true
  default_launch_container = "window"  
  url                      = "https://start.roboform.com/#view=folder"  
},
@{
    create_desktop_shortcut  = $true
    default_launch_container = "window"  
    url                      = "https://web.telegram.org/"
},
@{
create_desktop_shortcut  = $true
default_launch_container = "window"  
url                      = "https://facebook.com/"
},
@{
  create_desktop_shortcut  = $true
  default_launch_container = "window"  
  url                      = "https://instagram.com/"
  },
  @{
    create_desktop_shortcut  = $true
    default_launch_container = "window"  
    url                      = "https://www.facebook.com/messages/t/"
    },
    @{
      create_desktop_shortcut  = $true
      default_launch_container = "window"  
      url                      = "https://www.seznam.cz/jizdnirady/"
      },
    @{
    create_desktop_shortcut  = $true
    default_launch_container = "window"  
    url                      = "https://www.youtube.com/"
}| ConvertTo-Json -Compress

$settings = 
[PSCustomObject]@{
    Path  = "SOFTWARE\Policies\BraveSoftware\Brave"
    Value = $apps
    Name  = "WebAppInstallForceList"
} | Group-Object Path

foreach($setting in $settings){
    $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($setting.Name, $true)
    if ($null -eq $registry) {
        $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($setting.Name, $true)
    }
    $setting.Group | ForEach-Object{
        $registry.SetValue($_.name, $_.value)
    }
    $registry.Dispose()
}