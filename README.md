# ✦ mt_lib

**A clean, framework-aware utility library for FiveM.**  
Small Lua APIs, useful client/server helpers, and a polished NUI — with notifications built to feel like part of your server, not an afterthought.

![FiveM](https://img.shields.io/badge/FiveM-resource-5865F2?style=flat-square)
![Lua 5.4](https://img.shields.io/badge/Lua-5.4-2C2D72?style=flat-square)
![Version](https://img.shields.io/badge/version-2.0.0-22C55E?style=flat-square)

---

## ⚡ What’s inside

| Module | What it does |
| --- | --- |
| **Notifications** | Four notification types, custom icons, six screen positions, hover-to-pause timers, and a configurable visible limit |
| **Progress UI** | Animated progress ring with label, icon, duration, and status color |
| **Input dialogs** | NUI form dialogs with submit and cancel results |
| **Menus** | Register, show, and remove menus with selection and close callbacks |
| **Callbacks** | Promise-based client-to-server requests and server callback registration |
| **Framework bridge** | Detects ESX, QBCore, vRP, or standalone |
| **Player helpers** | Common client and server player/entity information |
| **Inventory bridge** | Item operations for ESX and QBCore |
| **Zones & targets** | Lightweight client-side proximity zones and entity interactions |
| **State & locale** | Global state helpers and 15 bundled locales |
| **Permissions** | ACE permission checks |

> **Compatibility note:** framework detection includes ESX, QBCore, and vRP. Inventory operations are currently implemented for ESX and QBCore; standalone and vRP inventory operations return without performing an inventory change. Permission helpers use FiveM ACE.

---

## 🚀 Install

1. Put the resource folder in your server’s `resources` directory.
2. Start it before resources that use it:

```cfg
ensure mt_lib
ensure my_resource
```

3. Configure the resource in [`mt_lib/config.lua`](./mt_lib/config.lua).

The public resource name must be `mt_lib` when you call it through `exports.mt_lib`.

---

## 🔔 Notifications

Call the notification API from a **client** script:

```lua
mt.lib.notify({
    title = 'Vehicle secured',
    description = 'Your vehicle is now locked.',
    type = 'success',
    duration = 4500,
    icon = '🔒',
    position = 'top-right'
})
```

Supported `type` values: `success`, `error`, `warning`, `info`. Unknown types fall back to `info`. The icon is optional; the UI selects a type-specific icon if none is supplied.

Notifications can be placed at `top-right`, `top-left`, `top-center`, `bottom-right`, `bottom-left`, or `bottom-center`. They can be dismissed with the close button, and hovering pauses the timeout.

Run `/mt_lib` in-game to open the position settings. Select one of the six screen locations; the choice is saved for that player and used for notifications unless a specific notification passes its own `position`. Use **Send test notification** to preview the toast at the selected location.

### Use from another resource

```lua
exports.mt_lib:notify({
    title = 'Payment received',
    description = '$250 was added to your account.',
    type = 'success'
})
```

### Notification defaults

Set defaults in `mt_lib/config.lua`; per-notification `duration` and `position` override the configured defaults.

```lua
mt.config.notifications = {
    duration = 5000,
    maxVisible = 4,
    position = 'top-right'
}
```

`maxVisible` limits how many notifications remain on screen. When the limit is reached, the oldest one is removed.

---

## 🧭 UI APIs

### Progress

```lua
local completed = mt.lib.progress({
    label = 'Repairing vehicle…',
    duration = 5000,
    icon = '🔧',
    color = 'success'
})

if completed then
    print('Progress finished')
end
```

Progress colors: `primary`, `success`, `error`, `warning`, `info`. `mt.lib.cancelProgress()` hides the current indicator.

### Input dialog

```lua
local result = mt.lib.inputDialog('Character details', {
    { type = 'input', label = 'First name', required = true },
    { type = 'input', label = 'Last name', required = true },
    { type = 'number', label = 'Age', required = true }
})

if result then
    print(json.encode(result))
end
```

The result is `nil` if the dialog is cancelled.

### Menus

Menus use an `items` array (not `options`):

```lua
mt.lib.registerMenu('player-actions', {
    title = 'Player actions',
    items = {
        {
            label = 'Check ID',
            description = 'Show your player ID',
            icon = '🪪',
            value = 'check-id'
        },
        {
            label = 'Open settings',
            value = 'settings'
        }
    },
    onSelect = function(value, item)
        print(('Selected: %s'):format(value))
    end,
    onClose = function()
        print('Menu closed')
    end
})

mt.lib.showMenu('player-actions')
```

Use `mt.lib.hideMenu()` to close the active menu and `mt.lib.unregisterMenu(id)` to remove a registered menu.

---

## 🔁 Client ↔ server callbacks

Register callbacks on the **server**. The first argument is the requesting player’s source:

```lua
mt.lib.registerCallback('getPlayerName', function(source)
    return GetPlayerName(source)
end)
```

Call it from the **client**; arguments after the callback name are passed to the server handler:

```lua
local playerName = mt.lib.callback('getPlayerName')
```

---

## 🧰 Other helpers

All helpers are available through `mt.lib` in their respective client or server context and as resource exports.

| Area | Available helpers |
| --- | --- |
| Framework | `getFramework`, `getFrameworkCore`, `isFramework`, `isFrameworkReady` |
| Client player | `getPed`, `getPlayerId`, `getServerId`, `getPlayerName`, `getCoords`, `getHeading`, `getVehicle`, `isInVehicle`, `getHealth`, `getArmour`, `getCurrentWeapon` |
| Server player | `getPlayer`, `getPlayerName`, `getIdentifiers`, `getIdentifier`, `isPlayerOnline`, `getPlayers` |
| Inventory | `addItem`, `removeItem`, `getItem`, `getItemCount`, `hasItem` |
| Zones | `addZone`, `removeZone`, `getZone`, `getZones`, `isInsideZone` |
| Targets | `addTarget`, `removeTarget`, `getTarget`, `getTargets` |
| State | `setState`, `getState`, `hasState`, `removeState`, `getAllState` |
| Permissions | `hasPermission`, `hasAnyPermission`, `hasAllPermissions` |
| Locale | `t`, `hasLocale`, `getLocale`, `getLocales` |

For exact arguments, return values, and the client/server context of a helper, see its source under [`mt_lib/modules/`](./mt_lib/modules/).

---

## 🎨 UI & languages

The NUI uses plain HTML, CSS, and JavaScript and does not require a separate build step. Customize its visual styles in [`mt_lib/web/style.css`](./mt_lib/web/style.css).

Choose a bundled locale with `mt.config.locale`. Available locales: `cs`, `da`, `de`, `en`, `es`, `fi`, `fr`, `it`, `nl`, `no`, `pl`, `pt`, `ru`, `sv`, `tr`.

---

## 📁 Repository layout

```text
README.md
mt_lib/
├── config.lua
├── fxmanifest.lua
├── init.lua
├── types.lua
├── locales/
├── modules/
└── web/
    ├── index.html
    ├── script.js
    └── style.css
```

---

## 📄 License

See the repository’s license file for usage and redistribution terms.

## 💜 Credits

Made by **MT Core** for the FiveM community.
