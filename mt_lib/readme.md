# 📄 CHANGELOG – mt_lib

# [1.9.2] – 2026-08-21


## ✨ Added

* New **mt_lib-inspired UI design**
* Completely redesigned **notification/toast system**

  * Success notifications
  * Error notifications
  * Warning notifications
  * Info notifications
  * Animated progress indicator
  * Smooth fade-in/out animations
  * Custom icons
* New **progress circle**

  * Animated SVG progress ring
  * Custom labels
  * Custom icons
  * Configurable duration
  * Primary, success, error, warning and info colors
* New **radial menu UI**

  * Dynamic menu items
  * Icons and labels
  * Animated opening
  * Item selection callbacks
  * Escape key support
* New **UI theme configuration**

  * Primary color
  * Success color
  * Error color
  * Warning color
  * Info color
  * Background colors
  * Border colors
  * Text colors
  * Border radius
  * Shadows
* Improved **NUI message handling**
* Added centralized UI configuration
* Improved HTML/CSS/JavaScript structure

## 🎨 UI Improvements

* Smaller and cleaner UI components
* Improved spacing and typography
* Subtle borders and shadows
* Better visual hierarchy
* Improved animations
* Transparent FiveM-friendly background
* Better scaling for different resolutions

## 🛠 Fixed / Improved

* Optimized NUI rendering
* Reduced unnecessary DOM updates
* Improved progress circle animation
* Improved toast cleanup
* Added HTML escaping for dynamic UI content
* Improved radial menu positioning
* Improved UI state handling
* Improved startup initialization
* Improved configuration structure
* Improved compatibility with FiveM NUI

## ⚙️ Configuration

The UI theme can now be configured directly from `config.lua`:

```lua
mt.config = {
    txAdminClean = true,

    theme = {
        primary = '#6366f1',

        success = '#22c55e',
        error = '#ef4444',
        warning = '#f59e0b',
        info = '#3b82f6',

        background = '#141414',
        backgroundLight = '#1e1e1e',

        border = 'rgba(255, 255, 255, 0.08)',
        borderLight = 'rgba(255, 255, 255, 0.12)',

        text = '#f5f5f5',
        textMuted = '#a3a3a3',

        radius = '5px',
        shadow = '0 8px 30px rgba(0, 0, 0, 0.45)'
    }
}
```

## 📦 Framework Support

mt_lib continues to support:

* **ESX**
* **QBCore**
* **vRP**
* **Standalone**

Framework detection remains automatic.

## 🔔 Notifications

Example:

```lua
mt.lib.notify({
    title = 'Success',
    description = 'Item given successfully.',
    type = 'success',
    duration = 5000
})
```

Supported notification types:

```text
success
error
warning
info
```

## ⏳ Progress Circle

Example:

```lua
SendNUIMessage({
    action = 'progressCircle',
    label = 'Processing...',
    duration = 5000,
    icon = '⏳',
    color = 'primary'
})
```

Supported colors:

```text
primary
success
error
warning
info
```

## 🎯 Radial Menu

The new radial menu supports dynamic items:

```lua
SendNUIMessage({
    action = 'radialMenu',

    items = {
        {
            id = 'player',
            label = 'Player',
            icon = '👤'
        },

        {
            id = 'vehicle',
            label = 'Vehicle',
            icon = '🚗'
        },

        {
            id = 'settings',
            label = 'Settings',
            icon = '⚙️'
        }
    }
})
```

## 🌐 GitHub Version Check

GitHub version checking remains integrated:

```lua
github = {
    version = 'https://raw.githubusercontent.com/MTCore-DK/mt_lib/main/version.txt',
    repo = 'https://github.com/MTCore-DK/mt_lib'
}
```

The system can be used to detect outdated versions and provide update information.

## 📋 Installation

1. Download `mt_lib`.
2. Place it inside your FiveM `resources` folder.
3. Add the following to `server.cfg`:

```cfg
ensure mt_lib
```

4. Make sure `mt_lib` starts **before resources that depend on it**.
5. Configure `config.lua` if required.

## 🚀 Previous Release

# [1.0.0] – 2026-01-15

**Initial release**

### Added

* Full support for **ESX, QBCore, vRP and standalone frameworks**
* UI notification system
* Zones system
* Target system
* Inventory management
* Player utilities
* Server ↔ client callbacks
* ACE and vRP permissions
* Global and player state management
* Menu, input and progress UI
* GitHub version checking
* txAdmin warning system
* Discord webhook support
* Full NUI web interface

### Fixed / Improved

* Optimized loops
* Framework auto-detection
* Standardized NUI messages
* Improved HTTP/version checking
* Smooth UI animations
* Export functions for core library features
