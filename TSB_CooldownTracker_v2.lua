-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                                                                            ║
-- ║            TSB COOLDOWN TRACKER  ·  v2.0  ·  Professional Edition         ║
-- ║                                                                            ║
-- ║   Features:                                                                ║
-- ║     · Smooth lerp bar fill with configurable speed                        ║
-- ║     · Per-ability color theming (fill / label / border / BG)              ║
-- ║     · Ability name labels above every bar                                 ║
-- ║     · READY flash + pulse animation on trigger                            ║
-- ║     · Overhead labels for enemy tracking (Dash + Evasive)                 ║
-- ║     · Overhead: per-ability BG frames with stroke borders                 ║
-- ║     · Obsidian notification hooks (Ready / Use / Enemy)                   ║
-- ║     · Cooldown override sliders per ability                               ║
-- ║     · Usage statistics panel with reset button                            ║
-- ║     · Font selector (5 fonts)                                             ║
-- ║     · Fill direction toggle (Left / Right)                                ║
-- ║     · Show-only-on-cooldown mode for overhead                             ║
-- ║     · Shine highlight strip on fill bar                                   ║
-- ║     · Percentage mode instead of raw seconds                              ║
-- ║     · Full Obsidian UI (4 tabs, sliders, toggles, dropdowns, pickers)     ║
-- ║                                                                            ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ─── SERVICES ─────────────────────────────────────────────────────────────────

local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")

local player           = Players.LocalPlayer
local LiveFolder       = Workspace:WaitForChild("Live")

-- ─── OBSIDIAN ─────────────────────────────────────────────────────────────────

local repo    = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

-- ─── GLOBAL CONSTANTS ─────────────────────────────────────────────────────────

local BLACK   = Color3.fromRGB(0,   0,   0  )
local WHITE   = Color3.fromRGB(255, 255, 255)
local READY_C = Color3.fromRGB(120, 255, 120)  -- green "READY" colour

-- TweenInfo presets
local TI_FAST   = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_MED    = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_BOUNCE = TweenInfo.new(0.45, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)

-- Font lookup
local FONT_MAP = {
    ["SourceSansBold"] = Enum.Font.SourceSansBold,
    ["GothamBold"]     = Enum.Font.GothamBold,
    ["Gotham"]         = Enum.Font.Gotham,
    ["SourceSans"]     = Enum.Font.SourceSans,
    ["RobotoMono"]     = Enum.Font.RobotoMono,
}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              WINDOW / TABS                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Window = Library:CreateWindow({
    Title            = "Cooldown Tracker",
    Footer           = "TSB  ·  v2.0",
    ShowCustomCursor = true,
})

pcall(function() Library:SetWatermark("TSB CD Tracker v2.0") end)

local Tabs = {
    Main     = Window:AddTab("Bars",     "box"),
    Overhead = Window:AddTab("Overhead", "user"),
    Effects  = Window:AddTab("Effects",  "star"),
    Extra    = Window:AddTab("Extra",    "settings"),
}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                          TAB 1  —  MAIN (BARS)                             ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ── Layout ────────────────────────────────────────────────────────────────────
local LayoutBox = Tabs.Main:AddLeftGroupbox("Bar Layout")

