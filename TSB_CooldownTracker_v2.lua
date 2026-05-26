local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player     = Players.LocalPlayer
local LiveFolder = Workspace:WaitForChild("Live")

local repo    = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

local BLACK   = Color3.fromRGB(0,   0,   0  )
local WHITE   = Color3.fromRGB(255, 255, 255)
local READY_C = Color3.fromRGB(120, 255, 120)

local FONT_MAP = {
    ["GothamBold"]     = Enum.Font.GothamBold,
    ["GothamBlack"]    = Enum.Font.GothamBlack,
    ["Gotham"]         = Enum.Font.Gotham,
    ["GothamMedium"]   = Enum.Font.GothamMedium,
    ["SourceSansBold"] = Enum.Font.SourceSansBold,
    ["SourceSans"]     = Enum.Font.SourceSans,
    ["RobotoMono"]     = Enum.Font.RobotoMono,
    ["Fantasy"]        = Enum.Font.Fantasy,
    ["SciFi"]          = Enum.Font.SciFi,
    ["Arcade"]         = Enum.Font.Arcade,
    ["Highway"]        = Enum.Font.Highway,
    ["Cartoon"]        = Enum.Font.Cartoon,
    ["Bodoni"]         = Enum.Font.Bodoni,
    ["Garamond"]       = Enum.Font.Garamond,
}

local FONT_LIST = {
    "GothamBold","GothamBlack","Gotham","GothamMedium",
    "SourceSansBold","SourceSans","RobotoMono",
    "Fantasy","SciFi","Arcade","Highway","Cartoon","Bodoni","Garamond",
}

local Window = Library:CreateWindow({
    Title            = "Cooldown Tracker",
    Footer           = "Dash",
    ShowCustomCursor = true,
})

local Tabs = {
    Main     = Window:AddTab("Bars",     "box"),
    Overhead = Window:AddTab("Overhead", "user"),
    Effects  = Window:AddTab("Effects",  "star"),
}

