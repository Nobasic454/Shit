-- ╔══════════════════════════════════════════════════════════════════════════════════════╗
-- ║                                                                                      ║
-- ║    ████████╗ ███████╗ ██████╗     ██████╗  ██████╗  ███████╗ ███╗   ███╗           ║
-- ║       ██╔══╝ ██╔════╝ ██╔══██╗    ██╔══██╗ ██╔══██╗ ██╔════╝ ████╗ ████║           ║
-- ║       ██║    ███████╗ ██████╔╝    ██████╔╝ ██████╔╝ █████╗   ██╔████╔██║           ║
-- ║       ██║    ╚════██║ ██╔══██╗    ██╔═══╝  ██╔══██╗ ██╔══╝   ██║╚██╔╝██║           ║
-- ║       ██║    ███████║ ██████╔╝    ██║      ██║  ██║ ███████╗ ██║ ╚═╝ ██║           ║
-- ║       ╚═╝    ╚══════╝ ╚═════╝     ╚═╝      ╚═╝  ╚═╝ ╚══════╝ ╚═╝     ╚═╝           ║
-- ║                                                                                      ║
-- ║          P R E M I U M   B A R S   ·   v 6 . 0   C R Y S T A L                    ║
-- ║                                                                                      ║
-- ║    ◈ Front Dash  ·  Side Dash  ·  Evasive                                          ║
-- ║    ◈ Player bars  +  Enemy overhead bars  (identical premium stack)                 ║
-- ║    ◈ 28 visual layers per bar · 6 live effect loops · Full Obsidian UI             ║
-- ║                                                                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════════════╝
--
-- ─────────────────────────────────────────────────────────────────────────────────────
--  VISUAL LAYER ORDER  (bottom = 1, top = highest number)
-- ─────────────────────────────────────────────────────────────────────────────────────
--
--   z1  ── Outer drop shadow          Wide very-faint dark blur behind bar
--   z1  ── Outer shadow glow          Faint coloured version of shadow
--   z2  ── Depth rim                  Thin offset stroke for 3-D ledge illusion
--   z2  ── Outer halo glow            Broad soft coloured halo (colour = fill)
--   z3  ── Inner glow                 Tight ring behind bar  (brighter)
--   z3  ── Ready aura ring            Separate pulsing ring, only while READY
--   z4  ── Crystal prism left         Diamond-like accent triangle, left end
--   z4  ── Crystal prism right        Diamond-like accent triangle, right end
--   z5  ── Reflection strip           Faint upside-down mirror beneath bar
--   z6  ── Ability label              Text above bar (icon + name)
--   z7  ── Bar background frame
--       └─ BG arcane gradient         Top-to-bottom purple-dark tint
--       └─ BG noise layer             Subtle texture overlay
--       └─ UIStroke border            Customisable colour + thickness
--       └─ Tick marks  25/50/75 %     Vertical dividers inside BG
--       └─ Left edge accent           Bright 2-px vertical strip at bar left
--       └─ Right edge accent          Bright 2-px vertical strip at bar right
--       └─ Warning overlay            Red tint frame pulsing when CD < thresh
--   z8  ── Fill clip (ClipsDescendants mask)
--       └─ Fill bar
--           └─ Fill gradient          Iridescent lavender → sky-blue → deep
--           └─ Fill colour layer      Solid base colour (blended with gradient)
--           └─ Enchant sweep          Animated horizontal light glide
--           └─ Second sweep (slower)  Offset second sweep for depth
--           └─ Shine hairline         2-px bright line at very top of fill
--           └─ Shine overlay          Frosted glass top-half highlight
--           └─ Specular dot           Moving bright point on fill surface
--           └─ Edge highlight R       Bright 3-px strip at right edge of fill
--           └─ Sparkle dots (×9)      Tiny blinking circles across fill
--   z9  ── Corner gem left            Accent circle, left end of bar
--   z9  ── Corner gem right           Accent circle, right end of bar
--   z9  ── Corner gem top-L           Small dot top-left corner
--   z9  ── Corner gem top-R           Small dot top-right corner
--  z10  ── Cooldown number label      Right-aligned time / READY text
--  z10  ── Icon label                 Small emoji/symbol on bar left
--
-- ─────────────────────────────────────────────────────────────────────────────────────
--  EFFECTS
-- ─────────────────────────────────────────────────────────────────────────────────────
--
--   ① Trigger pulse      Bar pops scale-X + scale-Y on ability use
--   ② Ready flash        Fill colour blinks when CD expires
--   ③ Ready breath       Border + glows breathe rhythmically while READY
--   ④ Warning pulse      Red overlay throbs in last N % of cooldown
--   ⑤ Aura pulse         Ready aura ring breathes independently
--   ⑥ Specular travel    Bright dot travels across fill surface continuously
--
-- ─────────────────────────────────────────────────────────────────────────────────────
--  DETECTION
-- ─────────────────────────────────────────────────────────────────────────────────────
--
--   Front Dash  anim IDs  10479335397 · 10491993682
--   Side Dash   anim IDs  10480793962 · 10480796021
--   Evasive     RagdollCancel descendant in LiveFolder
--   All three detected for  LOCAL PLAYER  and  ALL ENEMIES
--
-- ─────────────────────────────────────────────────────────────────────────────────────

-- ════════════════════════════════════════════════════════════════════════════════════
--  §0   ROBLOX SERVICES
-- ════════════════════════════════════════════════════════════════════════════════════

local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player     = Players.LocalPlayer
local LiveFolder = Workspace:WaitForChild("Live")

-- ════════════════════════════════════════════════════════════════════════════════════
--  §1   OBSIDIAN LIBRARY  (auto-fetched from GitHub)
-- ════════════════════════════════════════════════════════════════════════════════════

local repo    = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local Options  = Library.Options
local Toggles  = Library.Toggles

-- ════════════════════════════════════════════════════════════════════════════════════
--  §2   GLOBAL COLOUR PALETTE
-- ════════════════════════════════════════════════════════════════════════════════════

local C = {
    BLACK       = Color3.fromRGB(  0,   0,   0),
    WHITE       = Color3.fromRGB(255, 255, 255),
    READY       = Color3.fromRGB(140, 255, 195),   -- mint-green  READY text
    DANGER      = Color3.fromRGB(255,  48,  48),   -- hot-red
    WARNING     = Color3.fromRGB(255, 168,  20),   -- amber
    GRAD_LAV    = Color3.fromRGB(218, 200, 255),   -- lavender    fill shimmer
    GRAD_SKY    = Color3.fromRGB(178, 218, 255),   -- sky-blue    fill shimmer
    GRAD_DEEP   = Color3.fromRGB( 32,  20, 108),   -- deep indigo fill shadow
    GRAD_BGPUR  = Color3.fromRGB(148, 128, 215),   -- BG arcane purple tint
    GRAD_BGTOP  = Color3.fromRGB( 24,  18,  48),   -- BG top dark
    GRAD_BGBOT  = Color3.fromRGB(  6,   4,  16),   -- BG bottom very dark
    CRYSTAL_L   = Color3.fromRGB(200, 240, 255),   -- crystal prism light
    NOISE_A     = Color3.fromRGB( 80,  70, 120),   -- noise layer A
    NOISE_B     = Color3.fromRGB( 40,  35,  80),   -- noise layer B
}

-- ════════════════════════════════════════════════════════════════════════════════════
--  §3   FONT MAP
-- ════════════════════════════════════════════════════════════════════════════════════

local FONT_MAP = {
    GothamBold     = Enum.Font.GothamBold,
    GothamBlack    = Enum.Font.GothamBlack,
    Gotham         = Enum.Font.Gotham,
    GothamMedium   = Enum.Font.GothamMedium,
    SourceSansBold = Enum.Font.SourceSansBold,
    SourceSans     = Enum.Font.SourceSans,
    RobotoMono     = Enum.Font.RobotoMono,
    Fantasy        = Enum.Font.Fantasy,
    SciFi          = Enum.Font.SciFi,
    Arcade         = Enum.Font.Arcade,
    Highway        = Enum.Font.Highway,
    Cartoon        = Enum.Font.Cartoon,
    Bodoni         = Enum.Font.Bodoni,
    Garamond       = Enum.Font.Garamond,
}
local FONT_LIST = {
    "GothamBold","GothamBlack","Gotham","GothamMedium",
    "SourceSansBold","SourceSans","RobotoMono",
    "Fantasy","SciFi","Arcade","Highway","Cartoon","Bodoni","Garamond",
}

-- ════════════════════════════════════════════════════════════════════════════════════
--  §4   OBSIDIAN WINDOW + TABS
-- ════════════════════════════════════════════════════════════════════════════════════

local Win = Library:CreateWindow({
    Title            = "Crystal Bars  ·  v6",
    Footer           = "Premium",
    ShowCustomCursor = true,
})

local Tab = {
    Player  = Win:AddTab("Player Bars",  "box"),
    PColors = Win:AddTab("P. Colors",    "palette"),
    Enemy   = Win:AddTab("Enemy Bars",   "user"),
    EColors = Win:AddTab("E. Colors",    "palette"),
    Effects = Win:AddTab("Effects",      "star"),
    Crystal = Win:AddTab("Crystal FX",   "diamond"),
}

-- ════════════════════════════════════════════════════════════════════════════════════
--  §5   PLAYER BARS — GEOMETRY SLIDERS
-- ════════════════════════════════════════════════════════════════════════════════════