LayoutBox:AddSlider("Width",      { Text="Bar Width",        Default=160,  Min=60,   Max=300            })
LayoutBox:AddSlider("Height",     { Text="Bar Height",       Default=22,   Min=8,    Max=80             })
LayoutBox:AddSlider("Spacing",    { Text="Bar Spacing",      Default=10,   Min=0,    Max=60             })
LayoutBox:AddSlider("Corner",     { Text="Corner Radius",    Default=6,    Min=0,    Max=20             })
LayoutBox:AddSlider("PosX",       { Text="Position X",       Default=0.5,  Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("PosY",       { Text="Position Y",       Default=0.85, Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("BGTransp",   { Text="BG Opacity",       Default=0.25, Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("FillTransp", { Text="Fill Opacity",     Default=0,    Min=0,    Max=1, Rounding=2 })
LayoutBox:AddSlider("TextSize",   { Text="Number Size",      Default=14,   Min=6,    Max=32             })
LayoutBox:AddSlider("LabelSize",  { Text="Label Text Size",  Default=10,   Min=6,    Max=22             })
LayoutBox:AddSlider("FillSpeed",  { Text="Fill Lerp Speed",  Default=9,    Min=1,    Max=30             })

-- ── Toggles ───────────────────────────────────────────────────────────────────
local TogBox = Tabs.Main:AddLeftGroupbox("Toggles")

TogBox:AddToggle("ShowBars",       { Text="Show Bars",            Default=true  })
TogBox:AddToggle("ShowNumbers",    { Text="Show Numbers",         Default=true  })
TogBox:AddToggle("ShowLabels",     { Text="Show Ability Labels",  Default=true  })
TogBox:AddToggle("ShowReady",      { Text="Show READY text",      Default=true  })
TogBox:AddToggle("ShowPercent",    { Text="Percentage Mode",      Default=false })
TogBox:AddToggle("ShowBorder",     { Text="Show Border Stroke",   Default=true  })
TogBox:AddToggle("ShowShine",      { Text="Shine Highlight",      Default=true  })

TogBox:AddDropdown("FillDir", {
    Values  = { "Left", "Right" },
    Default = 1,
    Text    = "Fill Direction",
})

TogBox:AddDropdown("FontChoice", {
    Values  = { "SourceSansBold", "GothamBold", "Gotham", "SourceSans", "RobotoMono" },
    Default = 2,
    Text    = "Font",
})

-- ── Colors — Dash ─────────────────────────────────────────────────────────────
local DashClr = Tabs.Main:AddRightGroupbox("Dash Colors")
DashClr:AddLabel("Fill"):AddColorPicker("DashFill",       { Default=Color3.fromRGB(60,  200, 255) })
DashClr:AddLabel("Numbers"):AddColorPicker("DashNum",     { Default=Color3.fromRGB(255, 255, 255) })
DashClr:AddLabel("Background"):AddColorPicker("DashBG",   { Default=Color3.fromRGB(8,   20,  45 ) })
DashClr:AddLabel("Label"):AddColorPicker("DashLbl",       { Default=Color3.fromRGB(140, 210, 255) })
DashClr:AddLabel("Border"):AddColorPicker("DashBorder",   { Default=Color3.fromRGB(60,  180, 255) })

-- ── Colors — Side ─────────────────────────────────────────────────────────────
local SideClr = Tabs.Main:AddRightGroupbox("Side Colors")
SideClr:AddLabel("Fill"):AddColorPicker("SideFill",       { Default=Color3.fromRGB(255, 200, 0  ) })
SideClr:AddLabel("Numbers"):AddColorPicker("SideNum",     { Default=Color3.fromRGB(255, 255, 255) })
SideClr:AddLabel("Background"):AddColorPicker("SideBG",   { Default=Color3.fromRGB(28,  22,  0  ) })
SideClr:AddLabel("Label"):AddColorPicker("SideLbl",       { Default=Color3.fromRGB(255, 225, 80 ) })
SideClr:AddLabel("Border"):AddColorPicker("SideBorder",   { Default=Color3.fromRGB(255, 190, 0  ) })

-- ── Colors — Evasive ──────────────────────────────────────────────────────────
local EvaClr = Tabs.Main:AddRightGroupbox("Evasive Colors")
EvaClr:AddLabel("Fill"):AddColorPicker("EvaFill",         { Default=Color3.fromRGB(255, 75,  75 ) })
EvaClr:AddLabel("Numbers"):AddColorPicker("EvaNum",       { Default=Color3.fromRGB(255, 255, 255) })
EvaClr:AddLabel("Background"):AddColorPicker("EvaBG",     { Default=Color3.fromRGB(35,  6,   6  ) })
EvaClr:AddLabel("Label"):AddColorPicker("EvaLbl",         { Default=Color3.fromRGB(255, 130, 130) })
EvaClr:AddLabel("Border"):AddColorPicker("EvaBorder",     { Default=Color3.fromRGB(255, 70,  70 ) })

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                        TAB 2  —  OVERHEAD                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

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

local OHClr = Tabs.Overhead:AddRightGroupbox("Overhead Colors")
OHClr:AddLabel("Dash Text"):AddColorPicker("OHDashTxt",   { Default=Color3.fromRGB(100, 220, 255) })
OHClr:AddLabel("Dash BG"):AddColorPicker("OHDashBG",      { Default=Color3.fromRGB(8,   25,  55 ) })
OHClr:AddLabel("Evasive Text"):AddColorPicker("OHEvaTxt", { Default=Color3.fromRGB(255, 80,  80 ) })
OHClr:AddLabel("Evasive BG"):AddColorPicker("OHEvaBG",    { Default=Color3.fromRGB(50,  8,   8  ) })
OHClr:AddLabel("Border"):AddColorPicker("OHBorder",       { Default=Color3.fromRGB(55,  55,  90 ) })

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                         TAB 3  —  EFFECTS                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ── Pulse ─────────────────────────────────────────────────────────────────────
local PulseBox = Tabs.Effects:AddLeftGroupbox("Pulse on Trigger")

PulseBox:AddToggle("PulseOn",    { Text="Enable Pulse",         Default=true  })
PulseBox:AddSlider("PulseDur",   { Text="Duration (s)",         Default=0.38, Min=0.1, Max=1.5, Rounding=2 })
PulseBox:AddSlider("PulseSc",    { Text="Scale",                Default=1.07, Min=1.01,Max=1.25,Rounding=2 })

-- ── Ready Flash ───────────────────────────────────────────────────────────────
local FlashBox = Tabs.Effects:AddLeftGroupbox("Ready Flash")

FlashBox:AddToggle("FlashOn",    { Text="Flash When Ready",     Default=true  })
FlashBox:AddSlider("FlashCnt",   { Text="Flash Count",          Default=3,    Min=1, Max=8             })
FlashBox:AddSlider("FlashSpd",   { Text="Flash Speed (s)",      Default=0.14, Min=0.04,Max=0.5,Rounding=2 })
FlashBox:AddLabel("Flash Color"):AddColorPicker("FlashClr", { Default=Color3.fromRGB(255, 255, 100) })

-- ── Notifications ─────────────────────────────────────────────────────────────
local NotifBox = Tabs.Effects:AddRightGroupbox("Notifications")

NotifBox:AddToggle("NotifReady",   { Text="Notify: Ability Ready",   Default=false })
NotifBox:AddToggle("NotifUse",     { Text="Notify: Ability Used",    Default=false })
NotifBox:AddToggle("NotifEnemy",   { Text="Notify: Enemy CD",        Default=false })
NotifBox:AddSlider("NotifDur",     { Text="Duration (s)",            Default=2, Min=1, Max=8 })

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                          TAB 4  —  EXTRA                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ── Cooldown Overrides ────────────────────────────────────────────────────────
local CdOvr = Tabs.Extra:AddLeftGroupbox("Cooldown Overrides")

CdOvr:AddSlider("DashCD",    { Text="Dash Cooldown (s)",    Default=5,  Min=0.5, Max=30,  Rounding=1 })
CdOvr:AddSlider("SideCD",    { Text="Side Cooldown (s)",    Default=2,  Min=0.5, Max=30,  Rounding=1 })
CdOvr:AddSlider("EvasiveCD", { Text="Evasive Cooldown (s)", Default=30, Min=1,   Max=120, Rounding=1 })

-- ── Statistics ────────────────────────────────────────────────────────────────
local StatsBox = Tabs.Extra:AddRightGroupbox("Session Statistics")

-- We store label references to update them later
local statLblDash    = StatsBox:AddLabel("Dash used: 0")
local statLblSide    = StatsBox:AddLabel("Side used: 0")
local statLblEvasive = StatsBox:AddLabel("Evasive used: 0")
local statLblEnemy   = StatsBox:AddLabel("Enemy Dash tracked: 0")
local statLblEnemyE  = StatsBox:AddLabel("Enemy Evasive tracked: 0")

local usageStats = {
    Dash       = 0,
    Side       = 0,
    Evasive    = 0,
    EnemyDash  = 0,
    EnemyEva   = 0,
}

local function refreshStats()
    -- Obsidian labels may or may not expose SetText; use pcall for safety
    pcall(function() statLblDash:SetText("Dash used: "    .. usageStats.Dash)    end)
    pcall(function() statLblSide:SetText("Side used: "    .. usageStats.Side)    end)
    pcall(function() statLblEvasive:SetText("Evasive used: " .. usageStats.Evasive) end)
    pcall(function() statLblEnemy:SetText("Enemy Dash tracked: "   .. usageStats.EnemyDash) end)
    pcall(function() statLblEnemyE:SetText("Enemy Evasive tracked: " .. usageStats.EnemyEva) end)
end

StatsBox:AddButton("Reset Statistics", function()
    for k in pairs(usageStats) do usageStats[k] = 0 end
    refreshStats()
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                          SCREEN GUI ROOT                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TSBCooldownTracker"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 10
screenGui.Parent         = player:WaitForChild("PlayerGui")

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                        ABILITY CONFIGURATION                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Each entry defines the UI label, default cooldown, and the Option keys
-- that point to the color pickers registered above.
local ABILITY_CFG = {
    Dash = {
        label        = "FRONT DASH",
        defaultCD    = 5,
        cdKey        = "DashCD",
        fillKey      = "DashFill",
        numKey       = "DashNum",
        bgKey        = "DashBG",
        lblKey       = "DashLbl",
        borderKey    = "DashBorder",
        order        = 1,
    },
    Side = {
        label        = "SIDE DASH",
        defaultCD    = 2,
        cdKey        = "SideCD",
        fillKey      = "SideFill",
        numKey       = "SideNum",
        bgKey        = "SideBG",
        lblKey       = "SideLbl",
        borderKey    = "SideBorder",
        order        = 2,
    },
    Evasive = {
        label        = "EVASIVE",
        defaultCD    = 30,
        cdKey        = "EvasiveCD",
        fillKey      = "EvaFill",
        numKey       = "EvaNum",
        bgKey        = "EvaBG",
        lblKey       = "EvaLbl",
        borderKey    = "EvaBorder",
        order        = 3,
    },
}

-- Stable iteration order
local ABILITY_ORDER = {"Dash", "Side", "Evasive"}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                         BAR CONSTRUCTION                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local bars = {}  -- bars[name] = { container, frame, fill, shine, text, abilityLabel, ... }

local function createBar(name)
    local cfg = ABILITY_CFG[name]

    -- ── Outer container (label + bar stacked vertically) ──────────────────────
    local container = Instance.new("Frame")
    container.Name                 = name .. "_Container"
    container.BackgroundTransparency = 1
    container.BorderSizePixel      = 0
    container.ZIndex               = 2
    container.Parent               = screenGui

    -- ── Ability name label (sits above the bar) ───────────────────────────────
    local abilityLabel = Instance.new("TextLabel")
    abilityLabel.Name                  = "AbilityLabel"
    abilityLabel.BackgroundTransparency = 1
    abilityLabel.BorderSizePixel       = 0
    abilityLabel.Text                  = cfg.label
    abilityLabel.Font                  = Enum.Font.GothamBold
    abilityLabel.TextScaled            = false
    abilityLabel.TextXAlignment        = Enum.TextXAlignment.Left
    abilityLabel.TextYAlignment        = Enum.TextYAlignment.Bottom
    abilityLabel.ZIndex                = 3
    abilityLabel.Parent                = container

    -- ── Background bar frame ──────────────────────────────────────────────────
    local frame = Instance.new("Frame")
    frame.Name             = "BarFrame"
    frame.BorderSizePixel  = 0
    frame.ZIndex           = 3
    frame.ClipsDescendants = false
    frame.Parent           = container

    local barCorner = Instance.new("UICorner", frame)

    -- Border stroke on the background bar
    local barStroke = Instance.new("UIStroke", frame)
    barStroke.Thickness       = 1
    barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    barStroke.Transparency    = 0.25

    -- ── Fill bar (child of frame, clipped) ────────────────────────────────────
    local fillClip = Instance.new("Frame")
    fillClip.Name                  = "FillClip"
    fillClip.BackgroundTransparency = 1
    fillClip.BorderSizePixel       = 0
    fillClip.ClipsDescendants      = true
    fillClip.ZIndex                = 4
    fillClip.Size                  = UDim2.new(1, 0, 1, 0)
    fillClip.Position              = UDim2.new(0, 0, 0, 0)
    fillClip.Parent                = frame

    local fill = Instance.new("Frame")
    fill.Name             = "Fill"
    fill.BorderSizePixel  = 0
    fill.ZIndex           = 4
    fill.Parent           = fillClip

    local fillCorner = Instance.new("UICorner", fill)

    -- ── Shine highlight strip (top portion of fill, semi-transparent white) ───
    local shine = Instance.new("Frame")
    shine.Name                   = "Shine"
    shine.Size                   = UDim2.new(1, 0, 0.42, 0)
    shine.Position               = UDim2.new(0, 0, 0, 0)
    shine.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.82
    shine.BorderSizePixel        = 0
    shine.ZIndex                 = 5
    shine.Parent                 = fill
    Instance.new("UICorner", shine)

    -- ── Number / status text label (inside bar, right-aligned) ───────────────
    local numLabel = Instance.new("TextLabel")
    numLabel.Name                  = "TimeText"
    numLabel.BackgroundTransparency = 1
    numLabel.Size                  = UDim2.new(1, -10, 1, 0)
    numLabel.Position              = UDim2.new(0, 5, 0, 0)
    numLabel.Font                  = Enum.Font.GothamBold
    numLabel.TextScaled            = false
    numLabel.TextXAlignment        = Enum.TextXAlignment.Right
    numLabel.TextYAlignment        = Enum.TextYAlignment.Center
    numLabel.TextStrokeTransparency = 0.45
    numLabel.TextStrokeColor3      = BLACK
    numLabel.ZIndex                = 7
    numLabel.Parent                = frame

    -- ── Store all refs ────────────────────────────────────────────────────────
    bars[name] = {
        container    = container,
        frame        = frame,
        fillClip     = fillClip,
        fill         = fill,
        shine        = shine,
        text         = numLabel,
        abilityLabel = abilityLabel,
        barCorner    = barCorner,
        fillCorner   = fillCorner,
        barStroke    = barStroke,
        -- State
        time         = 0,
        duration     = cfg.defaultCD,
        visRatio     = 0,       -- smoothly lerped visual fill ratio
        prevOnCd     = false,   -- was on cooldown last frame (for ready detection)
        pulseActive  = false,
        readyFlashing = false,
    }
end

for _, name in ipairs(ABILITY_ORDER) do
    createBar(name)
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                        EFFECT HELPERS                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ── Pulse (scale the bar out then back on trigger) ────────────────────────────

local function doPulse(barData)
    if not Toggles.PulseOn.Value  then return end
    if barData.pulseActive         then return end
    barData.pulseActive = true

    local frame    = barData.frame
    local scale    = Options.PulseSc.Value  or 1.07
    local halfDur  = (Options.PulseDur.Value or 0.38) * 0.5

    -- Temporarily scale using Size (no Scale object to avoid conflicts)
    local origSize = frame.Size
    local scaledW  = UDim2.new(
        origSize.X.Scale * scale, origSize.X.Offset * scale,
        origSize.Y.Scale * scale, origSize.Y.Offset * scale
    )

    -- Store original position offset so we can re-centre
    local origPos = frame.Position

    TweenService:Create(frame, TweenInfo.new(halfDur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = scaledW,
    }):Play()

    task.delay(halfDur, function()
        TweenService:Create(frame, TweenInfo.new(halfDur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = origSize,
        }):Play()
        task.delay(halfDur + 0.05, function()
            barData.pulseActive = false
        end)
    end)
end

-- ── Ready Flash (briefly tint fill to flash colour) ───────────────────────────

local function doReadyFlash(barData)
    if not Toggles.FlashOn.Value    then return end
    if barData.readyFlashing         then return end
    barData.readyFlashing = true

    local fill      = barData.fill
    local flashClr  = Options.FlashClr and Options.FlashClr.Value or Color3.fromRGB(255, 255, 100)
    local origClr   = fill.BackgroundColor3
    local count     = Options.FlashCnt.Value or 3
    local spd       = Options.FlashSpd.Value or 0.14

    local function flashN(n)
        if n <= 0 then
            pcall(function() fill.BackgroundColor3 = origClr end)
            barData.readyFlashing = false
            return
        end
        TweenService:Create(fill, TweenInfo.new(spd, Enum.EasingStyle.Linear), { BackgroundColor3 = flashClr }):Play()
        task.delay(spd, function()
            TweenService:Create(fill, TweenInfo.new(spd, Enum.EasingStyle.Linear), { BackgroundColor3 = origClr }):Play()
            task.delay(spd, function() flashN(n - 1) end)
        end)
    end

    task.spawn(flashN, count)
end

-- ── Notification helper ───────────────────────────────────────────────────────

local function pushNotif(title, body)
    pcall(function()
        Library:Notify({
            Title    = title,
            Content  = body,
            Duration = Options.NotifDur.Value or 2,
        })
    end)
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                         MAIN BAR UPDATE LOOP                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

RunService.Heartbeat:Connect(function(dt)
    -- Read all option values once per frame to avoid repeated table lookups
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
    local fillDir    = Options.FillDir.Value       -- "Left" or "Right"
    local fontChoice = Options.FontChoice.Value
    local font       = FONT_MAP[fontChoice] or Enum.Font.GothamBold

    local showBars    = Toggles.ShowBars.Value
    local showNums    = Toggles.ShowNumbers.Value
    local showLabels  = Toggles.ShowLabels.Value
    local showReady   = Toggles.ShowReady.Value
    local showPct     = Toggles.ShowPercent.Value
    local showBorder  = Toggles.ShowBorder.Value
    local showShine   = Toggles.ShowShine.Value

    -- Centred layout: total width of all three bars
    local totalW = #ABILITY_ORDER * width + (#ABILITY_ORDER - 1) * spacing
    local startX = -totalW / 2

    for i, name in ipairs(ABILITY_ORDER) do
        local data = bars[name]
        local cfg  = ABILITY_CFG[name]

        -- Update duration from override slider
        if Options[cfg.cdKey] then
            data.duration = Options[cfg.cdKey].Value
        end

        -- ── Tick down ────────────────────────────────────────────────────────
        if data.time > 0 then
            data.time = math.max(data.time - dt, 0)
        end

        -- ── Compute ratios ───────────────────────────────────────────────────
        local realRatio = 1 - (data.time / math.max(data.duration, 0.001))
        local lf        = math.min(lerpSpd * dt, 1)
        data.visRatio   = data.visRatio + (realRatio - data.visRatio) * lf

        -- ── Ready transition ─────────────────────────────────────────────────
        local isOnCd = data.time > 0
        if data.prevOnCd and not isOnCd then
            -- Just became ready
            task.spawn(doReadyFlash, data)
            if Toggles.NotifReady.Value then
                pushNotif("✓ Ready", name .. " cooldown is ready!")
            end
        end
        data.prevOnCd = isOnCd

        -- ── Positioning ──────────────────────────────────────────────────────
        local xOff  = startX + (i - 1) * (width + spacing)
        local lblH  = showLabels and (lblSize + 3) or 0
        local totH  = height + lblH + (showLabels and 2 or 0)

        data.container.Size     = UDim2.new(0, width, 0, totH)
        data.container.Position = UDim2.new(posX, xOff, posY, -totH / 2)

        -- ── Ability name label ───────────────────────────────────────────────
        data.abilityLabel.Size      = UDim2.new(1, 0, 0, lblH)
        data.abilityLabel.Position  = UDim2.new(0, 2, 0, 0)
        data.abilityLabel.TextSize  = lblSize
        data.abilityLabel.Font      = font
        data.abilityLabel.TextColor3 = Options[cfg.lblKey].Value
        data.abilityLabel.Visible   = showLabels

        -- ── Bar frame sizing ─────────────────────────────────────────────────
        data.frame.Size     = UDim2.new(0, width, 0, height)
        data.frame.Position = UDim2.new(0, 0, 0, lblH + (showLabels and 2 or 0))
        data.barCorner.CornerRadius = UDim.new(0, cornerR)
        data.fillCorner.CornerRadius = UDim.new(0, cornerR)

        -- ── Color values ─────────────────────────────────────────────────────
        local fillClr   = Options[cfg.fillKey].Value
        local bgClr     = Options[cfg.bgKey].Value
        local numClr    = Options[cfg.numKey].Value
        local borderClr = Options[cfg.borderKey].Value

        -- ── Border stroke ────────────────────────────────────────────────────
        data.barStroke.Enabled     = showBorder
        data.barStroke.Color       = borderClr
        data.barStroke.Transparency = 0.25

        -- ── Shine visibility ─────────────────────────────────────────────────
        data.shine.Visible = showShine

        -- ── Bars visible branch ──────────────────────────────────────────────
        if showBars then
            data.container.Visible               = true
            data.frame.Visible                   = true
            data.fill.Visible                    = true
            data.frame.BackgroundColor3          = bgClr
            data.frame.BackgroundTransparency    = bgTransp
            data.fill.BackgroundColor3           = fillClr
            data.fill.BackgroundTransparency     = fillTransp

            -- Fill sizing + direction
            local ratio = math.clamp(data.visRatio, 0, 1)
            if fillDir == "Left" then
                data.fill.AnchorPoint = Vector2.new(0, 0)
                data.fill.Position    = UDim2.new(0, 0, 0, 0)
                data.fill.Size        = UDim2.new(ratio, 0, 1, 0)
            else
                data.fill.AnchorPoint = Vector2.new(1, 0)
                data.fill.Position    = UDim2.new(1, 0, 0, 0)
                data.fill.Size        = UDim2.new(ratio, 0, 1, 0)
            end

        elseif showNums then
            -- Numbers-only mode: hide the fill, make BG transparent
            data.container.Visible             = true
            data.frame.Visible                 = true
            data.fill.Visible                  = false
            data.frame.BackgroundTransparency  = 1
        else
            data.container.Visible = false
        end

        -- ── Number / READY text (skip when hidden) ──────────────────────
        if data.container.Visible then
            data.text.Font     = font
            data.text.TextSize = textSize

            if showNums then
                if isOnCd then
                    data.text.TextColor3 = numClr
                    if showPct then
                        data.text.Text = string.format("%.0f%%", realRatio * 100)
                    else
                        data.text.Text = string.format("%.1f", data.time)
                    end
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

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                        LOCAL PLAYER ANIMATION DETECTION                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Animations that trigger bars — {abilityName, ids}
local ANIM_MAP = {
    { name="Dash", ids={ 10479335397, 10491993682 } },
    { name="Side", ids={ 10480793962, 10480796021 } },
}

local function trigger(name)
    local data = bars[name]
    if not data then return end

    -- Refresh duration from override
    local cfg = ABILITY_CFG[name]
    if cfg and Options[cfg.cdKey] then
        data.duration = Options[cfg.cdKey].Value
    end

    data.time    = data.duration
    data.prevOnCd = true

    -- Stats
    if usageStats[name] ~= nil then
        usageStats[name] = usageStats[name] + 1
        task.spawn(refreshStats)
    end

    -- Pulse
    task.spawn(doPulse, data)

    -- Notification
    if Toggles.NotifUse.Value then
        pushNotif("⚡ Used", name .. " activated!")
    end
end

local function onLocalAnimId(id)
    for _, entry in ipairs(ANIM_MAP) do
        for _, animId in ipairs(entry.ids) do
            if id == animId then
                trigger(entry.name)
            end
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

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                       OVERHEAD LABELS (OTHER PLAYERS)                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Only Dash and Evasive are tracked overhead
local OH_CFG = {
    Dash = {
        label      = "Front Dash",
        cdKey      = "DashCD",
        defaultCD  = 5,
        txtKey     = "OHDashTxt",
        bgKey      = "OHDashBG",
        statKey    = "EnemyDash",
    },
    Evasive = {
        label      = "Evasive",
        cdKey      = "EvasiveCD",
        defaultCD  = 30,
        txtKey     = "OHEvaTxt",
        bgKey      = "OHEvaBG",
        statKey    = "EnemyEva",
    },
}

local OH_ORDER = { "Dash", "Evasive" }

-- playerTrackers[p] = {
--     _billboard = BillboardGui,
--     Dash    = { time=N, label=TextLabel, bg=Frame },
--     Evasive = { time=N, label=TextLabel, bg=Frame },
-- }
local playerTrackers = {}

-- ── Build / rebuild overhead billboard for a player ───────────────────────────

local function buildOverhead(p)
    if not Toggles.ShowOH.Value then return end

    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- Remove old billboard
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
    bill.AlwaysOnTop    = Options.OHTop.Value
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

        -- Background frame
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

        local bgStroke = Instance.new("UIStroke", bg)
        bgStroke.Color          = Options.OHBorder.Value
        bgStroke.Thickness      = 1
        bgStroke.Transparency   = 0.4
        bgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- Text label
        local lbl = Instance.new("TextLabel")
        lbl.Name                   = abilityName .. "Text"
        lbl.Size                   = UDim2.new(1, -8, 1, 0)
        lbl.Position               = UDim2.new(0, 4, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text                   = ""
        lbl.TextColor3             = Options[cfg.txtKey].Value
        lbl.TextScaled             = false
        lbl.TextSize               = ohH * 0.62
        lbl.Font                   = Enum.Font.GothamBold
        lbl.TextXAlignment         = Enum.TextXAlignment.Center
        lbl.TextYAlignment         = Enum.TextYAlignment.Center
        lbl.TextStrokeTransparency = Options.OHStroke.Value
        lbl.TextStrokeColor3       = BLACK
        lbl.ZIndex                 = 2
        lbl.Parent                 = bg

        labelRefs[abilityName] = { lbl=lbl, bg=bg }
    end

    -- Ensure tracker entry
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

-- ── Trigger overhead cooldown for a specific player ───────────────────────────

local function triggerOverhead(p, abilityName)
    local cfg = OH_CFG[abilityName]
    if not cfg then return end
    if not playerTrackers[p] then playerTrackers[p] = {} end
    if not playerTrackers[p][abilityName] then
        playerTrackers[p][abilityName] = { time=0, label=nil, bg=nil }
    end

    local cd = cfg.defaultCD
    if Options[cfg.cdKey] then cd = Options[cfg.cdKey].Value end
    playerTrackers[p][abilityName].time = cd

    -- Stats
    if usageStats[cfg.statKey] ~= nil then
        usageStats[cfg.statKey] = usageStats[cfg.statKey] + 1
        task.spawn(refreshStats)
    end

    -- Notification
    if Toggles.NotifEnemy.Value then
        pushNotif("👁 Enemy", p.Name .. " used " .. abilityName .. "!")
    end
end

-- ── Per-player setup ──────────────────────────────────────────────────────────

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
            -- Only Dash IDs trigger overhead
            for _, entry in ipairs(ANIM_MAP) do
                if entry.name == "Dash" then
                    for _, animId in ipairs(entry.ids) do
                        if id == animId then
                            triggerOverhead(p, "Dash")
                        end
                    end
                end
            end
        end)
    end

    if p.Character then task.spawn(onChar, p.Character) end
    p.CharacterAdded:Connect(onChar)
end

-- Init players already in server
for _, p in ipairs(Players:GetPlayers()) do
    setupPlayer(p)
end

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(p)
    local tracker = playerTrackers[p]
    if not tracker then return end
    if tracker._billboard then
        pcall(function() tracker._billboard:Destroy() end)
    end
    playerTrackers[p] = nil
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                     EVASIVE DETECTION  (all players)                       ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- RagdollCancel is the in-world signal that evasive was used.
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

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                      OVERHEAD UPDATE LOOP                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

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
    local ohAlTop  = Options.OHTop.Value
    local borderC  = Options.OHBorder.Value
    local totH     = #OH_ORDER * ohH + (#OH_ORDER - 1) * ohSp

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

            -- Tick
            if data.time > 0 then
                data.time = math.max(data.time - dt, 0)
            end

            local lbl = data.label
            local bg  = data.bg
            local cfg = OH_CFG[abilityName]
            if not cfg or not lbl or not bg then continue end
            if not lbl.Parent or not bg.Parent then continue end

            -- Update style
            lbl.TextColor3             = Options[cfg.txtKey].Value
            lbl.TextStrokeTransparency = ohStr
            lbl.TextSize               = ohH * 0.62

            -- BG appearance
            if showBG then
                bg.BackgroundTransparency = ohBGT
                bg.BackgroundColor3       = Options[cfg.bgKey].Value
            else
                bg.BackgroundTransparency = 1
            end

            -- Border stroke
            local stroke = bg:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Enabled     = showBord
                stroke.Color       = borderC
                stroke.Transparency = 0.35
            end

            -- Text content
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

-- ── Initial stat refresh ──────────────────────────────────────────────────────
refreshStats()

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                             END OF SCRIPT                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
