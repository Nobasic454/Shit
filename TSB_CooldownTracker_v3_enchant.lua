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
local READY_C = Color3.fromRGB(150, 255, 200)  -- cool mint-green, enchant feel

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

-- ── Dash Colors  (enchant electric blue) ──────────────────────────────────────
local DashClr = Tabs.Main:AddRightGroupbox("Dash Colors")
DashClr:AddLabel("Fill"):AddColorPicker("DashFill",     { Default=Color3.fromRGB(80,  155, 255) })
DashClr:AddLabel("Numbers"):AddColorPicker("DashNum",   { Default=Color3.fromRGB(210, 235, 255) })
DashClr:AddLabel("Background"):AddColorPicker("DashBG", { Default=Color3.fromRGB(5,   8,   28 ) })
DashClr:AddLabel("Label"):AddColorPicker("DashLbl",     { Default=Color3.fromRGB(155, 210, 255) })
DashClr:AddLabel("Border"):AddColorPicker("DashBorder", { Default=Color3.fromRGB(65,  130, 255) })

-- ── Side Colors  (enchant arcane gold) ────────────────────────────────────────
local SideClr = Tabs.Main:AddRightGroupbox("Side Colors")
SideClr:AddLabel("Fill"):AddColorPicker("SideFill",     { Default=Color3.fromRGB(255, 195, 55 ) })
SideClr:AddLabel("Numbers"):AddColorPicker("SideNum",   { Default=Color3.fromRGB(255, 245, 195) })
SideClr:AddLabel("Background"):AddColorPicker("SideBG", { Default=Color3.fromRGB(22,  14,  3  ) })
SideClr:AddLabel("Label"):AddColorPicker("SideLbl",     { Default=Color3.fromRGB(255, 215, 100) })
SideClr:AddLabel("Border"):AddColorPicker("SideBorder", { Default=Color3.fromRGB(225, 165, 20 ) })

-- ── Evasive Colors  (enchant arcane violet) ───────────────────────────────────
local EvaClr = Tabs.Main:AddRightGroupbox("Evasive Colors")
EvaClr:AddLabel("Fill"):AddColorPicker("EvaFill",     { Default=Color3.fromRGB(205, 65,  255) })
EvaClr:AddLabel("Numbers"):AddColorPicker("EvaNum",   { Default=Color3.fromRGB(235, 200, 255) })
EvaClr:AddLabel("Background"):AddColorPicker("EvaBG", { Default=Color3.fromRGB(16,  4,   30 ) })
EvaClr:AddLabel("Label"):AddColorPicker("EvaLbl",     { Default=Color3.fromRGB(195, 115, 255) })
EvaClr:AddLabel("Border"):AddColorPicker("EvaBorder", { Default=Color3.fromRGB(175, 45,  225) })

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
OHClr:AddLabel("Dash Text"):AddColorPicker("OHDashTxt",   { Default=Color3.fromRGB(100, 210, 255) })
OHClr:AddLabel("Dash BG"):AddColorPicker("OHDashBG",      { Default=Color3.fromRGB(6,   22,  52 ) })
OHClr:AddLabel("Evasive Text"):AddColorPicker("OHEvaTxt", { Default=Color3.fromRGB(200, 100, 255) })
OHClr:AddLabel("Evasive BG"):AddColorPicker("OHEvaBG",    { Default=Color3.fromRGB(18,  6,   38 ) })
OHClr:AddLabel("Border"):AddColorPicker("OHBorder",       { Default=Color3.fromRGB(75,  55,  135) })

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

-- ── Screen GUI ────────────────────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TSBCooldownTracker"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 10
screenGui.Parent         = player:WaitForChild("PlayerGui")