local PGeo = Tab.Player:AddLeftGroupbox("Geometry")
PGeo:AddSlider("PW",         {Text="Bar Width",           Default=178,  Min=60,  Max=360            })
PGeo:AddSlider("PH",         {Text="Bar Height",          Default=30,   Min=8,   Max=110            })
PGeo:AddSlider("PSp",        {Text="Bar Spacing",         Default=16,   Min=0,   Max=90             })
PGeo:AddSlider("PCr",        {Text="Corner Radius",       Default=9,    Min=0,   Max=22             })
PGeo:AddSlider("PX",         {Text="Position X",          Default=0.5,  Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PY",         {Text="Position Y",          Default=0.85, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PBGTr",      {Text="BG Transparency",     Default=0.16, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PFTr",       {Text="Fill Transparency",   Default=0,    Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PTxSz",      {Text="Number Size",         Default=14,   Min=6,   Max=42             })
PGeo:AddSlider("PLbSz",      {Text="Label Size",          Default=10,   Min=6,   Max=30             })
PGeo:AddSlider("PLp",        {Text="Fill Lerp Speed",     Default=10,   Min=1,   Max=50             })
PGeo:AddSlider("PGlSprd",    {Text="Glow Spread (px)",    Default=22,   Min=0,   Max=70             })
PGeo:AddSlider("PGlAlph",    {Text="Glow Alpha",          Default=0.82, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PShOff",     {Text="Shadow Offset",       Default=5,    Min=0,   Max=20             })
PGeo:AddSlider("PShAlph",    {Text="Shadow Alpha",        Default=0.64, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PGmSz",      {Text="Gem Size",            Default=8,    Min=0,   Max=22             })
PGeo:AddSlider("PTkAlph",    {Text="Tick Alpha",          Default=0.52, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PRfH",       {Text="Reflection Height",   Default=7,    Min=0,   Max=24             })
PGeo:AddSlider("PRfAlph",    {Text="Reflection Alpha",    Default=0.74, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PStTh",      {Text="Border Thickness",    Default=1.6,  Min=0.5, Max=6, Rounding=1  })
PGeo:AddSlider("PEdAlph",    {Text="Edge Highlight",      Default=0.52, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PShAlphFl",  {Text="Shine Opacity",       Default=0.80, Min=0,   Max=1, Rounding=2  })
PGeo:AddSlider("PSw1W",      {Text="Sweep-1 Width (%)",   Default=36,   Min=8,   Max=80             })
PGeo:AddSlider("PSw1D",      {Text="Sweep-1 Duration",    Default=2.4,  Min=0.4, Max=9, Rounding=1  })
PGeo:AddSlider("PSw1G",      {Text="Sweep-1 Gap (s)",     Default=3.2,  Min=1,   Max=14,Rounding=1  })
PGeo:AddSlider("PSw2W",      {Text="Sweep-2 Width (%)",   Default=18,   Min=4,   Max=50             })
PGeo:AddSlider("PSw2D",      {Text="Sweep-2 Duration",    Default=4.2,  Min=1,   Max=14,Rounding=1  })
PGeo:AddSlider("PSw2G",      {Text="Sweep-2 Gap (s)",     Default=6.0,  Min=2,   Max=20,Rounding=1  })
PGeo:AddSlider("PSpCnt",     {Text="Sparkle Count",       Default=9,    Min=0,   Max=14             })
PGeo:AddSlider("PWnTh",      {Text="Warn Threshold (%)",  Default=28,   Min=5,   Max=65             })
PGeo:AddSlider("PAuSp",      {Text="Aura Spread (px)",    Default=12,   Min=2,   Max=36             })
PGeo:AddSlider("PCrSz",      {Text="Crystal Prism Size",  Default=10,   Min=0,   Max=28             })
PGeo:AddSlider("PSpDotSz",   {Text="Specular Dot Size",   Default=6,    Min=2,   Max=20             })
PGeo:AddSlider("PNoiseAlph", {Text="Noise Layer Alpha",   Default=0.88, Min=0.5, Max=1, Rounding=2  })
PGeo:AddDropdown("PFDir",    {Values={"Left","Right"},    Default=1, Text="Fill Direction"           })
PGeo:AddDropdown("PFont",    {Values=FONT_LIST,           Default=1, Text="Bar Font"                 })

-- ════════════════════════════════════════════════════════════════════════════════════
--  §6   PLAYER BARS — VISIBILITY TOGGLES
-- ════════════════════════════════════════════════════════════════════════════════════

local PVis = Tab.Player:AddRightGroupbox("Visibility")
PVis:AddToggle("PBars",       {Text="Show Bars",                  Default=true })
PVis:AddToggle("PNums",       {Text="Show Numbers",               Default=true })
PVis:AddToggle("PLabels",     {Text="Show Ability Labels",        Default=true })
PVis:AddToggle("PReady",      {Text="Show READY Text",            Default=true })
PVis:AddToggle("PPct",        {Text="Percentage Mode",            Default=false})
PVis:AddToggle("PBorder",     {Text="Border Stroke",              Default=true })
PVis:AddToggle("PShine",      {Text="Shine + Shine Line",         Default=true })
PVis:AddToggle("PGlow",       {Text="Glow Layers",                Default=true })
PVis:AddToggle("PShadow",     {Text="Drop Shadow",                Default=true })
PVis:AddToggle("PDepthRim",   {Text="Depth Rim",                  Default=true })
PVis:AddToggle("PGems",       {Text="Corner Gems (×4)",           Default=true })
PVis:AddToggle("PTicks",      {Text="Tick Marks 25/50/75%",       Default=true })
PVis:AddToggle("PReflect",    {Text="Reflection Strip",           Default=true })
PVis:AddToggle("PEdge",       {Text="Edge Highlights L+R",        Default=true })
PVis:AddToggle("PSweep1",     {Text="Sweep 1 (fast)",             Default=true })
PVis:AddToggle("PSweep2",     {Text="Sweep 2 (slow, wide)",       Default=true })
PVis:AddToggle("PSparkles",   {Text="Sparkle Dots",               Default=true })
PVis:AddToggle("PWarnOv",     {Text="Warning Overlay",            Default=true })
PVis:AddToggle("PReadyAura",  {Text="Ready Aura Ring",            Default=true })
PVis:AddToggle("PCrystals",   {Text="Crystal Prisms L+R",         Default=true })
PVis:AddToggle("PSpecular",   {Text="Specular Dot Travel",        Default=true })
PVis:AddToggle("PNoise",      {Text="Noise Texture Layer",        Default=true })
PVis:AddToggle("PBGEdgeL",    {Text="BG Left Edge Accent",        Default=true })
PVis:AddToggle("PBGEdgeR",    {Text="BG Right Edge Accent",       Default=true })
PVis:AddToggle("PColorTime",  {Text="Dynamic Danger Tint",        Default=true })
PVis:AddToggle("PIconLabel",  {Text="Icon Label on Bar",          Default=true })

-- ════════════════════════════════════════════════════════════════════════════════════
--  §7   PLAYER COLORS — DASH
-- ════════════════════════════════════════════════════════════════════════════════════

local PDC = Tab.PColors:AddLeftGroupbox("◈  FRONT DASH")
PDC:AddLabel("Fill"):AddColorPicker("PDFill",       {Default=Color3.fromRGB( 72, 148, 255)})
PDC:AddLabel("Fill Danger"):AddColorPicker("PDDngr",{Default=Color3.fromRGB(255,  60,  60)})
PDC:AddLabel("Fill Warning"):AddColorPicker("PDWrn",{Default=Color3.fromRGB(255, 160,  20)})
PDC:AddLabel("Number"):AddColorPicker("PDNum",      {Default=Color3.fromRGB(205, 232, 255)})
PDC:AddLabel("Background"):AddColorPicker("PDBG",   {Default=Color3.fromRGB(  4,   7,  26)})
PDC:AddLabel("Label"):AddColorPicker("PDLbl",       {Default=Color3.fromRGB(148, 208, 255)})
PDC:AddLabel("Border"):AddColorPicker("PDBrd",      {Default=Color3.fromRGB( 60, 124, 255)})
PDC:AddLabel("Glow"):AddColorPicker("PDGlw",        {Default=Color3.fromRGB( 20,  82, 255)})
PDC:AddLabel("Shadow"):AddColorPicker("PDShd",      {Default=Color3.fromRGB(  4,  16,  58)})
PDC:AddLabel("Gem"):AddColorPicker("PDGem",         {Default=Color3.fromRGB(115, 196, 255)})
PDC:AddLabel("Depth Rim"):AddColorPicker("PDRim",   {Default=Color3.fromRGB( 38,  76, 178)})
PDC:AddLabel("Aura"):AddColorPicker("PDAur",        {Default=Color3.fromRGB( 96, 196, 255)})
PDC:AddLabel("Warn Overlay"):AddColorPicker("PDWOv",{Default=Color3.fromRGB(255,  50,  50)})
PDC:AddLabel("Crystal"):AddColorPicker("PDCry",     {Default=Color3.fromRGB(180, 222, 255)})
PDC:AddLabel("Specular"):AddColorPicker("PDSpc",    {Default=Color3.fromRGB(240, 248, 255)})
PDC:AddLabel("BG Noise"):AddColorPicker("PDNoi",    {Default=Color3.fromRGB( 30,  50, 120)})
PDC:AddLabel("BG Edge"):AddColorPicker("PDEdgC",    {Default=Color3.fromRGB( 80, 150, 255)})
PDC:AddLabel("Reflection"):AddColorPicker("PDRef",  {Default=Color3.fromRGB( 60, 120, 220)})

-- ════════════════════════════════════════════════════════════════════════════════════
--  §8   PLAYER COLORS — SIDE
-- ════════════════════════════════════════════════════════════════════════════════════

local PSC = Tab.PColors:AddLeftGroupbox("◈  SIDE DASH")
PSC:AddLabel("Fill"):AddColorPicker("PSFill",       {Default=Color3.fromRGB(255, 192,  48)})
PSC:AddLabel("Fill Danger"):AddColorPicker("PSDngr",{Default=Color3.fromRGB(255,  55,  55)})
PSC:AddLabel("Fill Warning"):AddColorPicker("PSWrn",{Default=Color3.fromRGB(255, 135,  15)})
PSC:AddLabel("Number"):AddColorPicker("PSNum",      {Default=Color3.fromRGB(255, 244, 190)})
PSC:AddLabel("Background"):AddColorPicker("PSBG",   {Default=Color3.fromRGB( 20,  13,   2)})
PSC:AddLabel("Label"):AddColorPicker("PSLbl",       {Default=Color3.fromRGB(255, 212,  96)})
PSC:AddLabel("Border"):AddColorPicker("PSBrd",      {Default=Color3.fromRGB(222, 162,  16)})
PSC:AddLabel("Glow"):AddColorPicker("PSGlw",        {Default=Color3.fromRGB(198, 126,   0)})
PSC:AddLabel("Shadow"):AddColorPicker("PSShd",      {Default=Color3.fromRGB( 48,  28,   0)})
PSC:AddLabel("Gem"):AddColorPicker("PSGem",         {Default=Color3.fromRGB(255, 224, 105)})
PSC:AddLabel("Depth Rim"):AddColorPicker("PSRim",   {Default=Color3.fromRGB(158,  96,   8)})
PSC:AddLabel("Aura"):AddColorPicker("PSAur",        {Default=Color3.fromRGB(255, 208,  74)})
PSC:AddLabel("Warn Overlay"):AddColorPicker("PSWOv",{Default=Color3.fromRGB(255,  50,  50)})
PSC:AddLabel("Crystal"):AddColorPicker("PSCry",     {Default=Color3.fromRGB(255, 236, 170)})
PSC:AddLabel("Specular"):AddColorPicker("PSSpc",    {Default=Color3.fromRGB(255, 252, 220)})
PSC:AddLabel("BG Noise"):AddColorPicker("PSNoi",    {Default=Color3.fromRGB(100,  65,   0)})
PSC:AddLabel("BG Edge"):AddColorPicker("PSEdgC",    {Default=Color3.fromRGB(220, 160,  20)})
PSC:AddLabel("Reflection"):AddColorPicker("PSRef",  {Default=Color3.fromRGB(200, 140,  10)})

-- ════════════════════════════════════════════════════════════════════════════════════
--  §9   PLAYER COLORS — EVASIVE
-- ════════════════════════════════════════════════════════════════════════════════════

local PEC = Tab.PColors:AddRightGroupbox("◈  EVASIVE")
PEC:AddLabel("Fill"):AddColorPicker("PEFill",       {Default=Color3.fromRGB(202,  58, 255)})
PEC:AddLabel("Fill Danger"):AddColorPicker("PEDngr",{Default=Color3.fromRGB(255,  40, 118)})
PEC:AddLabel("Fill Warning"):AddColorPicker("PEWrn",{Default=Color3.fromRGB(255, 112,  35)})
PEC:AddLabel("Number"):AddColorPicker("PENum",      {Default=Color3.fromRGB(234, 198, 255)})
PEC:AddLabel("Background"):AddColorPicker("PEBG",   {Default=Color3.fromRGB( 14,   3,  28)})
PEC:AddLabel("Label"):AddColorPicker("PELbl",       {Default=Color3.fromRGB(192, 112, 255)})
PEC:AddLabel("Border"):AddColorPicker("PEBrd",      {Default=Color3.fromRGB(172,  42, 222)})
PEC:AddLabel("Glow"):AddColorPicker("PEGlw",        {Default=Color3.fromRGB(128,  12, 198)})
PEC:AddLabel("Shadow"):AddColorPicker("PEShd",      {Default=Color3.fromRGB( 34,   5,  58)})
PEC:AddLabel("Gem"):AddColorPicker("PEGem",         {Default=Color3.fromRGB(218, 138, 255)})
PEC:AddLabel("Depth Rim"):AddColorPicker("PERim",   {Default=Color3.fromRGB(108,  26, 162)})
PEC:AddLabel("Aura"):AddColorPicker("PEAur",        {Default=Color3.fromRGB(198,  86, 255)})
PEC:AddLabel("Warn Overlay"):AddColorPicker("PEWOv",{Default=Color3.fromRGB(255,  40,  98)})
PEC:AddLabel("Crystal"):AddColorPicker("PECry",     {Default=Color3.fromRGB(228, 180, 255)})
PEC:AddLabel("Specular"):AddColorPicker("PESpc",    {Default=Color3.fromRGB(248, 230, 255)})
PEC:AddLabel("BG Noise"):AddColorPicker("PENoi",    {Default=Color3.fromRGB( 80,  20, 130)})
PEC:AddLabel("BG Edge"):AddColorPicker("PEEdgC",    {Default=Color3.fromRGB(175,  45, 225)})
PEC:AddLabel("Reflection"):AddColorPicker("PERef",  {Default=Color3.fromRGB(150,  35, 200)})

-- Shared player colours
local PShC = Tab.PColors:AddRightGroupbox("Shared")
PShC:AddLabel("READY text"):AddColorPicker("PReadyC",   {Default=Color3.fromRGB(140, 255, 195)})
PShC:AddLabel("Flash"):AddColorPicker("PFlashC",         {Default=Color3.fromRGB(255, 255,  90)})
PShC:AddLabel("Tick marks"):AddColorPicker("PTickC",     {Default=Color3.fromRGB(255, 255, 255)})
PShC:AddLabel("Sweep 1"):AddColorPicker("PSw1C",         {Default=Color3.fromRGB(255, 255, 255)})
PShC:AddLabel("Sweep 2"):AddColorPicker("PSw2C",         {Default=Color3.fromRGB(220, 220, 255)})
PShC:AddLabel("Shine line"):AddColorPicker("PShnLC",     {Default=Color3.fromRGB(255, 255, 255)})
PShC:AddLabel("Shine overlay"):AddColorPicker("PShnOC",  {Default=Color3.fromRGB(255, 255, 255)})
PShC:AddLabel("Icon text"):AddColorPicker("PIconC",      {Default=Color3.fromRGB(255, 255, 255)})

-- ════════════════════════════════════════════════════════════════════════════════════
--  §10  ENEMY BARS — GEOMETRY SLIDERS
-- ════════════════════════════════════════════════════════════════════════════════════

local EGeo = Tab.Enemy:AddLeftGroupbox("Enemy Geometry")
EGeo:AddSlider("EW",         {Text="Bar Width",           Default=142,  Min=60,  Max=330            })
EGeo:AddSlider("EH",         {Text="Bar Height",          Default=22,   Min=6,   Max=64             })
EGeo:AddSlider("ESp",        {Text="Bar Spacing",         Default=8,    Min=0,   Max=34             })
EGeo:AddSlider("ECr",        {Text="Corner Radius",       Default=6,    Min=0,   Max=18             })
EGeo:AddSlider("EStd",       {Text="Studs Above Head",    Default=3.6,  Min=1,   Max=16,Rounding=1  })
EGeo:AddSlider("EBGTr",      {Text="BG Transparency",     Default=0.20, Min=0,   Max=1, Rounding=2  })
EGeo:AddSlider("ETxSz",      {Text="Number Size",         Default=11,   Min=6,   Max=30             })
EGeo:AddSlider("ELbSz",      {Text="Label Size",          Default=9,    Min=6,   Max=24             })
EGeo:AddSlider("ELp",        {Text="Fill Lerp Speed",     Default=8,    Min=1,   Max=50             })
EGeo:AddSlider("EGlSprd",    {Text="Glow Spread (px)",    Default=14,   Min=0,   Max=50             })
EGeo:AddSlider("EGlAlph",    {Text="Glow Alpha",          Default=0.82, Min=0,   Max=1, Rounding=2  })
EGeo:AddSlider("EGmSz",      {Text="Gem Size",            Default=5,    Min=0,   Max=16             })
EGeo:AddSlider("ETkAlph",    {Text="Tick Alpha",          Default=0.50, Min=0,   Max=1, Rounding=2  })
EGeo:AddSlider("ERfH",       {Text="Reflection Height",   Default=5,    Min=0,   Max=18             })
EGeo:AddSlider("ERfAlph",    {Text="Reflection Alpha",    Default=0.76, Min=0,   Max=1, Rounding=2  })
EGeo:AddSlider("EStTh",      {Text="Border Thickness",    Default=1.3,  Min=0.5, Max=5, Rounding=1  })
EGeo:AddSlider("EEdAlph",    {Text="Edge Highlight",      Default=0.48, Min=0,   Max=1, Rounding=2  })
EGeo:AddSlider("EShAlphFl",  {Text="Shine Opacity",       Default=0.84, Min=0,   Max=1, Rounding=2  })
EGeo:AddSlider("ESw1W",      {Text="Sweep-1 Width (%)",   Default=35,   Min=8,   Max=80             })
EGeo:AddSlider("ESw1D",      {Text="Sweep-1 Duration",    Default=2.0,  Min=0.4, Max=9, Rounding=1  })
EGeo:AddSlider("ESw1G",      {Text="Sweep-1 Gap (s)",     Default=2.8,  Min=1,   Max=14,Rounding=1  })
EGeo:AddSlider("ESw2W",      {Text="Sweep-2 Width (%)",   Default=16,   Min=4,   Max=50             })
EGeo:AddSlider("ESw2D",      {Text="Sweep-2 Duration",    Default=3.8,  Min=1,   Max=14,Rounding=1  })
EGeo:AddSlider("ESw2G",      {Text="Sweep-2 Gap (s)",     Default=5.6,  Min=2,   Max=20,Rounding=1  })
EGeo:AddSlider("ESpCnt",     {Text="Sparkle Count",       Default=6,    Min=0,   Max=12             })
EGeo:AddSlider("EWnTh",      {Text="Warn Threshold (%)",  Default=28,   Min=5,   Max=65             })
EGeo:AddSlider("EAuSp",      {Text="Aura Spread (px)",    Default=10,   Min=2,   Max=30             })
EGeo:AddSlider("ECrSz",      {Text="Crystal Prism Size",  Default=8,    Min=0,   Max=22             })
EGeo:AddSlider("ESpDotSz",   {Text="Specular Dot Size",   Default=4,    Min=2,   Max=16             })
EGeo:AddSlider("EMaxDst",    {Text="Max Visible Studs",   Default=100,  Min=10,  Max=500            })
EGeo:AddSlider("EStrkOp",    {Text="Text Stroke Alpha",   Default=0.30, Min=0,   Max=1, Rounding=2  })
EGeo:AddDropdown("EFDir",    {Values={"Left","Right"},    Default=1, Text="Fill Direction"           })
EGeo:AddDropdown("EFont",    {Values=FONT_LIST,           Default=1, Text="Enemy Font"               })

-- ════════════════════════════════════════════════════════════════════════════════════
--  §11  ENEMY BARS — VISIBILITY TOGGLES
-- ════════════════════════════════════════════════════════════════════════════════════

local EVis = Tab.Enemy:AddRightGroupbox("Enemy Visibility")
EVis:AddToggle("EBars",       {Text="Show Enemy Bars",             Default=true })
EVis:AddToggle("EOnlyCd",     {Text="Only Show On Cooldown",       Default=true })
EVis:AddToggle("EAlTop",      {Text="Always On Top",               Default=false})
EVis:AddToggle("EFill",       {Text="Show Fill",                   Default=true })
EVis:AddToggle("ENums",       {Text="Show Numbers",                Default=true })
EVis:AddToggle("ELabels",     {Text="Show Labels",                 Default=true })
EVis:AddToggle("EBorder",     {Text="Border Stroke",               Default=true })
EVis:AddToggle("EShine",      {Text="Shine + Shine Line",          Default=true })
EVis:AddToggle("EGlow",       {Text="Glow Layers",                 Default=true })
EVis:AddToggle("EGems",       {Text="Corner Gems (×4)",            Default=true })
EVis:AddToggle("ETicks",      {Text="Tick Marks",                  Default=true })
EVis:AddToggle("EReflect",    {Text="Reflection Strip",            Default=true })
EVis:AddToggle("EEdge",       {Text="Edge Highlights",             Default=true })
EVis:AddToggle("ESweep1",     {Text="Sweep 1",                     Default=true })
EVis:AddToggle("ESweep2",     {Text="Sweep 2",                     Default=true })
EVis:AddToggle("ESparkles",   {Text="Sparkle Dots",                Default=true })
EVis:AddToggle("EWarnOv",     {Text="Warning Overlay",             Default=true })
EVis:AddToggle("EReadyAura",  {Text="Ready Aura Ring",             Default=true })
EVis:AddToggle("ECrystals",   {Text="Crystal Prisms",              Default=true })
EVis:AddToggle("ESpecular",   {Text="Specular Dot",                Default=true })
EVis:AddToggle("EDistFade",   {Text="Distance-Based Fade",         Default=true })
EVis:AddToggle("EReady",      {Text="Show READY Text",             Default=true })
EVis:AddToggle("EDepthRim",   {Text="Depth Rim",                   Default=true })

-- ════════════════════════════════════════════════════════════════════════════════════
--  §12  ENEMY COLORS — DASH / SIDE / EVASIVE
-- ════════════════════════════════════════════════════════════════════════════════════

local EDC = Tab.EColors:AddLeftGroupbox("Enemy Dash")
EDC:AddLabel("Fill"):AddColorPicker("EDFill",       {Default=Color3.fromRGB( 72, 172, 255)})
EDC:AddLabel("Fill Danger"):AddColorPicker("EDDngr",{Default=Color3.fromRGB(255,  60,  60)})
EDC:AddLabel("Fill Warning"):AddColorPicker("EDWrn",{Default=Color3.fromRGB(255, 155,  18)})
EDC:AddLabel("Number"):AddColorPicker("EDNum",      {Default=Color3.fromRGB(195, 228, 255)})
EDC:AddLabel("Background"):AddColorPicker("EDBG",   {Default=Color3.fromRGB(  3,   9,  28)})
EDC:AddLabel("Label"):AddColorPicker("EDLbl",       {Default=Color3.fromRGB(125, 196, 255)})
EDC:AddLabel("Border"):AddColorPicker("EDBrd",      {Default=Color3.fromRGB( 48, 116, 255)})
EDC:AddLabel("Glow"):AddColorPicker("EDGlw",        {Default=Color3.fromRGB( 16,  76, 255)})
EDC:AddLabel("Gem"):AddColorPicker("EDGem",         {Default=Color3.fromRGB(108, 188, 255)})
EDC:AddLabel("Aura"):AddColorPicker("EDAur",        {Default=Color3.fromRGB( 86, 192, 255)})
EDC:AddLabel("Warn Overlay"):AddColorPicker("EDWOv",{Default=Color3.fromRGB(255,  48,  48)})
EDC:AddLabel("Crystal"):AddColorPicker("EDCry",     {Default=Color3.fromRGB(172, 218, 255)})
EDC:AddLabel("Depth Rim"):AddColorPicker("EDRim",   {Default=Color3.fromRGB( 32,  72, 172)})
EDC:AddLabel("Specular"):AddColorPicker("EDSpc",    {Default=Color3.fromRGB(235, 246, 255)})

local ESC2 = Tab.EColors:AddLeftGroupbox("Enemy Side")
ESC2:AddLabel("Fill"):AddColorPicker("ESFill",       {Default=Color3.fromRGB(255, 192,  50)})
ESC2:AddLabel("Fill Danger"):AddColorPicker("ESDngr",{Default=Color3.fromRGB(255,  52,  52)})
ESC2:AddLabel("Fill Warning"):AddColorPicker("ESWrn",{Default=Color3.fromRGB(255, 132,  14)})
ESC2:AddLabel("Number"):AddColorPicker("ESNum",      {Default=Color3.fromRGB(255, 242, 185)})
ESC2:AddLabel("Background"):AddColorPicker("ESBG",   {Default=Color3.fromRGB( 18,  12,   2)})
ESC2:AddLabel("Label"):AddColorPicker("ESLbl",       {Default=Color3.fromRGB(255, 210,  90)})
ESC2:AddLabel("Border"):AddColorPicker("ESBrd",      {Default=Color3.fromRGB(218, 158,  14)})
ESC2:AddLabel("Glow"):AddColorPicker("ESGlw",        {Default=Color3.fromRGB(194, 122,   0)})
ESC2:AddLabel("Gem"):AddColorPicker("ESGem",         {Default=Color3.fromRGB(255, 222, 100)})
ESC2:AddLabel("Aura"):AddColorPicker("ESAur",        {Default=Color3.fromRGB(255, 205,  72)})
ESC2:AddLabel("Warn Overlay"):AddColorPicker("ESWOv",{Default=Color3.fromRGB(255,  48,  48)})
ESC2:AddLabel("Crystal"):AddColorPicker("ESCry",     {Default=Color3.fromRGB(255, 234, 165)})
ESC2:AddLabel("Depth Rim"):AddColorPicker("ESRim",   {Default=Color3.fromRGB(152,  92,   6)})
ESC2:AddLabel("Specular"):AddColorPicker("ESSpc",    {Default=Color3.fromRGB(255, 250, 215)})

local EEC2 = Tab.EColors:AddRightGroupbox("Enemy Evasive")
EEC2:AddLabel("Fill"):AddColorPicker("EEFill",       {Default=Color3.fromRGB(198,  55, 255)})
EEC2:AddLabel("Fill Danger"):AddColorPicker("EEDngr",{Default=Color3.fromRGB(255,  36, 116)})
EEC2:AddLabel("Fill Warning"):AddColorPicker("EEWrn",{Default=Color3.fromRGB(255, 108,  32)})
EEC2:AddLabel("Number"):AddColorPicker("EENum",      {Default=Color3.fromRGB(228, 188, 255)})
EEC2:AddLabel("Background"):AddColorPicker("EEBG",   {Default=Color3.fromRGB( 12,   2,  26)})
EEC2:AddLabel("Label"):AddColorPicker("EELbl",       {Default=Color3.fromRGB(188, 108, 255)})
EEC2:AddLabel("Border"):AddColorPicker("EEBrd",      {Default=Color3.fromRGB(168,  38, 218)})
EEC2:AddLabel("Glow"):AddColorPicker("EEGlw",        {Default=Color3.fromRGB(124,  10, 194)})
EEC2:AddLabel("Gem"):AddColorPicker("EEGem",         {Default=Color3.fromRGB(214, 132, 255)})
EEC2:AddLabel("Aura"):AddColorPicker("EEAur",        {Default=Color3.fromRGB(194,  82, 255)})
EEC2:AddLabel("Warn Overlay"):AddColorPicker("EEWOv",{Default=Color3.fromRGB(255,  36,  96)})
EEC2:AddLabel("Crystal"):AddColorPicker("EECry",     {Default=Color3.fromRGB(224, 175, 255)})
EEC2:AddLabel("Depth Rim"):AddColorPicker("EERim",   {Default=Color3.fromRGB(102,  22, 158)})
EEC2:AddLabel("Specular"):AddColorPicker("EESpc",    {Default=Color3.fromRGB(246, 226, 255)})

local EShC = Tab.EColors:AddRightGroupbox("Enemy Shared")
EShC:AddLabel("READY text"):AddColorPicker("EReadyC",  {Default=Color3.fromRGB(140, 255, 195)})
EShC:AddLabel("Tick marks"):AddColorPicker("ETickC",   {Default=Color3.fromRGB(255, 255, 255)})
EShC:AddLabel("Sweep 1"):AddColorPicker("ESw1C",       {Default=Color3.fromRGB(255, 255, 255)})
EShC:AddLabel("Sweep 2"):AddColorPicker("ESw2C",       {Default=Color3.fromRGB(220, 220, 255)})

-- ════════════════════════════════════════════════════════════════════════════════════
--  §13  EFFECTS TAB
-- ════════════════════════════════════════════════════════════════════════════════════

local FXPulse = Tab.Effects:AddLeftGroupbox("Trigger Pulse")
FXPulse:AddToggle("FXPulOn",  {Text="Enable Pulse",      Default=true })
FXPulse:AddSlider("FXPulDur", {Text="Duration (s)",      Default=0.36, Min=0.05,Max=2.0, Rounding=2})
FXPulse:AddSlider("FXPulSX",  {Text="Scale X",           Default=1.06, Min=1.01,Max=1.35,Rounding=2})
FXPulse:AddSlider("FXPulSY",  {Text="Scale Y",           Default=1.11, Min=1.01,Max=1.45,Rounding=2})
FXPulse:AddSlider("FXPulEase",{Text="Easing Sharpness",  Default=4,    Min=1,   Max=10             })

local FXFlash = Tab.Effects:AddLeftGroupbox("Ready Flash")
FXFlash:AddToggle("FXFlOn",   {Text="Enable Flash",      Default=true})
FXFlash:AddSlider("FXFlCnt",  {Text="Flash Count",       Default=3,    Min=1,   Max=12             })
FXFlash:AddSlider("FXFlSpd",  {Text="Speed (s)",         Default=0.12, Min=0.03,Max=0.6, Rounding=2})

local FXBreath = Tab.Effects:AddLeftGroupbox("Ready Breath")
FXBreath:AddToggle("FXBrOn",  {Text="Enable Breathing",  Default=true})
FXBreath:AddSlider("FXBrSpd", {Text="Speed (s)",         Default=1.0,  Min=0.2, Max=6.0, Rounding=1})
FXBreath:AddSlider("FXBrDim", {Text="Dim (alpha)",       Default=0.58, Min=0,   Max=1.0, Rounding=2})
FXBreath:AddSlider("FXBrBrt", {Text="Bright (alpha)",    Default=0.02, Min=0,   Max=0.9, Rounding=2})

local FXWarn = Tab.Effects:AddRightGroupbox("Warning Pulse")
FXWarn:AddToggle("FXWnOn",    {Text="Enable Warn Pulse", Default=true})
FXWarn:AddSlider("FXWnSpd",   {Text="Speed (s)",         Default=0.50, Min=0.1, Max=2.0, Rounding=2})
FXWarn:AddSlider("FXWnAlA",   {Text="Max Alpha",         Default=0.32, Min=0,   Max=0.8, Rounding=2})
FXWarn:AddSlider("FXWnAlB",   {Text="Min Alpha",         Default=0.0,  Min=0,   Max=0.5, Rounding=2})

local FXAura = Tab.Effects:AddRightGroupbox("Ready Aura Pulse")
FXAura:AddToggle("FXAuOn",    {Text="Enable Aura Pulse", Default=true})
FXAura:AddSlider("FXAuSpd",   {Text="Speed (s)",         Default=0.82, Min=0.2, Max=3.0, Rounding=2})
FXAura:AddSlider("FXAuAlA",   {Text="Max Alpha",         Default=0.44, Min=0,   Max=0.9, Rounding=2})
FXAura:AddSlider("FXAuAlB",   {Text="Min Alpha",         Default=0.76, Min=0,   Max=1.0, Rounding=2})

local FXSpec = Tab.Effects:AddRightGroupbox("Specular Travel")
FXSpec:AddToggle("FXSpOn",    {Text="Enable Specular",   Default=true})
FXSpec:AddSlider("FXSpDur",   {Text="Travel Duration",   Default=3.0,  Min=0.5, Max=10, Rounding=1})
FXSpec:AddSlider("FXSpGap",   {Text="Gap (s)",           Default=2.5,  Min=0.5, Max=12, Rounding=1})
FXSpec:AddSlider("FXSpAlph",  {Text="Dot Alpha",         Default=0.70, Min=0.1, Max=1.0,Rounding=2})

-- ════════════════════════════════════════════════════════════════════════════════════
--  §14  CRYSTAL FX TAB
-- ════════════════════════════════════════════════════════════════════════════════════

local CryFX = Tab.Crystal:AddLeftGroupbox("Crystal Prism FX")
CryFX:AddToggle("CryPulse",  {Text="Crystal Pulse",       Default=true })
CryFX:AddSlider("CryPulSpd", {Text="Pulse Speed (s)",     Default=1.2,  Min=0.3,Max=5.0,Rounding=1})
CryFX:AddSlider("CryPulAlA", {Text="Max Alpha",           Default=0.18, Min=0,  Max=0.6,Rounding=2})
CryFX:AddSlider("CryPulAlB", {Text="Min Alpha",           Default=0.55, Min=0,  Max=1.0,Rounding=2})
CryFX:AddSlider("CryRot",    {Text="Rotation (deg)",      Default=45,   Min=0,  Max=180           })

local NoiseFX = Tab.Crystal:AddLeftGroupbox("Noise Texture")
NoiseFX:AddToggle("NoiseAnim",{Text="Animate Noise",       Default=true })
NoiseFX:AddSlider("NoiseSpd", {Text="Scroll Speed",        Default=0.8,  Min=0.1,Max=4.0,Rounding=1})
NoiseFX:AddSlider("NoiseAl",  {Text="Noise Alpha",         Default=0.88, Min=0.5,Max=1.0,Rounding=2})

local RainbowFX = Tab.Crystal:AddRightGroupbox("Rainbow Mode")
RainbowFX:AddToggle("RbwFill", {Text="Rainbow Fill",      Default=false})
RainbowFX:AddToggle("RbwBord", {Text="Rainbow Border",    Default=false})
RainbowFX:AddToggle("RbwGlow", {Text="Rainbow Glow",      Default=false})
RainbowFX:AddSlider("RbwSpd",  {Text="Cycle Speed (s)",   Default=4.0, Min=0.5,Max=20,Rounding=1})
RainbowFX:AddSlider("RbwSat",  {Text="Saturation",        Default=1.0, Min=0.2,Max=1.0,Rounding=2})
RainbowFX:AddSlider("RbwVal",  {Text="Value / Brightness",Default=1.0, Min=0.2,Max=1.0,Rounding=2})

-- ════════════════════════════════════════════════════════════════════════════════════
--  §15  SCREEN GUI ROOT
-- ════════════════════════════════════════════════════════════════════════════════════

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TSBCrystalBars"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 25
screenGui.Parent         = player:WaitForChild("PlayerGui")

-- ════════════════════════════════════════════════════════════════════════════════════
--  §16  ABILITY CONFIGS  (key references into Options/Toggles)
-- ════════════════════════════════════════════════════════════════════════════════════

-- Player ability config — prefix references colour pickers in §7-9
local PCFG = {
    Dash = {
        label="◈ FRONT DASH", icon="⚡", defaultCD=5,
        fk="PDFill", dk="PDDngr", wk="PDWrn",
        nk="PDNum",  bgk="PDBG",  lk="PDLbl",
        bk="PDBrd",  gk="PDGlw",  sk="PDShd",
        gmk="PDGem", rmk="PDRim", ak="PDAur",
        wok="PDWOv", crk="PDCry", spk="PDSpc",
        nok="PDNoi", eck="PDEdgC",rfk="PDRef",
        order=1,
    },
    Side = {
        label="◈ SIDE DASH", icon="💨", defaultCD=2,
        fk="PSFill", dk="PSDngr", wk="PSWrn",
        nk="PSNum",  bgk="PSBG",  lk="PSLbl",
        bk="PSBrd",  gk="PSGlw",  sk="PSShd",
        gmk="PSGem", rmk="PSRim", ak="PSAur",
        wok="PSWOv", crk="PSCry", spk="PSSpc",
        nok="PSNoi", eck="PSEdgC",rfk="PSRef",
        order=2,
    },
    Evasive = {
        label="◈ EVASIVE", icon="🌀", defaultCD=30,
        fk="PEFill", dk="PEDngr", wk="PEWrn",
        nk="PENum",  bgk="PEBG",  lk="PELbl",
        bk="PEBrd",  gk="PEGlw",  sk="PEShd",
        gmk="PEGem", rmk="PERim", ak="PEAur",
        wok="PEWOv", crk="PECry", spk="PESpc",
        nok="PENoi", eck="PEEdgC",rfk="PERef",
        order=3,
    },
}
local PORDER = {"Dash","Side","Evasive"}

-- Enemy ability config
local ECFG = {
    Dash = {
        label="FRONT DASH", sym="◈", defaultCD=5,
        fk="EDFill", dk="EDDngr", wk="EDWrn",
        nk="EDNum",  bgk="EDBG",  lk="EDLbl",
        bk="EDBrd",  gk="EDGlw",
        gmk="EDGem", rmk="EDRim", ak="EDAur",
        wok="EDWOv", crk="EDCry", spk="EDSpc",
        order=1,
    },
    Side = {
        label="SIDE DASH", sym="◈", defaultCD=2,
        fk="ESFill", dk="ESDngr", wk="ESWrn",
        nk="ESNum",  bgk="ESBG",  lk="ESLbl",
        bk="ESBrd",  gk="ESGlw",
        gmk="ESGem", rmk="ESRim", ak="ESAur",
        wok="ESWOv", crk="ESCry", spk="ESSpc",
        order=2,
    },
    Evasive = {
        label="EVASIVE", sym="◈", defaultCD=30,
        fk="EEFill", dk="EEDngr", wk="EEWrn",
        nk="EENum",  bgk="EEBG",  lk="EELbl",
        bk="EEBrd",  gk="EEGlw",
        gmk="EEGem", rmk="EERim", ak="EEAur",
        wok="EEWOv", crk="EECry", spk="EESpc",
        order=3,
    },
}
local EORDER = {"Dash","Side","Evasive"}

-- ════════════════════════════════════════════════════════════════════════════════════
--  §17  UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════

-- Safe option/toggle getters
local function o(k)  return Options[k]  and Options[k].Value  end
local function t(k)  return Toggles[k]  and Toggles[k].Value  end

-- Linear RGB blend (t=0→a, t=1→b)
local function blendC(a, b, f)
    f = math.clamp(f, 0, 1)
    return Color3.new(
        a.R + (b.R-a.R)*f,
        a.G + (b.G-a.G)*f,
        a.B + (b.B-a.B)*f)
end

-- HSV → RGB (for rainbow mode)
local function hsvToRgb(h, s, v)
    local r,g,b
    local i = math.floor(h*6)
    local f = h*6-i
    local p = v*(1-s)
    local q = v*(1-f*s)
    local tv = v*(1-(1-f)*s)
    i = i % 6
    if i==0 then r,g,b=v,tv,p
    elseif i==1 then r,g,b=q,v,p
    elseif i==2 then r,g,b=p,v,tv
    elseif i==3 then r,g,b=p,q,v
    elseif i==4 then r,g,b=tv,p,v
    else r,g,b=v,p,q end
    return Color3.new(r,g,b)
end

-- Dynamic fill colour: shifts from fill → warning → danger as cdPct rises
-- cdPct = fraction of cooldown elapsed (0=just started, 1=about to expire)
local function dynFillC(cdPct, fC, wC, dC, useDyn)
    if not useDyn then return fC end
    if cdPct < 0.38 then return fC end
    if cdPct < 0.64 then
        local tt = (cdPct-0.38)/0.26
        return blendC(fC, wC, math.min(tt*0.65, 0.65))
    end
    local tt = (cdPct-0.64)/0.36
    return blendC(wC, dC, math.min(tt, 0.88))
end

-- UICorner shorthand
local function mkCorner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

-- ════════════════════════════════════════════════════════════════════════════════════
--  §18  VISUAL LAYER BUILDERS  (each returns the created instance(s))
-- ════════════════════════════════════════════════════════════════════════════════════

-- ── Drop shadow + coloured shadow glow ─────────────────────────────────────────────
local function mkShadow(parent)
    local s = Instance.new("Frame")
    s.Name="Shadow"; s.BackgroundColor3=C.BLACK
    s.BackgroundTransparency=0.62; s.BorderSizePixel=0; s.ZIndex=1
    s.Parent=parent
    mkCorner(s,14)
    local g=Instance.new("UIGradient",s); g.Rotation=90
    g.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.38),
        NumberSequenceKeypoint.new(.5,0.58),
        NumberSequenceKeypoint.new(1,0.84),
    })
    return s
end

local function mkShadowGlow(parent)
    local sg = Instance.new("Frame")
    sg.Name="ShadowGlow"; sg.BackgroundTransparency=0.90
    sg.BorderSizePixel=0; sg.ZIndex=1; sg.Parent=parent
    mkCorner(sg,18)
    return sg
end

-- ── Depth rim ──────────────────────────────────────────────────────────────────────
local function mkDepthRim(parent)
    local r=Instance.new("Frame")
    r.Name="DepthRim"; r.BackgroundTransparency=1
    r.BorderSizePixel=0; r.ZIndex=2; r.Parent=parent
    mkCorner(r,12)
    local st=Instance.new("UIStroke",r)
    st.Thickness=1.2; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    st.Transparency=0.48
    return r, st
end

-- ── Outer halo glow ────────────────────────────────────────────────────────────────
local function mkOuterGlow(parent)
    local g=Instance.new("Frame")
    g.Name="OuterGlow"; g.BackgroundTransparency=0.84
    g.BorderSizePixel=0; g.ZIndex=1; g.Parent=parent
    mkCorner(g,26)
    local gr=Instance.new("UIGradient",g); gr.Rotation=90
    gr.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.66),
        NumberSequenceKeypoint.new(.5,0.80),
        NumberSequenceKeypoint.new(1,0.96),
    })
    return g
end

-- ── Inner glow ─────────────────────────────────────────────────────────────────────
local function mkInnerGlow(parent)
    local g=Instance.new("Frame")
    g.Name="InnerGlow"; g.BackgroundTransparency=0.70
    g.BorderSizePixel=0; g.ZIndex=2; g.Parent=parent
    mkCorner(g,16)
    local gr=Instance.new("UIGradient",g); gr.Rotation=90
    gr.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.58),
        NumberSequenceKeypoint.new(1,0.80),
    })
    return g
end

-- ── Ready aura ring ─────────────────────────────────────────────────────────────────
local function mkReadyAura(parent, cornerR)
    local a=Instance.new("Frame")
    a.Name="ReadyAura"; a.BackgroundTransparency=1
    a.BorderSizePixel=0; a.ZIndex=2; a.Parent=parent
    mkCorner(a, (cornerR or 8)+10)
    local st=Instance.new("UIStroke",a)
    st.Thickness=2.5; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    st.Transparency=1
    return a, st
end

-- ── Crystal prism (left and right end accents) ─────────────────────────────────────
-- Simulated with a rotated Frame + gradient to look like a diamond facet
local function mkCrystalPrism(parent, isRight)
    local cp=Instance.new("Frame")
    cp.Name=isRight and "CrystalR" or "CrystalL"
    cp.BackgroundColor3=C.CRYSTAL_L
    cp.BackgroundTransparency=0.35
    cp.BorderSizePixel=0; cp.ZIndex=3; cp.Parent=parent
    mkCorner(cp,3)
    local cg=Instance.new("UIGradient",cp)
    cg.Rotation=isRight and 135 or 45
    cg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,  0.15),
        NumberSequenceKeypoint.new(0.5,0.52),
        NumberSequenceKeypoint.new(1,  0.90),
    })
    return cp
