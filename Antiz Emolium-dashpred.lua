local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo.."Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = true

local Window = Library:CreateWindow({
    Title = "Antiz Emolium",
    Footer = "Version 0.9.3",
    Icon = 100032358358540,
    ShowCustomCursor = true,
})

local Tabs = {
    Main      = Window:AddTab("Main",        "sword"),
    Misc      = Window:AddTab("Misc",        "box"),
    Visuals   = Window:AddTab("Visuals",     "eye"),
    Trusting  = Window:AddTab("Trusting",    "shield"),
    Bars      = Window:AddTab("Bars",        "activity"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings")
}

local SilentBox   = Tabs.Main:AddLeftGroupbox("Silent Aim")
local PredBox     = Tabs.Main:AddRightGroupbox("Prediction")
local MiscBox     = Tabs.Misc:AddLeftGroupbox("No Collision")
local VelocityBox = Tabs.Misc:AddRightGroupbox("Velocity")
local VisualBox   = Tabs.Visuals:AddLeftGroupbox("Effects")
local TrustBox    = Tabs.Trusting:AddLeftGroupbox("Part Trust")

-- ── Silent Aim ────────────────────────────────────────────────────────────────
SilentBox:AddToggle("AimLock", {Text = "Aim Lock", Default = false})
SilentBox:AddLabel("Aim Lock Key"):AddKeyPicker("AimLockKey", {
    Default = "V", Mode = "Toggle", SyncToggleState = false, Text = "Aim Lock"
})
SilentBox:AddDropdown("TargetPart", {
    Values = {"HumanoidRootPart","Torso","Head","Right Arm","Left Arm","Right Leg","Left Leg"},
    Default = 1, Text = "Target Part"
})
SilentBox:AddDropdown("AimMode", {
    Values = {"Snap", "Lerp", "Hybrid", "Instant", "Aggressive"},
    Default = 1, Text = "Aim Mode"
})
SilentBox:AddSlider("AimAlpha", {
    Text = "Smooth Alpha", Default = 65, Min = 1, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("LerpMultiplier", {
    Text = "Lerp Multiplier", Default = 1.0, Min = 0.10, Max = 1, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. "x" end
})
SilentBox:AddSlider("AimSpeed", {
    Text = "Aim Speed", Default = 100, Min = 10, Max = 200, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("AggressiveMultiplier", {
    Text = "Aggressive Multiplier", Default = 1, Min = 1, Max = 5, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "x" end
})
SilentBox:AddSlider("SnapThreshold", {
    Text = "Snap Angle Threshold", Default = 15, Min = 1, Max = 360, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "°" end
})
SilentBox:AddSlider("SnapSpeedDelay", {
    Text = "Snap Speed Delay", Default = 0, Min = 0, Max = 2, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
SilentBox:AddSlider("HybridThreshold", {
    Text = "Hybrid Snap Threshold", Default = 40, Min = 5, Max = 150, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " st/s" end
})
SilentBox:AddDivider()
SilentBox:AddToggle("OffsetEnable", {Text = "Enable Offset", Default = false})
SilentBox:AddDropdown("OffsetSide", {
    Values = {"Left", "Right"}, Default = 1, Text = "Offset Side"
})
SilentBox:AddSlider("OffsetAmount", {
    Text = "Offset Amount", Default = 1, Min = 0, Max = 10, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. " st" end
})
SilentBox:AddDivider()
SilentBox:AddDropdown("LockEvents", {
    Values = {"Stepped", "Heartbeat", "RenderStepped", "BindToRenderStep"},
    Default = 2, Text = "Update Events", Multi = true,
})
SilentBox:AddDropdown("PriorityMode", {
    Values = {"Early", "Normal", "Late"},
    Default = 2, Text = "BindToRenderStep Priority",
})

-- ── Prediction ────────────────────────────────────────────────────────────────
PredBox:AddToggle("PredEnable", {Text = "Prediction", Default = false})
PredBox:AddToggle("AngularPredEnable", {Text = "Angular Prediction", Default = false})
PredBox:AddToggle("AccelPredEnable", {Text = "Acceleration Prediction", Default = false})
PredBox:AddSlider("PredStrength", {
    Text = "Prediction Strength", Default = 70, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AngularStrength", {
    Text = "Angular Strength", Default = 60, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AccelStrength", {
    Text = "Accel Strength", Default = 70, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("LeadSpeed", {
    Text = "Lead Speed", Default = 150, Min = 10, Max = 300, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
PredBox:AddDivider()
PredBox:AddToggle("AggrEnable", {Text = "Aggressive Prediction", Default = false})
PredBox:AddToggle("AggrAngularEnable", {Text = "Aggressive Angular Prediction", Default = false})
PredBox:AddToggle("AggrAccelEnable", {Text = "Aggressive Acceleration Prediction", Default = false})
PredBox:AddSlider("AggrStrength", {
    Text = "Aggr Strength", Default = 55, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AggrAngularStrength", {
    Text = "Aggr Angular Strength", Default = 55, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AggrAccelStrength", {
    Text = "Aggr Accel Strength", Default = 55, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AggrLeadSpeed", {
    Text = "Aggressive Lead Speed", Default = 150, Min = 10, Max = 300, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})

-- ── Dash-Aware Prediction ─────────────────────────────────────────────────────
PredBox:AddDivider()
PredBox:AddToggle("DashPredEnable", {Text = "Dash-Aware Prediction", Default = false})
PredBox:AddSlider("MovemePredStrength", {
    Text = "Moveme Pred Strength", Default = 55, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("DashDuration", {
    Text = "Dash Duration", Default = 30, Min = 10, Max = 60, Rounding = 0,
    FormatDisplayValue = function(_, v) return string.format("%.2fs", v / 100) end
})
PredBox:AddSlider("DashEndBlend", {
    Text = "Dash End Blend", Default = 75, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})

-- ── No Collision ──────────────────────────────────────────────────────────────
MiscBox:AddToggle("TargetNoColl", {Text = "No Collision", Default = false})
MiscBox:AddDropdown("ModeSelection", {
    Values = {"Aim Target","Aim Target and Distance","Aim Target and Distance and Limit","Distance","Distance and Limit"},
    Default = 3, Text = "Mode Selection"
})
MiscBox:AddSlider("MaxDistanceMe", {
    Text = "Distance From Me", Default = 200, Min = 0, Max = 301, Rounding = 0,
    FormatDisplayValue = function(_, v)
        if v == 0 then return "OFF" elseif v >= 300 then return "Unlimited" else return v.." studs" end
    end
})
MiscBox:AddSlider("MaxDistanceTarget", {
    Text = "Distance From Target", Default = 0, Min = 0, Max = 301, Rounding = 0,
    FormatDisplayValue = function(_, v)
        if v == 0 then return "OFF" elseif v >= 300 then return "Unlimited" else return v.." studs" end
    end
})
MiscBox:AddSlider("MaxPlayers", {
    Text = "Max Players", Default = 3, Min = 0, Max = 14, Rounding = 0,
    FormatDisplayValue = function(_, v) return v == 0 and "OFF" or tostring(v) end
})
MiscBox:AddDropdown("DistanceFrom", {
    Values = {"Me","Target"}, Default = {"Target"}, Text = "Distance From", Multi = true
})

-- ── Velocity ──────────────────────────────────────────────────────────────────
VelocityBox:AddToggle("VelocityModify", {Text = "Velocity Speed Modify", Default = false})
VelocityBox:AddDropdown("VelocityMode", {
    Values = {"Keybind", "Keybind Once", "Keybind Time", "Animation"},
    Default = 1, Text = "Velocity Mode"
})
VelocityBox:AddLabel("Velocity Modify"):AddKeyPicker("VelocityKey", {
    Default = "X", Mode = "Toggle", SyncToggleState = false, Text = "Velocity Modify"
})
VelocityBox:AddSlider("VelocityTime", {
    Text = "Modify Time", Default = 1, Min = 0, Max = 5, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
VelocityBox:AddSlider("VelocityValue", {
    Text = "Velocity Value", Default = 54, Min = 0, Max = 165, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
VelocityBox:AddDivider()
VelocityBox:AddDropdown("VelocityAnimations", {
    Values = {"Uppercut", "Lethal"},
    Default = {"Uppercut"}, Multi = true, Text = "Animation Filter"
})
VelocityBox:AddDropdown("VelocityAnimMode", {
    Values = {"Once", "Time"}, Default = 1, Text = "Animation Mode"
})
VelocityBox:AddSlider("VelocityAnimTime", {
    Text = "Modify Animation Time", Default = 1, Min = 0, Max = 5, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. " s" end
})

-- ── Visuals ───────────────────────────────────────────────────────────────────
VisualBox:AddToggle("WaterToggle", {Text = "Water Color", Default = false})
    :AddColorPicker("WaterColor", {Default = Color3.fromRGB(255, 255, 0)})
VisualBox:AddToggle("HighlightToggle", {Text = "Highlight", Default = false})
    :AddColorPicker("HighlightColor", {Default = Color3.fromRGB(255, 0, 0)})

-- ── Trusting ──────────────────────────────────────────────────────────────────
TrustBox:AddSlider("TrustHead", {
    Text = "Head", Default = 0.35, Min = 0, Max = 1, Rounding = 2,
})
TrustBox:AddSlider("TrustTorso", {
    Text = "Torso", Default = 0.65, Min = 0, Max = 1, Rounding = 2,
})
TrustBox:AddSlider("TrustRightArm", {
    Text = "Right Arm", Default = 0.30, Min = 0, Max = 1, Rounding = 2,
})
TrustBox:AddSlider("TrustLeftArm", {
    Text = "Left Arm", Default = 0.30, Min = 0, Max = 1, Rounding = 2,
})
TrustBox:AddSlider("TrustRightLeg", {
    Text = "Right Leg", Default = 0.30, Min = 0, Max = 1, Rounding = 2,
})
TrustBox:AddSlider("TrustLeftLeg", {
    Text = "Left Leg", Default = 0.30, Min = 0, Max = 1, Rounding = 2,
})

-- ── Bars (Cooldown Tracker) ───────────────────────────────────────────────────
local BarsUIBox    = Tabs.Bars:AddLeftGroupbox("Bar Settings")
local BarsColorBox = Tabs.Bars:AddRightGroupbox("Colors")

BarsUIBox:AddSlider("CdWidth",   {Text="Width",          Default=160, Min=60,  Max=280})
BarsUIBox:AddSlider("CdHeight",  {Text="Height",         Default=20,  Min=6,   Max=60})
BarsUIBox:AddSlider("CdSpacing", {Text="Bar Spacing",    Default=8,   Min=0,   Max=40})
BarsUIBox:AddSlider("CdCorner",  {Text="Corner Radius",  Default=6,   Min=0,   Max=20})
BarsUIBox:AddSlider("CdPosX",    {Text="Position X",     Default=0.5, Min=0,   Max=1, Rounding=2})
BarsUIBox:AddSlider("CdPosY",    {Text="Position Y",     Default=0.85,Min=0,   Max=1, Rounding=2})
BarsUIBox:AddDivider()
BarsUIBox:AddToggle("CdShowNumbers", {Text="Show Numbers", Default=true})
BarsUIBox:AddToggle("CdShowBars",    {Text="Show Bars",    Default=true})
BarsUIBox:AddDropdown("CdFillDir", {
    Values={"Left","Right"}, Default=1, Text="Fill Direction"
})
BarsUIBox:AddDropdown("CdLabelFormat", {
    Values={"Name  Time","Time  Name"}, Default=1, Text="Label Format"
})

BarsColorBox:AddLabel("Dash Fill")    :AddColorPicker("CdDashFill",   {Default=Color3.fromRGB(0,255,0)})
BarsColorBox:AddLabel("Dash Numbers") :AddColorPicker("CdDashNum",    {Default=Color3.fromRGB(255,255,255)})
BarsColorBox:AddLabel("Dash BG")      :AddColorPicker("CdDashBG",     {Default=Color3.fromRGB(0,0,0)})
BarsColorBox:AddDivider()
BarsColorBox:AddLabel("Side Fill")    :AddColorPicker("CdSideFill",   {Default=Color3.fromRGB(255,200,0)})
BarsColorBox:AddLabel("Side Numbers") :AddColorPicker("CdSideNum",    {Default=Color3.fromRGB(255,255,255)})
BarsColorBox:AddLabel("Side BG")      :AddColorPicker("CdSideBG",     {Default=Color3.fromRGB(0,0,0)})
BarsColorBox:AddDivider()
BarsColorBox:AddLabel("Evasive Fill") :AddColorPicker("CdEvasiveFill",{Default=Color3.fromRGB(255,80,80)})
BarsColorBox:AddLabel("Evasive Nums") :AddColorPicker("CdEvasiveNum", {Default=Color3.fromRGB(255,255,255)})
BarsColorBox:AddLabel("Evasive BG")   :AddColorPicker("CdEvasiveBG",  {Default=Color3.fromRGB(0,0,0)})

-- ── UI Settings ───────────────────────────────────────────────────────────────
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor", Default = true,
    Callback = function(value) Library.ShowCustomCursor = value end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values = {"Left","Right"}, Default = "Right", Text = "Notification Side",
    Callback = function(value) Library:SetNotifySide(value) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values = {"25","50%","75%","100%","125%","150%","175%","200%","250"},
    Default = "100%", Text = "DPI Scale",
    Callback = function(value)
        value = value:gsub("%%","")
        Library:SetDPIScale(tonumber(value))
    end,
})
MenuGroup:AddSlider("UICornerSlider", {
    Text = "Corner Radius", Default = Library.CornerRadius, Min = 0, Max = 20, Rounding = 0,
    Callback = function(value) Window:SetCornerRadius(value) end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
MenuGroup:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind

-- ─────────────────────────────────────────────────────────────────────────────
-- Services & locals
-- ─────────────────────────────────────────────────────────────────────────────
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local Camera      = workspace.CurrentCamera
local UIS         = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- BindToRenderStep priority map (body aim only)
local PriorityMap = {
    Early  = Enum.RenderPriority.Character.Value - 1,
    Normal = Enum.RenderPriority.Character.Value,
    Late   = Enum.RenderPriority.Character.Value + 1,
}
local currentRenderBind = nil

local HumanoidRootPart = nil
local function refreshHRP()
    local char = LocalPlayer.Character
    if char then HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5) end
end
refreshHRP()

local lockedTarget      = nil
local silentActive      = false
local lockConnections   = {}
local activeConstraints = {}
local highlightObj      = nil
local waterConnections  = {}
local currentWaterColor = Options.WaterColor.Value
local lastVel           = Vector3.zero
local lastDir           = Vector3.zero
local lastPredTime      = tick()
local lastSnapTime      = 0

-- ── Dash (moveme) prediction state ───────────────────────────────────────────
local movemeActive    = false   -- true пока BodyVelocity "moveme" существует
local movemeEnd       = 0       -- tick() после которого затухает blend
local movemeBlend     = 1.0     -- 1 = normal pred, <1 = damped during dash
local dashLockedVel   = nil     -- зафиксированный velocity в начале dash
local dashLockedDir   = nil     -- зафиксированное direction (Unit)
local dashEndPos      = nil     -- предсказанная конечная позиция dash
local dashWatchConns  = {}      -- connections для watchMoveme

-- ─────────────────────────────────────────────────────────────────────────────
-- Velocity state
-- ─────────────────────────────────────────────────────────────────────────────
local velocityEnabled  = false
local velocityArmed    = false
local velocityExpire   = 0
local velocityAnimExp  = 0
local velocityAnimConn = nil

local ANIMATION_IDS = {
    Uppercut = "10503381238",
    Lethal   = "12296113986",
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────
local function isAlive(p)
    if not p.Character then return false end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getRoot(p)
    return p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

local function getTargetPart(p)
    if not p.Character then return nil end
    return p.Character:FindFirstChild(Options.TargetPart.Value)
end

local function getDistance(a, b)
    local r1, r2 = getRoot(a), getRoot(b)
    if not r1 or not r2 then return math.huge end
    return (r1.Position - r2.Position).Magnitude
end

local function getParts(model)
    local t = {}
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then table.insert(t, v) end
    end
    return t
end

local function isRagdolled(char)
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local rag1 = char and char:FindFirstChild("Ragdoll")
    local rag2 = char and char:FindFirstChild("RagdollSim")
    if (rag1 and rag1.Value) or (rag2 and rag2.Value) then return true end
    return hum and hum.PlatformStand
end

-- ─────────────────────────────────────────────────────────────────────────────
-- NoCollision
-- ─────────────────────────────────────────────────────────────────────────────
local function createNoclip(p)
    local char = LocalPlayer.Character
    if not p.Character or not char then return end
    if activeConstraints[p] then
        if activeConstraints[p].Character == p.Character then return end
        for _, c in pairs(activeConstraints[p].Constraints) do if c then c:Destroy() end end
    end
    local cons = {}
    for _, a in pairs(getParts(char)) do
        for _, b in pairs(getParts(p.Character)) do
            local n = Instance.new("NoCollisionConstraint")
            n.Part0 = a; n.Part1 = b; n.Parent = a
            table.insert(cons, n)
        end
    end
    activeConstraints[p] = {Constraints = cons, Character = p.Character}
end

local function removeNoclip(p)
    if not activeConstraints[p] then return end
    for _, c in pairs(activeConstraints[p].Constraints) do if c then c:Destroy() end end
    activeConstraints[p] = nil
end

local function clearAll()
    for p in pairs(activeConstraints) do removeNoclip(p) end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Dash (moveme) detection — следим за BodyVelocity цели
-- ─────────────────────────────────────────────────────────────────────────────
local function stopWatchMoveme()
    for _, c in ipairs(dashWatchConns) do c:Disconnect() end
    dashWatchConns = {}
end

local function watchMoveme(char)
    stopWatchMoveme()

    table.insert(dashWatchConns, char.DescendantAdded:Connect(function(v)
        if not (v:IsA("BodyVelocity") and v.Name == "moveme") then return end
        movemeActive = true

        -- Фиксируем velocity и direction в самом начале dash (ИДЕЯ №3)
        local spd = v.Velocity.Magnitude
        if spd > 0.1 then
            dashLockedVel = v.Velocity
            dashLockedDir = v.Velocity.Unit
        end

        -- Предсказываем конечную позицию: pos + vel * dashDuration (ИДЕЯ №1)
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and dashLockedVel then
            local dashDur = Options.DashDuration.Value / 100
            -- Учитываем затухание скорости к концу dash: ×0.75 (ИДЕЯ №5)
            dashEndPos = root.Position + dashLockedVel * dashDur * 0.75
        end
    end))

    table.insert(dashWatchConns, char.DescendantRemoving:Connect(function(v)
        if not (v:IsA("BodyVelocity") and v.Name == "moveme") then return end
        movemeActive = false
        movemeEnd    = tick() + 0.4   -- 400 мс хвост после dash
    end))
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Highlight
-- ─────────────────────────────────────────────────────────────────────────────
local function updateHighlight()
    if highlightObj then highlightObj:Destroy(); highlightObj = nil end
    if Toggles.HighlightToggle.Value and lockedTarget and lockedTarget.Character then
        highlightObj              = Instance.new("Highlight")
        highlightObj.FillColor    = Options.HighlightColor.Value
        highlightObj.OutlineColor = Options.HighlightColor.Value
        highlightObj.Adornee      = lockedTarget.Character
        highlightObj.Parent       = game.CoreGui
    end
end

Toggles.HighlightToggle:OnChanged(updateHighlight)
Options.HighlightColor:OnChanged(function()
    if highlightObj then
        highlightObj.FillColor    = Options.HighlightColor.Value
        highlightObj.OutlineColor = Options.HighlightColor.Value
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Blocked animations (aim)
-- ─────────────────────────────────────────────────────────────────────────────
local blockedAnimations = {
    ["rbxassetid://12296113986"] = true,
    ["rbxassetid://12309835105"] = true,
}

local function isBlockedAnimationPlaying()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return false end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        if anim then
            local id = anim.AnimationId:match("%d+")
            if id and blockedAnimations["rbxassetid://"..id] then return true end
        end
    end
    return false
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Velocity system
-- ─────────────────────────────────────────────────────────────────────────────
local function isVelocityAllowed()
    if not Toggles.VelocityModify.Value then return false end
    local mode = Options.VelocityMode.Value
    if mode == "Keybind"     then return velocityEnabled
    elseif mode == "Keybind Once" then return velocityArmed
    elseif mode == "Keybind Time" then return tick() < velocityExpire
    elseif mode == "Animation"   then return tick() < velocityAnimExp
    end
    return false
end

local function modifyBodyVelocity(v)
    if not v:IsA("BodyVelocity") then return end
    if v.Name ~= "moveme" then return end
    if not isVelocityAllowed() then return end

    v:SetAttribute("Speed", Options.VelocityValue.Value)

    local mode     = Options.VelocityMode.Value
    local animMode = Options.VelocityAnimMode.Value

    if mode == "Keybind Once" then
        velocityArmed = false
        local conn; conn = v.AncestryChanged:Connect(function()
            if not v.Parent then conn:Disconnect() end
        end)
    elseif mode == "Animation" and animMode == "Once" then
        local conn; conn = v.AncestryChanged:Connect(function()
            if not v.Parent then
                velocityAnimExp = 0
                conn:Disconnect()
            end
        end)
    end
end

local function isTargetAnimPlaying()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return false end
    local sel = Options.VelocityAnimations.Value
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        if anim then
            local id = anim.AnimationId:match("%d+")
            if id then
                for name, animId in pairs(ANIMATION_IDS) do
                    if sel[name] and id == animId then return true end
                end
            end
        end
    end
    return false
end

local function startAnimLoop()
    if velocityAnimConn then velocityAnimConn:Disconnect(); velocityAnimConn = nil end
    velocityAnimConn = RunService.Heartbeat:Connect(function()
        if not Toggles.VelocityModify.Value then return end
        if Options.VelocityMode.Value ~= "Animation" then return end
        local animMode = Options.VelocityAnimMode.Value
        if isTargetAnimPlaying() then
            if animMode == "Time" then
                velocityAnimExp = tick() + Options.VelocityAnimTime.Value
            elseif animMode == "Once" and velocityAnimExp == 0 then
                velocityAnimExp = tick() + 999
            end
        end
    end)
end

local function stopAnimLoop()
    if velocityAnimConn then velocityAnimConn:Disconnect(); velocityAnimConn = nil end
    velocityAnimExp = 0
end

Options.VelocityMode:OnChanged(function()
    if Options.VelocityMode.Value == "Animation" then
        startAnimLoop()
    else
        stopAnimLoop()
        velocityEnabled = false
        velocityArmed   = false
        velocityExpire  = 0
    end
end)

Options.VelocityKey:OnClick(function()
    if not Toggles.VelocityModify.Value then return end
    local mode = Options.VelocityMode.Value
    if mode == "Keybind"     then velocityEnabled = not velocityEnabled
    elseif mode == "Keybind Once" then velocityArmed = true
    elseif mode == "Keybind Time" then velocityExpire = tick() + Options.VelocityTime.Value
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- stopLock
-- ─────────────────────────────────────────────────────────────────────────────
local function stopLock()
    for _, conn in pairs(lockConnections) do
        if conn then conn:Disconnect() end
    end
    lockConnections = {}
    -- Unbind BindToRenderStep if active
    if currentRenderBind then
        RunService:UnbindFromRenderStep(currentRenderBind)
        currentRenderBind = nil
    end
    silentActive = false
    lockedTarget = nil
    lastVel      = Vector3.zero
    lastDir      = Vector3.zero
    lastPredTime = tick()
    lastSnapTime = 0
    if highlightObj then highlightObj:Destroy(); highlightObj = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
    -- Сбрасываем dash-state при разлоке
    stopWatchMoveme()
    movemeActive  = false
    movemeBlend   = 1.0
    dashLockedVel = nil
    dashLockedDir = nil
    dashEndPos    = nil
end

-- ── movemeBlend smooth update ─────────────────────────────────────────────────
-- Плавно снижает blend во время dash, возвращает к 1 после (ИДЕЯ смягчения)
RunService.Heartbeat:Connect(function(dt)
    if not Toggles.DashPredEnable or not Toggles.DashPredEnable.Value then
        movemeBlend = 1.0
        return
    end
    local target = 1.0
    local dampStr = Options.MovemePredStrength.Value / 100
    if movemeActive then
        -- Во время dash: гасим обычный prediction до movemePredStrength
        target = dampStr
    elseif tick() < movemeEnd then
        -- Хвост после dash: держим дамп ещё 400 мс
        local remain = movemeEnd - tick()
        local frac   = math.clamp(remain / 0.4, 0, 1)
        target = dampStr + (1 - dampStr) * (1 - frac)
    end
    movemeBlend = movemeBlend + (target - movemeBlend) * math.clamp(dt * 8, 0, 1)
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Offset
-- ─────────────────────────────────────────────────────────────────────────────
local function applyOffset(predicted, myPos)
    if not Toggles.OffsetEnable.Value then return predicted end
    local dir = Vector3.new(predicted.X - myPos.X, 0, predicted.Z - myPos.Z)
    if dir.Magnitude < 0.01 then return predicted end
    dir = dir.Unit
    local right = Vector3.new(dir.Z, 0, -dir.X).Unit
    local sign  = (Options.OffsetSide.Value == "Right") and 1 or -1
    return predicted + right * (sign * Options.OffsetAmount.Value)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Core aim update
--
-- DUAL SYSTEM:
--   позиция  → смарт-бленд root + visual (по выбранной части)
--   velocity → ВСЕГДА от root (стабильно, не зависит от анимаций)
--
-- PIPELINE:
--   root/visual blend → prediction → offset → CFrame
-- ─────────────────────────────────────────────────────────────────────────────
local function updateAim()
    if not silentActive then return end
    if not HumanoidRootPart then return end

    local char = LocalPlayer.Character
    if not char then stopLock(); return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then stopLock(); return end

    if not lockedTarget or not lockedTarget.Character then stopLock(); return end
    local tgtHum = lockedTarget.Character:FindFirstChildOfClass("Humanoid")
    if not tgtHum or tgtHum.Health <= 0 then stopLock(); return end

    if isRagdolled(char) or isBlockedAnimationPlaying() then
        hum.AutoRotate = true
        return
    end

    -- Dual system: root (серверная физика) + visual (выбранная часть)
    local root   = getRoot(lockedTarget)
    local visual = getTargetPart(lockedTarget) or root
    if not root or not visual then stopLock(); return end

    hum.AutoRotate = false

    local myPos    = HumanoidRootPart.Position
    local rootPos  = root.Position
    local visualPos = visual.Position

    -- Смарт-бленд: берём значение доверия из вкладки Trusting
    local partName = Options.TargetPart.Value
    local isLimb   = partName:find("Arm") or partName:find("Leg")
    local trustMap = {
        ["Head"]      = Options.TrustHead.Value,
        ["Torso"]     = Options.TrustTorso.Value,
        ["Right Arm"] = Options.TrustRightArm.Value,
        ["Left Arm"]  = Options.TrustLeftArm.Value,
        ["Right Leg"] = Options.TrustRightLeg.Value,
        ["Left Leg"]  = Options.TrustLeftLeg.Value,
    }
    local blend = trustMap[partName] or Options.TrustTorso.Value
    
    if partName == "HumanoidRootPart" then
    blend = 0
end
    -- Итоговая серверная позиция = бленд root + visual
    local blendedPos = rootPos:Lerp(visualPos, blend)
    -- Anti-desync: слегка тянем к root (как у приваток)
    blendedPos = blendedPos:Lerp(rootPos, 0.2)

    local targetPos = Vector3.new(blendedPos.X, myPos.Y, blendedPos.Z)

    -- Velocity ВСЕГДА от root — стабильно, не зависит от анимаций конечностей
    local vel      = root.AssemblyLinearVelocity
    local now      = tick()
    local dt       = math.max(now - lastPredTime, 1e-4)   -- защита от деления на 0
    lastPredTime   = now
    local accel    = (vel - lastVel) / dt                  -- правильное ускорение (FPS-independent)
    lastVel        = vel

    local speed    = vel.Magnitude
    local distance = (HumanoidRootPart.Position - rootPos).Magnitude

    -- Anti-dash: TSB дэш > 60 st/s — уменьшаем влияние velocity
    local velForPred = vel
    if speed > 60 then
        velForPred = vel * 0.5
    end

    -- ── Dash-aware: direction & velocity lock ─────────────────────────────────
    -- Пока dash активен — используем зафиксированный direction из момента старта
    -- Это убирает aim jitter от рывка (ИДЕЯ №2 + ИДЕЯ №3)
    local dashActive = Toggles.DashPredEnable.Value and movemeActive
    if dashActive and dashLockedDir and dashLockedVel then
        -- Anti-overshoot: если speed > 80 — дополнительно режем (ИДЕЯ №7)
        local antiOver = (speed > 80) and 0.6 or 1.0
        velForPred = dashLockedDir * dashLockedVel.Magnitude * antiOver
        -- Distance-adaptive: чем ближе, тем слабее dash prediction (ИДЕЯ №6)
        local distFactor = math.clamp(distance / 40, 0.4, 1.0)
        velForPred = velForPred * distFactor
    end

    -- Лимб стабилизация: сглаживаем и уменьшаем velocity для конечностей
    if isLimb then
        velForPred = velForPred:Lerp(lastVel, 0.35) * 0.75
    end

    -- Clamp от мусорных скачков (анимации, баги)
    local predSpeed = velForPred.Magnitude
    if predSpeed > 120 then
        velForPred = velForPred.Unit * 120
    end

    local LeadSpeed = math.max(Options.LeadSpeed.Value, 1)
    local t = distance / (LeadSpeed + math.max(predSpeed, 1))

    -- ── Prediction ────────────────────────────────────────────────────────────
    -- Все 6 prediction независимы и стакаются друг на друга.
    -- predicted обновляется последовательно: каждый читает текущий predicted.
    local predicted = targetPos

    -- ── Dash End Prediction: целимся в предсказанный конец dash (ИДЕЯ №1) ────
    -- Когда moveme активен — бленд между текущей позицией и dashEndPos.
    -- Убирает дёрганье прицела во время всего рывка.
    if Toggles.DashPredEnable.Value and dashActive and dashEndPos then
        local endBlend = Options.DashEndBlend.Value / 100
        local dashTarget = Vector3.new(dashEndPos.X, myPos.Y, dashEndPos.Z)
        predicted = predicted:Lerp(dashTarget, endBlend)
    end

    -- Вычисляем текущий dir один раз для angular-методов
    -- Во время dash — используем зафиксированный dir (ИДЕЯ №3)
    local curDir
    if dashActive and dashLockedDir then
        curDir = Vector3.new(dashLockedDir.X, 0, dashLockedDir.Z)
        if curDir.Magnitude > 0.001 then curDir = curDir.Unit else curDir = lastDir end
    else
        curDir = speed > 0.1 and velForPred.Unit or lastDir
    end

    -- 1. Velocity Prediction: predicted + vel*t
    if Toggles.PredEnable.Value then
        local mult   = Options.PredStrength.Value / 100
        -- movemeBlend гасит обычный pred во время dash — без этого aim перелетает
        local offset = velForPred * t * mult * movemeBlend
        predicted = Vector3.new(predicted.X + offset.X, myPos.Y, predicted.Z + offset.Z)
    end

    -- 2. Acceleration Prediction: predicted + vel*t + 0.5*accel*t²  (FPS-independent)
    if Toggles.AccelPredEnable.Value then
        local mult   = Options.AccelStrength.Value / 100
        -- Accel prediction во время dash — нестабильна, гасим вместе с blend
        local offset = (velForPred * t * mult + 0.5 * accel * (t ^ 2) * mult) * movemeBlend
        predicted = Vector3.new(predicted.X + offset.X, myPos.Y, predicted.Z + offset.Z)
    end

    -- 3. Angular Prediction: только поворот направления, без magnitude
    --    futureDir = (dir + angular*t).Unit  →  predicted + futureDir*speed*tAng
    if Toggles.AngularPredEnable.Value then
        local mult         = Options.AngularStrength.Value / 100
        -- Во время dash angular стабилизирован (dir зафиксирован) → angular ≈ 0
        local angular      = dashActive and Vector3.zero or ((curDir - lastDir) / dt)
        local tAng         = math.clamp(distance / 250, 0.08, 0.45)
        local futureDirRaw = curDir + angular * tAng
        local futureDir    = futureDirRaw.Magnitude > 0.001 and futureDirRaw.Unit or curDir
        local angOffset    = futureDir * speed * tAng * mult * movemeBlend
        predicted = Vector3.new(predicted.X + angOffset.X, myPos.Y, predicted.Z + angOffset.Z)
    end

    -- 4. Aggressive Velocity Prediction: speedBoost + velocity spike
    if Toggles.AggrEnable.Value then
        local mult       = Options.AggrStrength.Value / 100
        local speedBoost = 1 + math.clamp(speed / 25, 0, 4) * mult
        local aggrOffset = velForPred * t * speedBoost
        if speed > 60 then aggrOffset = velForPred.Unit * (speed * 0.3) * mult end
        local maxOffset  = (15 + distance * 0.1) * math.max(mult, 0.1)
        if aggrOffset.Magnitude > maxOffset then aggrOffset = aggrOffset.Unit * maxOffset end
        -- Во время dash aggressive pred гасится movemeBlend
        aggrOffset = aggrOffset * movemeBlend
        local aggrPred = Vector3.new(predicted.X + aggrOffset.X, myPos.Y, predicted.Z + aggrOffset.Z)
        predicted = predicted:Lerp(aggrPred, mult)
        predicted = predicted + Vector3.new(velForPred.X * 0.15, 0, velForPred.Z * 0.15) * movemeBlend
    end

    -- 5. Aggressive Acceleration Prediction: vel*t*speedBoost + accel*t²
    if Toggles.AggrAccelEnable.Value then
        local mult       = Options.AggrAccelStrength.Value / 100
        local speedBoost = 1 + math.clamp(speed / 25, 0, 4) * mult
        local aggrOffset = (velForPred * t * speedBoost + accel * (t ^ 2 * 0.6) * mult) * movemeBlend
        if speed > 60 then aggrOffset = velForPred.Unit * (speed * 0.3) * mult * movemeBlend end
        local maxOffset  = (15 + distance * 0.1) * math.max(mult, 0.1)
        if aggrOffset.Magnitude > maxOffset then aggrOffset = aggrOffset.Unit * maxOffset end
        local aggrPred = Vector3.new(predicted.X + aggrOffset.X, myPos.Y, predicted.Z + aggrOffset.Z)
        predicted = predicted:Lerp(aggrPred, mult)
        predicted = predicted + Vector3.new(velForPred.X * 0.15, 0, velForPred.Z * 0.15) * movemeBlend
    end

    -- 6. Aggressive Angular Prediction: широкое окно tAng + dash boost
    if Toggles.AggrAngularEnable.Value then
        local mult         = Options.AggrAngularStrength.Value / 100
        -- Во время dash угловое ускорение зафиксировано → angular = 0
        local angular      = dashActive and Vector3.zero or ((curDir - lastDir) / dt)
        local tAng         = math.clamp(distance / 180, 0.1, 0.6)
        local speedBoost   = 1 + math.clamp(speed / 40, 0, 2) * mult
        local futureDirRaw = curDir + angular * tAng * speedBoost
        local futureDir    = futureDirRaw.Magnitude > 0.001 and futureDirRaw.Unit or curDir
        local aggrAngOffset = futureDir * speed * tAng * mult * speedBoost * movemeBlend
        local maxOff        = (20 + distance * 0.15) * math.max(mult, 0.1)
        if aggrAngOffset.Magnitude > maxOff then aggrAngOffset = aggrAngOffset.Unit * maxOff end
        local aggrAngPred = Vector3.new(predicted.X + aggrAngOffset.X, myPos.Y, predicted.Z + aggrAngOffset.Z)
        predicted = predicted:Lerp(aggrAngPred, mult)
    end

    -- обновляем lastDir один раз в конце (не внутри каждого angular-блока)
    lastDir = curDir

    -- ── Offset (после prediction, до CFrame) ──────────────────────────────────
    predicted = applyOffset(predicted, myPos)

    -- ── CFrame ────────────────────────────────────────────────────────────────
    local targetCFrame  = CFrame.new(myPos, predicted)
    local currentCFrame = HumanoidRootPart.CFrame
    local aimMode       = Options.AimMode.Value

    -- Вычисляем угол между текущим и целевым направлением
    local currentLook = currentCFrame.LookVector
    local targetLook  = targetCFrame.LookVector
    local dotProduct  = currentLook:Dot(targetLook)
    local angleDiff   = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))

    -- Адаптивная скорость: чем больше угол, тем быстрее поворот
    local baseSpeed  = Options.AimAlpha.Value / 100
    local speedMult  = Options.AimSpeed and (Options.AimSpeed.Value / 100) or 1

    -- Экспоненциальное ускорение для больших углов
    local angleBoost = 1 + (angleDiff / 45) ^ 1.5
    local finalAlpha = math.clamp(baseSpeed * speedMult * angleBoost, 0, 1)

    if aimMode == "Instant" then
        -- Мгновенный поворот без интерполяции
        local snapDelay = Options.SnapSpeedDelay and Options.SnapSpeedDelay.Value or 0
        local now = tick()
        if now - lastSnapTime >= snapDelay then
            HumanoidRootPart.CFrame = targetCFrame
            lastSnapTime = now
        end

    elseif aimMode == "Aggressive" then
        -- Агрессивный режим: 1x–5x множитель через слайдер
        local aggrMult = Options.AggressiveMultiplier and Options.AggressiveMultiplier.Value or 1
        -- aggrMult 1 → original ×2.5 behaviour; 5 → ×6.5
        local aggressiveAlpha = math.clamp(finalAlpha * (1.5 + aggrMult), 0.85, 1)
        HumanoidRootPart.CFrame = currentCFrame:Lerp(targetCFrame, aggressiveAlpha)

    elseif aimMode == "Snap" then
        -- Snap с умным threshold (1°–360°)
        local snapThreshold = Options.SnapThreshold and Options.SnapThreshold.Value or 15
        local snapDelay = Options.SnapSpeedDelay and Options.SnapSpeedDelay.Value or 0
        local now = tick()
        if angleDiff > snapThreshold then
            if now - lastSnapTime >= snapDelay then
                HumanoidRootPart.CFrame = targetCFrame
                lastSnapTime = now
            end
        else
            HumanoidRootPart.CFrame = currentCFrame:Lerp(targetCFrame, math.max(finalAlpha, 0.7))
        end

    elseif aimMode == "Lerp" then
        -- Lerp с multiplier 0.10x–1x и clamp до 1.0
        -- floor = 0 чтобы multiplier реально давил вниз
        local lerpMult   = Options.LerpMultiplier and Options.LerpMultiplier.Value or 1.0
        local smartAlpha = math.clamp(finalAlpha ^ 0.75 * 1.2 * lerpMult, 0, 1.0)
        HumanoidRootPart.CFrame = currentCFrame:Lerp(targetCFrame, smartAlpha)

    elseif aimMode == "Hybrid" then
        if speed >= Options.HybridThreshold.Value or angleDiff > 30 then
            HumanoidRootPart.CFrame = targetCFrame
        else
            local hybridAlpha = math.clamp(finalAlpha * 1.5, 0.5, 1)
            HumanoidRootPart.CFrame = currentCFrame:Lerp(targetCFrame, hybridAlpha)
        end
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- startLock
-- ─────────────────────────────────────────────────────────────────────────────
local function startLock()
    lockedTarget = nil
    local shortest = math.huge
    local mousePos = UIS:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then
            local root = getRoot(p)
            if root then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < shortest then shortest = dist; lockedTarget = p end
                end
            end
        end
    end

    if not lockedTarget then return end

    silentActive = true
    lastVel      = Vector3.zero
    updateHighlight()

    -- Запускаем наблюдение за moveme на персонаже цели
    if lockedTarget.Character then
        watchMoveme(lockedTarget.Character)
    end

    -- Obsidian Multi Dropdown → словарь { [name] = true/false }
    local sel = Options.LockEvents.Value
    if sel["Stepped"]       then table.insert(lockConnections, RunService.Stepped:Connect(updateAim)) end
    if sel["Heartbeat"]     then table.insert(lockConnections, RunService.Heartbeat:Connect(updateAim)) end
    if sel["RenderStepped"] then table.insert(lockConnections, RunService.RenderStepped:Connect(updateAim)) end
    if sel["BindToRenderStep"] then
        -- Clean up any stale bind first
        if currentRenderBind then
            RunService:UnbindFromRenderStep(currentRenderBind)
            currentRenderBind = nil
        end
        local priorityMode = Options.PriorityMode and Options.PriorityMode.Value or "Normal"
        local priority = PriorityMap[priorityMode] or PriorityMap.Normal
        currentRenderBind = "BodyAim_" .. priorityMode
        RunService:BindToRenderStep(currentRenderBind, priority, updateAim)
    end
end

Options.AimLockKey:OnClick(function()
    if not Toggles.AimLock.Value then return end
    if silentActive then stopLock() else startLock() end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Water
-- ─────────────────────────────────────────────────────────────────────────────
local function setWaterColor(obj)
    obj.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, currentWaterColor),
        ColorSequenceKeypoint.new(1, currentWaterColor)
    }
end

local function applyWater(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v.Name == "WaterTrail" then setWaterColor(v) end
    end
end

local function setupWater(char)
    for _, c in pairs(waterConnections) do c:Disconnect() end
    waterConnections = {}
    applyWater(char)
    table.insert(waterConnections, char.DescendantAdded:Connect(function(v)
        if not Toggles.WaterToggle.Value then return end
        if v:IsA("ParticleEmitter") or v.Name == "WaterTrail" then setWaterColor(v) end
    end))
end

Toggles.WaterToggle:OnChanged(function()
    local char = LocalPlayer.Character
    if char and Toggles.WaterToggle.Value then setupWater(char) end
end)

Options.WaterColor:OnChanged(function()
    currentWaterColor = Options.WaterColor.Value
    local char = LocalPlayer.Character
    if char and Toggles.WaterToggle.Value then applyWater(char) end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- NoCollision Heartbeat
-- ─────────────────────────────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function()
    if not Toggles.TargetNoColl.Value then clearAll(); return end
    if not LocalPlayer.Character then return end

    local MODE        = Options.ModeSelection.Value
    local MAX_PLAYERS = Options.MaxPlayers.Value
    local candidates  = {}

    -- Read options once per frame (not once per player)
    local useFrom   = Options.DistanceFrom.Value
    local useMe     = useFrom["Me"]
    local useTarget = useFrom["Target"]
    local maxMe     = Options.MaxDistanceMe.Value
    local maxTarget = Options.MaxDistanceTarget.Value

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then

            -- Locked target always gets noclip, no distance filter needed
            if p == lockedTarget then
                table.insert(candidates, {player = p, distance = 0})
                continue
            end

            local valid     = false
            local finalDist = math.huge

            -- Distance from Me check (independent of Target)
            if useMe and maxMe > 0 then
                local d = getDistance(LocalPlayer, p)
                if maxMe >= 300 or d <= maxMe then
                    valid    = true
                    finalDist = math.min(finalDist, d)
                end
            end

            -- Distance from locked Target check (independent of Me)
            if useTarget and maxTarget > 0 and lockedTarget and isAlive(lockedTarget) then
                local d = getDistance(lockedTarget, p)
                if maxTarget >= 300 or d <= maxTarget then
                    valid    = true
                    finalDist = math.min(finalDist, d)
                end
            end

            if valid then
                table.insert(candidates, {player = p, distance = finalDist})
            else
                removeNoclip(p)
            end
        else
            removeNoclip(p)
        end
    end

    table.sort(candidates, function(a, b) return a.distance < b.distance end)

    local used = {}; local count = 0

    for _, data in ipairs(candidates) do
        local p = data.player
        if MODE == "Aim Target" then
            if p == lockedTarget then createNoclip(p); used[p] = true end
        elseif MODE == "Aim Target and Distance" then
            if p == lockedTarget or data.distance ~= math.huge then
                createNoclip(p); used[p] = true
            end
        elseif MODE == "Aim Target and Distance and Limit" then
            if p == lockedTarget then
                createNoclip(p); used[p] = true
            elseif data.distance ~= math.huge and (MAX_PLAYERS == 0 or count < MAX_PLAYERS) then
                createNoclip(p); used[p] = true; count += 1
            end
        elseif MODE == "Distance" then
            if data.distance ~= math.huge then createNoclip(p); used[p] = true end
        elseif MODE == "Distance and Limit" then
            if data.distance ~= math.huge and (MAX_PLAYERS == 0 or count < MAX_PLAYERS) then
                createNoclip(p); used[p] = true; count += 1
            end
        end
    end

    for p in pairs(activeConstraints) do
        if not used[p] then removeNoclip(p) end
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Character / player events
-- ─────────────────────────────────────────────────────────────────────────────
local function onCharacterAdded(char)
    stopLock(); clearAll()
    velocityEnabled = false; velocityArmed = false
    velocityExpire  = 0;     velocityAnimExp = 0
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
    char.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
    if Toggles.WaterToggle.Value then task.wait(0.5); setupWater(char) end
end

Players.PlayerRemoving:Connect(function(p) removeNoclip(p) end)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterAdded:Connect(refreshHRP)

if LocalPlayer.Character then
    LocalPlayer.Character.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Theme / Save
-- ─────────────────────────────────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("TSBUtility")
SaveManager:SetFolder("TSBUtility/tsb")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- ─────────────────────────────────────────────────────────────────────────────
-- Cooldown Tracker (Dash / Side / Evasive)
-- ─────────────────────────────────────────────────────────────────────────────
do
    local Workspace   = game:GetService("Workspace")
    local LiveFolder  = Workspace:WaitForChild("Live")

    local cdGui = Instance.new("ScreenGui")
    cdGui.Name            = "CooldownBars"
    cdGui.ResetOnSpawn    = false
    cdGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    cdGui.Parent          = LocalPlayer:WaitForChild("PlayerGui")

    -- ability order defines display order (left → right)
    local abilityOrder = {"Side  Dash", "Front / Back Dash", "Evasive"}
    local abilityDefs = {
        ["Front / Back Dash"] = {cooldown=5,  fillKey="CdDashFill",    numKey="CdDashNum",    bgKey="CdDashBG"},
        ["Side  Dash"]       = {cooldown=2,  fillKey="CdSideFill",    numKey="CdSideNum",    bgKey="CdSideBG"},
        ["Evasive"]         = {cooldown=30, fillKey="CdEvasiveFill", numKey="CdEvasiveNum", bgKey="CdEvasiveBG"},
    }

    local cdBars = {}

    local function createCdBar(name)
        local def = abilityDefs[name]

        local frame = Instance.new("Frame")
        frame.BorderSizePixel = 0
        frame.Parent = cdGui

        local bgCorner = Instance.new("UICorner", frame)

        local fill = Instance.new("Frame")
        fill.BorderSizePixel = 0
        fill.Parent = frame

        local fillCorner = Instance.new("UICorner", fill)

        -- ability label (top-left inside bar)
        local label = Instance.new("TextLabel")
        label.Size               = UDim2.new(0.45, 0, 1, 0)
        label.Position           = UDim2.new(0, 4, 0, 0)
        label.BackgroundTransparency = 1
        label.TextScaled         = true
        label.TextXAlignment     = Enum.TextXAlignment.Left
        label.Font               = Enum.Font.SourceSansBold
        label.Text               = name
        label.Parent             = frame

        -- timer text (right side)
        local timerLbl = Instance.new("TextLabel")
        timerLbl.Size                = UDim2.new(0.5, -4, 1, 0)
        timerLbl.Position            = UDim2.new(0.5, 0, 0, 0)
        timerLbl.BackgroundTransparency = 1
        timerLbl.TextScaled          = true
        timerLbl.TextXAlignment      = Enum.TextXAlignment.Right
        timerLbl.Font                = Enum.Font.SourceSansBold
        timerLbl.Text                = ""
        timerLbl.Parent              = frame

        cdBars[name] = {
            frame      = frame,
            fill       = fill,
            label      = label,
            timerLbl   = timerLbl,
            bgCorner   = bgCorner,
            fillCorner = fillCorner,
            time       = 0,
            duration   = def.cooldown,
        }
    end

    for _, name in ipairs(abilityOrder) do
        createCdBar(name)
    end

    -- Heartbeat update
    RunService.Heartbeat:Connect(function(dt)
        local showBars    = Toggles.CdShowBars.Value
        local showNumbers = Toggles.CdShowNumbers.Value
        local width       = Options.CdWidth.Value
        local height      = Options.CdHeight.Value
        local spacing     = Options.CdSpacing.Value
        local corner      = Options.CdCorner.Value
        local posX        = Options.CdPosX.Value
        local posY        = Options.CdPosY.Value
        local fillDir     = Options.CdFillDir.Value

        local totalWidth = #abilityOrder * width + (#abilityOrder - 1) * spacing
        local startX     = -totalWidth / 2

        for i, name in ipairs(abilityOrder) do
            local data = cdBars[name]
            local def  = abilityDefs[name]
            local frame     = data.frame
            local fill      = data.fill
            local label     = data.label
            local timerLbl  = data.timerLbl

            -- tick down
            if data.time > 0 then
                data.time = math.max(data.time - dt, 0)
            end

            local ratio = 1 - (data.time / data.duration)

            -- position: centered cluster
            local xOff = startX + (i - 1) * (width + spacing)
            frame.Size     = UDim2.new(0, width, 0, height)
            frame.Position = UDim2.new(posX, xOff, posY, 0)

            data.bgCorner.CornerRadius   = UDim.new(0, corner)
            data.fillCorner.CornerRadius = UDim.new(0, corner)

            -- visibility modes
            if showBars then
                frame.Visible               = true
                fill.Visible                = true
                frame.BackgroundTransparency = 0
                frame.BackgroundColor3       = Options[def.bgKey].Value
                fill.BackgroundColor3        = Options[def.fillKey].Value
                fill.Size                    = UDim2.new(ratio, 0, 1, 0)

                if fillDir == "Left" then
                    fill.AnchorPoint = Vector2.new(0, 0)
                    fill.Position    = UDim2.new(0, 0, 0, 0)
                else
                    fill.AnchorPoint = Vector2.new(1, 0)
                    fill.Position    = UDim2.new(1, 0, 0, 0)
                end

                -- Always show timer text alongside bar
                local numCol  = Options[def.numKey].Value
                local timeStr = string.format("%.1f", data.time)
                local labelFmt = Options.CdLabelFormat and Options.CdLabelFormat.Value or "Name  Time"
                if labelFmt == "Time  Name" then
                    -- timer on left, name on right
                    label.Size             = UDim2.new(0.5, -4, 1, 0)
                    label.Position         = UDim2.new(0.5, 0, 0, 0)
                    label.TextXAlignment   = Enum.TextXAlignment.Right
                    timerLbl.Size          = UDim2.new(0.45, 0, 1, 0)
                    timerLbl.Position      = UDim2.new(0, 4, 0, 0)
                    timerLbl.TextXAlignment = Enum.TextXAlignment.Left
                    timerLbl.Text          = timeStr
                    label.Text             = name
                else
                    -- name on left, timer on right (default)
                    label.Size             = UDim2.new(0.45, 0, 1, 0)
                    label.Position         = UDim2.new(0, 4, 0, 0)
                    label.TextXAlignment   = Enum.TextXAlignment.Left
                    timerLbl.Size          = UDim2.new(0.5, -4, 1, 0)
                    timerLbl.Position      = UDim2.new(0.5, 0, 0, 0)
                    timerLbl.TextXAlignment = Enum.TextXAlignment.Right
                    timerLbl.Text          = timeStr
                    label.Text             = name
                end
                timerLbl.TextColor3 = numCol
                label.TextColor3    = numCol
                label.Visible       = true
                timerLbl.Visible    = true
            elseif showNumbers then
                frame.Visible                = true
                fill.Visible                 = false
                frame.BackgroundTransparency = 1
            else
                frame.Visible = false
            end

            -- text (numbers-only mode, no bar)
            if not showBars and showNumbers then
                local numCol  = Options[def.numKey].Value
                local timeStr = string.format("%.1f", data.time)
                local labelFmt = Options.CdLabelFormat and Options.CdLabelFormat.Value or "Name  Time"
                if labelFmt == "Time  Name" then
                    label.Size             = UDim2.new(0.5, -4, 1, 0)
                    label.Position         = UDim2.new(0.5, 0, 0, 0)
                    label.TextXAlignment   = Enum.TextXAlignment.Right
                    timerLbl.Size          = UDim2.new(0.45, 0, 1, 0)
                    timerLbl.Position      = UDim2.new(0, 4, 0, 0)
                    timerLbl.TextXAlignment = Enum.TextXAlignment.Left
                    timerLbl.Text          = timeStr
                    label.Text             = name
                else
                    label.Size             = UDim2.new(0.45, 0, 1, 0)
                    label.Position         = UDim2.new(0, 4, 0, 0)
                    label.TextXAlignment   = Enum.TextXAlignment.Left
                    timerLbl.Size          = UDim2.new(0.5, -4, 1, 0)
                    timerLbl.Position      = UDim2.new(0.5, 0, 0, 0)
                    timerLbl.TextXAlignment = Enum.TextXAlignment.Right
                    timerLbl.Text          = timeStr
                    label.Text             = name
                end
                timerLbl.TextColor3 = numCol
                label.TextColor3    = numCol
                label.Visible       = true
                timerLbl.Visible    = true
            elseif not showBars then
                timerLbl.Text    = ""
                label.Visible    = false
                timerLbl.Visible = false
            end
        end
    end)

    -- trigger a cooldown
    local function cdTrigger(name)
        if cdBars[name] then
            cdBars[name].time = cdBars[name].duration
        end
    end

    -- animation → cooldown map
    local cdAnimMap = {
        {name="Side  Dash", ids={10480793962, 10480796021}},
        {name="Front / Back Dash", ids={10479335397, 10491993682}},
    }

    local function onCdAnim(animId)
        for _, entry in ipairs(cdAnimMap) do
            for _, id in ipairs(entry.ids) do
                if animId == id then cdTrigger(entry.name) end
            end
        end
    end

    local function setupCdDetect()
        local char     = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local animator = humanoid:WaitForChild("Animator")

        animator.AnimationPlayed:Connect(function(track)
            local id = tonumber(track.Animation.AnimationId:match("%d+"))
            if id then onCdAnim(id) end
        end)
    end

    LocalPlayer.CharacterAdded:Connect(setupCdDetect)
    if LocalPlayer.Character then setupCdDetect() end

    -- Evasive: triggered by RagdollCancel appearing on own character
    LiveFolder.DescendantAdded:Connect(function(child)
        if child.Name == "RagdollCancel" and child.Parent == LocalPlayer.Character then
            cdTrigger("Evasive")
        end
    end)
end