-- ── Bar Layout ────────────────────────────────────────────────────────────────
local LayoutBox = Tabs.Main:AddLeftGroupbox("Bar Layout")
LayoutBox:AddSlider("Width",      { Text="Bar Width",       Default=165,  Min=60,   Max=300            })
LayoutBox:AddSlider("Height",     { Text="Bar Height",      Default=24,   Min=8,    Max=80             })
LayoutBox:AddSlider("Spacing",    { Text="Bar Spacing",     Default=12,   Min=0,    Max=60             })
LayoutBox:AddSlider("Corner",     { Text="Corner Radius",   Default=8,    Min=0,    Max=20             })
LayoutBox:AddSlider("PosX",       { Text="Position X",      Default=0.5,  Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("PosY",       { Text="Position Y",      Default=0.85, Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("BGTransp",   { Text="BG Opacity",      Default=0.2,  Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("FillTransp", { Text="Fill Opacity",    Default=0,    Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("TextSize",   { Text="Number Size",     Default=14,   Min=6,    Max=32             })
LayoutBox:AddSlider("LabelSize",  { Text="Label Size",      Default=10,   Min=6,    Max=22             })
LayoutBox:AddSlider("FillSpeed",  { Text="Fill Lerp Speed", Default=9,    Min=1,    Max=30             })

local TogBox = Tabs.Main:AddLeftGroupbox("Toggles")
TogBox:AddToggle("ShowBars",    { Text="Show Bars",           Default=true  })
TogBox:AddToggle("ShowNumbers", { Text="Show Numbers",        Default=true  })
TogBox:AddToggle("ShowLabels",  { Text="Show Ability Labels", Default=true  })
TogBox:AddToggle("ShowReady",   { Text="Show READY text",     Default=true  })
TogBox:AddToggle("ShowPercent", { Text="Percentage Mode",     Default=false })
TogBox:AddToggle("ShowBorder",  { Text="Show Border Stroke",  Default=true  })
TogBox:AddToggle("ShowShine",   { Text="Shine Highlight",     Default=true  })
TogBox:AddToggle("ShowGlow",    { Text="Glow Effect",         Default=true  })
TogBox:AddDropdown("FillDir",   { Values={"Left","Right"}, Default=1, Text="Fill Direction" })
TogBox:AddDropdown("FontChoice",{ Values=FONT_LIST, Default=1, Text="Bar Font" })

-- ── Dash Colors ───────────────────────────────────────────────────────────────
local DashClr = Tabs.Main:AddRightGroupbox("Dash Colors")
DashClr:AddLabel("Fill"):AddColorPicker("DashFill",     { Default=Color3.fromRGB(60,  200, 255) })
DashClr:AddLabel("Numbers"):AddColorPicker("DashNum",   { Default=Color3.fromRGB(255, 255, 255) })
DashClr:AddLabel("Background"):AddColorPicker("DashBG", { Default=Color3.fromRGB(8,   20,  45 ) })
DashClr:AddLabel("Label"):AddColorPicker("DashLbl",     { Default=Color3.fromRGB(140, 210, 255) })
DashClr:AddLabel("Border"):AddColorPicker("DashBorder", { Default=Color3.fromRGB(60,  180, 255) })

-- ── Side Colors ───────────────────────────────────────────────────────────────
local SideClr = Tabs.Main:AddRightGroupbox("Side Colors")
SideClr:AddLabel("Fill"):AddColorPicker("SideFill",     { Default=Color3.fromRGB(255, 200, 0  ) })
SideClr:AddLabel("Numbers"):AddColorPicker("SideNum",   { Default=Color3.fromRGB(255, 255, 255) })
SideClr:AddLabel("Background"):AddColorPicker("SideBG", { Default=Color3.fromRGB(28,  22,  0  ) })
SideClr:AddLabel("Label"):AddColorPicker("SideLbl",     { Default=Color3.fromRGB(255, 225, 80 ) })
SideClr:AddLabel("Border"):AddColorPicker("SideBorder", { Default=Color3.fromRGB(255, 190, 0  ) })

-- ── Evasive Colors ────────────────────────────────────────────────────────────
local EvaClr = Tabs.Main:AddRightGroupbox("Evasive Colors")
EvaClr:AddLabel("Fill"):AddColorPicker("EvaFill",     { Default=Color3.fromRGB(255, 75,  75 ) })
EvaClr:AddLabel("Numbers"):AddColorPicker("EvaNum",   { Default=Color3.fromRGB(255, 255, 255) })
EvaClr:AddLabel("Background"):AddColorPicker("EvaBG", { Default=Color3.fromRGB(35,  6,   6  ) })
EvaClr:AddLabel("Label"):AddColorPicker("EvaLbl",     { Default=Color3.fromRGB(255, 130, 130) })
EvaClr:AddLabel("Border"):AddColorPicker("EvaBorder", { Default=Color3.fromRGB(255, 70,  70 ) })

-- ── Overhead Settings ─────────────────────────────────────────────────────────
local OHBox = Tabs.Overhead:AddLeftGroupbox("Overhead Settings")
OHBox:AddToggle("ShowOH",       { Text="Show Overhead Labels",  Default=true  })
OHBox:AddToggle("OHBGShow",     { Text="Label Background",      Default=true  })
OHBox:AddToggle("OHTop",        { Text="Always On Top",         Default=false })
OHBox:AddToggle("OHOnlyCd",     { Text="Only Show On Cooldown", Default=true  })
OHBox:AddToggle("OHBorderShow", { Text="Show Border",           Default=true  })
OHBox:AddSlider("OHW",          { Text="Label Width",           Default=145,  Min=80, Max=300            })
OHBox:AddSlider("OHH",          { Text="Label Height",          Default=20,   Min=12, Max=44             })
OHBox:AddSlider("OHSp",         { Text="Label Spacing",         Default=3,    Min=0,  Max=20             })
OHBox:AddSlider("OHStuds",      { Text="Studs Above Head",      Default=3,    Min=1,  Max=10, Rounding=1 })
OHBox:AddSlider("OHBGTransp",   { Text="BG Opacity",            Default=0.35, Min=0,  Max=1,  Rounding=2 })
OHBox:AddSlider("OHCorner",     { Text="Corner Radius",         Default=4,    Min=0,  Max=14             })
OHBox:AddSlider("OHStroke",     { Text="Text Stroke Opacity",   Default=0.35, Min=0,  Max=1,  Rounding=2 })
OHBox:AddDropdown("OHFontChoice",{ Values=FONT_LIST, Default=1, Text="Overhead Font" })

-- ── Overhead Colors ───────────────────────────────────────────────────────────
local OHClr = Tabs.Overhead:AddRightGroupbox("Overhead Colors")
OHClr:AddLabel("Dash Text"):AddColorPicker("OHDashTxt",   { Default=Color3.fromRGB(100, 220, 255) })
OHClr:AddLabel("Dash BG"):AddColorPicker("OHDashBG",      { Default=Color3.fromRGB(8,   25,  55 ) })
OHClr:AddLabel("Evasive Text"):AddColorPicker("OHEvaTxt", { Default=Color3.fromRGB(255, 80,  80 ) })
OHClr:AddLabel("Evasive BG"):AddColorPicker("OHEvaBG",    { Default=Color3.fromRGB(50,  8,   8  ) })
OHClr:AddLabel("Border"):AddColorPicker("OHBorder",       { Default=Color3.fromRGB(55,  55,  90 ) })

-- ── Effects ───────────────────────────────────────────────────────────────────
local PulseBox = Tabs.Effects:AddLeftGroupbox("Pulse on Trigger")
PulseBox:AddToggle("PulseOn",  { Text="Enable Pulse",  Default=true  })
PulseBox:AddSlider("PulseDur", { Text="Duration (s)",  Default=0.38, Min=0.1, Max=1.5, Rounding=2 })
PulseBox:AddSlider("PulseSc",  { Text="Scale",         Default=1.07, Min=1.01,Max=1.25,Rounding=2 })

local FlashBox = Tabs.Effects:AddLeftGroupbox("Ready Flash")
FlashBox:AddToggle("FlashOn",  { Text="Flash When Ready",  Default=true  })
FlashBox:AddSlider("FlashCnt", { Text="Flash Count",       Default=3,    Min=1, Max=8             })
FlashBox:AddSlider("FlashSpd", { Text="Flash Speed (s)",   Default=0.14, Min=0.04,Max=0.5,Rounding=2 })
FlashBox:AddLabel("Flash Color"):AddColorPicker("FlashClr", { Default=Color3.fromRGB(255, 255, 100) })

local NotifBox = Tabs.Effects:AddRightGroupbox("Notifications")
NotifBox:AddToggle("NotifReady", { Text="Notify: Ability Ready", Default=false })
NotifBox:AddToggle("NotifUse",   { Text="Notify: Ability Used",  Default=false })
NotifBox:AddToggle("NotifEnemy", { Text="Notify: Enemy CD",      Default=false })
NotifBox:AddSlider("NotifDur",   { Text="Duration (s)",          Default=2, Min=1, Max=8 })

-- ── Screen GUI ────────────────────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TSBCooldownTracker"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 10
screenGui.Parent         = player:WaitForChild("PlayerGui")

-- ── Ability Config ────────────────────────────────────────────────────────────
local ABILITY_CFG = {
    Dash = {
        label="FRONT DASH", defaultCD=5,
        fillKey="DashFill", numKey="DashNum", bgKey="DashBG",
        lblKey="DashLbl",   borderKey="DashBorder", order=1,
    },
    Side = {
        label="SIDE DASH",  defaultCD=2,
        fillKey="SideFill", numKey="SideNum", bgKey="SideBG",
        lblKey="SideLbl",   borderKey="SideBorder", order=2,
    },
    Evasive = {
        label="EVASIVE",    defaultCD=30,
        fillKey="EvaFill",  numKey="EvaNum",  bgKey="EvaBG",
        lblKey="EvaLbl",    borderKey="EvaBorder", order=3,
    },
}
local ABILITY_ORDER = {"Dash", "Side", "Evasive"}

-- ── Bar Construction ──────────────────────────────────────────────────────────
local bars = {}

local function makeGradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    g.Parent   = parent
    return g
end

local function createBar(name)
    local cfg = ABILITY_CFG[name]

    local container = Instance.new("Frame")
    container.Name                  = name .. "_Container"
    container.BackgroundTransparency = 1
    container.BorderSizePixel       = 0
    container.ZIndex                = 2
    container.Parent                = screenGui

    local abilityLabel = Instance.new("TextLabel")
    abilityLabel.Name                   = "AbilityLabel"
    abilityLabel.BackgroundTransparency = 1
    abilityLabel.BorderSizePixel        = 0
    abilityLabel.Text                   = cfg.label
    abilityLabel.Font                   = Enum.Font.GothamBold
    abilityLabel.TextScaled             = false
    abilityLabel.TextXAlignment         = Enum.TextXAlignment.Left
    abilityLabel.TextYAlignment         = Enum.TextYAlignment.Bottom
    abilityLabel.ZIndex                 = 3
    abilityLabel.Parent                 = container

    -- Glow behind bar
    local glow = Instance.new("Frame")
    glow.Name                  = "Glow"
    glow.BorderSizePixel       = 0
    glow.ZIndex                = 2
    glow.BackgroundTransparency = 0.72
    glow.Parent                = container
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 12)

    local frame = Instance.new("Frame")
    frame.Name             = "BarFrame"
    frame.BorderSizePixel  = 0
    frame.ZIndex           = 3
    frame.ClipsDescendants = false
    frame.Parent           = container

    local barCorner = Instance.new("UICorner", frame)

    -- BG gradient (top = slightly lighter, bottom = darker for depth)
    local bgGrad = makeGradient(frame,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        }), 90)
    bgGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.88),
        NumberSequenceKeypoint.new(1, 0.65),
    })

    local barStroke = Instance.new("UIStroke", frame)
    barStroke.Thickness       = 1.2
    barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    barStroke.Transparency    = 0.2

    local fillClip = Instance.new("Frame")
    fillClip.Name                   = "FillClip"
    fillClip.BackgroundTransparency = 1
    fillClip.BorderSizePixel        = 0
    fillClip.ClipsDescendants       = true
    fillClip.ZIndex                 = 4
    fillClip.Size                   = UDim2.new(1, 0, 1, 0)
    fillClip.Position               = UDim2.new(0, 0, 0, 0)
    fillClip.Parent                 = frame

    local fill = Instance.new("Frame")
    fill.Name            = "Fill"
    fill.BorderSizePixel = 0
    fill.ZIndex          = 4
    fill.Parent          = fillClip

    local fillCorner = Instance.new("UICorner", fill)

    -- Fill gradient: bright top → slightly darker bottom
    local fillGrad = makeGradient(fill,
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        }), 90)
    fillGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55),
        NumberSequenceKeypoint.new(0.45, 0.75),
        NumberSequenceKeypoint.new(1, 0.3),
    })

    -- Shine strip (top 2px bright white line)
    local shineLine = Instance.new("Frame")
    shineLine.Name                   = "ShineLine"
    shineLine.Size                   = UDim2.new(0.85, 0, 0, 2)
    shineLine.Position               = UDim2.new(0.075, 0, 0, 2)
    shineLine.BackgroundColor3       = WHITE
    shineLine.BackgroundTransparency = 0.45
    shineLine.BorderSizePixel        = 0
    shineLine.ZIndex                 = 6
    shineLine.Parent                 = fill
    Instance.new("UICorner", shineLine).CornerRadius = UDim.new(1, 0)

    -- Shine soft gradient overlay (top half)
    local shine = Instance.new("Frame")
    shine.Name                   = "Shine"
    shine.Size                   = UDim2.new(1, 0, 0.5, 0)
    shine.Position               = UDim2.new(0, 0, 0, 0)
    shine.BackgroundColor3       = WHITE
    shine.BackgroundTransparency = 0.88
    shine.BorderSizePixel        = 0
    shine.ZIndex                 = 5
    shine.Parent                 = fill
    Instance.new("UICorner", shine)

    local numLabel = Instance.new("TextLabel")
    numLabel.Name                   = "TimeText"
    numLabel.BackgroundTransparency = 1
    numLabel.Size                   = UDim2.new(1, -10, 1, 0)
    numLabel.Position               = UDim2.new(0, 5, 0, 0)
    numLabel.Font                   = Enum.Font.GothamBold
    numLabel.TextScaled             = false
    numLabel.TextXAlignment         = Enum.TextXAlignment.Right
    numLabel.TextYAlignment         = Enum.TextYAlignment.Center
    numLabel.TextStrokeTransparency = 0.35
    numLabel.TextStrokeColor3       = BLACK
    numLabel.ZIndex                 = 7
    numLabel.Parent                 = frame

    bars[name] = {
        container     = container,
        frame         = frame,
        glow          = glow,
        fillClip      = fillClip,
        fill          = fill,
        fillGrad      = fillGrad,
        shine         = shine,
        shineLine     = shineLine,
        text          = numLabel,
        abilityLabel  = abilityLabel,
        barCorner     = barCorner,
        fillCorner    = fillCorner,
        barStroke     = barStroke,
        time          = 0,
        duration      = cfg.defaultCD,
        visRatio      = 0,
        prevOnCd      = false,
        pulseActive   = false,
        readyFlashing = false,
    }