end

-- ── Reflection strip ───────────────────────────────────────────────────────────────
local function mkReflection(parent)
    local r=Instance.new("Frame")
    r.Name="Reflection"; r.BackgroundColor3=C.WHITE
    r.BackgroundTransparency=0.88; r.BorderSizePixel=0; r.ZIndex=3
    r.Parent=parent
    mkCorner(r,5)
    local g=Instance.new("UIGradient",r); g.Rotation=90
    g.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,  0.68),
        NumberSequenceKeypoint.new(0.6,0.86),
        NumberSequenceKeypoint.new(1,  1.00),
    })
    return r
end

-- ── Ability label (text row above bar) ─────────────────────────────────────────────
local function mkAbilLabel(parent, text)
    local l=Instance.new("TextLabel")
    l.Name="AbilLabel"; l.BackgroundTransparency=1; l.BorderSizePixel=0
    l.Text=text; l.Font=Enum.Font.GothamBold; l.TextScaled=false
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Bottom
    l.TextStrokeTransparency=0.22; l.TextStrokeColor3=C.BLACK
    l.ZIndex=6; l.Parent=parent
    return l
end

-- ── Bar background frame ───────────────────────────────────────────────────────────
local function mkBarBG(parent)
    local f=Instance.new("Frame")
    f.Name="BarBG"; f.BorderSizePixel=0; f.ZIndex=4
    f.ClipsDescendants=false; f.Parent=parent
    local co=mkCorner(f,8)
    -- Multi-stop arcane gradient: very dark top → purple midpoint → near-black bottom
    local bg=Instance.new("UIGradient")
    bg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.GRAD_BGTOP),
        ColorSequenceKeypoint.new(0.42,C.GRAD_BGPUR),
        ColorSequenceKeypoint.new(1,   C.GRAD_BGBOT),
    })
    bg.Rotation=90; bg.Parent=f
    -- Extra transparency gradient so the fill below bleeds through
    local bgT=Instance.new("UIGradient")
    bgT.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.72),
        NumberSequenceKeypoint.new(1,0.48),
    })
    bgT.Rotation=90; bgT.Parent=f
    local st=Instance.new("UIStroke",f)
    st.Thickness=1.6; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    st.Transparency=0.10
    return f, co, st