-- ── Ability Config  (◈ symbol in labels for enchant aesthetic) ───────────────
local ABILITY_CFG = {
    Dash = {
        label="◈ FRONT DASH", defaultCD=5,
        fillKey="DashFill", numKey="DashNum", bgKey="DashBG",
        lblKey="DashLbl",   borderKey="DashBorder", order=1,
    },
    Side = {
        label="◈ SIDE DASH",  defaultCD=2,
        fillKey="SideFill", numKey="SideNum", bgKey="SideBG",
        lblKey="SideLbl",   borderKey="SideBorder", order=2,
    },
    Evasive = {
        label="◈ EVASIVE",    defaultCD=30,
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

-- ── Enchant sweep: a soft light strip that glides L→R across the fill ─────────
local function startEnchantSweep(sweep, delay)
    task.spawn(function()
        task.wait(delay or 0)
        while sweep and sweep.Parent do
            pcall(function()
                sweep.Position = UDim2.new(-0.45, 0, -0.1, 0)
            end)
            local t = TweenService:Create(sweep,
                TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                { Position = UDim2.new(1.15, 0, -0.1, 0) })
            t:Play()
            task.wait(3.4)  -- sweep duration + pause before next
        end
    end)
end

-- ── Sparkle: tiny dot that blinks with a flash-fade pattern ──────────────────
local function startSparkle(sp, delay)
    task.spawn(function()
        task.wait(delay or 0)
        while sp and sp.Parent do
            task.wait(math.random(10, 32) * 0.1)
            if not (sp and sp.Parent) then break end
            sp.BackgroundTransparency = 0.05
            task.wait(0.055)
            sp.BackgroundTransparency = 0.45
            task.wait(0.055)
            sp.BackgroundTransparency = 0.05
            TweenService:Create(sp,
                TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { BackgroundTransparency = 1 }):Play()
        end
    end)
end

local function createBar(name, barIdx)
    local cfg = ABILITY_CFG[name]

    local container = Instance.new("Frame")
    container.Name                   = name .. "_Container"
    container.BackgroundTransparency = 1
    container.BorderSizePixel        = 0
    container.ZIndex                 = 2
    container.Parent                 = screenGui

    -- ── Outer halo: wide, very faint glow ring ────────────────────────────────
    local outerGlow = Instance.new("Frame")
    outerGlow.Name                   = "OuterGlow"
    outerGlow.BorderSizePixel        = 0
    outerGlow.ZIndex                 = 1
    outerGlow.BackgroundTransparency = 0.92
    outerGlow.Parent                 = container
    Instance.new("UICorner", outerGlow).CornerRadius = UDim.new(0, 20)

    -- ── Ability label ─────────────────────────────────────────────────────────
    local abilityLabel = Instance.new("TextLabel")
    abilityLabel.Name                   = "AbilityLabel"
    abilityLabel.BackgroundTransparency = 1
    abilityLabel.BorderSizePixel        = 0
    abilityLabel.Text                   = cfg.label
    abilityLabel.Font                   = Enum.Font.GothamBold
    abilityLabel.TextScaled             = false
    abilityLabel.TextXAlignment         = Enum.TextXAlignment.Left
    abilityLabel.TextYAlignment         = Enum.TextYAlignment.Bottom
    abilityLabel.TextStrokeTransparency = 0.35
    abilityLabel.TextStrokeColor3       = BLACK
    abilityLabel.ZIndex                 = 3
    abilityLabel.Parent                 = container

    -- ── Inner glow (sits directly behind bar) ─────────────────────────────────
    local glow = Instance.new("Frame")
    glow.Name                   = "Glow"
    glow.BorderSizePixel        = 0
    glow.ZIndex                 = 2
    glow.BackgroundTransparency = 0.72
    glow.Parent                 = container
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 13)

    -- ── Bar frame ─────────────────────────────────────────────────────────────
    local frame = Instance.new("Frame")
    frame.Name             = "BarFrame"
    frame.BorderSizePixel  = 0
    frame.ZIndex           = 3
    frame.ClipsDescendants = false
    frame.Parent           = container

    local barCorner = Instance.new("UICorner", frame)

    -- BG gradient: deep dark with subtle arcane purple tint top→bottom
    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(150, 130, 210)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,   0,   0  )),
    })
    bgGrad.Rotation = 90
    bgGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.84),
        NumberSequenceKeypoint.new(1, 0.60),
    })
    bgGrad.Parent = frame

    local barStroke = Instance.new("UIStroke", frame)
    barStroke.Thickness       = 1.5
    barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    barStroke.Transparency    = 0.2

    -- ── Fill clip (masks fill to bar width) ───────────────────────────────────
    local fillClip = Instance.new("Frame")
    fillClip.Name                   = "FillClip"
    fillClip.BackgroundTransparency = 1
    fillClip.BorderSizePixel        = 0
    fillClip.ClipsDescendants       = true
    fillClip.ZIndex                 = 4
    fillClip.Size                   = UDim2.new(1, 0, 1, 0)
    fillClip.Position               = UDim2.new(0, 0, 0, 0)
    fillClip.Parent                 = frame

    -- ── Fill bar ──────────────────────────────────────────────────────────────
    local fill = Instance.new("Frame")
    fill.Name              = "Fill"
    fill.BorderSizePixel   = 0
    fill.ZIndex            = 4
    fill.ClipsDescendants  = true   -- clip sweep & sparkles to fill bounds
    fill.Parent            = fillClip

    local fillCorner = Instance.new("UICorner", fill)

    -- Fill gradient: iridescent enchant shimmer (lavender → sky-blue overlay)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.38, Color3.fromRGB(200, 188, 255)),  -- lavender sheen
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(175, 215, 255)),  -- sky-blue sheen
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(50,  35,  130)),  -- deep arcane shadow
    })
    fillGrad.Rotation = 90
    fillGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,    0.48),
        NumberSequenceKeypoint.new(0.42, 0.65),
        NumberSequenceKeypoint.new(1,    0.18),
    })
    fillGrad.Parent = fill

    -- ── Enchant sweep strip (horizontal light glide, clipped by fill) ─────────
    local sweep = Instance.new("Frame")
    sweep.Name                   = "EnchantSweep"
    sweep.Size                   = UDim2.new(0.40, 0, 1.2, 0)
    sweep.AnchorPoint            = Vector2.new(0.5, 0)
    sweep.Position               = UDim2.new(-0.45, 0, -0.1, 0)
    sweep.BackgroundColor3       = WHITE
    sweep.BackgroundTransparency = 0
    sweep.BorderSizePixel        = 0
    sweep.ZIndex                 = 6
    sweep.Parent                 = fill
    local sweepGrad = Instance.new("UIGradient")
    sweepGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,    1   ),
        NumberSequenceKeypoint.new(0.32, 0.68),
        NumberSequenceKeypoint.new(0.50, 0.55),
        NumberSequenceKeypoint.new(0.68, 0.68),
        NumberSequenceKeypoint.new(1,    1   ),
    })
    sweepGrad.Rotation = 0  -- horizontal
    sweepGrad.Parent = sweep
    startEnchantSweep(sweep, (barIdx - 1) * 0.85)

    -- ── Sparkle particles (tiny diamond dots, clipped inside fill) ────────────
    local sparkles   = {}
    local spPositions = {
        {x=0.10, y=0.50}, {x=0.28, y=0.50}, {x=0.50, y=0.50},
        {x=0.72, y=0.50}, {x=0.90, y=0.50},
    }
    for j, pos in ipairs(spPositions) do
        local sp = Instance.new("Frame")
        sp.Size                   = UDim2.new(0, 3, 0, 3)
        sp.AnchorPoint            = Vector2.new(0.5, 0.5)
        sp.Position               = UDim2.new(pos.x, 0, pos.y, 0)
        sp.BackgroundColor3       = WHITE
        sp.BackgroundTransparency = 1
        sp.BorderSizePixel        = 0
        sp.ZIndex                 = 8
        sp.Parent                 = fill
        Instance.new("UICorner", sp).CornerRadius = UDim.new(1, 0)
        sparkles[j] = sp
        startSparkle(sp, (j - 1) * 0.45 + (barIdx - 1) * 0.18)
    end

    -- ── Shine strip: bright top edge line ─────────────────────────────────────
    local shineLine = Instance.new("Frame")
    shineLine.Name                   = "ShineLine"
    shineLine.Size                   = UDim2.new(0.85, 0, 0, 2)
    shineLine.Position               = UDim2.new(0.075, 0, 0, 2)
    shineLine.BackgroundColor3       = WHITE
    shineLine.BackgroundTransparency = 0.42
    shineLine.BorderSizePixel        = 0
    shineLine.ZIndex                 = 7
    shineLine.Parent                 = fill
    Instance.new("UICorner", shineLine).CornerRadius = UDim.new(1, 0)

    -- ── Shine overlay: soft top-half highlight ────────────────────────────────
    local shine = Instance.new("Frame")
    shine.Name                   = "Shine"
    shine.Size                   = UDim2.new(1, 0, 0.5, 0)
    shine.Position               = UDim2.new(0, 0, 0, 0)
    shine.BackgroundColor3       = WHITE
    shine.BackgroundTransparency = 0.86
    shine.BorderSizePixel        = 0
    shine.ZIndex                 = 5
    shine.Parent                 = fill
    Instance.new("UICorner", shine)

    -- ── Number label ──────────────────────────────────────────────────────────
    local numLabel = Instance.new("TextLabel")
    numLabel.Name                   = "TimeText"
    numLabel.BackgroundTransparency = 1
    numLabel.Size                   = UDim2.new(1, -10, 1, 0)
    numLabel.Position               = UDim2.new(0, 5, 0, 0)
    numLabel.Font                   = Enum.Font.GothamBold
    numLabel.TextScaled             = false
    numLabel.TextXAlignment         = Enum.TextXAlignment.Right
    numLabel.TextYAlignment         = Enum.TextYAlignment.Center
    numLabel.TextStrokeTransparency = 0.28
    numLabel.TextStrokeColor3       = BLACK
    numLabel.ZIndex                 = 9
    numLabel.Parent                 = frame

    bars[name] = {
        container        = container,
        frame            = frame,
        outerGlow        = outerGlow,
        glow             = glow,
        fillClip         = fillClip,
        fill             = fill,
        fillGrad         = fillGrad,
        sweep            = sweep,
        sparkles         = sparkles,
        shine            = shine,
        shineLine        = shineLine,
        text             = numLabel,
        abilityLabel     = abilityLabel,
        barCorner        = barCorner,
        fillCorner       = fillCorner,
        barStroke        = barStroke,
        time             = 0,
        duration         = cfg.defaultCD,
        visRatio         = 0,
        prevOnCd         = false,
        pulseActive      = false,
        readyFlashing    = false,
        readyPulseActive = false,
    }