end

for _, name in ipairs(ABILITY_ORDER) do createBar(name) end

-- ── Effect Helpers ────────────────────────────────────────────────────────────
local function doPulse(barData)
    if not Toggles.PulseOn.Value then return end
    if barData.pulseActive then return end
    barData.pulseActive = true
    local frame   = barData.frame
    local scale   = Options.PulseSc.Value or 1.07
    local halfDur = (Options.PulseDur.Value or 0.38) * 0.5
    local orig    = frame.Size
    local scaled  = UDim2.new(orig.X.Scale*scale, orig.X.Offset*scale, orig.Y.Scale*scale, orig.Y.Offset*scale)
    TweenService:Create(frame, TweenInfo.new(halfDur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size=scaled}):Play()
    task.delay(halfDur, function()
        TweenService:Create(frame, TweenInfo.new(halfDur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size=orig}):Play()
        task.delay(halfDur+0.05, function() barData.pulseActive = false end)
    end)
end

local function doReadyFlash(barData)
    if not Toggles.FlashOn.Value then return end
    if barData.readyFlashing then return end
    barData.readyFlashing = true
    local fill     = barData.fill
    local flashClr = Options.FlashClr and Options.FlashClr.Value or Color3.fromRGB(255,255,100)
    local origClr  = fill.BackgroundColor3
    local count    = Options.FlashCnt.Value or 3
    local spd      = Options.FlashSpd.Value or 0.14
    local function flashN(n)
        if n <= 0 then
            pcall(function() fill.BackgroundColor3 = origClr end)
            barData.readyFlashing = false
            return
        end
        TweenService:Create(fill, TweenInfo.new(spd, Enum.EasingStyle.Linear), {BackgroundColor3=flashClr}):Play()
        task.delay(spd, function()
            TweenService:Create(fill, TweenInfo.new(spd, Enum.EasingStyle.Linear), {BackgroundColor3=origClr}):Play()
            task.delay(spd, function() flashN(n-1) end)
        end)
    end
    task.spawn(flashN, count)
