---@meta

-- =========================================================
-- MT LIB
-- =========================================================

---@class MTLib
mt.lib = {}


-- =========================================================
-- NOTIFICATIONS
-- =========================================================

---@alias NotifyType
---| 'success'
---| 'error'
---| 'info'
---| 'warning'

---@class NotifyData
---@field title? string
---@field description? string
---@field type? NotifyType
---@field duration? number
---@field icon? string
---@field position? string


-- =========================================================
-- PROGRESS
-- =========================================================

---@class ProgressData
---@field label? string
---@field duration? number
---@field position? string
---@field canCancel? boolean
---@field disable? table
---@field anim? table
---@field prop? table


-- =========================================================
-- INPUT
-- =========================================================

---@alias InputType
---| 'input'
---| 'number'
---| 'password'
---| 'textarea'
---| 'select'
---| 'checkbox'

---@class InputField
---@field type InputType
---@field label string
---@field description? string
---@field placeholder? string
---@field required? boolean
---@field default? any
---@field options? table

---@class InputDialogResult
---@field [number] any


-- =========================================================
-- MENU
-- =========================================================

---@class MenuItem
---@field label string
---@field description? string
---@field icon? string
---@field value? any
---@field disabled? boolean
---@field onSelect? fun(value: any)

---@class MenuData
---@field title? string
---@field description? string
---@field items MenuItem[]
---@field onSelect? fun(value: any)


-- =========================================================
-- ZONES
-- =========================================================

---@class ZoneData
---@field coords vector3
---@field radius number
---@field onEnter? fun(zone: ZoneData)
---@field onExit? fun(zone: ZoneData)
---@field onTick? fun(zone: ZoneData, distance: number)
---@field inside? boolean


-- =========================================================
-- TARGET
-- =========================================================

---@class TargetData
---@field label? string
---@field distance? number
---@field groups? table
---@field canInteract? fun(entity: number): boolean
---@field onSelect fun(entity: number)


-- =========================================================
-- PLAYER
-- =========================================================

---@class PlayerData
---@field id number
---@field name string
---@field identifiers string[]


-- =========================================================
-- FRAMEWORK
-- =========================================================

---@alias FrameworkName
---| 'esx'
---| 'qb'
---| 'vrp'
---| 'standalone'


-- =========================================================
-- CALLBACK
-- =========================================================

---@alias CallbackFunction fun(source: number, ...: any): any


-- =========================================================
-- INVENTORY
-- =========================================================

---@class ItemData
---@field name string
---@field label? string
---@field count? number
---@field amount? number
---@field metadata? table
