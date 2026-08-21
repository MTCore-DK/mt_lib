# mt_lib

**mt_lib** is a modern, framework-agnostic FiveM library focused on simplicity, performance, and a clean dark UI inspired by modern FiveM libraries.

---

## ✨ Features

* 🌐 **Framework Support**

  * ESX
  * QBCore
  * vRP
  * Standalone

* 🔔 **Notification System**

  * Success
  * Error
  * Warning
  * Info
  * Custom icons
  * Animated progress indicator

* ⏳ **Progress System**

  * Animated progress circle
  * Custom labels
  * Custom icons
  * Custom colors
  * Cancel support

* 📋 **Input Dialog**

  * Text inputs
  * Number inputs
  * Multiple fields
  * Submit / Cancel

* 📑 **Menu System**

  * Register menus
  * Dynamic options
  * Selection callbacks
  * Close callbacks

* 🎯 **Callback System**

  * Client → Server
  * Server → Client
  * Promise-based callbacks
  * `Citizen.Await`

* 🔐 **Permissions**

  * ACE permissions
  * vRP groups

* 📦 **Inventory Bridge**

* 👤 **Player Utilities**

* 📍 **Zones**

* 🎯 **Target System**

* 💾 **State Management**

* 🔄 **GitHub Version Checking**

* 🛠️ **txAdmin Integration**

* 📢 **Discord Update Notifications**

---

# 📦 Installation

Download or clone the repository into your FiveM resources folder.

```text
resources/
└── mt_lib/
```

Add the following to your `server.cfg`:

```cfg
ensure mt_lib
```

Make sure `mt_lib` starts **before any resources that depend on it**.

Example:

```cfg
ensure mt_lib

ensure my_resource
ensure another_resource
```

---

# ⚙️ Configuration

The main configuration is located in:

```text
mt_lib/
└── config.lua
```

Example:

```lua
mt = {}

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
    },

    github = {
        version = 'https://raw.githubusercontent.com/MTCore-DK/mt_lib/main/version.txt',
        repo = 'https://github.com/MTCore-DK/mt_lib'
    }
}
```

---

# 🔔 Notifications

The notification system uses a simple table-based API.

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

You can also use custom icons:

```lua
mt.lib.notify({
    title = 'Vehicle',
    description = 'Vehicle locked.',
    type = 'info',
    icon = '🔒',
    duration = 4000
})
```

### Export

Other resources can use:

```lua
exports.mt_lib:notify({
    title = 'Success',
    description = 'Action completed.',
    type = 'success'
})
```

---

# ⏳ Progress

The progress system displays an animated circular progress indicator.

```lua
local completed = mt.lib.progress({
    label = 'Processing...',
    duration = 5000,
    icon = '⏳',
    color = 'primary'
})

if completed then
    print('Progress completed')
end
```

Supported colors:

```text
primary
success
error
warning
info
```

### Example

```lua
mt.lib.progress({
    label = 'Repairing vehicle...',
    duration = 10000,
    icon = '🔧',
    color = 'success'
})
```

### Cancel Progress

```lua
mt.lib.cancelProgress()
```

Export:

```lua
exports.mt_lib:progress({
    label = 'Loading...',
    duration = 5000
})
```

---

# 📋 Input Dialog

Create an input dialog with multiple fields:

```lua
local result = mt.lib.inputDialog(
    'Character Information',
    {
        {
            type = 'input',
            label = 'First Name',
            name = 'firstname',
            required = true
        },

        {
            type = 'input',
            label = 'Last Name',
            name = 'lastname',
            required = true
        },

        {
            type = 'number',
            label = 'Age',
            name = 'age',
            required = true
        }
    }
)
```

Check if the dialog was cancelled:

```lua
if not result then
    print('Input cancelled')
    return
end

print(json.encode(result))
```

Export:

```lua
local result = exports.mt_lib:inputDialog(
    'Character Information',
    fields
)
```

---

# 📑 Menu System

Register a menu:

```lua
mt.lib.registerMenu('player_menu', {
    title = 'Player Menu',

    options = {
        {
            id = 'identity',
            label = 'Identity',
            description = 'View your identity',
            icon = '👤',
            value = 'identity'
        },

        {
            id = 'settings',
            label = 'Settings',
            description = 'Open settings',
            icon = '⚙️',
            value = 'settings'
        }
    },

    onSelect = function(value, data)

        if value == 'identity' then
            print('Identity selected')

        elseif value == 'settings' then
            print('Settings selected')
        end

    end,

    onClose = function()
        print('Menu closed')
    end
})
```