end

local function pushNotif(title, body)
    pcall(function()
        Library:Notify({ Title=title, Content=body, Duration=Options.NotifDur.Value or 2 })
    end)
end

-- ── Main Bar Update Loop ──────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function(dt)
    local width      = Options.Width.Value
    local height     = Options.Height.Value
    local spacing    = Options.Spacing.Value
    local cornerR    = Options.Corner.Value
    local posX       = Options.PosX.Value
    local posY       = Options.PosY.Value
    local bgTransp   = Options.BGTransp.Value
    local fillTransp = Options.FillTransp.Value
    local textSize   = Options.TextSize.Value
    local lblSize    = Options.LabelSize.Value
    local lerpSpd    = Options.FillSpeed.Value
    local fillDir    = Options.FillDir.Value
    local font       = FONT_MAP[Options.FontChoice.Value] or Enum.Font.GothamBold

    local showBars   = Toggles.ShowBars.Value
    local showNums   = Toggles.ShowNumbers.Value
    local showLabels = Toggles.ShowLabels.Value
    local showReady  = Toggles.ShowReady.Value
    local showPct    = Toggles.ShowPercent.Value
    local showBorder = Toggles.ShowBorder.Value
    local showShine  = Toggles.ShowShine.Value
    local showGlow   = Toggles.ShowGlow.Value

    local totalW = #ABILITY_ORDER * width + (#ABILITY_ORDER - 1) * spacing
    local startX = -totalW / 2

    for i, name in ipairs(ABILITY_ORDER) do
        local data = bars[name]
        local cfg  = ABILITY_CFG[name]

        if data.time > 0 then data.time = math.max(data.time - dt, 0) end

        local realRatio = 1 - (data.time / math.max(data.duration, 0.001))
        local lf        = math.min(lerpSpd * dt, 1)
        data.visRatio   = data.visRatio + (realRatio - data.visRatio) * lf

        local isOnCd = data.time > 0
        if data.prevOnCd and not isOnCd then
            task.spawn(doReadyFlash, data)
            if Toggles.NotifReady.Value then pushNotif("✓ Ready", name .. " is ready!") end
        end
        data.prevOnCd = isOnCd

        local xOff = startX + (i-1) * (width + spacing)
        local lblH = showLabels and (lblSize + 3) or 0
        local totH = height + lblH + (showLabels and 2 or 0)

        data.container.Size     = UDim2.new(0, width, 0, totH)
        data.container.Position = UDim2.new(posX, xOff, posY, -totH/2)

        -- Ability label
        data.abilityLabel.Size       = UDim2.new(1, 0, 0, lblH)
        data.abilityLabel.Position   = UDim2.new(0, 2, 0, 0)
        data.abilityLabel.TextSize   = lblSize
        data.abilityLabel.Font       = font
        data.abilityLabel.TextColor3 = Options[cfg.lblKey].Value
        data.abilityLabel.Visible    = showLabels

        -- Glow (sits behind frame, slightly larger)
        local fillClr   = Options[cfg.fillKey].Value
        local bgClr     = Options[cfg.bgKey].Value
        local numClr    = Options[cfg.numKey].Value
        local borderClr = Options[cfg.borderKey].Value

        local ratio = math.clamp(data.visRatio, 0, 1)

        data.glow.Size            = UDim2.new(0, width + 10, 0, height + 8)
        data.glow.Position        = UDim2.new(0, -5, 0, lblH - 3)
        data.glow.BackgroundColor3 = fillClr
        data.glow.Visible         = showGlow and ratio > 0.05

        data.frame.Size     = UDim2.new(0, width, 0, height)
        data.frame.Position = UDim2.new(0, 0, 0, lblH + (showLabels and 2 or 0))
        data.barCorner.CornerRadius  = UDim.new(0, cornerR)
        data.fillCorner.CornerRadius = UDim.new(0, cornerR)

        data.barStroke.Enabled     = showBorder
        data.barStroke.Color       = borderClr
        data.barStroke.Transparency = 0.15

        data.shine.Visible     = showShine
        data.shineLine.Visible = showShine

        if showBars then
            data.container.Visible            = true
            data.frame.Visible                = true
            data.fill.Visible                 = true
            data.frame.BackgroundColor3       = bgClr
            data.frame.BackgroundTransparency = bgTransp
            data.fill.BackgroundColor3        = fillClr
            data.fill.BackgroundTransparency  = fillTransp

            if fillDir == "Left" then
                data.fill.AnchorPoint = Vector2.new(0, 0)
                data.fill.Position    = UDim2.new(0, 0, 0, 0)
            else
                data.fill.AnchorPoint = Vector2.new(1, 0)
                data.fill.Position    = UDim2.new(1, 0, 0, 0)
            end
            data.fill.Size = UDim2.new(ratio, 0, 1, 0)

        elseif showNums then
            data.container.Visible            = true
            data.frame.Visible                = true
            data.fill.Visible                 = false
            data.frame.BackgroundTransparency = 1
        else
            data.container.Visible = false
        end

        if data.container.Visible then
            data.text.Font     = font
            data.text.TextSize = textSize
            if showNums then
                if isOnCd then
                    data.text.TextColor3 = numClr
                    data.text.Text = showPct
                        and string.format("%.0f%%", realRatio*100)
                        or  string.format("%.1f",   data.time)
                elseif showReady then
                    data.text.Text       = "READY"
                    data.text.TextColor3 = READY_C
                else
                    data.text.Text = ""
                end
            else
                data.text.Text = ""
            end
        end
    end