end

for i, name in ipairs(ABILITY_ORDER) do createBar(name, i) end

-- ── Effect Helpers ────────────────────────────────────────────────────────────
local function doPulse(barData)
    if not Toggles.PulseOn.Value then return end
    if barData.pulseActive then return end
    barData.pulseActive = true
    local frame   = barData.frame
    local scale   = Options.PulseSc.Value or 1.07
    local halfDur = (Options.PulseDur.Value or 0.38) * 0.5
    local orig    = frame.Size
    local scaled  = UDim2.new(
        orig.X.Scale * scale, orig.X.Offset * scale,
        orig.Y.Scale * scale, orig.Y.Offset * scale)
    TweenService:Create(frame,
        TweenInfo.new(halfDur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Size = scaled }):Play()
    task.delay(halfDur, function()
        TweenService:Create(frame,
            TweenInfo.new(halfDur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = orig }):Play()
        task.delay(halfDur + 0.05, function() barData.pulseActive = false end)
    end)
end

local function doReadyFlash(barData)
    if not Toggles.FlashOn.Value then return end
    if barData.readyFlashing then return end
    barData.readyFlashing = true
    local fill     = barData.fill
    local flashClr = Options.FlashClr and Options.FlashClr.Value or Color3.fromRGB(255, 255, 100)
    local origClr  = fill.BackgroundColor3
    local count    = Options.FlashCnt.Value or 3
    local spd      = Options.FlashSpd.Value or 0.14
    local function flashN(n)
        if n <= 0 then
            pcall(function() fill.BackgroundColor3 = origClr end)
            barData.readyFlashing = false
            return
        end
        TweenService:Create(fill,
            TweenInfo.new(spd, Enum.EasingStyle.Linear),
            { BackgroundColor3 = flashClr }):Play()
        task.delay(spd, function()
            TweenService:Create(fill,
                TweenInfo.new(spd, Enum.EasingStyle.Linear),
                { BackgroundColor3 = origClr }):Play()
            task.delay(spd, function() flashN(n - 1) end)
        end)
    end
    task.spawn(flashN, count)