end

-- ── Noise texture overlay on BG ────────────────────────────────────────────────────
local function mkNoiseLayer(parent)
    local n=Instance.new("Frame")
    n.Name="NoiseLayer"; n.BackgroundColor3=C.NOISE_A
    n.BackgroundTransparency=0.90; n.BorderSizePixel=0
    n.Size=UDim2.new(1,0,1,0); n.Position=UDim2.new(0,0,0,0)
    n.ZIndex=5; n.Parent=parent
    mkCorner(n,8)
    local ng=Instance.new("UIGradient",n)
    ng.Rotation=37
    ng.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.NOISE_A),
        ColorSequenceKeypoint.new(0.33,C.BLACK),
        ColorSequenceKeypoint.new(0.66,C.NOISE_B),
        NumberSequenceKeypoint and
        ColorSequenceKeypoint.new(1,   C.NOISE_A) or
        ColorSequenceKeypoint.new(1,   C.NOISE_A),
    })
    ng.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,  0.84),
        NumberSequenceKeypoint.new(0.5,0.78),
        NumberSequenceKeypoint.new(1,  0.84),
    })
    return n
end

-- ── BG left and right edge accent strips ───────────────────────────────────────────
local function mkBGEdge(parent, isRight)
    local e=Instance.new("Frame")
    e.Name=isRight and "BGEdgeR" or "BGEdgeL"
    e.Size=UDim2.new(0,2,0.80,0)
    e.AnchorPoint=isRight and Vector2.new(1,0.5) or Vector2.new(0,0.5)
    e.Position=isRight and UDim2.new(1,-1,0.5,0) or UDim2.new(0,1,0.5,0)
    e.BackgroundColor3=C.WHITE; e.BackgroundTransparency=0.55
    e.BorderSizePixel=0; e.ZIndex=6; e.Parent=parent
    mkCorner(e,2)
    local eg=Instance.new("UIGradient",e); eg.Rotation=90
    eg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,  0.60),
        NumberSequenceKeypoint.new(0.5,0.28),
        NumberSequenceKeypoint.new(1,  0.60),
    })
    return e
end

-- ── Tick marks at 25 / 50 / 75 % ──────────────────────────────────────────────────
local function mkTicks(parent)
    local tks={}
    for _,xp in ipairs({0.25,0.50,0.75}) do
        local tk=Instance.new("Frame")
        tk.Size=UDim2.new(0,1,0.62,0)
        tk.AnchorPoint=Vector2.new(0.5,0.5)
        tk.Position=UDim2.new(xp,0,0.5,0)
        tk.BackgroundColor3=C.WHITE
        tk.BackgroundTransparency=0.54
        tk.BorderSizePixel=0; tk.ZIndex=7; tk.Parent=parent
        table.insert(tks,tk)
    end
    return tks
end

-- ── Warning overlay (red tint, pulses near CD expiry) ──────────────────────────────
local function mkWarnOverlay(parent, r)
    local w=Instance.new("Frame")
    w.Name="WarnOverlay"; w.Size=UDim2.new(1,0,1,0)
    w.Position=UDim2.new(0,0,0,0)
    w.BackgroundColor3=C.DANGER; w.BackgroundTransparency=1
    w.BorderSizePixel=0; w.ZIndex=8; w.Parent=parent
    mkCorner(w, r or 9)
    return w
end

-- ── Fill clip + fill bar + fill gradient ───────────────────────────────────────────
local function mkFillSystem(parent)
    local clip=Instance.new("Frame")
    clip.Name="FillClip"; clip.BackgroundTransparency=1
    clip.BorderSizePixel=0; clip.ClipsDescendants=true
    clip.ZIndex=8; clip.Size=UDim2.new(1,0,1,0)
    clip.Position=UDim2.new(0,0,0,0); clip.Parent=parent

    local fill=Instance.new("Frame")
    fill.Name="Fill"; fill.BorderSizePixel=0
    fill.ZIndex=8; fill.ClipsDescendants=true; fill.Parent=clip
    local fc=mkCorner(fill,8)

    -- Iridescent shimmer gradient: white top → lavender → sky-blue → deep indigo
    local fg=Instance.new("UIGradient")
    fg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.WHITE),
        ColorSequenceKeypoint.new(0.28,C.GRAD_LAV),
        ColorSequenceKeypoint.new(0.58,C.GRAD_SKY),
        ColorSequenceKeypoint.new(1,   C.GRAD_DEEP),
    })
    fg.Rotation=90
    fg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.40),
        NumberSequenceKeypoint.new(0.35,0.56),
        NumberSequenceKeypoint.new(1,   0.08),
    })
    fg.Parent=fill

    -- Solid colour layer on top of gradient (blended with gradient via transparency)
    local solidLayer=Instance.new("Frame")
    solidLayer.Name="FillSolid"; solidLayer.BackgroundTransparency=0.55
    solidLayer.BorderSizePixel=0; solidLayer.ZIndex=9
    solidLayer.Size=UDim2.new(1,0,1,0); solidLayer.Position=UDim2.new(0,0,0,0)
    solidLayer.Parent=fill
    mkCorner(solidLayer,8)

    return clip, fill, fc, solidLayer
end

-- ── Enchant sweep strip ────────────────────────────────────────────────────────────
local function mkSweepStrip(fill, zidx)
    local sw=Instance.new("Frame")
    sw.Name="Sweep"; sw.AnchorPoint=Vector2.new(0.5,0)
    sw.BackgroundColor3=C.WHITE; sw.BackgroundTransparency=0
    sw.BorderSizePixel=0; sw.ZIndex=zidx or 10; sw.Parent=fill
    local sg=Instance.new("UIGradient",sw); sg.Rotation=0
    sg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,   1.00),
        NumberSequenceKeypoint.new(0.22,0.62),
        NumberSequenceKeypoint.new(0.50,0.44),
        NumberSequenceKeypoint.new(0.78,0.62),
        NumberSequenceKeypoint.new(1,   1.00),
    })
    return sw
end

-- ── Shine hairline + shine overlay ─────────────────────────────────────────────────
local function mkShineElements(fill)
    local ln=Instance.new("Frame")
    ln.Name="ShineLine"; ln.Size=UDim2.new(0.84,0,0,2)
    ln.Position=UDim2.new(0.08,0,0,2)
    ln.BackgroundColor3=C.WHITE; ln.BackgroundTransparency=0.32
    ln.BorderSizePixel=0; ln.ZIndex=12; ln.Parent=fill
    mkCorner(ln,2)
    local ov=Instance.new("Frame")
    ov.Name="ShineOver"; ov.Size=UDim2.new(1,0,0.50,0)
    ov.Position=UDim2.new(0,0,0,0)
    ov.BackgroundColor3=C.WHITE; ov.BackgroundTransparency=0.80
    ov.BorderSizePixel=0; ov.ZIndex=11; ov.Parent=fill
    mkCorner(ov)
    return ln, ov
end

-- ── Edge highlight (right edge of fill) ───────────────────────────────────────────
local function mkEdgeHL(fill)
    local e=Instance.new("Frame")
    e.Name="EdgeHL"; e.Size=UDim2.new(0,4,1,0)
    e.AnchorPoint=Vector2.new(1,0); e.Position=UDim2.new(1,0,0,0)
    e.BackgroundColor3=C.WHITE; e.BackgroundTransparency=0.48
    e.BorderSizePixel=0; e.ZIndex=13; e.Parent=fill
    local eg=Instance.new("UIGradient",e); eg.Rotation=90
    eg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.26),
        NumberSequenceKeypoint.new(1,0.78),
    })
    return e
end

-- ── Sparkle dots ──────────────────────────────────────────────────────────────────
local function mkSparkles(fill, cnt)
    local sps={}
    cnt=math.clamp(cnt or 9,0,14)
    for i=1,cnt do
        local xp=(i-0.5)/cnt
        local sp=Instance.new("Frame")
        sp.Size=UDim2.new(0,3,0,3); sp.AnchorPoint=Vector2.new(0.5,0.5)
        sp.Position=UDim2.new(xp,0,0.50,0)
        sp.BackgroundColor3=C.WHITE; sp.BackgroundTransparency=1
        sp.BorderSizePixel=0; sp.ZIndex=14; sp.Parent=fill
        mkCorner(sp,99)
        sps[i]=sp
    end
    return sps
end

-- ── Specular dot (travels across fill surface) ────────────────────────────────────
local function mkSpecularDot(fill, sizePx)
    local sd=Instance.new("Frame")
    sd.Name="SpecDot"; sd.Size=UDim2.new(0,sizePx or 6,0,sizePx or 6)
    sd.AnchorPoint=Vector2.new(0.5,0.5); sd.Position=UDim2.new(-0.1,0,0.5,0)
    sd.BackgroundColor3=C.WHITE; sd.BackgroundTransparency=1
    sd.BorderSizePixel=0; sd.ZIndex=15; sd.Parent=fill
    mkCorner(sd,99)
    local sg=Instance.new("UIGradient",sd); sg.Rotation=45
    sg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.10),
        NumberSequenceKeypoint.new(1,0.80),
    })
    return sd
end

-- ── Corner gems (×4: bottom-L, bottom-R, top-L, top-R) ────────────────────────────
local function mkGems(parent)
    local gems={}
    local positions = {
        {ax=0,   ay=0.5, name="GemL"},
        {ax=1,   ay=0.5, name="GemR"},
        {ax=0,   ay=0,   name="GemTL"},
        {ax=1,   ay=0,   name="GemTR"},
    }
    for _,pd in ipairs(positions) do
        local g=Instance.new("Frame")
        g.Name=pd.name; g.AnchorPoint=Vector2.new(pd.ax,pd.ay)
        g.BackgroundColor3=C.WHITE; g.BackgroundTransparency=0.18
        g.BorderSizePixel=0; g.ZIndex=15; g.Parent=parent
        mkCorner(g,99)
        table.insert(gems,g)
    end
    return gems
end

-- ── Number / time label ────────────────────────────────────────────────────────────
local function mkNumLabel(parent)
    local n=Instance.new("TextLabel")
    n.Name="NumLabel"; n.BackgroundTransparency=1
    n.Size=UDim2.new(1,-16,1,0); n.Position=UDim2.new(0,8,0,0)
    n.Font=Enum.Font.GothamBold; n.TextScaled=false
    n.TextXAlignment=Enum.TextXAlignment.Right
    n.TextYAlignment=Enum.TextYAlignment.Center
    n.TextStrokeTransparency=0.20; n.TextStrokeColor3=C.BLACK
    n.ZIndex=16; n.Parent=parent
    return n
end

-- ── Icon label (small symbol on left of bar) ──────────────────────────────────────
local function mkIconLabel(parent)
    local il=Instance.new("TextLabel")
    il.Name="IconLabel"; il.BackgroundTransparency=1
    il.Size=UDim2.new(0,30,1,0); il.Position=UDim2.new(0,4,0,0)
    il.Font=Enum.Font.GothamBold; il.TextScaled=false; il.TextSize=12
    il.TextXAlignment=Enum.TextXAlignment.Left
    il.TextYAlignment=Enum.TextYAlignment.Center
    il.TextStrokeTransparency=0.30; il.TextStrokeColor3=C.BLACK
    il.ZIndex=16; il.Parent=parent
    return il
end

-- ════════════════════════════════════════════════════════════════════════════════════
--  §19  ANIMATION LOOP HELPERS
-- ════════════════════════════════════════════════════════════════════════════════════