Open the menu:

```lua
mt.lib.showMenu('player_menu')
```

Close the menu:

```lua
mt.lib.hideMenu()
```

Unregister a menu:

```lua
mt.lib.unregisterMenu('player_menu')
```

---

# 🔄 Callback System

`mt_lib` includes a promise-based client/server callback system.

## Server

Register a callback:

```lua
mt.lib.registerCallback(
    'getPlayerData',
    function(source)

        return {
            id = source,
            name = GetPlayerName(source)
        }

    end
)
```

## Client

Call the server:

```lua
local data = mt.lib.callback(
    'getPlayerData'
)

if data then
    print(data.name)
end
```

Callbacks can also receive arguments.

### Server

```lua
mt.lib.registerCallback(
    'getPlayerMoney',
    function(source, account)

        if account == 'cash' then
            return 500
        end

        if account == 'bank' then
            return 2500
        end

        return 0
    end
)
```

### Client

```lua
local money = mt.lib.callback(
    'getPlayerMoney',
    'cash'
)

print(money)
```

---

# 🎨 NUI

The NUI is built using:

```text
HTML
CSS
JavaScript
```

The UI currently supports:

* Notifications
* Progress circle
* Menus
* Input dialogs
* Radial menus

The interface uses a modern dark design with compact components, subtle borders, smooth animations, and configurable theme colors.

---

# 🧩 Exports

Common exports include:

```lua
exports.mt_lib:notify(...)
```

```lua
exports.mt_lib:progress(...)
```

```lua
exports.mt_lib:cancelProgress()
```

```lua
exports.mt_lib:inputDialog(...)
```

```lua
exports.mt_lib:registerMenu(...)
```

```lua
exports.mt_lib:showMenu(...)
```

```lua
exports.mt_lib:hideMenu()
```

```lua
exports.mt_lib:unregisterMenu(...)
```

```lua
exports.mt_lib:callback(...)
```

```lua
exports.mt_lib:registerCallback(...)
```

---

# 🌐 Framework Support

| Framework  | Support |
| ---------- | ------- |
| ESX        | ✅       |
| QBCore     | ✅       |
| vRP        | ✅       |
| Standalone | ✅       |

Framework detection is handled automatically where supported.

---

# 📁 Project Structure

```text
mt_lib/
│
├── mt_lib/
│   │
│   ├── modules/
│   │   ├── callbacks/
│   │   │   ├── client.lua
│   │   │   └── server.lua
│   │   │
│   │   └── ui/
│   │       ├── notify.lua
│   │       ├── progress.lua
│   │       ├── input.lua
│   │       └── menu.lua
│   │
│   └── init.lua
│
├── web/
│   ├── index.html
│   ├── style.css
│   └── script.js
│
├── config.lua
├── fxmanifest.lua
└── README.md
```

---

# 🚀 Performance

mt_lib is designed with performance in mind.

The library aims to:

* Minimize unnecessary loops
* Avoid unnecessary NUI updates
* Keep client-side operations lightweight
* Use event-driven communication
* Clean up callbacks and UI elements after use

---

# 🔄 Version Checking

mt_lib includes GitHub-based version checking.

Configuration:

```lua
github = {
    version = 'https://raw.githubusercontent.com/MTCore-DK/mt_lib/main/version.txt',
    repo = 'https://github.com/MTCore-DK/mt_lib'
}
```

This allows the library to check whether the installed version is outdated.

---

# 🛠️ Development

When developing resources using mt_lib, make sure the library is started first:

```cfg
ensure mt_lib
```

Then start your resource:

```cfg
ensure my_resource
```

Example:

```lua
local data = mt.lib.callback('getPlayerData')

if data then
    mt.lib.notify({
        title = 'Player',
        description = data.name,
        type = 'info'
    })
end
```

---

# 📜 License

See the repository license for usage and redistribution terms.

---

# 📌 Links

**GitHub Repository:**
https://github.com/MTCore-DK/mt_lib

**Current Version:**
See `version.txt` in the repository.

---

# ❤️ Credits

Developed by **MTCore-DK**.

Built for the FiveM community with a focus on clean APIs, performance, and a modern user interface.