end

-- ── Enchant READY pulse: border + both glows breathe rhythmically ─────────────
local function doReadyPulse(barData)
    if barData.readyPulseActive then return end
    barData.readyPulseActive = true
    local stroke    = barData.barStroke
    local glow      = barData.glow
    local outerGlow = barData.outerGlow
    local function pulse()
        if not barData.readyPulseActive then return end
        -- breathe in
        TweenService:Create(stroke,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine), { Transparency = 0.0  }):Play()
        TweenService:Create(glow,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.48 }):Play()
        TweenService:Create(outerGlow,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.76 }):Play()
        task.wait(1.0)
        if not barData.readyPulseActive then return end
        -- breathe out
        TweenService:Create(stroke,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine), { Transparency = 0.58 }):Play()
        TweenService:Create(glow,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.84 }):Play()
        TweenService:Create(outerGlow,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.95 }):Play()
        task.wait(1.0)
        if barData.readyPulseActive then task.spawn(pulse) end
    end
    task.spawn(pulse)
end

local function stopReadyPulse(barData)
    barData.readyPulseActive = false
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

        -- state transitions
        if data.prevOnCd and not isOnCd then
            task.spawn(doReadyFlash, data)
            task.spawn(doReadyPulse, data)
        elseif not data.prevOnCd and isOnCd then
            -- just triggered: stop ready pulse
        end
        data.prevOnCd = isOnCd

        local xOff = startX + (i - 1) * (width + spacing)
        local lblH  = showLabels and (lblSize + 3) or 0
        local totH  = height + lblH + (showLabels and 2 or 0)

        data.container.Size     = UDim2.new(0, width, 0, totH)
        data.container.Position = UDim2.new(posX, xOff, posY, -totH / 2)

        -- Ability label
        data.abilityLabel.Size       = UDim2.new(1, 0, 0, lblH)
        data.abilityLabel.Position   = UDim2.new(0, 2, 0, 0)
        data.abilityLabel.TextSize   = lblSize
        data.abilityLabel.Font       = font
        data.abilityLabel.TextColor3 = Options[cfg.lblKey].Value
        data.abilityLabel.Visible    = showLabels

        local fillClr   = Options[cfg.fillKey].Value
        local bgClr     = Options[cfg.bgKey].Value
        local numClr    = Options[cfg.numKey].Value
        local borderClr = Options[cfg.borderKey].Value

        local ratio = math.clamp(data.visRatio, 0, 1)
        local hasFill = ratio > 0.03

        -- Outer halo
        data.outerGlow.Size             = UDim2.new(0, width + 26, 0, height + 18)
        data.outerGlow.Position         = UDim2.new(0, -13, 0, lblH - 7)
        data.outerGlow.BackgroundColor3 = fillClr
        data.outerGlow.Visible          = showGlow and hasFill and not data.readyPulseActive

        -- Inner glow
        data.glow.Size             = UDim2.new(0, width + 10, 0, height + 8)
        data.glow.Position         = UDim2.new(0, -5, 0, lblH - 3)
        data.glow.BackgroundColor3 = fillClr
        data.glow.Visible          = showGlow and hasFill and not data.readyPulseActive

        -- Sparkle color update (clipped inside fill, so only show when fill is visible)
        for _, sp in ipairs(data.sparkles) do
            sp.BackgroundColor3 = fillClr
        end

        data.frame.Size     = UDim2.new(0, width, 0, height)
        data.frame.Position = UDim2.new(0, 0, 0, lblH + (showLabels and 2 or 0))
        data.barCorner.CornerRadius  = UDim.new(0, cornerR)
        data.fillCorner.CornerRadius = UDim.new(0, cornerR)

        -- Border: don't override transparency during ready pulse
        data.barStroke.Enabled = showBorder
        data.barStroke.Color   = borderClr
        if not data.readyPulseActive then
            data.barStroke.Transparency = 0.15
        end

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
                        and string.format("%.0f%%", realRatio * 100)
                        or  string.format("%.1f",   data.time)
                elseif showReady then
                    data.text.Text       = "✦ READY ✦"
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
    stopReadyPulse(data)
    task.spawn(doPulse, data)
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
    local totH = #OH_ORDER * ohH + (#OH_ORDER - 1) * ohSp

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

        -- Enchant-style gradient on overhead pill
        local bgGrad = Instance.new("UIGradient")
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(170, 155, 235)),
            ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,   0,   0  )),
        })
        bgGrad.Rotation = 90
        bgGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.62),
            NumberSequenceKeypoint.new(1, 0.48),
        })
        bgGrad.Parent = bg

        local bgStroke = Instance.new("UIStroke", bg)
        bgStroke.Color           = Options.OHBorder.Value
        bgStroke.Thickness       = 1
        bgStroke.Transparency    = 0.30
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
    if tracker._billboard then
        pcall(function() tracker._billboard:Destroy() end)
    end
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
    local totH     = #OH_ORDER * ohH + (#OH_ORDER - 1) * ohSp
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
                stroke.Transparency = 0.30
            end

            if data.time > 0 then
                bg.Visible     = showOH
                lbl.Text       = cfg.label .. ": " .. string.format("%.1f", data.time)
                lbl.TextColor3 = Options[cfg.txtKey].Value
            elseif not onlyCd then
                bg.Visible     = showOH
                lbl.Text       = cfg.label .. ": ✦ READY"
                lbl.TextColor3 = READY_C
            else
                bg.Visible = false
                lbl.Text   = ""
            end
        end
    end
end)