-- Generic sweep loop: reads W/D/G from option keys each cycle
local function loopSweep(sw, wKey, dKey, gKey, enKey, clrKey, delay)
    task.spawn(function()
        if delay and delay>0 then task.wait(delay) end
        while sw and sw.Parent do
            local swW=(o(wKey) or 36)/100
            local swD= o(dKey) or 2.4
            local swG= o(gKey) or 3.2
            pcall(function()
                sw.Size=UDim2.new(swW,0,1.22,0)
                sw.Position=UDim2.new(-(swW+0.06),0,-0.11,0)
                sw.BackgroundColor3=o(clrKey) or C.WHITE
            end)
            if t(enKey) then
                local tw=TweenService:Create(sw,
                    TweenInfo.new(swD,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                    {Position=UDim2.new(1.18,0,-0.11,0)})
                tw:Play()
                task.wait(swG)
            else
                task.wait(0.8)
            end
        end
    end)
end

-- Sparkle blink loop
local function loopSparkle(sp, delay, slow)
    task.spawn(function()
        if delay and delay>0 then task.wait(delay) end
        local lo=slow and 14 or 8
        local hi=slow and 44 or 28
        while sp and sp.Parent do
            task.wait(math.random(lo,hi)*0.1)
            if not(sp and sp.Parent) then break end
            sp.BackgroundTransparency=0.05
            task.wait(0.052)
            sp.BackgroundTransparency=0.42
            task.wait(0.052)
            sp.BackgroundTransparency=0.05
            TweenService:Create(sp,
                TweenInfo.new(0.72,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {BackgroundTransparency=1}):Play()
        end
    end)
end

local function loopAllSparkles(sps, base, slow)
    for i,sp in ipairs(sps) do
        loopSparkle(sp,(i-1)*0.42+(base or 0),slow)
    end
end

-- Specular dot travel loop
local function loopSpecular(sd, durKey, gapKey, alKey, enKey, delay)
    task.spawn(function()
        if delay and delay>0 then task.wait(delay) end
        while sd and sd.Parent do
            local dur=o(durKey) or 3.0
            local gap=o(gapKey) or 2.5
            local alph=o(alKey) or 0.70
            pcall(function()
                sd.Position=UDim2.new(-0.10,0,0.5,0)
                sd.BackgroundTransparency=1
            end)
            if t(enKey) then
                TweenService:Create(sd,
                    TweenInfo.new(dur*0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                    {BackgroundTransparency=1-alph}):Play()
                task.wait(dur*0.12)
                if not(sd and sd.Parent) then break end
                TweenService:Create(sd,
                    TweenInfo.new(dur*0.76,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                    {Position=UDim2.new(1.10,0,0.5,0)}):Play()
                task.wait(dur*0.76)
                if not(sd and sd.Parent) then break end
                TweenService:Create(sd,
                    TweenInfo.new(dur*0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
                    {BackgroundTransparency=1}):Play()
                task.wait(dur*0.12)
                task.wait(gap)
            else
                task.wait(0.8)
            end
        end
    end)
end

-- Crystal prism pulse loop
local function loopCrystalPulse(cp, delay)
    task.spawn(function()
        if delay and delay>0 then task.wait(delay) end
        while cp and cp.Parent do
            if not t("CryPulse") then task.wait(0.5); continue end
            local spd= o("CryPulSpd") or 1.2
            local alA= o("CryPulAlA") or 0.18
            local alB= o("CryPulAlB") or 0.55
            TweenService:Create(cp,
                TweenInfo.new(spd,Enum.EasingStyle.Sine),
                {BackgroundTransparency=alB}):Play()
            task.wait(spd)
            if not(cp and cp.Parent) then break end
            TweenService:Create(cp,
                TweenInfo.new(spd,Enum.EasingStyle.Sine),
                {BackgroundTransparency=alA}):Play()
            task.wait(spd)
        end
    end)
end

-- Rainbow hue rotation (shared clock)
local rainbowHue = 0
RunService.Heartbeat:Connect(function(dt)
    local spd = o("RbwSpd") or 4.0
    rainbowHue = (rainbowHue + dt/spd) % 1
end)

local function getRainbowColor()
    local sat = o("RbwSat") or 1.0
    local val = o("RbwVal") or 1.0
    return hsvToRgb(rainbowHue, sat, val)
end

-- ════════════════════════════════════════════════════════════════════════════════════
--  §20  FULL PLAYER BAR CONSTRUCTION
-- ════════════════════════════════════════════════════════════════════════════════════

local pBars = {}

local function buildPlayerBar(name, idx)
    local cfg=PCFG[name]

    -- Root container (transparent positioner)
    local root=Instance.new("Frame")
    root.Name=name.."_Root"; root.BackgroundTransparency=1
    root.BorderSizePixel=0; root.ZIndex=2; root.Parent=screenGui

    -- Layer stack
    local shadow      = mkShadow(root)
    local shadowGlow  = mkShadowGlow(root)
    local dRim, dRimSt= mkDepthRim(root)
    local outerGlow   = mkOuterGlow(root)
    local innerGlow   = mkInnerGlow(root)
    local rAura, rAuraSt = mkReadyAura(root, 9)
    local crystalL    = mkCrystalPrism(root, false)
    local crystalR    = mkCrystalPrism(root, true)
    local reflection  = mkReflection(root)
    local abilLabel   = mkAbilLabel(root, cfg.label)
    local barBG, bgCo, bgSt = mkBarBG(root)
    local noiseLayer  = mkNoiseLayer(barBG)
    local bgEdgeL     = mkBGEdge(barBG, false)
    local bgEdgeR     = mkBGEdge(barBG, true)
    local ticks       = mkTicks(barBG)
    local warnOv      = mkWarnOverlay(barBG, 9)
    local fillClip, fill, fillCo, fillSolid = mkFillSystem(barBG)
    local sweep1      = mkSweepStrip(fill, 10)
    local sweep2      = mkSweepStrip(fill, 10)
    local shineLn, shineOv = mkShineElements(fill)
    local edgeHL      = mkEdgeHL(fill)
    local specDot     = mkSpecularDot(fill, 6)
    local sparkles    = mkSparkles(fill, o("PSpCnt") or 9)
    local gems        = mkGems(barBG)
    local numLabel    = mkNumLabel(barBG)
    local iconLabel   = mkIconLabel(barBG)

    -- Start animation loops
    local base=(idx-1)*0.82
    loopSweep(sweep1,"PSw1W","PSw1D","PSw1G","PSweep1","PSw1C",base)
    loopSweep(sweep2,"PSw2W","PSw2D","PSw2G","PSweep2","PSw2C",base+0.40)
    loopAllSparkles(sparkles, base*0.22, false)
    loopSpecular(specDot,"FXSpDur","FXSpGap","FXSpAlph","FXSpOn",base+0.6)
    loopCrystalPulse(crystalL, base)
    loopCrystalPulse(crystalR, base+0.62)

    pBars[name]={
        root=root, shadow=shadow, shadowGlow=shadowGlow,
        dRim=dRim, dRimSt=dRimSt,
        outerGlow=outerGlow, innerGlow=innerGlow,
        rAura=rAura, rAuraSt=rAuraSt,
        crystalL=crystalL, crystalR=crystalR,
        reflection=reflection, abilLabel=abilLabel,
        barBG=barBG, bgCo=bgCo, bgSt=bgSt,
        noiseLayer=noiseLayer, bgEdgeL=bgEdgeL, bgEdgeR=bgEdgeR,
        ticks=ticks, warnOv=warnOv,
        fillClip=fillClip, fill=fill, fillCo=fillCo, fillSolid=fillSolid,
        sweep1=sweep1, sweep2=sweep2,
        shineLn=shineLn, shineOv=shineOv,
        edgeHL=edgeHL, specDot=specDot,
        sparkles=sparkles, gems=gems,
        numLabel=numLabel, iconLabel=iconLabel,
        -- state
        time=0, duration=cfg.defaultCD, visRatio=0,
        prevOnCd=false, pulseActive=false,
        readyFlashing=false, breathActive=false,
        warnPulseActive=false, auraPulseActive=false,
    }
end

for i,n in ipairs(PORDER) do buildPlayerBar(n,i) end

-- ════════════════════════════════════════════════════════════════════════════════════
--  §21  PLAYER EFFECT FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════

local function doPulse(bd)
    if not t("FXPulOn") then return end
    if bd.pulseActive then return end
    bd.pulseActive=true
    local f=bd.barBG
    local half=(o("FXPulDur") or 0.36)*0.5
    local scX=o("FXPulSX") or 1.06
    local scY=o("FXPulSY") or 1.11
    local orig=f.Size
    local big=UDim2.new(
        orig.X.Scale*scX,orig.X.Offset*scX,
        orig.Y.Scale*scY,orig.Y.Offset*scY)
    TweenService:Create(f,
        TweenInfo.new(half,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=big}):Play()
    task.delay(half,function()
        TweenService:Create(f,
            TweenInfo.new(half,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
            {Size=orig}):Play()
        task.delay(half+0.06,function() bd.pulseActive=false end)
    end)
end

local function doFlash(bd, fillC)
    if not t("FXFlOn") then return end
    if bd.readyFlashing then return end
    bd.readyFlashing=true
    local fill=bd.fill
    local flashC=o("PFlashC") or Color3.fromRGB(255,255,90)
    local origC=fillC or fill.BackgroundColor3
    local cnt=o("FXFlCnt") or 3
    local spd=o("FXFlSpd") or 0.12
    local function step(n)
        if n<=0 then
            pcall(function() fill.BackgroundColor3=origC end)
            bd.readyFlashing=false; return
        end
        TweenService:Create(fill,TweenInfo.new(spd,Enum.EasingStyle.Linear),
            {BackgroundColor3=flashC}):Play()
        task.delay(spd,function()
            TweenService:Create(fill,TweenInfo.new(spd,Enum.EasingStyle.Linear),
                {BackgroundColor3=origC}):Play()
            task.delay(spd,function() step(n-1) end)
        end)
    end
    task.spawn(step,cnt)
end

local function doBreath(bd)
    if bd.breathActive then return end
    bd.breathActive=true
    local function cycle()
        if not bd.breathActive then return end
        if not t("FXBrOn") then task.wait(0.5); if bd.breathActive then task.spawn(cycle) end; return end
        local spd=o("FXBrSpd") or 1.0
        local dim=o("FXBrDim") or 0.58
        local brt=o("FXBrBrt") or 0.02
        TweenService:Create(bd.bgSt,TweenInfo.new(spd,Enum.EasingStyle.Sine),{Transparency=brt}):Play()
        TweenService:Create(bd.innerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.38}):Play()
        TweenService:Create(bd.outerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.62}):Play()
        task.wait(spd)
        if not bd.breathActive then return end
        TweenService:Create(bd.bgSt,TweenInfo.new(spd,Enum.EasingStyle.Sine),{Transparency=dim}):Play()
        TweenService:Create(bd.innerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.86}):Play()
        TweenService:Create(bd.outerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.96}):Play()
        task.wait(spd)
        if bd.breathActive then task.spawn(cycle) end
    end
    task.spawn(cycle)
end
local function stopBreath(bd) bd.breathActive=false end

local function doWarnPulse(bd)
    if bd.warnPulseActive then return end
    bd.warnPulseActive=true
    local function cycle()
        if not bd.warnPulseActive then return end
        if not t("FXWnOn") then task.wait(0.3); if bd.warnPulseActive then task.spawn(cycle) end; return end
        local spd=o("FXWnSpd") or 0.50
        local aA=o("FXWnAlA") or 0.32
        local aB=o("FXWnAlB") or 0.0
        TweenService:Create(bd.warnOv,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=1-aA}):Play()
        task.wait(spd)
        if not bd.warnPulseActive then return end
        TweenService:Create(bd.warnOv,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=1-aB}):Play()
        task.wait(spd)
        if bd.warnPulseActive then task.spawn(cycle) end
    end
    task.spawn(cycle)
end
local function stopWarnPulse(bd)
    bd.warnPulseActive=false
    pcall(function() bd.warnOv.BackgroundTransparency=1 end)
end

local function doAuraPulse(bd)
    if bd.auraPulseActive then return end
    bd.auraPulseActive=true
    local function cycle()
        if not bd.auraPulseActive then return end
        if not(t("PReadyAura") and t("FXAuOn")) then task.wait(0.4); if bd.auraPulseActive then task.spawn(cycle) end; return end
        local spd=o("FXAuSpd") or 0.82
        local aA=o("FXAuAlA") or 0.44
        local aB=o("FXAuAlB") or 0.76
        TweenService:Create(bd.rAuraSt,TweenInfo.new(spd,Enum.EasingStyle.Sine),{Transparency=1-aA}):Play()
        task.wait(spd)
        if not bd.auraPulseActive then return end
        TweenService:Create(bd.rAuraSt,TweenInfo.new(spd,Enum.EasingStyle.Sine),{Transparency=1-aB}):Play()
        task.wait(spd)
        if bd.auraPulseActive then task.spawn(cycle) end
    end
    task.spawn(cycle)
end
local function stopAuraPulse(bd)
    bd.auraPulseActive=false
    pcall(function() bd.rAuraSt.Transparency=1 end)
end

-- ════════════════════════════════════════════════════════════════════════════════════
--  §22  PLAYER BAR HEARTBEAT UPDATE
-- ════════════════════════════════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function(dt)
    -- ── Read options once ────────────────────────────────────────────────────────
    local bW      = o("PW")         or 178
    local bH      = o("PH")         or 30
    local bSp     = o("PSp")        or 16
    local bCr     = o("PCr")        or 9
    local posX    = o("PX")         or 0.5
    local posY    = o("PY")         or 0.85
    local bgTr    = o("PBGTr")      or 0.16
    local fillTr  = o("PFTr")       or 0
    local txSz    = o("PTxSz")      or 14
    local lbSz    = o("PLbSz")      or 10
    local lrpSpd  = o("PLp")        or 10
    local glSprd  = o("PGlSprd")    or 22
    local glAlph  = o("PGlAlph")    or 0.82
    local shOff   = o("PShOff")     or 5
    local shAlph  = o("PShAlph")    or 0.64
    local gmSz    = o("PGmSz")      or 8
    local tkAlph  = o("PTkAlph")    or 0.52
    local rfH     = o("PRfH")       or 7
    local rfAlph  = o("PRfAlph")    or 0.74
    local stTh    = o("PStTh")      or 1.6
    local edAlph  = o("PEdAlph")    or 0.52
    local shAlphF = o("PShAlphFl")  or 0.80
    local warnThr = (o("PWnTh") or 28)/100
    local auSp    = o("PAuSp")      or 12
    local crSz    = o("PCrSz")      or 10
    local spDotSz = o("PSpDotSz")   or 6
    local noiseAl = o("PNoiseAlph") or 0.88
    local fDir    = o("PFDir")      or "Left"
    local font    = FONT_MAP[o("PFont")] or Enum.Font.GothamBold
    local rbwFill = t("RbwFill") or false
    local rbwBord = t("RbwBord") or false
    local rbwGlow = t("RbwGlow") or false
    local useDyn  = t("PColorTime") or false

    local showBars   = t("PBars")
    local showNums   = t("PNums")
    local showLabels = t("PLabels")
    local showReady  = t("PReady")
    local showPct    = t("PPct")
    local showBorder = t("PBorder")
    local showShine  = t("PShine")
    local showGlow   = t("PGlow")
    local showShadow = t("PShadow")
    local showDRim   = t("PDepthRim")
    local showGems   = t("PGems")
    local showTicks  = t("PTicks")
    local showRefl   = t("PReflect")
    local showEdge   = t("PEdge")
    local showSp1    = t("PSweep1")
    local showSp2    = t("PSweep2")
    local showSparks = t("PSparkles")
    local showWarn   = t("PWarnOv")
    local showAura   = t("PReadyAura")
    local showCry    = t("PCrystals")
    local showSpec   = t("PSpecular")
    local showNoise  = t("PNoise")
    local showBGEL   = t("PBGEdgeL")
    local showBGER   = t("PBGEdgeR")
    local showIcon   = t("PIconLabel")

    local readyC = o("PReadyC")  or C.READY
    local tickC  = o("PTickC")   or C.WHITE
    local shnLC  = o("PShnLC")   or C.WHITE
    local shnOC  = o("PShnOC")   or C.WHITE

    local totalW = #PORDER*bW+(#PORDER-1)*bSp
    local startX = -totalW/2

    for i,name in ipairs(PORDER) do
        local bd  = pBars[name]
        local cfg = PCFG[name]
        if not bd then continue end

        -- Tick CD
        if bd.time>0 then bd.time=math.max(bd.time-dt,0) end
        local realRatio = 1-(bd.time/math.max(bd.duration,0.001))
        bd.visRatio = bd.visRatio + (realRatio-bd.visRatio)*math.min(lrpSpd*dt,1)
        local isOnCd  = bd.time>0
        local ratio   = math.clamp(bd.visRatio,0,1)
        local hasFill = ratio>0.03
        local cdPct   = 1-realRatio
        local inWarn  = isOnCd and cdPct>(1-warnThr)

        -- State transitions
        if bd.prevOnCd and not isOnCd then
            task.spawn(doFlash, bd, o(cfg.fk))
            task.spawn(doBreath, bd)
            task.spawn(doAuraPulse, bd)
            stopWarnPulse(bd)
        elseif not bd.prevOnCd and isOnCd then
            stopBreath(bd); stopAuraPulse(bd); stopWarnPulse(bd)
        end
        if inWarn and showWarn and not bd.warnPulseActive then
            task.spawn(doWarnPulse,bd)
        elseif not inWarn and bd.warnPulseActive then
            stopWarnPulse(bd)
        end
        bd.prevOnCd=isOnCd

        -- Geometry
        local xOff = startX+(i-1)*(bW+bSp)
        local lblH  = showLabels and (lbSz+3) or 0
        local totH  = bH+lblH+(showLabels and 2 or 0)
        bd.root.Size     = UDim2.new(0,bW,0,totH)
        bd.root.Position = UDim2.new(posX,xOff,posY,-totH/2)

        -- Colours (with rainbow override)
        local fClr  = rbwFill and getRainbowColor() or (o(cfg.fk)  or C.WHITE)
        local dClr  = o(cfg.dk)  or C.DANGER
        local wClr  = o(cfg.wk)  or C.WARNING
        local bgClr = o(cfg.bgk) or C.BLACK
        local nClr  = o(cfg.nk)  or C.WHITE
        local lClr  = o(cfg.lk)  or C.WHITE
        local bClr  = rbwBord and getRainbowColor() or (o(cfg.bk) or C.WHITE)
        local gClr  = rbwGlow and getRainbowColor() or (o(cfg.gk) or C.WHITE)
        local sClr  = o(cfg.sk)  or C.BLACK
        local gmClr = o(cfg.gmk) or fClr
        local rmClr = o(cfg.rmk) or bClr
        local aClr  = o(cfg.ak)  or fClr
        local wOvC  = o(cfg.wok) or C.DANGER
        local cryC  = o(cfg.crk) or C.CRYSTAL_L
        local spcC  = o(cfg.spk) or C.WHITE
        local noiC  = o(cfg.nok) or C.NOISE_A
        local edgC  = o(cfg.eck) or fClr
        local rfC   = o(cfg.rfk) or fClr
        local dynF  = dynFillC(cdPct, fClr, wClr, dClr, useDyn)

        -- ── Shadow ─────────────────────────────────────────────────────────────
        bd.shadow.BackgroundColor3=sClr
        bd.shadow.Size    =UDim2.new(1,shOff*2,0,bH+shOff*2)
        bd.shadow.Position=UDim2.new(0,-shOff,0,lblH+shOff*0.4)
        bd.shadow.BackgroundTransparency=(showShadow and showBars) and (1-shAlph) or 1

        bd.shadowGlow.BackgroundColor3=gClr
        bd.shadowGlow.Size    =UDim2.new(1,shOff*3,0,bH+shOff*3)
        bd.shadowGlow.Position=UDim2.new(0,-shOff*1.5,0,lblH+shOff*0.6)
        bd.shadowGlow.BackgroundTransparency=(showShadow and showGlow and hasFill) and 0.88 or 1

        -- ── Depth rim ─────────────────────────────────────────────────────────
        bd.dRim.Size    =UDim2.new(1,3,0,bH+3)
        bd.dRim.Position=UDim2.new(0,-1.5,0,lblH-1)
        bd.dRimSt.Color=rmClr; bd.dRimSt.Enabled=showDRim and showBars

        -- ── Outer glow ────────────────────────────────────────────────────────
        bd.outerGlow.BackgroundColor3=gClr
        bd.outerGlow.Size    =UDim2.new(0,bW+glSprd*2,0,bH+glSprd)
        bd.outerGlow.Position=UDim2.new(0,-glSprd,0,lblH-glSprd*0.4)
        bd.outerGlow.Visible = showGlow and hasFill and not bd.breathActive
        if bd.outerGlow.Visible then
            bd.outerGlow.BackgroundTransparency=1-glAlph*0.44 end

        -- ── Inner glow ────────────────────────────────────────────────────────
        bd.innerGlow.BackgroundColor3=gClr
        bd.innerGlow.Size    =UDim2.new(0,bW+12,0,bH+10)
        bd.innerGlow.Position=UDim2.new(0,-6,0,lblH-4)
        bd.innerGlow.Visible = showGlow and hasFill and not bd.breathActive
        if bd.innerGlow.Visible then
            bd.innerGlow.BackgroundTransparency=1-glAlph*0.74 end

        -- ── Ready aura ────────────────────────────────────────────────────────
        bd.rAura.Size    =UDim2.new(0,bW+auSp*2,0,bH+auSp)
        bd.rAura.Position=UDim2.new(0,-auSp,0,lblH-auSp*0.4)
        bd.rAuraSt.Color=aClr
        bd.rAura.Visible=showAura and not isOnCd
        if not showAura or isOnCd then bd.rAuraSt.Transparency=1 end

        -- ── Crystal prisms ────────────────────────────────────────────────────
        local crOff=lblH+bH*0.5
        bd.crystalL.BackgroundColor3=cryC
        bd.crystalL.Size    =UDim2.new(0,crSz,0,crSz*1.6)
        bd.crystalL.Position=UDim2.new(0,-crSz*0.5,0,crOff-crSz*0.8)
        bd.crystalL.Rotation=o("CryRot") or 45
        bd.crystalL.Visible=showCry and hasFill

        bd.crystalR.BackgroundColor3=cryC
        bd.crystalR.Size    =UDim2.new(0,crSz,0,crSz*1.6)
        bd.crystalR.Position=UDim2.new(1,-crSz*0.5,0,crOff-crSz*0.8)
        bd.crystalR.Rotation=-(o("CryRot") or 45)
        bd.crystalR.Visible=showCry and hasFill

        -- ── Reflection ────────────────────────────────────────────────────────
        bd.reflection.BackgroundColor3=rfC
        bd.reflection.Size    =UDim2.new(1,0,0,rfH)
        bd.reflection.Position=UDim2.new(0,0,0,lblH+bH+2)
        bd.reflection.BackgroundTransparency=(showRefl and hasFill and showBars) and (1-rfAlph) or 1

        -- ── Ability label ─────────────────────────────────────────────────────
        bd.abilLabel.Size    =UDim2.new(1,0,0,lblH)
        bd.abilLabel.Position=UDim2.new(0,2,0,0)
        bd.abilLabel.TextSize=lbSz; bd.abilLabel.Font=font
        bd.abilLabel.TextColor3=lClr; bd.abilLabel.Visible=showLabels

        -- ── Bar BG ────────────────────────────────────────────────────────────
        bd.barBG.Size              =UDim2.new(0,bW,0,bH)
        bd.barBG.Position          =UDim2.new(0,0,0,lblH+(showLabels and 2 or 0))
        bd.bgCo.CornerRadius       =UDim.new(0,bCr)
        bd.barBG.BackgroundColor3  =bgClr
        bd.barBG.BackgroundTransparency=bgTr
        bd.bgSt.Enabled=showBorder; bd.bgSt.Color=bClr; bd.bgSt.Thickness=stTh
        if not bd.breathActive then bd.bgSt.Transparency=0.08 end

        -- ── Noise layer ───────────────────────────────────────────────────────
        bd.noiseLayer.BackgroundColor3=noiC
        bd.noiseLayer.BackgroundTransparency=showNoise and noiseAl or 1
        if t("NoiseAnim") then
            local noiseOff=(tick()*(o("NoiseSpd") or 0.8)) % 1
            local ng=bd.noiseLayer:FindFirstChildOfClass("UIGradient")
            if ng then ng.Rotation=(noiseOff*360) % 180 end
        end

        -- ── BG edge accents ───────────────────────────────────────────────────
        bd.bgEdgeL.BackgroundColor3=edgC
        bd.bgEdgeL.Visible=showBGEL and showBars
        bd.bgEdgeR.BackgroundColor3=edgC
        bd.bgEdgeR.Visible=showBGER and showBars

        -- ── Tick marks ────────────────────────────────────────────────────────
        for _,tk in ipairs(bd.ticks) do
            tk.Visible=showTicks
            tk.BackgroundColor3=tickC
            tk.BackgroundTransparency=1-tkAlph
        end

        -- ── Warn overlay ──────────────────────────────────────────────────────
        bd.warnOv.BackgroundColor3=wOvC
        if not inWarn then bd.warnOv.BackgroundTransparency=1 end

        -- ── Fill ──────────────────────────────────────────────────────────────
        bd.fillCo.CornerRadius=UDim.new(0,bCr)
        bd.fill.BackgroundColor3=dynF
        bd.fill.BackgroundTransparency=fillTr
        bd.fillSolid.BackgroundColor3=dynF
        if fDir=="Left" then
            bd.fill.AnchorPoint=Vector2.new(0,0)
            bd.fill.Position=UDim2.new(0,0,0,0)
        else
            bd.fill.AnchorPoint=Vector2.new(1,0)
            bd.fill.Position=UDim2.new(1,0,0,0)
        end
        bd.fill.Size=UDim2.new(ratio,0,1,0)

        -- ── Shine ─────────────────────────────────────────────────────────────
        bd.shineLn.Visible=showShine and hasFill
        bd.shineLn.BackgroundColor3=shnLC
        bd.shineOv.Visible=showShine and hasFill
        bd.shineOv.BackgroundColor3=shnOC
        if showShine then bd.shineOv.BackgroundTransparency=shAlphF end

        -- ── Edge highlight ────────────────────────────────────────────────────
        bd.edgeHL.Visible=showEdge and hasFill
        bd.edgeHL.BackgroundTransparency=1-edAlph

        -- ── Specular dot size ──────────────────────────────────────────────────
        bd.specDot.BackgroundColor3=spcC
        bd.specDot.Size=UDim2.new(0,spDotSz,0,spDotSz)
        bd.specDot.Visible=showSpec

        -- ── Sparkles ─────────────────────────────────────────────────────────
        for _,sp in ipairs(bd.sparkles) do
            sp.BackgroundColor3=dynF
            sp.Visible=showSparks
        end

        -- ── Corner gems ───────────────────────────────────────────────────────
        local gemPositions={
            {UDim2.new(0,gmSz*0.6,0.5,0)},
            {UDim2.new(1,-(gmSz*1.6),0.5,0)},
            {UDim2.new(0,gmSz*0.6,0,gmSz*0.6)},
            {UDim2.new(1,-(gmSz*1.6),0,gmSz*0.6)},
        }
        for gi,gm in ipairs(bd.gems) do
            gm.Size=UDim2.new(0,gmSz,0,gmSz)
            gm.Position=gemPositions[gi][1]
            gm.BackgroundColor3=gmClr
            gm.BackgroundTransparency=(showGems and hasFill) and 0.12 or 1
        end

        -- ── Icon label ────────────────────────────────────────────────────────
        bd.iconLabel.Text=cfg.icon or ""
        bd.iconLabel.TextColor3=o("PIconC") or C.WHITE
        bd.iconLabel.Visible=showIcon and showBars

        -- ── Visibility gate ────────────────────────────────────────────────────
        if showBars then
            bd.root.Visible=true; bd.barBG.Visible=true; bd.fill.Visible=true
        elseif showNums then
            bd.root.Visible=true; bd.barBG.Visible=true; bd.fill.Visible=false
            bd.barBG.BackgroundTransparency=1
        else
            bd.root.Visible=false
        end

        -- ── Number label ──────────────────────────────────────────────────────
        bd.numLabel.Font=font; bd.numLabel.TextSize=txSz
        if bd.root.Visible and showNums then
            if isOnCd then
                bd.numLabel.TextColor3=nClr
                bd.numLabel.Text=showPct
                    and string.format("%.0f%%",realRatio*100)
                    or  string.format("%.1f",bd.time)
            elseif showReady then
                bd.numLabel.Text="✦  READY  ✦"; bd.numLabel.TextColor3=readyC
            else
                bd.numLabel.Text=""
            end
        else bd.numLabel.Text="" end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════
