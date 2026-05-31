local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library       = loadstring(game:HttpGet(repo.."Library.lua"))()
local ThemeManager  = loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager   = loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = true

local function bound(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local Window = Library:CreateWindow({
    Title = "Anti Emo",
    Footer = "Version 1.2.0",
    Icon = 100032358358540,
    ShowCustomCursor = true,
})

local Tabs = {
    Main      = Window:AddTab("Main",        "sword"),
    Misc      = Window:AddTab("Misc",        "box"),
    Visuals   = Window:AddTab("Visuals",     "eye"),
    Trusting  = Window:AddTab("Trusting",    "flame"),
    Bars      = Window:AddTab("Bars",        "activity"),
    Events    = Window:AddTab("Events",      "zap"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings")
}

local SilentBox      = Tabs.Main:AddLeftGroupbox("Silent Aim")
local PredBox        = Tabs.Main:AddRightGroupbox("Prediction")
local MovemePredBox  = Tabs.Main:AddRightGroupbox("Moveme Prediction")
local NoCollBox      = Tabs.Misc:AddLeftGroupbox("No Collision")
local NoCollPlusBox  = Tabs.Misc:AddLeftGroupbox("No Collision+")
local VelocityBox    = Tabs.Misc:AddRightGroupbox("Velocity")
local TouchBox       = Tabs.Misc:AddRightGroupbox("Touch Destroy Moveme")
local AnimNoCollBox  = Tabs.Misc:AddRightGroupbox("Anim Triggered No Collision")
local VisualBox      = Tabs.Visuals:AddLeftGroupbox("Effects")
local IgnoreBox      = Tabs.Visuals:AddRightGroupbox("Visual Ignore")
local TrustBox       = Tabs.Trusting:AddLeftGroupbox("Part Trust")
local AimEventsBox   = Tabs.Events:AddLeftGroupbox("Aim Lock Events")
local GlobalEventsBox= Tabs.Events:AddRightGroupbox("Global Events")

SilentBox:AddToggle("AimLock", {Text = "Aim Lock", Default = false})
SilentBox:AddLabel("Aim Lock Key"):AddKeyPicker("AimLockKey", {
    Default = "V", Mode = "Toggle", SyncToggleState = false, Text = "Aim Lock"
})
SilentBox:AddDropdown("TargetPart", {
    Values = {"Pivot","Center Mass","Bounding Box","HumanoidRootPart","Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg","Hitbox_RightArm","Hitbox_LeftArm","Hitbox_RightLeg","Hitbox_LeftLeg","Random Limb","Auto Limb","Nearest Part","Auto","Bone Priority"},

    Default = 1, Text = "Target Part"
})
SilentBox:AddLabel("— Bone Priority —")
SilentBox:AddSlider("BonePriorityHead", {
    Text = "Head", Default = 80, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("BonePriorityTorso", {
    Text = "Torso", Default = 60, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("BonePriorityHRP", {
    Text = "HumanoidRootPart", Default = 50, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("BonePriorityLeftArm", {
    Text = "Left Arm", Default = 30, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("BonePriorityRightArm", {
    Text = "Right Arm", Default = 1, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("BonePriorityLeftLeg", {
    Text = "Left Leg", Default = 10, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("BonePriorityRightLeg", {
    Text = "Right Leg", Default = 20, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddDropdown("AimMode", {
    Values = {"Instant", "Aggressive", "Lerp", "\194\176", "Snap", "Step", "Magnetic", "Adaptive", "Hybrid", "Linear", "Burst", "Velocity Aim", "Spiral"},
    Default = 1, Text = "Aim Mode"
})
SilentBox:AddSlider("AimBlendFactor", {
    Text = "Smoothing", Default = 65, Min = 1, Max = 100, Rounding = 0,
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
    FormatDisplayValue = function(_, v) return v .. "deg" end
})
SilentBox:AddSlider("SnapSpeedDelay", {
    Text = "Snap Speed Delay", Default = 0, Min = 0, Max = 2, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
SilentBox:AddSlider("HybridThreshold", {
    Text = "Hybrid Snap Threshold", Default = 40, Min = 5, Max = 1000, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " st/s" end
})
SilentBox:AddSlider("AdaptiveMinBlend", {
    Text = "Adaptive Min Blend", Default = 20, Min = 5, Max = 80, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("AdaptiveMaxBlend", {
    Text = "Adaptive Max Blend", Default = 95, Min = 50, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— Step Settings —")
SilentBox:AddDropdown("StepSteps", {
    Values = {"1", "2", "3", "4"}, Default = 2, Text = "Step Steps"
})
SilentBox:AddSlider("Step1Threshold", {
    Text = "Step 1 Threshold", Default = -70, Min = -360, Max = 360, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176" end
})
SilentBox:AddSlider("Step1Delay", {
    Text = "Step 1 Delay", Default = 0.5, Min = 0, Max = 2, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
SilentBox:AddSlider("Step2Threshold", {
    Text = "Step 2 Threshold", Default = 360, Min = -360, Max = 360, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176" end
})
SilentBox:AddSlider("Step2Delay", {
    Text = "Step 2 Delay", Default = 0.5, Min = 0, Max = 2, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
SilentBox:AddSlider("Step3Threshold", {
    Text = "Step 3 Threshold", Default = 0, Min = -360, Max = 360, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176" end
})
SilentBox:AddSlider("Step3Delay", {
    Text = "Step 3 Delay", Default = 0.3, Min = 0, Max = 2, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
SilentBox:AddSlider("Step4Threshold", {
    Text = "Step 4 Threshold", Default = 0, Min = -360, Max = 360, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176" end
})
SilentBox:AddSlider("Step4Delay", {
    Text = "Step 4 Delay", Default = 0.3, Min = 0, Max = 2, Rounding = 2,
    FormatDisplayValue = function(_, v) return v .. " s" end
})
SilentBox:AddSlider("StepRepeatDelay", {
    Text = "Repeat Delay", Default = 200, Min = 0, Max = 444, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " ms" end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— Magnetic Settings —")
SilentBox:AddSlider("MagneticStrength", {
    Text = "Magnetic Strength", Default = 92, Min = 1, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("TargetHz", {
    Text = "Target Hz (dt normalize)", Default = 120, Min = 1, Max = 240, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " Hz" end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— Linear Settings —")
SilentBox:AddSlider("LinearUpdatePerSecond", {
    Text = "Update Per Second", Default = 20, Min = 1, Max = 240, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
SilentBox:AddSlider("LinearMaxAnglePerTurn", {
    Text = "Max Angle Per Turn", Default = 180, Min = 1, Max = 360, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176" end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— Burst Settings —")
SilentBox:AddSlider("BurstUpdatePerSecond", {
    Text = "Update Per Second", Default = 20, Min = 1, Max = 240, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
SilentBox:AddSlider("BurstStrength", {
    Text = "Strength", Default = 77, Min = 1, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— Velocity Aim Settings —")
SilentBox:AddSlider("VelocityAimStrength", {
    Text = "Strength", Default = 85, Min = 1, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
SilentBox:AddSlider("VelocityAimScale", {
    Text = "Speed Scale", Default = 30, Min = 1, Max = 200, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— Spiral Settings —")
SilentBox:AddSlider("SpiralFrequency", {
    Text = "Frequency", Default = 20, Min = 1, Max = 240, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. " Hz" end
})
SilentBox:AddSlider("SpiralAmplitude", {
    Text = "Amplitude", Default = 10, Min = 1, Max = 90, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176" end
})
SilentBox:AddDivider()
SilentBox:AddLabel("— \194\176 (Degree) Settings —")
SilentBox:AddSlider("TurnSpeed", {
    Text = "Turn Speed", Default = 180, Min = 1, Max = 720, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "\194\176/s" end
})
SilentBox:AddSlider("DegreeMultA", {
    Text = "\194\176 Multiple A", Default = 1.0, Min = 0.1, Max = 10, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. "x" end
})
SilentBox:AddSlider("DegreeMultB", {
    Text = "\194\176 Multiple B", Default = 1.0, Min = 0.1, Max = 2.5, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. "x" end
})
SilentBox:AddToggle("OffsetEnable", {Text = "Enable Offset", Default = false})
SilentBox:AddDropdown("OffsetSide", {
    Values = {"Left", "Right"}, Default = 1, Text = "Offset Side"
})
SilentBox:AddSlider("OffsetAmount", {
    Text = "Offset Amount", Default = 1, Min = 0, Max = 10, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. " st" end
})

PredBox:AddToggle("PredEnable",      {Text = "Prediction",                      Default = false})
PredBox:AddToggle("AccelPredEnable", {Text = "Acceleration Prediction",         Default = false})
PredBox:AddSlider("PredStrength", {
    Text = "Prediction Strength", Default = 70, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("LeadSpeed", {
    Text = "Lead Speed", Default = 150, Min = 10, Max = 300, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
PredBox:AddSlider("PredMultiple", {
    Text = "Prediction Multiple", Default = 1.0, Min = 1.0, Max = 2.5, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. "x" end
})
PredBox:AddToggle("AggrEnable",      {Text = "Aggressive Prediction",            Default = false})
PredBox:AddToggle("AggrAccelEnable", {Text = "Aggressive Acceleration Prediction",    Default = false})
PredBox:AddSlider("AggrStrength", {
    Text = "Aggressive Strength", Default = 55, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})
PredBox:AddSlider("AggrLeadSpeed", {
    Text = "Aggressive Lead Speed", Default = 200, Min = 10, Max = 300, Rounding = 0,
    FormatDisplayValue = function(_, v) return tostring(v) end
})
PredBox:AddSlider("AggrPredMultiple", {
    Text = "Aggressive Prediction Multiple", Default = 1.0, Min = 1.0, Max = 2.5, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. "x" end
})

MovemePredBox:AddDropdown("MovemePredAnims", {
    Values = {"Uppercut","Lethal"}, Default = {"Uppercut"}, Multi = true, Text = "Trigger Animations"
})
MovemePredBox:AddSlider("MovemePredMult", {
    Text = "Moveme Prediction %", Default = 100, Min = 0, Max = 100, Rounding = 0,
    FormatDisplayValue = function(_, v) return v .. "%" end
})

NoCollBox:AddToggle("TargetNoColl", {Text = "No Collision Constraints", Default = false})
NoCollBox:AddDropdown("ModeSelection", {
    Values = {"Aim Target","Aim Target and Distance","Aim Target and Distance and Limit","Distance","Distance and Limit"},
    Default = 3, Text = "Mode Selection"
})
NoCollBox:AddSlider("MaxDistanceMe", {
    Text = "Distance From Me", Default = 200, Min = 0, Max = 301, Rounding = 0,
    FormatDisplayValue = function(_, v)
        if v == 0 then return "OFF" elseif v >= 300 then return "Unlimited" else return v.." studs" end
    end
})
NoCollBox:AddSlider("MaxDistanceTarget", {
    Text = "Distance From Target", Default = 0, Min = 0, Max = 301, Rounding = 0,
    FormatDisplayValue = function(_, v)
        if v == 0 then return "OFF" elseif v >= 300 then return "Unlimited" else return v.." studs" end
    end
})
NoCollBox:AddSlider("MaxPlayers", {
    Text = "Max Players", Default = 3, Min = 0, Max = 14, Rounding = 0,
    FormatDisplayValue = function(_, v) return v == 0 and "OFF" or tostring(v) end
})
NoCollBox:AddDropdown("DistanceFrom", {
    Values = {"Me","Target"}, Default = {"Target"}, Text = "Distance From", Multi = true
})
NoCollBox:AddToggle("IgnoreTarget", {Text = "Ignore Target", Default = false})

NoCollPlusBox:AddToggle("NoCollPlus", {Text = "No Collision+", Default = false})
NoCollPlusBox:AddDropdown("NoCollPlusParts", {
    Values = {"Head","Torso","Right Arm","Left Arm","Right Leg","Left Leg","HumanoidRootPart","Hitbox_RightArm","Hitbox_LeftArm","Hitbox_RightLeg","Hitbox_LeftLeg"},
    Default = {"Head","Torso","Right Arm","Left Arm","Right Leg","Left Leg"},
    Multi = true, Text = "Parts"
})
NoCollPlusBox:AddDropdown("NoCollPlusMode", {
    Values = {"Aim Target","Aim Target and Distance","Aim Target and Distance and Limit","Distance","Distance and Limit"},
    Default = 3, Text = "Mode Selection"
})
NoCollPlusBox:AddSlider("NoCollPlusDistMe", {
    Text = "Distance From Me", Default = 200, Min = 0, Max = 301, Rounding = 0,
    FormatDisplayValue = function(_, v)
        if v == 0 then return "OFF" elseif v >= 300 then return "Unlimited" else return v.." studs" end
    end
})
NoCollPlusBox:AddSlider("NoCollPlusDistTarget", {
    Text = "Distance From Target", Default = 0, Min = 0, Max = 301, Rounding = 0,
    FormatDisplayValue = function(_, v)
        if v == 0 then return "OFF" elseif v >= 300 then return "Unlimited" else return v.." studs" end
    end
})
NoCollPlusBox:AddSlider("NoCollPlusMaxPlayers", {
    Text = "Max Players", Default = 3, Min = 0, Max = 14, Rounding = 0,
    FormatDisplayValue = function(_, v) return v == 0 and "OFF" or tostring(v) end
})
NoCollPlusBox:AddDropdown("NoCollPlusFrom", {
    Values = {"Me","Target"}, Default = {"Target"}, Text = "Distance From", Multi = true
})
NoCollPlusBox:AddToggle("IgnoreTargetPlus", {Text = "Ignore Target+", Default = false})


AnimNoCollBox:AddToggle("OnlyUppLethalNoColl", {
    Text = "Only Uppercut/Lethal No Collision", Default = false
})
AnimNoCollBox:AddDropdown("OnlyUppLethalAnims", {
    Values = {"Uppercut","Lethal"}, Default = {"Uppercut","Lethal"}, Multi = true, Text = "Animations"
})

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

TouchBox:AddToggle("TouchDestroyEnable", {Text = "Destroy moveme on touch / range", Default = false})
TouchBox:AddSlider("TouchDistance", {
    Text = "Touch Distance", Default = 5, Min = 0, Max = 10, Rounding = 1,
    FormatDisplayValue = function(_, v) return v .. " st" end
})

VisualBox:AddToggle("WaterToggle", {Text = "Water Color", Default = false})
    :AddColorPicker("WaterColor", {Default = Color3.fromRGB(255, 255, 0)})
VisualBox:AddToggle("HighlightToggle", {Text = "Highlight", Default = false})
    :AddColorPicker("HighlightColor", {Default = Color3.fromRGB(255, 0, 0)})

IgnoreBox:AddToggle("AnimIgnoreEnable", {Text = "Ignore Animations", Default = true})
IgnoreBox:AddDropdown("AnimIgnoreList", {
    Values = {"Lethal", "Hunter's Grasp"},
    Default = {"Lethal", "Hunter's Grasp"},
    Multi = true, Text = "Ignored Animations"
})

TrustBox:AddToggle("TrustingEnabled", {Text = "Trusting", Default = true})
TrustBox:AddSlider("TrustHRP",      {Text = "HumanoidRootPart", Default = 0.00, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustHead",     {Text = "Head",             Default = 0.35, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustTorso",    {Text = "Torso",            Default = 0.65, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustRightArm", {Text = "Right Arm",        Default = 0.30, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustLeftArm",  {Text = "Left Arm",         Default = 0.30, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustRightLeg", {Text = "Right Leg",        Default = 0.30, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustLeftLeg",  {Text = "Left Leg",         Default = 0.30, Min = 0, Max = 1, Rounding = 2})

-- BindToRenderStep: priority 0-2000, рендер-цикл
-- BindToSimulation: priority 0-2000, физика-цикл (PreSimulation + PostSimulation priority-sorted)
-- Misprediction:    срабатывает при обнаружении сетевой коррекции позиции (network reconciliation)
local EVENT_NAMES = {
    "PreRender","PreAnimation","PreSimulation","PostSimulation",
    "RenderStepped","Stepped","Heartbeat",
    "BindToRenderStep","BindToSimulation","Misprediction"
}

AimEventsBox:AddDropdown("AimLockEvents", {
    Values = EVENT_NAMES, Default = {"Heartbeat"}, Multi = true, Text = "Aim Lock Events"
})
AimEventsBox:AddSlider("AimBindPriority", {
    Text = "BindToRenderStep Priority", Default = 200, Min = 0, Max = 2000, Rounding = 0,
})
AimEventsBox:AddSlider("AimSimPriority", {
    Text = "BindToSimulation Priority", Default = 200, Min = 0, Max = 2000, Rounding = 0,
})

GlobalEventsBox:AddDropdown("GlobalEvents", {
    Values = EVENT_NAMES, Default = {"Heartbeat"}, Multi = true, Text = "Global Events"
})
GlobalEventsBox:AddSlider("GlobalBindPriority", {
    Text = "BindToRenderStep Priority", Default = 201, Min = 0, Max = 2000, Rounding = 0,
})
GlobalEventsBox:AddSlider("GlobalSimPriority", {
    Text = "BindToSimulation Priority", Default = 201, Min = 0, Max = 2000, Rounding = 0,
})

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

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local Stats       = game:GetService("Stats")
local Camera      = workspace.CurrentCamera
local UIS         = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local HumanoidRootPart = nil
local function refreshHRP()

    local char = LocalPlayer.Character
    if char then HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5) end
end
refreshHRP()

local lockedTarget       = nil
local silentActive       = false
local highlightObj       = nil
local waterConnections   = {}
local currentWaterColor  = Options.WaterColor.Value
local lastVel            = Vector3.zero
local lastAccel          = Vector3.zero
local lastSnapTime       = 0

local stepCurrentIdx     = 1
local stepState          = "apply"
local stepTimer          = 0
local lastFrameTime      = tick()

local elasticVel         = 0
local momentumVel        = 0
local pidIntegral        = 0
local pidLastError       = 0
local linearLastTick     = 0
local burstLastTick      = 0
local spiralTime         = 0

local velocityEnabled    = false
local velocityArmed      = false
local velocityExpire     = 0
local velocityAnimExp    = 0

local animNoCollPending  = false
local animNoCollActive   = false
local movemePredPending  = false
local movemePredActive   = false

local ANIMATION_IDS = {
    Uppercut = "10503381238",
    Lethal   = "12296113986",
}
local ANIM_NAME_BY_ID = {}
for n, id in pairs(ANIMATION_IDS) do ANIM_NAME_BY_ID[id] = n end

local aimLockConns       = {}
local aimBindNames       = {}

local globalConns        = {}
local globalBindNames    = {}

local activeConstraints  = {}
local plusModified       = {}
local plusHumConstraints = {}

local function isAlive(p)
    if not p.Character then return false end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getRoot(p)
    return p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

local bonePriorityMap = {
    ["Head"]             = "BonePriorityHead",
    ["Torso"]            = "BonePriorityTorso",
    ["HumanoidRootPart"] = "BonePriorityHRP",
    ["Left Arm"]         = "BonePriorityLeftArm",
    ["Right Arm"]        = "BonePriorityRightArm",
    ["Left Leg"]         = "BonePriorityLeftLeg",
    ["Right Leg"]        = "BonePriorityRightLeg",
}
local boneNames = {"Head","Torso","HumanoidRootPart","Left Arm","Right Arm","Left Leg","Right Leg"}

local function getTargetPart(p)
    if not p.Character then return nil end
    local char    = p.Character
    local myPos   = HumanoidRootPart and HumanoidRootPart.Position or Vector3.zero
    local mode    = Options.TargetPart.Value

    -- Direct named parts
    if mode == "HumanoidRootPart" then return char:FindFirstChild("HumanoidRootPart") end
    if mode == "Head"      then return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Torso"     then return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Left Arm"  then return char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Right Arm" then return char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Left Leg"  then return char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Right Leg" then return char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Hitbox_RightArm" then return char:FindFirstChild("Hitbox_RightArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Hitbox_LeftArm"  then return char:FindFirstChild("Hitbox_LeftArm")  or char:FindFirstChild("Left Arm")  or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Hitbox_RightLeg" then return char:FindFirstChild("Hitbox_RightLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("HumanoidRootPart") end
    if mode == "Hitbox_LeftLeg"  then return char:FindFirstChild("Hitbox_LeftLeg")  or char:FindFirstChild("Left Leg")  or char:FindFirstChild("HumanoidRootPart") end

    -- Random Limb: случайная часть с ненулевым priority
    if mode == "Random Limb" then
        local pool = {}
        for _, name in ipairs(boneNames) do
            local opt = bonePriorityMap[name]
            if opt and Options[opt].Value > 0 then
                local part = char:FindFirstChild(name)
                if part then table.insert(pool, part) end
            end
        end
        if #pool > 0 then return pool[math.random(1, #pool)] end
        return char:FindFirstChild("HumanoidRootPart")
    end

    -- Auto Limb: выбирает часть с наибольшим priority
    if mode == "Auto Limb" then
        local best, bestVal = nil, -1
        for _, name in ipairs(boneNames) do
            local opt = bonePriorityMap[name]
            if opt then
                local val = Options[opt].Value
                if val > bestVal then
                    local part = char:FindFirstChild(name)
                    if part then best = part; bestVal = val end
                end
            end
        end
        return best or char:FindFirstChild("HumanoidRootPart")
    end

    -- Nearest Part: ближайшая BasePart к нам
    if mode == "Nearest Part" then
        local nearest, nearDist = nil, math.huge
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                local d = (v.Position - myPos).Magnitude
                if d < nearDist then nearest = v; nearDist = d end
            end
        end
        return nearest or char:FindFirstChild("HumanoidRootPart")
    end

    -- Pivot: использует PrimaryPart или HRP
    if mode == "Pivot" then
        return char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
    end

    -- Center Mass: среднее положение всех BasePart → виртуальный Part не нужен, возвращаем HRP со смещением через fake
    -- Реализуем через weightedPos в основном loop, здесь возвращаем HRP как anchor
    if mode == "Center Mass" then
        return char:FindFirstChild("HumanoidRootPart")
    end

    -- Bounding Box: центр AABB всех частей
    if mode == "Bounding Box" then
        return char:FindFirstChild("HumanoidRootPart")
    end

    -- Auto: взвешенный выбор по priority + proximity
    if mode == "Auto" then
        local bestScore, bestPart = -math.huge, nil
        for _, name in ipairs(boneNames) do
            local opt = bonePriorityMap[name]
            if opt then
                local priority = Options[opt].Value
                local part = char:FindFirstChild(name)
                if part and priority > 0 then
                    local dist = (part.Position - myPos).Magnitude
                    local proxBonus = math.max(0, 1 - dist / 50) * 20
                    local score = priority + proxBonus
                    if score > bestScore then bestScore = score; bestPart = part end
                end
            end
        end
        return bestPart or char:FindFirstChild("HumanoidRootPart")
    end

    -- Bone Priority: взвешенная позиция по слайдерам
    if mode == "Bone Priority" then
        local totalWeight, weightedPos = 0, Vector3.zero
        for _, name in ipairs(boneNames) do
            local opt = bonePriorityMap[name]
            if opt then
                local w = Options[opt].Value
                if w > 0 then
                    local part = char:FindFirstChild(name)
                    if part then
                        weightedPos = weightedPos + part.Position * w
                        totalWeight = totalWeight + w
                    end
                end
            end
        end
        if totalWeight > 0 then
            -- возвращаем HRP как anchor, позиция считается в getTargetPos
            return char:FindFirstChild("HumanoidRootPart")
        end
        return char:FindFirstChild("HumanoidRootPart")
    end

    return char:FindFirstChild("HumanoidRootPart")
end

local function getTargetPos(p)
    if not p.Character then return nil end
    local char  = p.Character
    local mode  = Options.TargetPart.Value

    if mode == "Center Mass" then
        local sum, count = Vector3.zero, 0
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then sum = sum + v.Position; count = count + 1 end
        end
        if count > 0 then return sum / count end
    end

    if mode == "Bounding Box" then
        local minV = Vector3.new(math.huge, math.huge, math.huge)
        local maxV = Vector3.new(-math.huge, -math.huge, -math.huge)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                minV = Vector3.new(math.min(minV.X, v.Position.X), math.min(minV.Y, v.Position.Y), math.min(minV.Z, v.Position.Z))
                maxV = Vector3.new(math.max(maxV.X, v.Position.X), math.max(maxV.Y, v.Position.Y), math.max(maxV.Z, v.Position.Z))
            end
        end
        if minV.X ~= math.huge then return (minV + maxV) / 2 end
    end

    if mode == "Bone Priority" then
        local totalWeight, weightedPos = 0, Vector3.zero
        for _, name in ipairs(boneNames) do
            local opt = bonePriorityMap[name]
            if opt then
                local w = Options[opt].Value
                if w > 0 then
                    local part = char:FindFirstChild(name)
                    if part then
                        weightedPos = weightedPos + part.Position * w
                        totalWeight = totalWeight + w
                    end
                end
            end
        end
        if totalWeight > 0 then return weightedPos / totalWeight end
    end

    local part = getTargetPart(p)
    return part and part.Position
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

local function getPing()
    local ok, ms = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and ms then return ms / 1000 end
    return 0.05
end

local function getEventSignal(name)
    if name == "PreRender"      then return RunService.PreRender end
    if name == "PreAnimation"   then return RunService.PreAnimation end
    if name == "PreSimulation"  then return RunService.PreSimulation end
    if name == "PostSimulation" then return RunService.PostSimulation end
    if name == "RenderStepped"  then return RunService.RenderStepped end
    if name == "Stepped"        then return RunService.Stepped end
    if name == "Heartbeat"      then return RunService.Heartbeat end
    return nil
end

-- BindToSimulation: priority-based physics binding
-- реализован через sorted-таблицу коллбэков на PreSimulation
-- имитирует порядок приоритетов как BindToRenderStep, но в физика-цикле
local simCallbacks = {}  -- { {priority, id, fn}, ... }
local simConn = nil

local function rebuildSimConn()
    if simConn then pcall(function() simConn:Disconnect() end); simConn = nil end
    if #simCallbacks == 0 then return end
    table.sort(simCallbacks, function(a, b) return a[1] < b[1] end)
    simConn = RunService.PreSimulation:Connect(function(dt)
        for _, entry in ipairs(simCallbacks) do
            pcall(entry[3], dt)
        end
    end)
end

local function addSimCallback(id, priority, fn)
    table.insert(simCallbacks, {priority, id, fn})
    rebuildSimConn()
end

local function removeSimCallback(id)
    for i = #simCallbacks, 1, -1 do
        if simCallbacks[i][2] == id then table.remove(simCallbacks, i) end
    end
    rebuildSimConn()
end

-- Misprediction: детектим сетевую коррекцию позиции
-- срабатывает когда HRP смещается > порога без нашего ввода (сервер корректирует клиент)
local mispredCallbacks = {}  -- { id = fn }
local mispredConn = nil
local mispredLastPos = nil
local MISPRED_THRESHOLD = 0.5  -- studs

local function rebuildMispredConn()
    if mispredConn then pcall(function() mispredConn:Disconnect() end); mispredConn = nil end
    if next(mispredCallbacks) == nil then mispredLastPos = nil; return end
    mispredConn = RunService.PostSimulation:Connect(function(dt)
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then mispredLastPos = nil; return end
        local pos = hrp.Position
        if mispredLastPos then
            local delta = (pos - mispredLastPos).Magnitude
            -- скорость перемещения > ожидаемой → сервер скорректировал
            local vel = hrp.AssemblyLinearVelocity.Magnitude
            local expectedDelta = vel * dt + MISPRED_THRESHOLD
            if delta > expectedDelta then
                for _, fn in pairs(mispredCallbacks) do
                    pcall(fn, dt)
                end
            end
        end
        mispredLastPos = pos
    end)
end

local function addMispredCallback(id, fn)
    mispredCallbacks[id] = fn
    rebuildMispredConn()
end

local function removeMispredCallback(id)
    mispredCallbacks[id] = nil
    rebuildMispredConn()
end

local function bindMulti(selectedDict, callback, bindName, renderPriority, simPriority, connList, bindNameList)
    for _, n in ipairs(EVENT_NAMES) do
        if selectedDict[n] then
            if n == "BindToRenderStep" then
                local id = bindName .. "_rend_" .. tostring(math.random(1, 1e9))
                local ok = pcall(function()
                    RunService:BindToRenderStep(id, renderPriority, callback)
                end)
                if ok then table.insert(bindNameList, "RENDER:" .. id) end

            elseif n == "BindToSimulation" then
                local id = bindName .. "_sim_" .. tostring(math.random(1, 1e9))
                addSimCallback(id, simPriority, callback)
                table.insert(bindNameList, "SIM:" .. id)

            elseif n == "Misprediction" then
                local id = bindName .. "_misp_" .. tostring(math.random(1, 1e9))
                addMispredCallback(id, callback)
                table.insert(bindNameList, "MISP:" .. id)

            else
                local sig = getEventSignal(n)
                if sig then
                    table.insert(connList, sig:Connect(callback))
                end
            end
        end
    end
end

local function unbindAll(connList, bindNameList)
    for _, c in pairs(connList) do
        if c then pcall(function() c:Disconnect() end) end
    end
    for i = #connList, 1, -1 do connList[i] = nil end
    for _, name in pairs(bindNameList) do
        if type(name) == "string" then
            if name:sub(1, 7) == "RENDER:" then
                pcall(function() RunService:UnbindFromRenderStep(name:sub(8)) end)
            elseif name:sub(1, 4) == "SIM:" then
                removeSimCallback(name:sub(5))
            elseif name:sub(1, 5) == "MISP:" then
                removeMispredCallback(name:sub(6))
            else
                -- legacy без префикса
                pcall(function() RunService:UnbindFromRenderStep(name) end)
            end
        end
    end
    for i = #bindNameList, 1, -1 do bindNameList[i] = nil end
end

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

local function clearAllNoclip()
    for p in pairs(activeConstraints) do removeNoclip(p) end
end

local function applyPlus(p)
    if not p.Character then return end
    local sel = Options.NoCollPlusParts.Value or {}
    local set = plusModified[p] or {}
    for partName, on in pairs(sel) do
        if on then
            local part = p.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
                set[part] = true
            end
        end
    end
    plusModified[p] = set
end

local function restorePlus(p)
    local set = plusModified[p]
    if set then
        for part in pairs(set) do
            if part and part.Parent then
                pcall(function() part.CanCollide = true end)
            end
        end
        plusModified[p] = nil
    end
    local cons = plusHumConstraints[p]
    if cons then
        for _, c in pairs(cons) do if c then pcall(function() c:Destroy() end) end end
        plusHumConstraints[p] = nil
    end
end

local function clearAllPlus()
    for p in pairs(plusModified) do restorePlus(p) end
    for p in pairs(plusHumConstraints) do restorePlus(p) end
end

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

local animIgnoreMap = {
    ["Lethal"]          = "rbxassetid://12296113986",
    ["Hunter's Grasp"]  = "rbxassetid://12309835105",
}

local function isBlockedAnimationPlaying()
    if not Toggles.AnimIgnoreEnable.Value then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return false end
    local selected = Options.AnimIgnoreList.Value or {}
    local active = {}
    for name, on in pairs(selected) do
        if on then active[animIgnoreMap[name]] = true end
    end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        if anim then
            local id = anim.AnimationId:match("%d+")
            if id and active["rbxassetid://"..id] then return true end
        end
    end
    return false
end

local function isVelocityAllowed()
    if not Toggles.VelocityModify.Value then return false end
    local mode = Options.VelocityMode.Value
    if mode == "Keybind"      then return velocityEnabled
    elseif mode == "Keybind Once" then return velocityArmed
    elseif mode == "Keybind Time" then return tick() < velocityExpire
    elseif mode == "Animation"    then return tick() < velocityAnimExp
    end
    return false
end

local function modifyBodyVelocity(v)
    if not v:IsA("BodyVelocity") then return end
    if v.Name ~= "moveme" then return end

    if Toggles.TouchDestroyEnable.Value then
        local conn; conn = RunService.Heartbeat:Connect(function()
            if not v.Parent then if conn then conn:Disconnect() end return end
            if not lockedTarget or not isAlive(lockedTarget) then return end
            local r = getRoot(lockedTarget)
            if not r or not HumanoidRootPart then return end
            local d = (r.Position - HumanoidRootPart.Position).Magnitude
            if d <= Options.TouchDistance.Value then
                pcall(function() v:Destroy() end)
                if conn then conn:Disconnect() end
            end
        end)
    end

    if Toggles.OnlyUppLethalNoColl.Value and animNoCollPending then
        animNoCollActive  = true
        animNoCollPending = false
        local conn; conn = v.AncestryChanged:Connect(function()
            if not v.Parent then
                animNoCollActive = false
                if conn then conn:Disconnect() end
            end
        end)
    end

    if movemePredPending then
        movemePredActive  = true
        movemePredPending = false
        local conn; conn = v.AncestryChanged:Connect(function()
            if not v.Parent then
                movemePredActive = false
                if conn then conn:Disconnect() end
            end
        end)
    end

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

local animLoopActive = false

local function startAnimLoop()
    animLoopActive = true
end

local function stopAnimLoop()
    animLoopActive = false
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
    if mode == "Keybind"      then velocityEnabled = not velocityEnabled
    elseif mode == "Keybind Once" then velocityArmed = true
    elseif mode == "Keybind Time" then velocityExpire = tick() + Options.VelocityTime.Value
    end
end)

local function stopLock()
    unbindAll(aimLockConns, aimBindNames)
    silentActive = false
    lockedTarget = nil
    lastVel      = Vector3.zero
    lastAccel    = Vector3.zero
    lastSnapTime = 0
    stepCurrentIdx = 1
    stepState      = "apply"
    stepTimer      = 0
    elasticVel     = 0
    momentumVel    = 0
    pidIntegral    = 0
    pidLastError   = 0
    linearLastTick = 0
    burstLastTick  = 0
    spiralTime     = 0
    if highlightObj then highlightObj:Destroy(); highlightObj = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end

local function applyOffset(predicted, myPos)
    if not Toggles.OffsetEnable.Value then return predicted end
    local dir = Vector3.new(predicted.X - myPos.X, 0, predicted.Z - myPos.Z)
    if dir.Magnitude < 0.01 then return predicted end
    dir = dir.Unit
    local right = Vector3.new(dir.Z, 0, -dir.X).Unit
    local sign  = (Options.OffsetSide.Value == "Right") and 1 or -1
    return predicted + right * (sign * Options.OffsetAmount.Value)
end

local function updateAim()
    if not silentActive then return end

    local char = LocalPlayer.Character
    if not char then stopLock(); return end

    if not HumanoidRootPart or not HumanoidRootPart.Parent then
        HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then return end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then stopLock(); return end

    if not lockedTarget or not lockedTarget.Character then stopLock(); return end
    local tgtHum = lockedTarget.Character:FindFirstChildOfClass("Humanoid")
    if not tgtHum or tgtHum.Health <= 0 then stopLock(); return end

    if isRagdolled(char) or isBlockedAnimationPlaying() then
        hum.AutoRotate = true
        return
    end

    local root   = getRoot(lockedTarget)
    local visual = getTargetPart(lockedTarget) or root
    if not root or not visual then stopLock(); return end

    hum.AutoRotate = false

    local myPos   = HumanoidRootPart.Position
    local rootPos = root.Position

    local function applyRotation(newCFrame)
        HumanoidRootPart.CFrame = newCFrame
    end

    local partName    = Options.TargetPart.Value
    local isLimb      = partName:find("Arm") or partName:find("Leg")
    local resolvedPos = getTargetPos(lockedTarget) or visual.Position
    local visualPos   = resolvedPos

    local targetPos
    if Toggles.TrustingEnabled.Value then
        -- универсальный trust blend: rootPos → resolvedPos
        local trustMap = {
            ["HumanoidRootPart"] = Options.TrustHRP.Value,
            ["Head"]      = Options.TrustHead.Value,
            ["Torso"]     = Options.TrustTorso.Value,
            ["Right Arm"] = Options.TrustRightArm.Value,
            ["Left Arm"]  = Options.TrustLeftArm.Value,
            ["Right Leg"] = Options.TrustRightLeg.Value,
            ["Left Leg"]  = Options.TrustLeftLeg.Value,
        }
        local blend = trustMap[partName] or Options.TrustTorso.Value
        local blendedPos = rootPos:Lerp(visualPos, blend)
        blendedPos = blendedPos:Lerp(rootPos, 0.2)
        targetPos = Vector3.new(blendedPos.X, myPos.Y, blendedPos.Z)
    else
        targetPos = Vector3.new(visualPos.X, myPos.Y, visualPos.Z)
    end

    local vel   = root.AssemblyLinearVelocity
    local accel = vel - lastVel
    lastVel    = vel
    lastAccel  = accel

    local speed    = vel.Magnitude
    local distance = (HumanoidRootPart.Position - rootPos).Magnitude

    local velForPred = vel

    if isLimb then
        velForPred = velForPred:Lerp(lastVel, 0.35) * 0.80
    end

    local LeadSpeed     = math.max(Options.LeadSpeed.Value, 1)
    local AggrLeadSpeed = math.max(Options.AggrLeadSpeed.Value, 1)

    local predSpeed = speed
    local t      = distance / (LeadSpeed + math.max(predSpeed, 1))
    local tAggr  = distance / (AggrLeadSpeed + math.max(predSpeed, 1))

    local movMult = 1.0
    if movemePredActive then
        local sel = Options.MovemePredAnims.Value or {}
        local any = false
        for k, on in pairs(sel) do if on then any = true break end end
        if any then movMult = Options.MovemePredMult.Value / 100 end
    end

    local predicted = targetPos

    local predMul = Options.PredMultiple and Options.PredMultiple.Value or 1.0

    if Toggles.AccelPredEnable.Value then
        local mult     = (Options.PredStrength.Value / 100) * movMult * predMul
        local midVel   = velForPred + 0.5 * accel * t
        local offset   = midVel * t * mult + 0.5 * accel * (t ^ 2) * mult
        predicted = Vector3.new(targetPos.X + offset.X, myPos.Y, targetPos.Z + offset.Z)
    elseif Toggles.PredEnable.Value then
        local mult   = (Options.PredStrength.Value / 100) * movMult * predMul
        local offset = velForPred * t * mult
        predicted = Vector3.new(targetPos.X + offset.X, myPos.Y, targetPos.Z + offset.Z)
    end

    local aggrPredMul = Options.AggrPredMultiple and Options.AggrPredMultiple.Value or 1.0

    if Toggles.AggrAccelEnable.Value then
        local mult       = (Options.AggrStrength.Value / 100) * movMult * aggrPredMul
        local speedBoost = 1 + bound(speed / 25, 0, 4) * mult
        local midVel     = velForPred + 0.5 * accel * tAggr
        local aggrOffset = midVel * tAggr * speedBoost + accel * (tAggr ^ 2 * 0.6) * mult
        local maxOffset  = (15 + distance * 0.1) * math.max(mult, 0.1)
        if aggrOffset.Magnitude > maxOffset then aggrOffset = aggrOffset.Unit * maxOffset end
        local aggrPred = Vector3.new(targetPos.X + aggrOffset.X, myPos.Y, targetPos.Z + aggrOffset.Z)
        predicted = predicted:Lerp(aggrPred, mult)
        predicted = predicted + Vector3.new(velForPred.X * 0.15, 0, velForPred.Z * 0.15)
    elseif Toggles.AggrEnable.Value then
        local mult       = (Options.AggrStrength.Value / 100) * movMult * aggrPredMul
        local speedBoost = 1 + bound(speed / 25, 0, 4) * mult
        local aggrOffset = velForPred * tAggr * speedBoost
        local maxOffset  = (15 + distance * 0.1) * math.max(mult, 0.1)
        if aggrOffset.Magnitude > maxOffset then aggrOffset = aggrOffset.Unit * maxOffset end
        local aggrPred = Vector3.new(targetPos.X + aggrOffset.X, myPos.Y, targetPos.Z + aggrOffset.Z)
        predicted = predicted:Lerp(aggrPred, mult)
        predicted = predicted + Vector3.new(velForPred.X * 0.15, 0, velForPred.Z * 0.15)
    end

    predicted = applyOffset(predicted, myPos)

    predicted = Vector3.new(predicted.X, myPos.Y, predicted.Z)

    local targetCFrame  = CFrame.new(myPos, predicted)
    local currentCFrame = HumanoidRootPart.CFrame
    local aimMode       = Options.AimMode.Value

    local currentLook = currentCFrame.LookVector
    local targetLook  = targetCFrame.LookVector
    local dotProduct  = currentLook:Dot(targetLook)
    local angleDiff   = math.deg(math.acos(bound(dotProduct, -1, 1)))

    local baseSpeed  = Options.AimBlendFactor.Value / 100
    local speedMult  = Options.AimSpeed and (Options.AimSpeed.Value / 100) or 1
    local angleBoost = 1 + (angleDiff / 45) ^ 1.5
    local finalBlend = bound(baseSpeed * speedMult * angleBoost, 0, 1)

    local now = tick()
    local dt  = now - lastFrameTime
    lastFrameTime = now
    if dt <= 0 then dt = 1/60 end

    -- ========== INSTANT ==========
    if aimMode == "Instant" then
        applyRotation(targetCFrame)

    -- ========== AGGRESSIVE ==========
    elseif aimMode == "Aggressive" then
        local aggrMult  = Options.AggressiveMultiplier and Options.AggressiveMultiplier.Value or 1
        local aggrBlend = bound(finalBlend * (1.5 + aggrMult), 0.85, 1)
        applyRotation(currentCFrame:Lerp(targetCFrame, aggrBlend))

    -- ========== LERP ==========
    elseif aimMode == "Lerp" then
        local lerpMult   = Options.LerpMultiplier and Options.LerpMultiplier.Value or 1.0
        local smartBlend = bound(finalBlend ^ 0.75 * 1.2 * lerpMult, 0, 1.0)
        applyRotation(currentCFrame:Lerp(targetCFrame, smartBlend))

    -- ========== ° (Degree turn-speed rotation) ==========
    elseif aimMode == "\194\176" then
        local turnSpd = Options.TurnSpeed.Value * Options.DegreeMultA.Value * Options.DegreeMultB.Value
        local rawDir = predicted - myPos
        if rawDir.Magnitude < 0.01 then return end
        local targetDir  = rawDir.Unit
        local currentDir = HumanoidRootPart.CFrame.LookVector
        local dotD   = math.clamp(currentDir:Dot(targetDir), -1, 1)
        local angleD = math.acos(dotD)
        if angleD < 0.0005 then return end
        local maxStep = math.rad(turnSpd) * dt
        local tgtCF   = CFrame.lookAt(myPos, myPos + targetDir)
        if angleD <= maxStep then
            applyRotation(tgtCF)
        else
            applyRotation(HumanoidRootPart.CFrame:Lerp(tgtCF, maxStep / angleD))
        end

    -- ========== SNAP ==========
    elseif aimMode == "Snap" then
        local snapThreshold = Options.SnapThreshold and Options.SnapThreshold.Value or 15
        local snapDelay     = Options.SnapSpeedDelay and Options.SnapSpeedDelay.Value or 0.08

        if now - lastSnapTime >= snapDelay then
            lastSnapTime = now
            if angleDiff <= snapThreshold then
                -- в пределах threshold — снапим сразу на цель
                applyRotation(targetCFrame)
            else
                -- поворачиваем ровно на snapThreshold° в направлении цели
                local rawDir = predicted - myPos
                if rawDir.Magnitude >= 0.01 then
                    local tgtCF = CFrame.lookAt(myPos, myPos + rawDir.Unit)
                    local t     = math.rad(snapThreshold) / math.rad(angleDiff)
                    applyRotation(currentCFrame:Lerp(tgtCF, t))
                end
            end
        end

    -- ========== STEP (multi-step sweep) ==========
    elseif aimMode == "Step" then
        local numSteps = tonumber(Options.StepSteps.Value) or 2
        local thresholds = {
            Options.Step1Threshold.Value,
            Options.Step2Threshold.Value,
            Options.Step3Threshold.Value,
            Options.Step4Threshold.Value,
        }
        local delays = {
            Options.Step1Delay.Value,
            Options.Step2Delay.Value,
            Options.Step3Delay.Value,
            Options.Step4Delay.Value,
        }

        if stepState == "repeat" then
            stepTimer = stepTimer - dt
            if stepTimer <= 0 then
                stepCurrentIdx = 1
                stepState = "apply"
            end
        elseif stepState == "delay" then
            stepTimer = stepTimer - dt
            if stepTimer <= 0 then
                stepCurrentIdx = stepCurrentIdx + 1
                if stepCurrentIdx > numSteps then
                    stepState = "repeat"
                    stepTimer = Options.StepRepeatDelay.Value / 1000
                else
                    stepState = "apply"
                end
            end
        end

        if stepState == "apply" then
            local threshold = thresholds[stepCurrentIdx] or 0
            local threshRad = math.rad(math.abs(threshold))

            local forward = HumanoidRootPart.CFrame.LookVector
            local flatFwd = Vector3.new(forward.X, 0, forward.Z)
            if flatFwd.Magnitude >= 0.01 then flatFwd = flatFwd.Unit else flatFwd = Vector3.new(0,0,-1) end

            local toTgt = Vector3.new(predicted.X - myPos.X, 0, predicted.Z - myPos.Z)
            if toTgt.Magnitude >= 0.01 then
                toTgt = toTgt.Unit
                local crossY     = flatFwd:Cross(toTgt).Y
                local dotVal     = math.clamp(flatFwd:Dot(toTgt), -1, 1)
                local angleToTgt = math.acos(dotVal)

                local canReach = false
                if threshold < 0 then
                    canReach = crossY > 0 and angleToTgt <= threshRad
                elseif threshold > 0 then
                    canReach = crossY < 0 and angleToTgt <= threshRad
                else
                    canReach = angleToTgt < 0.01
                end

                if canReach then
                    applyRotation(CFrame.lookAt(myPos, myPos + toTgt))
                else
                    local rotAngle = -math.rad(threshold)
                    local newDir   = CFrame.Angles(0, rotAngle, 0):VectorToWorldSpace(flatFwd)
                    applyRotation(CFrame.lookAt(myPos, myPos + Vector3.new(newDir.X, 0, newDir.Z)))
                end
            end

            stepState = "delay"
            stepTimer = delays[stepCurrentIdx] or 0
        end

    -- ========== MAGNETIC ==========
    elseif aimMode == "Magnetic" then
        local strength  = Options.MagneticStrength.Value / 100
        local dtFactor  = bound(dt * Options.TargetHz.Value, 0.1, 4)
        local expPull   = (math.exp(strength * 4.0) - 1) / (math.exp(4.0) - 1)
        local distBoost = 1 + bound(1 - distance / 50, 0, 1.0)
        local blend     = bound(expPull * distBoost * dtFactor, 0.005, 1)
        applyRotation(currentCFrame:Lerp(targetCFrame, blend))

    -- ========== ADAPTIVE ==========
    elseif aimMode == "Adaptive" then
        local minB = (Options.AdaptiveMinBlend and Options.AdaptiveMinBlend.Value or 20) / 100
        local maxB = (Options.AdaptiveMaxBlend and Options.AdaptiveMaxBlend.Value or 95) / 100
        local distFactor  = bound(1 - (distance / 60), 0.1, 1)
        local speedFactor = bound(speed / 50, 0, 1)
        local angleFactor = bound(angleDiff / 90, 0, 1)
        local raw = (distFactor * 0.3 + speedFactor * 0.4 + angleFactor * 0.3) * speedMult
        local adaptiveBlend = bound(minB + raw * (maxB - minB), minB, maxB)
        applyRotation(currentCFrame:Lerp(targetCFrame, adaptiveBlend))

    -- ========== HYBRID ==========
    elseif aimMode == "Hybrid" then
        if speed >= Options.HybridThreshold.Value or angleDiff > 30 then
            applyRotation(targetCFrame)
        else
            local hybridBlend = bound(finalBlend * 1.5, 0.5, 1)
            applyRotation(currentCFrame:Lerp(targetCFrame, hybridBlend))
        end

    -- ========== LINEAR ==========
    elseif aimMode == "Linear" then
        local ups      = Options.LinearUpdatePerSecond.Value
        local maxAngle = Options.LinearMaxAnglePerTurn.Value
        if now - linearLastTick >= 1 / ups then
            linearLastTick = now
            local rawDir = predicted - myPos
            if rawDir.Magnitude >= 0.01 then
                local tgtCF = CFrame.lookAt(myPos, myPos + rawDir.Unit)
                if angleDiff <= maxAngle then
                    applyRotation(tgtCF)
                else
                    local t = math.rad(maxAngle) / math.rad(angleDiff)
                    applyRotation(currentCFrame:Lerp(tgtCF, t))
                end
            end
        end

    -- ========== BURST ==========
    elseif aimMode == "Burst" then
        local ups      = Options.BurstUpdatePerSecond.Value
        local strength = Options.BurstStrength.Value / 100
        if now - burstLastTick >= 1 / ups then
            burstLastTick = now
            applyRotation(currentCFrame:Lerp(targetCFrame, strength))
        end

    -- ========== VELOCITY AIM ==========
    elseif aimMode == "Velocity Aim" then
        local base     = Options.VelocityAimStrength.Value / 100
        local scale    = Options.VelocityAimScale.Value
        local velScale = bound(speed / scale, 0.1, 5)
        local blend    = bound(base * velScale, 0.01, 1)
        applyRotation(currentCFrame:Lerp(targetCFrame, blend))

    -- ========== SPIRAL ==========
    elseif aimMode == "Spiral" then
        local freq = Options.SpiralFrequency.Value
        local amp  = math.rad(Options.SpiralAmplitude.Value)
        spiralTime = spiralTime + dt
        local rawDir = predicted - myPos
        if rawDir.Magnitude >= 0.01 then
            local baseDir = rawDir.Unit
            local perp    = Vector3.new(-baseDir.Z, 0, baseDir.X)
            local wobble  = math.sin(spiralTime * freq) * amp
            local spiralDir = (baseDir + perp * wobble)
            if spiralDir.Magnitude >= 0.01 then
                spiralDir = spiralDir.Unit
                local tgtCF = CFrame.lookAt(myPos, myPos + Vector3.new(spiralDir.X, 0, spiralDir.Z))
                applyRotation(currentCFrame:Lerp(tgtCF, bound(finalBlend, 0.05, 1)))
            end
        end
    end
end

local function startLock()
    local char = LocalPlayer.Character
    if not char then return end
    if not HumanoidRootPart or not HumanoidRootPart.Parent then
        HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    end
    if not HumanoidRootPart then return end

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
    lastAccel    = Vector3.zero
    updateHighlight()

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = false end

    local sel = Options.AimLockEvents.Value or {}
    local hasAny = false
    for _, v in pairs(sel) do if v then hasAny = true break end end
    if not hasAny then sel = {Heartbeat = true} end
    bindMulti(sel, updateAim, "AimLockBind", Options.AimBindPriority.Value, Options.AimSimPriority.Value, aimLockConns, aimBindNames)
end

Options.AimLockKey:OnClick(function()
    if not Toggles.AimLock.Value then return end
    if silentActive then stopLock() else startLock() end
end)

local function rebindAim()
    if silentActive then
        unbindAll(aimLockConns, aimBindNames)
        local sel = Options.AimLockEvents.Value or {}
        bindMulti(sel, updateAim, "AimLockBind", Options.AimBindPriority.Value, Options.AimSimPriority.Value, aimLockConns, aimBindNames)
    end
end
Options.AimLockEvents:OnChanged(rebindAim)
Options.AimBindPriority:OnChanged(rebindAim)

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

local function noCollisionTick()
    local animGate = false
    if Toggles.OnlyUppLethalNoColl.Value then
        animGate = animNoCollActive
    end

    local constraintsOn = Toggles.TargetNoColl.Value
    local plusOn        = Toggles.NoCollPlus.Value

    if Toggles.OnlyUppLethalNoColl.Value and not animGate then
        clearAllNoclip()
        clearAllPlus()
        return
    end

    if not constraintsOn and not plusOn then
        clearAllNoclip()
        clearAllPlus()
        return
    end
    if not LocalPlayer.Character then return end

    local function processSet(modeOpt, distMeOpt, distTargetOpt, fromOpt, maxOpt, applyFn, removeFn, activeTbl, ignoreTarget)
        local MODE        = modeOpt
        local MAX_PLAYERS = maxOpt
        local candidates  = {}
        local useFrom   = fromOpt or {}
        local useMe     = useFrom["Me"]
        local useTarget = useFrom["Target"]
        local maxMe     = distMeOpt
        local maxTarget = distTargetOpt
        ignoreTarget = ignoreTarget or false

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isAlive(p) then
                if ignoreTarget and p == lockedTarget then
                    removeFn(p)
                else
                    if p == lockedTarget then
                        table.insert(candidates, {player = p, distance = 0})
                    else
                        local valid     = false
                        local finalDist = math.huge
                        if useMe and maxMe > 0 then
                            local d = getDistance(LocalPlayer, p)
                            if maxMe >= 300 or d <= maxMe then
                                valid = true; finalDist = math.min(finalDist, d)
                            end
                        end
                        if useTarget and maxTarget > 0 and lockedTarget and isAlive(lockedTarget) then
                            local d = getDistance(lockedTarget, p)
                            if maxTarget >= 300 or d <= maxTarget then
                                valid = true; finalDist = math.min(finalDist, d)
                            end
                        end
                        if valid then
                            table.insert(candidates, {player = p, distance = finalDist})
                        else
                            removeFn(p)
                        end
                    end
                end
            else
                removeFn(p)
            end
        end

        table.sort(candidates, function(a, b) return a.distance < b.distance end)

        local used = {}
        local count = 0
        for _, data in ipairs(candidates) do
            local p = data.player
            if MODE == "Aim Target" then
                if p == lockedTarget and not ignoreTarget then applyFn(p); used[p] = true end
            elseif MODE == "Aim Target and Distance" then
                if (p == lockedTarget and not ignoreTarget) or data.distance ~= math.huge then
                    applyFn(p); used[p] = true
                end
            elseif MODE == "Aim Target and Distance and Limit" then
                if p == lockedTarget and not ignoreTarget then
                    applyFn(p); used[p] = true
                elseif data.distance ~= math.huge and (MAX_PLAYERS == 0 or count < MAX_PLAYERS) then
                    applyFn(p); used[p] = true; count = count + 1
                end
            elseif MODE == "Distance" then
                if data.distance ~= math.huge then applyFn(p); used[p] = true end
            elseif MODE == "Distance and Limit" then
                if data.distance ~= math.huge and (MAX_PLAYERS == 0 or count < MAX_PLAYERS) then
                    applyFn(p); used[p] = true; count = count + 1
                end
            end
        end

        for p in pairs(activeTbl) do
            if not used[p] then removeFn(p) end
        end
    end

    if constraintsOn then
        processSet(
            Options.ModeSelection.Value,
            Options.MaxDistanceMe.Value,
            Options.MaxDistanceTarget.Value,
            Options.DistanceFrom.Value,
            Options.MaxPlayers.Value,
            createNoclip, removeNoclip, activeConstraints,
            Toggles.IgnoreTarget.Value
        )
    else
        clearAllNoclip()
    end

    if plusOn then
        processSet(
            Options.NoCollPlusMode.Value,
            Options.NoCollPlusDistMe.Value,
            Options.NoCollPlusDistTarget.Value,
            Options.NoCollPlusFrom.Value,
            Options.NoCollPlusMaxPlayers.Value,
            applyPlus, restorePlus, plusModified,
            Toggles.IgnoreTargetPlus.Value
        )
    else
        clearAllPlus()
    end
end

local dashBarsTick = nil

local function globalTick(dt)
    -- Velocity anim detection (runs in global event, не хардкод Heartbeat)
    if animLoopActive and Toggles.VelocityModify.Value and Options.VelocityMode.Value == "Animation" then
        local animMode = Options.VelocityAnimMode.Value
        if isTargetAnimPlaying() then
            if animMode == "Time" then
                velocityAnimExp = tick() + Options.VelocityAnimTime.Value
            elseif animMode == "Once" and velocityAnimExp == 0 then
                velocityAnimExp = tick() + 999
            end
        end
    end
    noCollisionTick()
    if dashBarsTick then dashBarsTick() end
end

local function rebindGlobal()
    unbindAll(globalConns, globalBindNames)
    local sel = Options.GlobalEvents.Value or {}
    bindMulti(sel, globalTick, "GlobalBind", Options.GlobalBindPriority.Value, Options.GlobalSimPriority.Value, globalConns, globalBindNames)
end
rebindGlobal()
Options.GlobalEvents:OnChanged(rebindGlobal)
Options.GlobalBindPriority:OnChanged(rebindGlobal)

local PENDING_WINDOW = 1  

local function setupAnimDetect(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    local animator = hum:WaitForChild("Animator", 5)
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local name = ANIM_NAME_BY_ID[id]
        if not name then return end

        if Toggles.OnlyUppLethalNoColl.Value then
            local sel = Options.OnlyUppLethalAnims.Value or {}
            if sel[name] then
                animNoCollPending = true
                task.delay(PENDING_WINDOW, function()
                    animNoCollPending = false
                end)
            end
        end

        do
            local sel = Options.MovemePredAnims.Value or {}
            if sel[name] then
                movemePredPending = true
                task.delay(PENDING_WINDOW, function()
                    movemePredPending = false
                end)
            end
        end
    end)
end

local function onCharacterAdded(char)
    stopLock()
    clearAllNoclip()
    clearAllPlus()
    velocityEnabled = false
    velocityArmed   = false
    velocityExpire  = 0
    velocityAnimExp = 0
    animNoCollPending = false
    animNoCollActive  = false
    movemePredPending = false
    movemePredActive  = false
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
    char.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
    if Toggles.WaterToggle.Value then task.wait(0.5); setupWater(char) end
    setupAnimDetect(char)
end

Players.PlayerRemoving:Connect(function(p) removeNoclip(p); restorePlus(p) end)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterAdded:Connect(refreshHRP)

if LocalPlayer.Character then
    LocalPlayer.Character.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
    setupAnimDetect(LocalPlayer.Character)
end

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("TSBUtility")
SaveManager:SetFolder("TSBUtility/tsb")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

do
    local Workspace   = game:GetService("Workspace")
    local LiveFolder  = Workspace:WaitForChild("Live")

    local cdGui = Instance.new("ScreenGui")
    cdGui.Name            = "CooldownBars"
    cdGui.ResetOnSpawn    = false
    cdGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    cdGui.Parent          = LocalPlayer:WaitForChild("PlayerGui")

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

        local label = Instance.new("TextLabel")
        label.Size               = UDim2.new(0.45, 0, 1, 0)
        label.Position           = UDim2.new(0, 4, 0, 0)
        label.BackgroundTransparency = 1
        label.TextScaled         = true
        label.TextXAlignment     = Enum.TextXAlignment.Left
        label.Font               = Enum.Font.SourceSansBold
        label.Text               = name
        label.Parent             = frame

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
            frame = frame, fill = fill, label = label, timerLbl = timerLbl,
            bgCorner = bgCorner, fillCorner = fillCorner,
            time = 0, duration = def.cooldown,
        }
    end

    for _, name in ipairs(abilityOrder) do createCdBar(name) end

    local _lastBarTime = tick()
    dashBarsTick = function()
        local now = tick()
        local dt = now - _lastBarTime
        _lastBarTime = now
        if dt <= 0 then dt = 1/60 end
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
            local frame    = data.frame
            local fill     = data.fill
            local label    = data.label
            local timerLbl = data.timerLbl

            if data.time > 0 then
                data.time = math.max(data.time - dt, 0)
            end

            local ratio = 1 - (data.time / data.duration)

            local xOff = startX + (i - 1) * (width + spacing)
            frame.Size     = UDim2.new(0, width, 0, height)
            frame.Position = UDim2.new(posX, xOff, posY, 0)

            data.bgCorner.CornerRadius   = UDim.new(0, corner)
            data.fillCorner.CornerRadius = UDim.new(0, corner)

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
            elseif showNumbers then
                frame.Visible                = true
                fill.Visible                 = false
                frame.BackgroundTransparency = 1
            else
                frame.Visible = false
            end

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
    end

    local function cdTrigger(name)
        if cdBars[name] then
            cdBars[name].time = cdBars[name].duration
        end
    end

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

    LiveFolder.DescendantAdded:Connect(function(child)
        if child.Name == "RagdollCancel" and child.Parent == LocalPlayer.Character then
            cdTrigger("Evasive")
        end
    end)
end