end)

-- ── Local Player Animation Detection ─────────────────────────────────────────
local ANIM_MAP = {
    { name="Dash", ids={ 10479335397, 10491993682 } },
    { name="Side", ids={ 10480793962, 10480796021 } },
}

local function trigger(name)
    local data = bars[name]
    if not data then return end
    data.time     = data.duration
    data.prevOnCd = true
    task.spawn(doPulse, data)
    if Toggles.NotifUse.Value then pushNotif("⚡ Used", name .. " activated!") end
end

local function onLocalAnimId(id)
    for _, entry in ipairs(ANIM_MAP) do
        for _, animId in ipairs(entry.ids) do
            if id == animId then trigger(entry.name) end
        end
    end
end

local function detectLocal()
    local char     = player.Character or player.CharacterAdded:Wait()
    local hum      = char:WaitForChild("Humanoid", 10)
    local animator = hum and hum:WaitForChild("Animator", 10)
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        local id = tonumber(track.Animation.AnimationId:match("%d+"))
        if id then onLocalAnimId(id) end
    end)
end

player.CharacterAdded:Connect(function() task.spawn(detectLocal) end)
if player.Character then task.spawn(detectLocal) end

-- ── Overhead Labels (Other Players) ──────────────────────────────────────────
local OH_CFG = {
    Dash = {
        label="Front Dash", defaultCD=5,
        txtKey="OHDashTxt", bgKey="OHDashBG", statKey="EnemyDash",
    },
    Evasive = {
        label="Evasive", defaultCD=30,
        txtKey="OHEvaTxt", bgKey="OHEvaBG",   statKey="EnemyEva",
    },
}
local OH_ORDER = { "Dash", "Evasive" }