--  §23  LOCAL PLAYER DETECTION + TRIGGER
-- ════════════════════════════════════════════════════════════════════════════════════

local LOCAL_ANIMS={
    {name="Dash",ids={10479335397,10491993682}},
    {name="Side",ids={10480793962,10480796021}},
}

local function triggerPlayer(name)
    local bd=pBars[name]; if not bd then return end
    bd.time=bd.duration; bd.prevOnCd=true
    stopBreath(bd); stopAuraPulse(bd)
    task.spawn(doPulse,bd)
end

local function onLocalAnim(id)
    for _,e in ipairs(LOCAL_ANIMS) do
        for _,aid in ipairs(e.ids) do
            if id==aid then triggerPlayer(e.name) end
        end
    end
end

local function detectLocal()
    local char=player.Character or player.CharacterAdded:Wait()
    local hum=char:WaitForChild("Humanoid",10)
    local anim=hum and hum:WaitForChild("Animator",10)
    if not anim then return end
    anim.AnimationPlayed:Connect(function(track)
        local id=tonumber(track.Animation.AnimationId:match("%d+"))
        if id then onLocalAnim(id) end
    end)
end
player.CharacterAdded:Connect(function() task.spawn(detectLocal) end)
if player.Character then task.spawn(detectLocal) end

LiveFolder.DescendantAdded:Connect(function(child)
    if child.Name=="RagdollCancel" and child.Parent==player.Character then
        triggerPlayer("Evasive")
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════
--  §24  ENEMY OVERHEAD — BILLBOARD CONSTRUCTION
-- ════════════════════════════════════════════════════════════════════════════════════

local eTracks={}   -- [Player] = { _bill, Dash={...}, Side={...}, Evasive={...} }

local function buildOverhead(p)
    local char=p.Character; if not char then return end
    local head=char:FindFirstChild("Head"); if not head then return end
    if eTracks[p] and eTracks[p]._bill then
        pcall(function() eTracks[p]._bill:Destroy() end)
    end

    local eW    = o("EW")    or 142
    local eH    = o("EH")    or 22
    local eSp   = o("ESp")   or 8
    local eCr   = o("ECr")   or 6
    local eLbSz = o("ELbSz") or 9
    local eStd  = o("EStd")  or 3.6
    local eFont = FONT_MAP[o("EFont")] or Enum.Font.GothamBold
    local sOp   = o("EStrkOp") or 0.30
    local eGmSz = o("EGmSz") or 5
    local eCrSz = o("ECrSz") or 8
    local eSpDSz= o("ESpDotSz") or 4
    local eSpCt = math.clamp(o("ESpCnt") or 6, 0, 12)

    local lblH   = eLbSz+2
    local entryH = eH+lblH+4
    local totH   = #EORDER*entryH+(#EORDER-1)*eSp

    -- BillboardGui root
    local bill=Instance.new("BillboardGui")
    bill.Name="CrystalCDTracker"; bill.Adornee=head
    bill.Size=UDim2.new(0,eW,0,totH)
    bill.StudsOffset=Vector3.new(0,eStd,0)
    bill.AlwaysOnTop=t("EAlTop") or false
    bill.LightInfluence=0; bill.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    bill.Parent=head

    local ll=Instance.new("UIListLayout",bill)
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.HorizontalAlignment=Enum.HorizontalAlignment.Center
    ll.FillDirection=Enum.FillDirection.Vertical
    ll.Padding=UDim.new(0,eSp)

    local rowRefs={}

    for idx,abn in ipairs(EORDER) do
        local cfg=ECFG[abn]

        -- ── Entry container ────────────────────────────────────────────────────
        local entry=Instance.new("Frame")
        entry.Name=abn.."_Row"; entry.Size=UDim2.new(1,0,0,entryH)
        entry.BackgroundTransparency=1; entry.BorderSizePixel=0
        entry.LayoutOrder=idx; entry.Visible=false; entry.Parent=bill

        -- ── Outer glow ─────────────────────────────────────────────────────────
        local eOG=Instance.new("Frame")
        eOG.Name="OGlow"; eOG.BackgroundTransparency=0.85
        eOG.BorderSizePixel=0; eOG.ZIndex=1; eOG.Parent=entry
        eOG.Size=UDim2.new(1,18,1,12); eOG.Position=UDim2.new(0,-9,0,-6)
        mkCorner(eOG,eCr+8)
        local eOGGrad=Instance.new("UIGradient",eOG); eOGGrad.Rotation=90
        eOGGrad.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.64),
            NumberSequenceKeypoint.new(.5,0.80),
            NumberSequenceKeypoint.new(1,0.96),
        })

        -- ── Inner glow ─────────────────────────────────────────────────────────
        local eIG=Instance.new("Frame")
        eIG.Name="IGlow"; eIG.BackgroundTransparency=0.74
        eIG.BorderSizePixel=0; eIG.ZIndex=2; eIG.Parent=entry
        eIG.Size=UDim2.new(1,8,1,6); eIG.Position=UDim2.new(0,-4,0,-3)
        mkCorner(eIG,eCr+4)
        local eIGGrad=Instance.new("UIGradient",eIG); eIGGrad.Rotation=90
        eIGGrad.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.58),
            NumberSequenceKeypoint.new(1,0.80),
        })

        -- ── Ready aura ─────────────────────────────────────────────────────────
        local eRA=Instance.new("Frame")
        eRA.Name="ReadyAura"; eRA.BackgroundTransparency=1
        eRA.BorderSizePixel=0; eRA.ZIndex=2; eRA.Parent=entry
        eRA.Size=UDim2.new(1,22,1,14); eRA.Position=UDim2.new(0,-11,0,-7)
        eRA.Visible=false; mkCorner(eRA,eCr+11)
        local eRASt=Instance.new("UIStroke",eRA)
        eRASt.Thickness=2.2; eRASt.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        eRASt.Transparency=1

        -- ── Depth rim ─────────────────────────────────────────────────────────
        local eRim=Instance.new("Frame")
        eRim.Name="DepthRim"; eRim.BackgroundTransparency=1
        eRim.BorderSizePixel=0; eRim.ZIndex=3; eRim.Parent=entry
        eRim.Size=UDim2.new(1,3,1,3); eRim.Position=UDim2.new(0,-1.5,0,-1.5)
        mkCorner(eRim,eCr+4)
        local eRimSt=Instance.new("UIStroke",eRim)
        eRimSt.Thickness=1.1; eRimSt.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        eRimSt.Transparency=0.50

        -- ── Crystal prisms ─────────────────────────────────────────────────────
        local eCryL=Instance.new("Frame")
        eCryL.Name="CryL"; eCryL.BackgroundColor3=C.CRYSTAL_L
        eCryL.BackgroundTransparency=0.38; eCryL.BorderSizePixel=0; eCryL.ZIndex=3
        eCryL.Parent=entry
        mkCorner(eCryL,3)
        local eCryLG=Instance.new("UIGradient",eCryL); eCryLG.Rotation=45
        eCryLG.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.18),NumberSequenceKeypoint.new(.5,0.56),NumberSequenceKeypoint.new(1,0.92)})

        local eCryR=Instance.new("Frame")
        eCryR.Name="CryR"; eCryR.BackgroundColor3=C.CRYSTAL_L
        eCryR.BackgroundTransparency=0.38; eCryR.BorderSizePixel=0; eCryR.ZIndex=3
        eCryR.Parent=entry
        mkCorner(eCryR,3)
        local eCryRG=Instance.new("UIGradient",eCryR); eCryRG.Rotation=135
        eCryRG.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.18),NumberSequenceKeypoint.new(.5,0.56),NumberSequenceKeypoint.new(1,0.92)})

        loopCrystalPulse(eCryL,(idx-1)*0.78)
        loopCrystalPulse(eCryR,(idx-1)*0.78+0.60)

        -- ── Reflection ─────────────────────────────────────────────────────────
        local eRefl=Instance.new("Frame")
        eRefl.Name="Refl"; eRefl.BackgroundColor3=C.WHITE
        eRefl.BackgroundTransparency=0.90; eRefl.BorderSizePixel=0; eRefl.ZIndex=3
        eRefl.Parent=entry
        mkCorner(eRefl,5)
        local eRG=Instance.new("UIGradient",eRefl); eRG.Rotation=90
        eRG.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.70),NumberSequenceKeypoint.new(.6,0.88),NumberSequenceKeypoint.new(1,1.00)})

        -- ── Ability label ──────────────────────────────────────────────────────
        local eLbl=Instance.new("TextLabel")
        eLbl.Name="Label"; eLbl.BackgroundTransparency=1; eLbl.BorderSizePixel=0
        eLbl.Size=UDim2.new(1,0,0,lblH); eLbl.Position=UDim2.new(0,0,0,0)
        eLbl.Text=cfg.sym.."  "..cfg.label
        eLbl.TextColor3=C.WHITE; eLbl.Font=eFont; eLbl.TextScaled=false
        eLbl.TextSize=eLbSz; eLbl.TextXAlignment=Enum.TextXAlignment.Left
        eLbl.TextYAlignment=Enum.TextYAlignment.Center
        eLbl.TextStrokeTransparency=sOp; eLbl.TextStrokeColor3=C.BLACK
        eLbl.ZIndex=5; eLbl.Parent=entry

        -- ── Bar background ─────────────────────────────────────────────────────
        local eBG=Instance.new("Frame")
        eBG.Name="BarBG"; eBG.Size=UDim2.new(1,0,0,eH)
        eBG.Position=UDim2.new(0,0,0,lblH+2)
        eBG.BackgroundColor3=C.BLACK
        eBG.BackgroundTransparency=o("EBGTr") or 0.20
        eBG.BorderSizePixel=0; eBG.ZIndex=4; eBG.ClipsDescendants=false
        eBG.Parent=entry
        local eBGCo=mkCorner(eBG,eCr)
        -- BG gradient
        local eBGGrad=Instance.new("UIGradient")
        eBGGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,   C.GRAD_BGTOP),
            ColorSequenceKeypoint.new(0.42,C.GRAD_BGPUR),
            ColorSequenceKeypoint.new(1,   C.GRAD_BGBOT),
        })
        eBGGrad.Rotation=90; eBGGrad.Parent=eBG
        local eBGT=Instance.new("UIGradient")
        eBGT.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.74),NumberSequenceKeypoint.new(1,0.50)})
        eBGT.Rotation=90; eBGT.Parent=eBG
        local eBGSt=Instance.new("UIStroke",eBG)
        eBGSt.Thickness=1.3; eBGSt.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        eBGSt.Transparency=0.10

        -- BG edge accents
        local eBGEL=mkBGEdge(eBG,false)
        local eBGER=mkBGEdge(eBG,true)

        -- Tick marks
        local eTks=mkTicks(eBG)

        -- Warn overlay
        local eWOv=mkWarnOverlay(eBG,eCr)

        -- ── Fill clip + fill bar ───────────────────────────────────────────────
        local eFClip=Instance.new("Frame")
        eFClip.Name="FillClip"; eFClip.BackgroundTransparency=1
        eFClip.BorderSizePixel=0; eFClip.ClipsDescendants=true; eFClip.ZIndex=5
        eFClip.Size=UDim2.new(1,0,1,0); eFClip.Position=UDim2.new(0,0,0,0)
        eFClip.Parent=eBG

        local eFill=Instance.new("Frame")
        eFill.Name="Fill"; eFill.BorderSizePixel=0; eFill.ZIndex=5
        eFill.ClipsDescendants=true; eFill.Parent=eFClip
        local eFCo=mkCorner(eFill,eCr)
        -- Fill gradient
        local eFG=Instance.new("UIGradient")
        eFG.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,   C.WHITE),
            ColorSequenceKeypoint.new(0.28,C.GRAD_LAV),
            ColorSequenceKeypoint.new(0.58,C.GRAD_SKY),
            ColorSequenceKeypoint.new(1,   C.GRAD_DEEP),
        })
        eFG.Rotation=90
        eFG.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.40),NumberSequenceKeypoint.new(0.35,0.56),NumberSequenceKeypoint.new(1,0.08)})
        eFG.Parent=eFill
        -- Solid colour layer
        local eFSolid=Instance.new("Frame")
        eFSolid.BackgroundTransparency=0.55; eFSolid.BorderSizePixel=0; eFSolid.ZIndex=6
        eFSolid.Size=UDim2.new(1,0,1,0); eFSolid.Position=UDim2.new(0,0,0,0)
        eFSolid.Parent=eFill; mkCorner(eFSolid,eCr)

        -- ── Sweep strips ───────────────────────────────────────────────────────
        local eSw1=mkSweepStrip(eFill,7)
        local eSw2=mkSweepStrip(eFill,7)
        loopSweep(eSw1,"ESw1W","ESw1D","ESw1G","ESweep1","ESw1C",(idx-1)*0.68)
        loopSweep(eSw2,"ESw2W","ESw2D","ESw2G","ESweep2","ESw2C",(idx-1)*0.68+0.38)

        -- ── Shine elements ─────────────────────────────────────────────────────
        local eSLn,eSOv=mkShineElements(eFill)

        -- ── Edge highlight ─────────────────────────────────────────────────────
        local eEdge=mkEdgeHL(eFill)

        -- ── Specular dot ───────────────────────────────────────────────────────
        local eSpec=mkSpecularDot(eFill,eSpDSz)
        loopSpecular(eSpec,"FXSpDur","FXSpGap","FXSpAlph","ESpecular",(idx-1)*0.7)

        -- ── Sparkle dots ───────────────────────────────────────────────────────
        local eSps={}
        for j=1,eSpCt do
            local xp=(j-0.5)/eSpCt
            local sp=Instance.new("Frame")
            sp.Size=UDim2.new(0,2,0,2); sp.AnchorPoint=Vector2.new(0.5,0.5)
            sp.Position=UDim2.new(xp,0,0.5,0)
            sp.BackgroundColor3=C.WHITE; sp.BackgroundTransparency=1
            sp.BorderSizePixel=0; sp.ZIndex=10; sp.Parent=eFill
            mkCorner(sp,99); eSps[j]=sp
            loopSparkle(sp,(j-1)*0.46+(idx-1)*0.20,true)
        end

        -- ── Corner gems (×4) ───────────────────────────────────────────────────
        local eGems=mkGems(eBG)

        -- ── Number label ───────────────────────────────────────────────────────
        local eNum=mkNumLabel(eBG)
        eNum.TextSize=o("ETxSz") or 11
        eNum.TextStrokeTransparency=sOp

        rowRefs[abn]={
            entry=entry, og=eOG, ig=eIG,
            ra=eRA, raSt=eRASt,
            rim=eRim, rimSt=eRimSt,
            cryL=eCryL, cryR=eCryR,
            refl=eRefl, lbl=eLbl,
            bg=eBG, bgCo=eBGCo, bgSt=eBGSt,
            bgEL=eBGEL, bgER=eBGER,
            ticks=eTks, wov=eWOv,
            fclip=eFClip, fill=eFill, fco=eFCo, fsolid=eFSolid,
            sw1=eSw1, sw2=eSw2,
            shLn=eSLn, shOv=eSOv,
            edge=eEdge, spec=eSpec,
            sparks=eSps, gems=eGems,
            num=eNum,
        }
    end

    if not eTracks[p] then eTracks[p]={} end
    eTracks[p]._bill=bill
    for abn in pairs(ECFG) do
        if not eTracks[p][abn] then
            eTracks[p][abn]={time=0,visRatio=0}
        else
            eTracks[p][abn].visRatio=eTracks[p][abn].visRatio or 0
        end
        local refs=rowRefs[abn]
        if refs then for k,v in pairs(refs) do eTracks[p][abn][k]=v end end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════
