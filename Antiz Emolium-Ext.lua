local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo.."Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = true

local Window = Library:CreateWindow({
    Title = "Antiz Emolium",
    Footer = "Version 1.0.0",
    Icon = 100032358358540,
    ShowCustomCursor = true,
})

local Tabs = {
    Main      = Window:AddTab("Main",        "sword"),
    Misc      = Window:AddTab("Misc",        "box"),
    Visuals   = Window:AddTab("Visuals",     "eye"),
    Trusting  = Window:AddTab("Trusting",    "shield"),
    Bars      = Window:AddTab("Bars",        "activity"),
    Combat    = Window:AddTab("Combat",      "zap"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings")
}

local SilentBox   = Tabs.Main:AddLeftGroupbox("Silent Aim")
local PredBox     = Tabs.Main:AddRightGroupbox("Prediction")
local MiscBox     = Tabs.Misc:AddLeftGroupbox("No Collision")
local VelocityBox = Tabs.Misc:AddRightGroupbox("Velocity")
local VisualBox   = Tabs.Visuals:AddLeftGroupbox("Effects")
local TrustBox    = Tabs.Trusting:AddLeftGroupbox("Part Trust")
local CombatBox   = Tabs.Combat:AddLeftGroupbox("Combat Mods")
local MoveBox     = Tabs.Combat:AddRightGroupbox("Movement")

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
PredBox:AddToggle("PredEnable",      {Text = "Prediction",              Default = false})
PredBox:AddToggle("AccelPredEnable", {Text = "Acceleration Prediction", Default = false})
PredBox:AddSlider("PredStrength", {
    Text = "Prediction Strength", Default = 70, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("LeadSpeed", {
    Text = "Lead Speed", Default = 150, Min = 10, Max = 300, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
PredBox:AddToggle("AggrEnable",      {Text = "Aggressive Prediction",             Default = false})
PredBox:AddToggle("AggrAccelEnable", {Text = "Aggressive Acceleration Prediction",Default = false})
PredBox:AddSlider("AggrStrength", {
    Text = "Aggressive Strength", Default = 55, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AggrLeadSpeed", {
    Text = "Aggressive Lead Speed", Default = 200, Min = 10, Max = 300, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
PredBox:AddDivider()
PredBox:AddToggle("VelSmoothEnable", {Text = "Velocity Smoothing", Default = true})
PredBox:AddSlider("VelSmoothFactor", {
    Text = "Smooth Samples", Default = 6, Min = 2, Max = 15, Rounding = 0,
})
PredBox:AddToggle("PingCompEnable", {Text = "Ping Compensation", Default = false})
PredBox:AddToggle("JitterFilterEnable", {Text = "Jitter Filter", Default = true})
PredBox:AddSlider("JitterThreshold", {
    Text = "Jitter Threshold", Default = 25, Min = 5, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " st/s" end
})
PredBox:AddToggle("DirChangePredEnable", {Text = "Direction Change Detect", Default = false})

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
VisualBox:AddDivider()
VisualBox:AddToggle("FOVToggle", {Text = "FOV Circle", Default = false})
    :AddColorPicker("FOVColor", {Default = Color3.fromRGB(255, 255, 255)})
VisualBox:AddSlider("FOVRadius", {
    Text = "FOV Radius", Default = 200, Min = 50, Max = 600, Rounding = 0,
})
VisualBox:AddSlider("FOVThickness", {
    Text = "FOV Thickness", Default = 2, Min = 1, Max = 5, Rounding = 0,
})
VisualBox:AddToggle("FOVFilled", {Text = "FOV Filled", Default = false})
VisualBox:AddDivider()
VisualBox:AddToggle("TargetInfoToggle", {Text = "Target Info HUD", Default = false})

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

-- ── Combat Mods ──────────────────────────────────────────────────────────────
CombatBox:AddToggle("AutoParry", {Text = "Auto Parry", Default = false})
CombatBox:AddLabel("Auto Parry Key"):AddKeyPicker("AutoParryKey", {
    Default = "F", Mode = "Toggle", SyncToggleState = false, Text = "Auto Parry"
})
CombatBox:AddSlider("ParryReaction", {
    Text = "Reaction Time", Default = 150, Min = 50, Max = 400, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " ms" end
})
CombatBox:AddDropdown("ParryMode", {
    Values = {"Distance", "Animation", "Both"}, Default = 3, Text = "Detection Mode"
})
CombatBox:AddSlider("ParryDistance", {
    Text = "Parry Distance", Default = 15, Min = 5, Max = 30, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " st" end
})

MoveBox:AddToggle("SpeedModify", {Text = "Speed Modifier", Default = false})
MoveBox:AddSlider("SpeedValue", {
    Text = "Walk Speed", Default = 16, Min = 0, Max = 100, Rounding = 0,
})
MoveBox:AddDivider()
MoveBox:AddToggle("AntiAim", {Text = "Anti-Aim (Visual)", Default = false})
MoveBox:AddDropdown("AntiAimMode", {
    Values = {"Spin", "Jitter", "Reverse"}, Default = 1, Text = "Anti-Aim Mode"
})
MoveBox:AddSlider("AntiAimSpeed", {
    Text = "Spin Speed", Default = 10, Min = 1, Max = 50, Rounding = 0,
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
local lastSnapTime      = 0

-- Velocity EMA smoothing
local velHistory        = {}
local smoothedVel       = Vector3.zero
local smoothedAccel     = Vector3.zero
local lastSmoothVel     = Vector3.zero
local prevDirection     = Vector3.zero
local dirChangeTime     = 0

-- FOV Circle
local fovCircle         = nil

-- Target Info HUD
local targetInfoGui     = nil
local tInfoLabels       = {}

-- Anti-Aim
local antiAimAngle      = 0

-- Auto Parry
local lastParryTime     = 0

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
    silentActive  = false
    lockedTarget  = nil
    lastVel       = Vector3.zero
    lastSnapTime  = 0
    -- Clear smoothing state
    velHistory    = {}
    smoothedVel   = Vector3.zero
    smoothedAccel = Vector3.zero
    lastSmoothVel = Vector3.zero
    prevDirection = Vector3.zero
    if highlightObj then highlightObj:Destroy(); highlightObj = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end

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

    -- ── Velocity Processing (Improved Pipeline) ─────────────────────────────
    local rawVel   = root.AssemblyLinearVelocity
    local rawAccel = rawVel - lastVel
    lastVel = rawVel

    -- Step 1: EMA Velocity Smoothing — rolling average with exponential weight
    local vel = rawVel
    if Toggles.VelSmoothEnable.Value then
        table.insert(velHistory, rawVel)
        local maxSamples = Options.VelSmoothFactor.Value
        while #velHistory > maxSamples do table.remove(velHistory, 1) end
        -- Weighted average: recent samples have more influence
        local totalWeight = 0
        local weightedSum = Vector3.zero
        for i, v in ipairs(velHistory) do
            local w = i / #velHistory  -- linear ramp: oldest=low, newest=high
            weightedSum = weightedSum + v * w
            totalWeight = totalWeight + w
        end
        vel = weightedSum / math.max(totalWeight, 0.001)
        -- EMA blend toward latest sample for responsiveness
        local emaAlpha = 2 / (#velHistory + 1)
        vel = vel:Lerp(rawVel, emaAlpha)
    end

    -- Step 2: Jitter Filter — reject sudden velocity spikes
    if Toggles.JitterFilterEnable.Value then
        local velDelta = (vel - lastSmoothVel).Magnitude
        local threshold = Options.JitterThreshold.Value
        if velDelta > threshold and lastSmoothVel.Magnitude > 1 then
            -- Spike detected: blend heavily toward previous smooth value
            vel = lastSmoothVel:Lerp(vel, 0.25)
        end
    end
    lastSmoothVel = vel

    -- Step 3: Smooth acceleration (reduces noise in accel-based prediction)
    local accel = vel - smoothedVel
    smoothedAccel = smoothedAccel:Lerp(accel, 0.35)
    smoothedVel = vel

    -- Step 4: Direction change detection
    if Toggles.DirChangePredEnable.Value then
        local dir = vel.Magnitude > 1 and vel.Unit or Vector3.zero
        if prevDirection.Magnitude > 0.5 and dir.Magnitude > 0.5 then
            local dot = dir:Dot(prevDirection)
            if dot < 0.2 then
                dirChangeTime = tick()
                vel = vel * 0.35  -- sharp turn: heavily reduce prediction
            elseif tick() - dirChangeTime < 0.25 then
                vel = vel * 0.55  -- recovery window
            end
        end
        prevDirection = dir
    end

    local speed    = vel.Magnitude
    local distance = (HumanoidRootPart.Position - rootPos).Magnitude

    -- Step 5: Ping compensation — add extra lead time based on network latency
    local pingBonus = 0
    if Toggles.PingCompEnable.Value then
        local ok, stats = pcall(function() return game:GetService("Stats") end)
        if ok and stats then
            local ok2, ping = pcall(function()
                return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if ok2 then pingBonus = math.clamp(ping / 1000, 0, 0.18) end
        end
    end

    -- Anti-dash: progressive dampening instead of hard cutoff
    local velForPred = vel
    if speed > 40 then
        local dampFactor = math.clamp(1 - (speed - 40) / 100, 0.25, 1)
        velForPred = vel * dampFactor
    end

    -- Лимб стабилизация
    if isLimb then
        velForPred = velForPred:Lerp(smoothedVel, 0.35) * 0.75
    end

    -- Clamp от мусорных скачков
    local predSpeed = velForPred.Magnitude
    if predSpeed > 120 then
        velForPred = velForPred.Unit * 120
    end

    local LeadSpeed     = math.max(Options.LeadSpeed.Value, 1)
    local AggrLeadSpeed = math.max(Options.AggrLeadSpeed.Value, 1)
    local t     = distance / (LeadSpeed + math.max(predSpeed, 1)) + pingBonus
    local tAggr = distance / (AggrLeadSpeed + math.max(predSpeed, 1)) + pingBonus

    -- ── Prediction ────────────────────────────────────────────────────────────
    local predicted = targetPos
    local useAccel  = smoothedAccel  -- use smoothed accel for stability

    -- Базовый prediction
    if Toggles.AccelPredEnable.Value then
        local mult   = Options.PredStrength.Value / 100
        local offset = velForPred * t * mult + 0.5 * useAccel * (t ^ 2) * mult
        predicted = Vector3.new(targetPos.X + offset.X, myPos.Y, targetPos.Z + offset.Z)
    elseif Toggles.PredEnable.Value then
        local mult   = Options.PredStrength.Value / 100
        local offset = velForPred * t * mult
        predicted = Vector3.new(targetPos.X + offset.X, myPos.Y, targetPos.Z + offset.Z)
    end

    -- Aggressive prediction
    if Toggles.AggrAccelEnable.Value then
        local mult       = Options.AggrStrength.Value / 100
        local speedBoost = 1 + math.clamp(speed / 25, 0, 4) * mult
        local aggrOffset = velForPred * tAggr * speedBoost + useAccel * (tAggr ^ 2 * 0.6) * mult
        if speed > 45 then aggrOffset = velForPred.Unit * (speed * 0.3) * mult end
        local maxOff = (15 + distance * 0.1) * math.max(mult, 0.1)
        if aggrOffset.Magnitude > maxOff then aggrOffset = aggrOffset.Unit * maxOff end
        local aggrPred = Vector3.new(targetPos.X + aggrOffset.X, myPos.Y, targetPos.Z + aggrOffset.Z)
        predicted = predicted:Lerp(aggrPred, mult)
        predicted = predicted + Vector3.new(velForPred.X * 0.12, 0, velForPred.Z * 0.12)
    elseif Toggles.AggrEnable.Value then
        local mult       = Options.AggrStrength.Value / 100
        local speedBoost = 1 + math.clamp(speed / 25, 0, 4) * mult
        local aggrOffset = velForPred * tAggr * speedBoost
        if speed > 60 then aggrOffset = velForPred.Unit * (speed * 0.3) * mult end
        local maxOff = (15 + distance * 0.1) * math.max(mult, 0.1)
        if aggrOffset.Magnitude > maxOff then aggrOffset = aggrOffset.Unit * maxOff end
        local aggrPred = Vector3.new(targetPos.X + aggrOffset.X, myPos.Y, targetPos.Z + aggrOffset.Z)
        predicted = predicted:Lerp(aggrPred, mult)
        predicted = predicted + Vector3.new(velForPred.X * 0.12, 0, velForPred.Z * 0.12)
    end

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
    -- Reset velocity smoothing on respawn
    velHistory   = {}
    smoothedVel  = Vector3.zero
    smoothedAccel = Vector3.zero
    lastSmoothVel = Vector3.zero
    prevDirection = Vector3.zero
end

Players.PlayerRemoving:Connect(function(p) removeNoclip(p) end)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterAdded:Connect(refreshHRP)

if LocalPlayer.Character then
    LocalPlayer.Character.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- FOV Circle (Drawing API)
-- ─────────────────────────────────────────────────────────────────────────────
do
    local ok, _ = pcall(function() return Drawing end)
    if ok then
        fovCircle = Drawing.new("Circle")
        fovCircle.Thickness  = 2
        fovCircle.NumSides   = 64
        fovCircle.Filled     = false
        fovCircle.Visible    = false
        fovCircle.Transparency = 0.8
        fovCircle.Color      = Color3.fromRGB(255, 255, 255)

        RunService.RenderStepped:Connect(function()
            if not fovCircle then return end
            local show = Toggles.FOVToggle.Value
            fovCircle.Visible    = show
            if show then
                local vp = Camera.ViewportSize
                fovCircle.Position   = Vector2.new(vp.X / 2, vp.Y / 2)
                fovCircle.Radius     = Options.FOVRadius.Value
                fovCircle.Thickness  = Options.FOVThickness.Value
                fovCircle.Color      = Options.FOVColor.Value
                fovCircle.Filled     = Toggles.FOVFilled.Value
                fovCircle.Transparency = Toggles.FOVFilled.Value and 0.15 or 0.8
            end
        end)
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Target Info HUD
-- ─────────────────────────────────────────────────────────────────────────────
do
    targetInfoGui = Instance.new("ScreenGui")
    targetInfoGui.Name           = "TargetInfo"
    targetInfoGui.ResetOnSpawn   = false
    targetInfoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    targetInfoGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size                = UDim2.new(0, 180, 0, 80)
    frame.Position            = UDim2.new(0.5, -90, 0, 10)
    frame.BackgroundColor3    = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel     = 0
    frame.Visible             = false
    frame.Parent              = targetInfoGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local fields = {"Name", "HP", "Distance", "Speed"}
    for i, name in ipairs(fields) do
        local lbl = Instance.new("TextLabel")
        lbl.Size                = UDim2.new(1, -12, 0, 16)
        lbl.Position            = UDim2.new(0, 6, 0, 4 + (i-1) * 18)
        lbl.BackgroundTransparency = 1
        lbl.TextScaled          = true
        lbl.TextXAlignment      = Enum.TextXAlignment.Left
        lbl.Font                = Enum.Font.SourceSansBold
        lbl.TextColor3          = Color3.fromRGB(255, 255, 255)
        lbl.Text                = name .. ": --"
        lbl.Parent              = frame
        tInfoLabels[name]       = lbl
    end
    targetInfoFrame = frame

    RunService.Heartbeat:Connect(function()
        local show = Toggles.TargetInfoToggle.Value and silentActive and lockedTarget
        targetInfoFrame.Visible = show and true or false
        if not show then return end
        local tgt = lockedTarget
        if not tgt or not tgt.Character then return end
        local tHum  = tgt.Character:FindFirstChildOfClass("Humanoid")
        local tRoot = tgt.Character:FindFirstChild("HumanoidRootPart")
        tInfoLabels["Name"].Text = "Target: " .. tgt.Name
        if tHum then
            tInfoLabels["HP"].Text = string.format("HP: %.0f / %.0f", tHum.Health, tHum.MaxHealth)
        end
        if tRoot and HumanoidRootPart then
            local d = (tRoot.Position - HumanoidRootPart.Position).Magnitude
            tInfoLabels["Distance"].Text = string.format("Dist: %.1f st", d)
            tInfoLabels["Speed"].Text = string.format("Speed: %.1f st/s", tRoot.AssemblyLinearVelocity.Magnitude)
        end
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Speed Modifier
-- ─────────────────────────────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function()
    if not Toggles.SpeedModify.Value then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = Options.SpeedValue.Value end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Anti-Aim (Visual rotation spoofing)
-- ─────────────────────────────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function(dt)
    if not Toggles.AntiAim.Value then return end
    if silentActive then return end  -- don't interfere with aim lock
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local mode  = Options.AntiAimMode.Value
    local speed = Options.AntiAimSpeed.Value

    if mode == "Spin" then
        antiAimAngle = antiAimAngle + speed * dt * 60
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(antiAimAngle), 0)
    elseif mode == "Jitter" then
        local jitter = (math.random() > 0.5) and speed * 12 or -speed * 12
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(jitter), 0)
    elseif mode == "Reverse" then
        local look = hrp.CFrame.LookVector
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position - look)
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Auto Parry
-- ─────────────────────────────────────────────────────────────────────────────
do
    -- Attack animation IDs to detect incoming hits
    local attackAnimIds = {
        ["10469493270"]  = true,  -- M1
        ["10469539925"]  = true,  -- M1 2
        ["10469542068"]  = true,  -- M1 3
        ["10469544190"]  = true,  -- M1 4
        ["10503381238"]  = true,  -- Uppercut
        ["12296113986"]  = true,  -- Lethal
    }

    local function tryParry()
        local now = tick()
        if now - lastParryTime < 0.5 then return end
        lastParryTime = now
        -- Fire parry via virtual input or remote
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.delay(0.05, function()
            vim:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
        end)
    end

    local function setupAutoParry(char)
        if not char then return end
        -- Monitor nearby players' animations
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local animator = hum:FindFirstChildOfClass("Animator")
                    if animator then
                        animator.AnimationPlayed:Connect(function(track)
                            if not Toggles.AutoParry.Value then return end
                            local parryMode = Options.ParryMode.Value
                            local id = track.Animation and track.Animation.AnimationId:match("%d+")
                            if not id then return end
                            local isAttack = attackAnimIds[id]
                            if not isAttack then return end

                            local root = getRoot(p)
                            if not root or not HumanoidRootPart then return end
                            local dist = (root.Position - HumanoidRootPart.Position).Magnitude
                            local maxDist = Options.ParryDistance.Value

                            if parryMode == "Animation" then
                                task.delay(Options.ParryReaction.Value / 1000, tryParry)
                            elseif parryMode == "Distance" then
                                if dist <= maxDist then
                                    task.delay(Options.ParryReaction.Value / 1000, tryParry)
                                end
                            elseif parryMode == "Both" then
                                if dist <= maxDist then
                                    task.delay(Options.ParryReaction.Value / 1000, tryParry)
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    -- Setup on new players joining
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if Toggles.AutoParry.Value then setupAutoParry(LocalPlayer.Character) end
        end)
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        setupAutoParry(char)
    end)
    if LocalPlayer.Character then task.spawn(function() setupAutoParry(LocalPlayer.Character) end) end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Theme / Save
-- ─────────────────────────────────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("TSBUtility/testingaimlockaccuracy/unfinished")
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