local playerTrackers = {}

local function buildOverhead(p)
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if playerTrackers[p] and playerTrackers[p]._billboard then
        pcall(function() playerTrackers[p]._billboard:Destroy() end)
    end

    local ohW  = Options.OHW.Value
    local ohH  = Options.OHH.Value
    local ohSp = Options.OHSp.Value
    local totH = #OH_ORDER * ohH + (#OH_ORDER-1) * ohSp

    local bill = Instance.new("BillboardGui")
    bill.Name           = "CDOverhead"
    bill.Adornee        = head
    bill.Size           = UDim2.new(0, ohW, 0, totH)
    bill.StudsOffset    = Vector3.new(0, Options.OHStuds.Value, 0)
    bill.AlwaysOnTop    = Toggles.OHTop.Value
    bill.LightInfluence = 0
    bill.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bill.Parent         = head

    local layout = Instance.new("UIListLayout", bill)
    layout.SortOrder           = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.FillDirection       = Enum.FillDirection.Vertical
    layout.Padding             = UDim.new(0, ohSp)

    local labelRefs = {}

    for idx, abilityName in ipairs(OH_ORDER) do
        local cfg = OH_CFG[abilityName]

        local bg = Instance.new("Frame")
        bg.Name                   = abilityName .. "BG"
        bg.Size                   = UDim2.new(1, 0, 0, ohH)
        bg.BackgroundColor3       = Options[cfg.bgKey].Value
        bg.BackgroundTransparency = Options.OHBGTransp.Value
        bg.BorderSizePixel        = 0
        bg.LayoutOrder            = idx
        bg.Visible                = false
        bg.Parent                 = bill

        local bgCorner = Instance.new("UICorner", bg)
        bgCorner.CornerRadius = UDim.new(0, Options.OHCorner.Value)

        -- Gradient on overhead BG
        local bgGrad = Instance.new("UIGradient")
        bgGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0))
        bgGrad.Rotation = 90
        bgGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(1, 0.55),
        })
        bgGrad.Parent = bg

        local bgStroke = Instance.new("UIStroke", bg)
        bgStroke.Color           = Options.OHBorder.Value
        bgStroke.Thickness       = 1
        bgStroke.Transparency    = 0.3
        bgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local ohFont = FONT_MAP[Options.OHFontChoice.Value] or Enum.Font.GothamBold

        local lbl = Instance.new("TextLabel")
        lbl.Name                   = abilityName .. "Text"
        lbl.Size                   = UDim2.new(1, -8, 1, 0)
        lbl.Position               = UDim2.new(0, 4, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text                   = ""
        lbl.TextColor3             = Options[cfg.txtKey].Value
        lbl.TextScaled             = false
        lbl.TextSize               = ohH * 0.62
        lbl.Font                   = ohFont
        lbl.TextXAlignment         = Enum.TextXAlignment.Center
        lbl.TextYAlignment         = Enum.TextYAlignment.Center
        lbl.TextStrokeTransparency = Options.OHStroke.Value
        lbl.TextStrokeColor3       = BLACK
        lbl.ZIndex                 = 2
        lbl.Parent                 = bg

        labelRefs[abilityName] = { lbl=lbl, bg=bg }
    end

    if not playerTrackers[p] then playerTrackers[p] = {} end
    playerTrackers[p]._billboard = bill

    for abilityName in pairs(OH_CFG) do
        if not playerTrackers[p][abilityName] then
            playerTrackers[p][abilityName] = { time=0 }
        end
        local refs = labelRefs[abilityName]
        if refs then
            playerTrackers[p][abilityName].label = refs.lbl
            playerTrackers[p][abilityName].bg    = refs.bg
        end
    end
end

local function triggerOverhead(p, abilityName)
    local cfg = OH_CFG[abilityName]
    if not cfg then return end
    if not playerTrackers[p] then playerTrackers[p] = {} end
    if not playerTrackers[p][abilityName] then
        playerTrackers[p][abilityName] = { time=0, label=nil, bg=nil }
    end
    playerTrackers[p][abilityName].time = cfg.defaultCD
    if Toggles.NotifEnemy.Value then
        pushNotif("👁 Enemy", p.Name .. " used " .. abilityName .. "!")
    end
end

local function setupPlayer(p)
    if p == player then return end
    playerTrackers[p] = {}
    for abilityName in pairs(OH_CFG) do
        playerTrackers[p][abilityName] = { time=0, label=nil, bg=nil }
    end
    local function onChar(char)
        char:WaitForChild("Head", 10)
        task.wait(0.1)
        buildOverhead(p)
        local hum  = char:WaitForChild("Humanoid", 10)
        local anim = hum and hum:WaitForChild("Animator", 10)
        if not anim then return end
        anim.AnimationPlayed:Connect(function(track)
            local id = tonumber(track.Animation.AnimationId:match("%d+"))
            if not id then return end
            for _, entry in ipairs(ANIM_MAP) do
                if entry.name == "Dash" then
                    for _, animId in ipairs(entry.ids) do
                        if id == animId then triggerOverhead(p, "Dash") end
                    end
                end
            end
        end)
    end
    if p.Character then task.spawn(onChar, p.Character) end
    p.CharacterAdded:Connect(onChar)
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(p)
    local tracker = playerTrackers[p]
    if not tracker then return end
    if tracker._billboard then pcall(function() tracker._billboard:Destroy() end) end
    playerTrackers[p] = nil
end)