--  §25  ENEMY TRIGGER + SETUP + CLEANUP
-- ════════════════════════════════════════════════════════════════════════════════════

local function triggerEnemy(p,abn)
    local cfg=ECFG[abn]; if not cfg then return end
    if not eTracks[p] then eTracks[p]={} end
    if not eTracks[p][abn] then eTracks[p][abn]={time=0,visRatio=0} end
    eTracks[p][abn].time=cfg.defaultCD
end

local ENEMY_ANIMS={
    {name="Dash",ids={10479335397,10491993682}},
    {name="Side",ids={10480793962,10480796021}},
}

local function setupEnemy(p)
    if p==player then return end
    eTracks[p]={}
    for abn in pairs(ECFG) do eTracks[p][abn]={time=0,visRatio=0} end
    local function onChar(char)
        char:WaitForChild("Head",10); task.wait(0.14)
        buildOverhead(p)
        local hum=char:WaitForChild("Humanoid",10)
        local anim=hum and hum:WaitForChild("Animator",10)
        if not anim then return end
        anim.AnimationPlayed:Connect(function(track)
            local id=tonumber(track.Animation.AnimationId:match("%d+"))
            if not id then return end
            for _,e in ipairs(ENEMY_ANIMS) do
                for _,aid in ipairs(e.ids) do
                    if id==aid then triggerEnemy(p,e.name) end
                end
            end
        end)
    end
    if p.Character then task.spawn(onChar,p.Character) end
    p.CharacterAdded:Connect(onChar)
end

for _,p in ipairs(Players:GetPlayers()) do setupEnemy(p) end
Players.PlayerAdded:Connect(setupEnemy)
Players.PlayerRemoving:Connect(function(p)
    local tr=eTracks[p]; if not tr then return end
    if tr._bill then pcall(function() tr._bill:Destroy() end) end
    eTracks[p]=nil
end)

-- Evasive (enemies via RagdollCancel in LiveFolder)
LiveFolder.DescendantAdded:Connect(function(child)
    if child.Name~="RagdollCancel" then return end
    local char=child.Parent
    if char==player.Character then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and p.Character==char then
            triggerEnemy(p,"Evasive"); break
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════
--  §26  ENEMY OVERHEAD HEARTBEAT UPDATE
-- ════════════════════════════════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function(dt)
    local showBars  = t("EBars")
    local onlyCd    = t("EOnlyCd")
    local showFill  = t("EFill")
    local showNums  = t("ENums")
    local showLbls  = t("ELabels")
    local showBord  = t("EBorder")
    local showShine = t("EShine")
    local showGlow  = t("EGlow")
    local showGems  = t("EGems")
    local showTicks = t("ETicks")
    local showRefl  = t("EReflect")
    local showEdge  = t("EEdge")
    local showSp1   = t("ESweep1")
    local showSp2   = t("ESweep2")
    local showSparks= t("ESparkles")
    local showWarn  = t("EWarnOv")
    local showAura  = t("EReadyAura")
    local showCrys  = t("ECrystals")
    local showSpec  = t("ESpecular")
    local distFade  = t("EDistFade")
    local showReady = t("EReady")
    local showDRim  = t("EDepthRim")
    local ohAlTop   = t("EAlTop")

    local eW     = o("EW")    or 142
    local eH     = o("EH")    or 22
    local eSp    = o("ESp")   or 8
    local eCr    = o("ECr")   or 6
    local eStd   = o("EStd")  or 3.6
    local eBGTr  = o("EBGTr") or 0.20
    local eTxSz  = o("ETxSz") or 11
    local eLbSz  = o("ELbSz") or 9
    local eLp    = o("ELp")   or 8
    local eGlSp  = o("EGlSprd") or 14
    local eGlAl  = o("EGlAlph") or 0.82
    local eGmSz  = o("EGmSz")   or 5
    local eTkAl  = o("ETkAlph") or 0.50
    local eRfH   = o("ERfH")    or 5
    local eRfAl  = o("ERfAlph") or 0.76
    local eStTh  = o("EStTh")   or 1.3
    local eEdAl  = o("EEdAlph") or 0.48
    local eShAl  = o("EShAlphFl") or 0.84
    local eWnTh  = (o("EWnTh") or 28)/100
    local eAuSp  = o("EAuSp")   or 10
    local eCrSz  = o("ECrSz")   or 8
    local eSpDAl = o("FXSpAlph") or 0.70
    local eMaxD  = o("EMaxDst")  or 100
    local sOp    = o("EStrkOp")  or 0.30
    local eFont  = FONT_MAP[o("EFont")] or Enum.Font.GothamBold
    local fDir   = o("EFDir") or "Left"
    local tickC  = o("ETickC") or C.WHITE
    local readyC = o("EReadyC") or C.READY
    local rbwFill= t("RbwFill") or false
    local rbwBord= t("RbwBord") or false
    local rbwGlow= t("RbwGlow") or false

    local lblH   = eLbSz+2
    local entryH = eH+lblH+4
    local totH   = #EORDER*entryH+(#EORDER-1)*eSp

    local cam    = Workspace.CurrentCamera
    local camPos = cam and cam.CFrame.Position or Vector3.zero

    for p,tracker in pairs(eTracks) do
        local bill=tracker._bill
        if bill then
            bill.Enabled    = showBars or false
            bill.AlwaysOnTop= ohAlTop  or false
            bill.StudsOffset= Vector3.new(0,eStd,0)
            bill.Size       = UDim2.new(0,eW,0,totH)
        end

        -- Distance fade multiplier
        local distMul=1.0
        if distFade and p.Character then
            local rp=p.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                local d=(rp.Position-camPos).Magnitude
                if d>eMaxD then distMul=0
                elseif d>eMaxD*0.72 then
                    distMul=1-((d-eMaxD*0.72)/(eMaxD*0.28))
                end
            end
        end

        for abn,data in pairs(tracker) do
            if abn=="_bill" then continue end
            local cfg=ECFG[abn]; if not cfg then continue end

            if data.time>0 then data.time=math.max(data.time-dt,0) end
            data.visRatio=data.visRatio or 0
            local realRatio=1-(data.time/math.max(cfg.defaultCD,0.001))
            data.visRatio=data.visRatio+(realRatio-data.visRatio)*math.min(eLp*dt,1)

            local isOnCd  = data.time>0
            local ratio   = math.clamp(data.visRatio,0,1)
            local hasFill = ratio>0.03
            local cdPct   = 1-realRatio
            local inWarn  = isOnCd and cdPct>(1-eWnTh)

            local entry=data.entry
            if not entry or not entry.Parent then continue end

            local shouldShow = showBars and (isOnCd or not onlyCd) and distMul>0
            entry.Visible=shouldShow
            if not shouldShow then continue end

            -- Colours
            local fClr  = rbwFill and getRainbowColor() or (o(cfg.fk)  or C.WHITE)
            local dClr  = o(cfg.dk)  or C.DANGER
            local wClr  = o(cfg.wk)  or C.WARNING
            local bgClr = o(cfg.bgk) or C.BLACK
            local nClr  = o(cfg.nk)  or C.WHITE
            local lClr  = o(cfg.lk)  or C.WHITE
            local bClr  = rbwBord and getRainbowColor() or (o(cfg.bk) or C.WHITE)
            local gClr  = rbwGlow and getRainbowColor() or (o(cfg.gk) or C.WHITE)
            local gmClr = o(cfg.gmk) or fClr
            local rmClr = o(cfg.rmk) or bClr
            local aClr  = o(cfg.ak)  or fClr
            local wOvC  = o(cfg.wok) or C.DANGER
            local cryC  = o(cfg.crk) or C.CRYSTAL_L
            local spcC  = o(cfg.spk) or C.WHITE
            local dynF  = dynFillC(cdPct,fClr,wClr,dClr,true)

            -- ── Outer glow ────────────────────────────────────────────────────
            if data.og then
                data.og.BackgroundColor3=gClr
                data.og.BackgroundTransparency=(showGlow and hasFill) and (1-eGlAl*0.44*distMul) or 1
            end
            if data.ig then
                data.ig.BackgroundColor3=gClr
                data.ig.BackgroundTransparency=(showGlow and hasFill) and (1-eGlAl*0.74*distMul) or 1
            end

            -- ── Ready aura ────────────────────────────────────────────────────
            if data.ra then
                data.ra.Visible=showAura and not isOnCd
                if data.raSt then
                    data.raSt.Color=aClr
                    data.raSt.Transparency=(showAura and not isOnCd) and 0.38 or 1
                end
            end

            -- ── Depth rim ─────────────────────────────────────────────────────
            if data.rim and data.rimSt then
                data.rimSt.Color=rmClr; data.rimSt.Enabled=showDRim end

            -- ── Crystal prisms ─────────────────────────────────────────────────
            if data.cryL then
                data.cryL.BackgroundColor3=cryC
                local crOff=lblH+eH*0.5
                data.cryL.Size    =UDim2.new(0,eCrSz,0,eCrSz*1.6)
                data.cryL.Position=UDim2.new(0,-eCrSz*0.5,0,crOff-eCrSz*0.8)
                data.cryL.Rotation=o("CryRot") or 45
                data.cryL.Visible=showCrys and hasFill
            end
            if data.cryR then
                data.cryR.BackgroundColor3=cryC
                local crOff=lblH+eH*0.5
                data.cryR.Size    =UDim2.new(0,eCrSz,0,eCrSz*1.6)
                data.cryR.Position=UDim2.new(1,-eCrSz*0.5,0,crOff-eCrSz*0.8)
                data.cryR.Rotation=-(o("CryRot") or 45)
                data.cryR.Visible=showCrys and hasFill
            end

            -- ── Reflection ────────────────────────────────────────────────────
            if data.refl then
                data.refl.BackgroundColor3=dynF
                data.refl.Size    =UDim2.new(1,0,0,eRfH)
                data.refl.Position=UDim2.new(0,0,0,entryH+2)
                data.refl.BackgroundTransparency=(showRefl and hasFill) and (1-eRfAl*distMul) or 1
            end

            -- ── Label ─────────────────────────────────────────────────────────
            if data.lbl then
                data.lbl.Visible=showLbls; data.lbl.TextColor3=lClr
                data.lbl.Font=eFont; data.lbl.TextSize=eLbSz
                data.lbl.TextStrokeTransparency=sOp
            end

            -- ── BG frame ──────────────────────────────────────────────────────
            if data.bg then
                data.bg.BackgroundColor3=bgClr
                data.bg.BackgroundTransparency=eBGTr
            end
            if data.bgCo then data.bgCo.CornerRadius=UDim.new(0,eCr) end
            if data.bgSt then
                data.bgSt.Enabled=showBord; data.bgSt.Color=bClr
                data.bgSt.Thickness=eStTh; data.bgSt.Transparency=0.08
            end

            -- BG edge accents
            if data.bgEL then data.bgEL.BackgroundColor3=fClr; data.bgEL.Visible=showBord end
            if data.bgER then data.bgER.BackgroundColor3=fClr; data.bgER.Visible=showBord end

            -- ── Ticks ─────────────────────────────────────────────────────────
            if data.ticks then
                for _,tk in ipairs(data.ticks) do
                    tk.Visible=showTicks; tk.BackgroundColor3=tickC
                    tk.BackgroundTransparency=1-eTkAl
                end
            end

            -- ── Warn overlay ──────────────────────────────────────────────────
            if data.wov then
                data.wov.BackgroundColor3=wOvC
                data.wov.BackgroundTransparency=(inWarn and showWarn)
                    and (1-(o("FXWnAlA") or 0.32)) or 1
            end

            -- ── Fill ──────────────────────────────────────────────────────────
            if data.fill then
                data.fill.Visible=showFill
                data.fill.BackgroundColor3=dynF; data.fill.BackgroundTransparency=0
                if data.fco then data.fco.CornerRadius=UDim.new(0,eCr) end
                if data.fsolid then data.fsolid.BackgroundColor3=dynF end
                if fDir=="Left" then
                    data.fill.AnchorPoint=Vector2.new(0,0)
                    data.fill.Position=UDim2.new(0,0,0,0)
                else
                    data.fill.AnchorPoint=Vector2.new(1,0)
                    data.fill.Position=UDim2.new(1,0,0,0)
                end
                data.fill.Size=UDim2.new(ratio,0,1,0)
            end

            -- ── Shine ─────────────────────────────────────────────────────────
            if data.shLn then data.shLn.Visible=showShine and hasFill end
            if data.shOv then
                data.shOv.Visible=showShine and hasFill
                if showShine then data.shOv.BackgroundTransparency=eShAl end
            end

            -- ── Edge highlight ─────────────────────────────────────────────────
            if data.edge then
                data.edge.Visible=showEdge and hasFill
                data.edge.BackgroundTransparency=1-eEdAl
            end

            -- ── Specular dot ───────────────────────────────────────────────────
            if data.spec then
                data.spec.BackgroundColor3=spcC
                data.spec.Visible=showSpec
            end

            -- ── Sparkles ──────────────────────────────────────────────────────
            if data.sparks then
                for _,sp in ipairs(data.sparks) do
                    sp.BackgroundColor3=dynF; sp.Visible=showSparks
                end
            end

            -- ── Corner gems ───────────────────────────────────────────────────
            if data.gems then
                local gemPos={
                    UDim2.new(0,eGmSz*0.6,0.5,0),
                    UDim2.new(1,-(eGmSz*1.6),0.5,0),
                    UDim2.new(0,eGmSz*0.6,0,eGmSz*0.6),
                    UDim2.new(1,-(eGmSz*1.6),0,eGmSz*0.6),
                }
                for gi,gm in ipairs(data.gems) do
                    gm.Size=UDim2.new(0,eGmSz,0,eGmSz)
                    gm.Position=gemPos[gi]
                    gm.BackgroundColor3=gmClr
                    gm.BackgroundTransparency=(showGems and hasFill) and 0.14 or 1
                end
            end

            -- ── Number label ───────────────────────────────────────────────────
            if data.num then
                data.num.Visible=showNums; data.num.Font=eFont
                data.num.TextSize=eTxSz; data.num.TextStrokeTransparency=sOp
                if showNums then
                    if isOnCd then
                        data.num.TextColor3=nClr
                        data.num.Text=string.format("%.1f",data.time)
                    elseif showReady then
                        data.num.TextColor3=readyC; data.num.Text="READY"
                    else data.num.Text="" end
                else data.num.Text="" end
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════
--  §27  END  —  Crystal Bars v6  ·  Premium  ·  Loaded successfully ✦
-- ════════════════════════════════════════════════════════════════════════════════════
--[[
    QUICK REFERENCE — Animation IDs used for detection:
    ───────────────────────────────────────────────────
    Front Dash   10479335397   10491993682
    Side Dash    10480793962   10480796021
    Evasive      RagdollCancel (LiveFolder descendant)

    All three detected for LOCAL PLAYER and ALL ENEMIES automatically.

    ── HOW THE COLOUR SYSTEM WORKS ────────────────────────────────────────────
    Each ability has 18 individual colour pickers (player) / 14 (enemy).
    The fill colour shifts dynamically:
      0-38% of CD elapsed  →  base Fill Color
      38-64% elapsed       →  lerp toward Fill Warning color
      64-100% elapsed      →  lerp toward Fill Danger color
    This can be disabled per-bar via "Dynamic Danger Tint" toggle.

    Rainbow Mode overrides Fill / Border / Glow with a cycling HSV hue.
    Saturation and Value sliders control vividness.

    ── LAYER COUNT ─────────────────────────────────────────────────────────────
    Player bars: 28 visual layers each × 3 bars = 84 total elements
    Enemy bars:  26 visual layers each × 3 abilities × N enemies

    ── EFFECTS ─────────────────────────────────────────────────────────────────
    Trigger Pulse    — Scale-X/Y bounce on ability use (Back easing)
    Ready Flash      — Multi-blink colour flash on CD expiry
    Ready Breath     — Sinusoidal border + glow breathing while ready
    Warning Pulse    — Red overlay throbs in last N% of CD
    Aura Pulse       — Ready aura ring breathes independently
    Specular Travel  — Bright dot glides across fill surface with fade in/out
    Crystal Pulse    — Prism accent fades in/out rhythmically
    Noise Animation  — BG texture layer scrolls / rotates slowly
    Rainbow Mode     — HSV colour cycling for fill, border, glow independently
]]

-- ════════════════════════════════════════════════════════════════════════════════════
--  §28  EXTENDED VISUAL NOTES AND PREMIUM FEATURE DOCUMENTATION
-- ════════════════════════════════════════════════════════════════════════════════════
--[[
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │                    CRYSTAL BARS v6 — COMPLETE VISUAL REFERENCE                   │
  └─────────────────────────────────────────────────────────────────────────────────┘

  ╔═══════════════════════════════════════════════════════════════════════════════════╗
  ║  PLAYER BARS  (screen-space, three bars laid horizontally)                       ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║                                                                                   ║
  ║  ┌───────────────────────────────────────────────────────────────────────────┐   ║
  ║  │  ◈ FRONT DASH              shadow  ·  depth-rim  ·  outer+inner glow     │   ║
  ║  │  ╔══╡crystal╞═════════════════════════════════════════════╡crystal╞══╗   │   ║
  ║  │  ║  ╔──────────────────────────────────────────────────────────────╗  ║   │   ║
  ║  │  ║  ║ ░░ BG noise ░░ | tick | tick | tick |   BG gradient          ║  ║   │   ║
  ║  │  ║  ║ ┌─────────────────────────────────┐  edge-L ↑ ↑ edge-R     ║  ║   │   ║
  ║  │  ║  ║ │ ░FILL░  sweep1→  sweep2→  specs │  shine-line at top      ║  ║   │   ║
  ║  │  ║  ║ │ ●sparkle  ●sparkle  ●sparkle   │  shine-overlay top-half  ║  ║   │   ║
  ║  │  ║  ║ │ ○gem-TL              ○gem-TR   │  edge-HL right strip     ║  ║   │   ║
  ║  │  ║  ║ │ ○gem-L  ⚡5.0s      ○gem-R    │  warn-overlay pulsing    ║  ║   │   ║
  ║  │  ║  ║ └─────────────────────────────────┘                         ║  ║   │   ║
  ║  │  ║  ╚──────────────────────────────────────────────────────────────╝  ║   │   ║
  ║  │  ╚══════════════════════════════════════════════════════════════════════╝   │   ║
  ║  │         reflection strip (faint mirror below bar)                          │   ║
  ║  │         ready-aura ring (pulses outside frame when READY)                  │   ║
  ║  └───────────────────────────────────────────────────────────────────────────┘   ║
  ║                                                                                   ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║  ENEMY OVERHEAD  (BillboardGui attached to head, three rows per enemy)            ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║                                                                                   ║
  ║  [enemy head]                                                                     ║
  ║      ↑                                                                            ║
  ║   ┌─────────────────────────────────┐   ← outer glow halo                        ║
  ║   │ ◈  FRONT DASH                   │   ← depth rim                              ║
  ║   │ ╔═══════════════════════════╗   │                                             ║
  ║   │ ║ ░░ fill ░░ sweep ░░ spec ║   │   ← ticks + warn overlay                   ║
  ║   │ ╚═══════════════════════════╝   │   ← gems + shine + edge                    ║
  ║   │ ◈  SIDE DASH                    │   ← crystal prisms at ends                 ║
  ║   │ ╔═══════════════════════════╗   │   ← reflection strip below                 ║
  ║   │ ║    2.0s                   ║   │   ← ready-aura ring when READY             ║
  ║   │ ╚═══════════════════════════╝   │                                             ║
  ║   │ ◈  EVASIVE                      │   ← distance fade (0→maxDist studs)        ║
  ║   │ ╔═══════════════════════════╗   │                                             ║
  ║   │ ║  READY                    ║   │                                             ║
  ║   │ ╚═══════════════════════════╝   │                                             ║
  ║   └─────────────────────────────────┘                                             ║
  ║                                                                                   ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║  FILL GRADIENT LAYERS  (stacked inside fill bar, bottom→top)                     ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║                                                                                   ║
  ║   Layer A:  UIGradient (iridescent)                                               ║
  ║             White top → Lavender midtop → Sky-blue midbot → Deep-indigo bot      ║
  ║             Transparency ramp: 0.40 → 0.56 → 0.08 (top bright, bot saturated)   ║
  ║                                                                                   ║
  ║   Layer B:  Solid Frame (BackgroundColor3 = dynFill)                              ║
  ║             Transparency 0.55 — blends BASE COLOUR into gradient wash             ║
  ║             Colour changes dynamically: fill → warning → danger                  ║
  ║                                                                                   ║
  ║   Layer C:  Enchant Sweep 1  (fast, narrow)                                       ║
  ║             Gaussian-like transparency envelope on a white frame                  ║
  ║             Glides left→right, wraps, loops with configurable gap                 ║
  ║                                                                                   ║
  ║   Layer D:  Enchant Sweep 2  (slow, wider)                                        ║
  ║             Same shape but wider and slower — creates depth parallax illusion     ║
  ║             Offset by ~0.40s from Sweep 1 so they don't overlap                  ║
  ║                                                                                   ║
  ║   Layer E:  Shine Hairline                                                        ║
  ║             2-px bright horizontal line at very top edge of fill                  ║
  ║             Rounded ends, slight transparency (~0.32)                             ║
  ║                                                                                   ║
  ║   Layer F:  Shine Overlay                                                         ║
  ║             Top 50% of fill is a white semi-transparent frame                     ║
  ║             Creates frosted-glass / holographic top-lit look                      ║
  ║                                                                                   ║
  ║   Layer G:  Specular Dot                                                          ║
  ║             Small bright circle that slowly glides left→right                    ║
  ║             Fades in at start, travels across surface, fades out at end           ║
  ║             Loops with configurable travel speed and gap                          ║
  ║                                                                                   ║
  ║   Layer H:  Edge Highlight                                                        ║
  ║             4-px bright strip at right edge of fill                               ║
  ║             Gradient: bright at top → dim at bottom                               ║
  ║             Gives the impression of a backlit edge                                ║
  ║                                                                                   ║
  ║   Layer I:  Sparkle Dots (×7-9)                                                   ║
  ║             Tiny circles spaced evenly across fill width                          ║
  ║             Each blinks independently at random intervals                         ║
  ║             Double-blink flash pattern then slow fade to invisible                ║
  ║             Restart interval randomised to avoid synchronisation                  ║
  ║                                                                                   ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║  BAR BACKGROUND LAYERS  (inside BarBG frame)                                     ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║                                                                                   ║
  ║   BG Gradient A:   Colour gradient  very-dark-top → arcane-purple-mid → near-black
  ║   BG Gradient B:   Transparency ramp to let fill colour bleed through slightly   ║
  ║   Noise Layer:     Diagonal-stripe UIGradient overlay for texture feel           ║
  ║                    Rotation animates slowly when "Animate Noise" is on           ║
  ║   BG Edge L/R:     2-px accent strips at each end of BG frame                   ║
  ║                    Vertical gradient bright-centre / dim-ends                    ║
  ║   UIStroke:        Border outline — colour + thickness fully configurable        ║
  ║   Tick Marks:      1-px vertical lines at 25%, 50%, 75% of bar width            ║
  ║   Warn Overlay:    Red-tinted Frame that pulses when CD almost expired           ║
  ║                                                                                   ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║  OUTER DECORATION LAYERS  (outside BarBG, in root container)                     ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║                                                                                   ║
  ║   Drop Shadow:     Dark blurred frame offset below+right of bar                  ║
  ║                    UIGradient fades from 0.38→0.84 transparency top→bot          ║
  ║   Shadow Glow:     Faint colour-matched glow behind shadow                       ║
  ║                    Makes bar feel "illuminated from within"                      ║
  ║   Depth Rim:       Thin UIStroke on a slightly-larger invisible frame            ║
  ║                    Colour = rimKey (default slightly desaturated border col)     ║
  ║                    Creates a 3-D ledge / bevel illusion                          ║
  ║   Outer Halo Glow: Wide soft frame coloured by glowKey                           ║
  ║                    UIGradient transparency ramp: 0.66→0.96 so edges fade         ║
  ║   Inner Glow:      Tighter version of outer glow, more saturated                 ║
  ║   Ready Aura Ring: Separate UIStroke on large invisible frame                   ║
  ║                    Only visible when ability is READY (not on CD)               ║
  ║                    Pulses via FXAuraPulse effect loop                           ║
  ║   Crystal Prisms:  Rotated Frames at each end of the bar                        ║
  ║                    Diagonal UIGradient gives diamond-facet appearance            ║
  ║                    Pulse independently via loopCrystalPulse                     ║
  ║                    Rotation angle configurable in Crystal FX tab                 ║
  ║   Reflection:      Thin Frame below bar with colour = fill colour               ║
  ║                    UIGradient fades bottom-to-transparent                        ║
  ║                    Creates wet/glossy surface reflection illusion                ║
  ║   Ability Label:   TextLabel above bar — icon emoji + ability name              ║
  ║   Icon Label:      Small emoji inside bar on left — quick visual ID             ║
  ║   Number Label:    Time remaining or READY text, right-aligned on bar           ║
  ║   Corner Gems ×4:  Tiny circles at L/R centres + TL/TR corners                 ║
  ║                    Colour-matched to fill, appear/disappear with fill amount    ║
  ║                                                                                   ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║  CONFIGURABLE OPTIONS SUMMARY                                                    ║
  ╠═══════════════════════════════════════════════════════════════════════════════════╣
  ║                                                                                   ║
  ║  Player Bars tab   ── 34 sliders  +  26 toggles                                  ║
  ║  P. Colors tab     ── 18 pickers × 3 abilities  +  8 shared  =  62 pickers      ║
  ║  Enemy Bars tab    ── 36 sliders  +  24 toggles                                  ║
  ║  E. Colors tab     ── 14 pickers × 3 abilities  +  4 shared  =  46 pickers      ║
  ║  Effects tab       ── 5 sub-groups with 18 sliders + 6 toggles                  ║
  ║  Crystal FX tab    ── Crystal pulse + Noise animation + Rainbow mode             ║
  ║                                                                                   ║
  ║  Total UI controls: ~260 individual options                                      ║
  ║                                                                                   ║
  ╚═══════════════════════════════════════════════════════════════════════════════════╝

  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │  PERFORMANCE NOTES                                                               │
  ├─────────────────────────────────────────────────────────────────────────────────┤
  │  • All animation loops run in task.spawn coroutines — no frame stalls           │
  │  • Heartbeat update reads all option values once at start, not per-bar         │
  │  • Enemy billboards are only rebuilt on character spawn, not every frame        │
  │  • Distance fade math uses simple magnitude compare, no sqrt per-frame         │
  │  • Sparkle loops have randomised wait so they never fire simultaneously         │
  │  • Crystal pulse loops check CryPulse toggle each cycle before tweening        │
  │  • Rainbow hue increments in a single shared Heartbeat, not N loops            │
  │  • Fill lerp uses dt-scaled alpha — frame-rate independent smoothing           │
  └─────────────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │  COLOUR DESIGN RATIONALE                                                         │
  ├─────────────────────────────────────────────────────────────────────────────────┤
  │  DASH (electric blue theme)                                                      │
  │    Fill    #4894FF  ── saturated royal blue, clean and readable                 │
  │    Border  #3C7CFF  ── slightly darker, creates definition                      │
  │    Glow    #1452FF  ── deep electric blue for atmospheric lighting              │
  │    BG      #04071A  ── near-black with subtle blue tint                         │
  │                                                                                  │
  │  SIDE DASH (arcane gold theme)                                                   │
  │    Fill    #FFC030  ── warm amber-gold, high contrast on dark BG               │
  │    Border  #DAA210  ── slightly cooler gold keeps border distinct               │
  │    Glow    #C67E00  ── burnt amber for warm halo effect                         │
  │    BG      #140D02  ── near-black with warm undertone                           │
  │                                                                                  │
  │  EVASIVE (arcane violet theme)                                                   │
  │    Fill    #CA3AFF  ── vivid violet-magenta, immediately distinctive            │
  │    Border  #AC2ADE  ── slightly cooler hue for separation                       │
  │    Glow    #800CC6  ── deep purple for arcane atmospheric glow                  │
  │    BG      #0E031C  ── near-black with strong violet undertone                  │
  │                                                                                  │
  │  The gradient overlay uses:                                                      │
  │    Lavender  #DAC8FF  ── light purple shimmer highlight                         │
  │    Sky-blue  #B2DAFF  ── cool blue midpoint shimmer                             │
  │    Deep      #2014 6C  ── dark indigo fill shadow at bottom                    │
  │  This creates an iridescent / holographic effect that looks premium regardless  │
  │  of the base fill colour chosen by the user.                                     │
  └─────────────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │  DETECTION METHOD                                                                │
  ├─────────────────────────────────────────────────────────────────────────────────┤
  │                                                                                  │
  │  ① Animator.AnimationPlayed fires whenever the character begins a new animation  │
  │    The AnimationId is extracted, matched against known IDs                      │
  │                                                                                  │
  │  Front Dash IDs:  10479335397  ·  10491993682                                   │
  │  Side Dash IDs:   10480793962  ·  10480796021                                   │
  │                                                                                  │
  │  ② Evasive is detected via LiveFolder.DescendantAdded                           │
  │    When a "RagdollCancel" instance appears under a character, the evasive       │
  │    cooldown is triggered. Works for local player and all enemies.               │
  │                                                                                  │
  │  ③ Enemy setup runs on all current players at script load, plus                 │
  │    Players.PlayerAdded for new joins. Each enemy gets an independent            │
  │    CharacterAdded listener that rebuilds the billboard on respawn.              │
  │                                                                                  │
  │  ④ Players.PlayerRemoving cleans up the billboard and tracker table.            │
  │                                                                                  │
  └─────────────────────────────────────────────────────────────────────────────────┘
]]

-- Crystal Bars v6 — End of file — ✦ Premium ✦