-- ── Evasive Detection ─────────────────────────────────────────────────────────
LiveFolder.DescendantAdded:Connect(function(child)
    if child.Name ~= "RagdollCancel" then return end
    local char = child.Parent
    if char == player.Character then
        trigger("Evasive")
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character == char then
            triggerOverhead(p, "Evasive")
            break
        end
    end
end)

-- ── Overhead Update Loop ──────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function(dt)
    local showOH   = Toggles.ShowOH.Value
    local showBG   = Toggles.OHBGShow.Value
    local onlyCd   = Toggles.OHOnlyCd.Value
    local showBord = Toggles.OHBorderShow.Value
    local ohW      = Options.OHW.Value
    local ohH      = Options.OHH.Value
    local ohSp     = Options.OHSp.Value
    local ohSO     = Options.OHStuds.Value
    local ohBGT    = Options.OHBGTransp.Value
    local ohStr    = Options.OHStroke.Value
    local ohAlTop  = Toggles.OHTop.Value
    local borderC  = Options.OHBorder.Value
    local totH     = #OH_ORDER * ohH + (#OH_ORDER-1) * ohSp
    local ohFont   = FONT_MAP[Options.OHFontChoice.Value] or Enum.Font.GothamBold

    for p, tracker in pairs(playerTrackers) do
        local bill = tracker._billboard
        if bill then
            bill.Enabled     = showOH
            bill.AlwaysOnTop = ohAlTop
            bill.StudsOffset = Vector3.new(0, ohSO, 0)
            bill.Size        = UDim2.new(0, ohW, 0, totH)
        end

        for abilityName, data in pairs(tracker) do
            if abilityName == "_billboard" then continue end
            if data.time > 0 then data.time = math.max(data.time - dt, 0) end

            local lbl = data.label
            local bg  = data.bg
            local cfg = OH_CFG[abilityName]
            if not cfg or not lbl or not bg then continue end
            if not lbl.Parent or not bg.Parent then continue end

            lbl.TextColor3             = Options[cfg.txtKey].Value
            lbl.TextStrokeTransparency = ohStr
            lbl.TextSize               = ohH * 0.62
            lbl.Font                   = ohFont

            if showBG then
                bg.BackgroundTransparency = ohBGT
                bg.BackgroundColor3       = Options[cfg.bgKey].Value
            else
                bg.BackgroundTransparency = 1
            end

            local stroke = bg:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Enabled      = showBord
                stroke.Color        = borderC
                stroke.Transparency = 0.3
            end

            if data.time > 0 then
                bg.Visible     = showOH
                lbl.Text       = cfg.label .. ": " .. string.format("%.1f", data.time)
                lbl.TextColor3 = Options[cfg.txtKey].Value
            elseif not onlyCd then
                bg.Visible     = showOH
                lbl.Text       = cfg.label .. ": READY"
                lbl.TextColor3 = READY_C
            else
                bg.Visible = false
                lbl.Text   = ""
            end
        end
    end
end)
