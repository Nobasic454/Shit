-- ╔══════════════════════════════════════════════════════════════════════════════════╗
-- ║   T S B   P R E M I U M   B A R S   ·   v 5 . 0   U L T R A                  ║
-- ║   ◈ Front Dash  ·  Side Dash  ·  Evasive                                       ║
-- ║   ◈ Player bars  +  Enemy overhead bars (identical stack)                       ║
-- ╚══════════════════════════════════════════════════════════════════════════════════╝
--[[
  LAYER ORDER per bar  (bottom → top):
    1.  Outer drop shadow
    2.  Depth rim  (thin offset 3-D stroke)
    3.  Outer halo glow
    4.  Inner glow
    5.  Ready aura ring
    6.  Reflection strip
    7.  Ability label
    8.  Bar background  + BG gradient  + UIStroke
    9.  Tick marks at 25 / 50 / 75 %
   10.  Warning overlay  (pulses red while CD < threshold)
   11.  Fill clip  (ClipsDescendants mask)
   12.  Fill bar  + iridescent gradient
   13.  Enchant sweep  (animated horizontal light glide)
   14.  Sparkle dots  (random blink)
   15.  Shine hairline  +  shine overlay
   16.  Edge highlight  (right-edge bright strip)
   17.  Corner gems  (left + right accent circles)
   18.  Number / time label
]]

-- ════════════════════════════════════════════════════════════════════════
-- §0  SERVICES
-- ════════════════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player     = Players.LocalPlayer
local LiveFolder = Workspace:WaitForChild("Live")

-- ════════════════════════════════════════════════════════════════════════
-- §1  OBSIDIAN LIBRARY
-- ════════════════════════════════════════════════════════════════════════
local repo    = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local Options  = Library.Options
local Toggles  = Library.Toggles

-- ════════════════════════════════════════════════════════════════════════
-- §2  GLOBAL PALETTE  +  FONT MAP
-- ════════════════════════════════════════════════════════════════════════
local C_BLACK    = Color3.fromRGB(  0,   0,   0)
local C_WHITE    = Color3.fromRGB(255, 255, 255)
local C_READY    = Color3.fromRGB(140, 255, 195)
local C_DANGER   = Color3.fromRGB(255,  55,  55)
local C_WARNING  = Color3.fromRGB(255, 175,  30)
local GP_LAV     = Color3.fromRGB(215, 198, 255)
local GP_SKY     = Color3.fromRGB(175, 215, 255)
local GP_DEEP    = Color3.fromRGB( 38,  26, 115)
local GP_BGPURP  = Color3.fromRGB(145, 125, 210)

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

-- ════════════════════════════════════════════════════════════════════════
-- §3  OBSIDIAN WINDOW
-- ════════════════════════════════════════════════════════════════════════
local Window = Library:CreateWindow({
    Title            = "TSB Premium Bars",
    Footer           = "v5 Ultra",
    ShowCustomCursor = true,
})
local Tabs = {
    Player  = Window:AddTab("Player Bars",  "box"),
    Colors  = Window:AddTab("Colors",       "palette"),
    Enemy   = Window:AddTab("Enemy Bars",   "user"),
    EColors = Window:AddTab("Enemy Colors", "palette"),
    Effects = Window:AddTab("Effects",      "star"),
}

-- ════════════════════════════════════════════════════════════════════════
-- §4  PLAYER BAR UI  —  Layout + Toggles
-- ════════════════════════════════════════════════════════════════════════
local PL = Tabs.Player:AddLeftGroupbox("Bar Geometry")
PL:AddSlider("PWidth",       {Text="Bar Width",          Default=175,  Min=60,  Max=340           })
PL:AddSlider("PHeight",      {Text="Bar Height",         Default=28,   Min=8,   Max=100           })
PL:AddSlider("PSpacing",     {Text="Bar Spacing",        Default=14,   Min=0,   Max=80            })
PL:AddSlider("PCorner",      {Text="Corner Radius",      Default=8,    Min=0,   Max=20            })
PL:AddSlider("PPosX",        {Text="Position X",         Default=0.5,  Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PPosY",        {Text="Position Y",         Default=0.85, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PBGTransp",    {Text="BG Opacity",         Default=0.18, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PFillTransp",  {Text="Fill Opacity",       Default=0,    Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PTextSize",    {Text="Number Size",        Default=14,   Min=6,   Max=40            })
PL:AddSlider("PLabelSize",   {Text="Label Size",         Default=10,   Min=6,   Max=28            })
PL:AddSlider("PLerpSpd",     {Text="Fill Lerp Speed",    Default=9,    Min=1,   Max=40            })
PL:AddSlider("PGlowSpread",  {Text="Glow Spread (px)",   Default=18,   Min=0,   Max=60            })
PL:AddSlider("PGlowAlpha",   {Text="Glow Alpha",         Default=0.80, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PShadowOff",   {Text="Shadow Offset",      Default=4,    Min=0,   Max=16            })
PL:AddSlider("PShadowAlpha", {Text="Shadow Alpha",       Default=0.62, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PGemSize",     {Text="Corner Gem Size",    Default=7,    Min=0,   Max=18            })
PL:AddSlider("PTickAlpha",   {Text="Tick Alpha",         Default=0.55, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PReflH",       {Text="Reflection Height",  Default=6,    Min=0,   Max=20            })
PL:AddSlider("PReflAlpha",   {Text="Reflection Alpha",   Default=0.72, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PStrokeThick", {Text="Border Thickness",   Default=1.5,  Min=0.5, Max=5, Rounding=1 })
PL:AddSlider("PEdgeAlpha",   {Text="Edge Highlight",     Default=0.50, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PShineAlpha",  {Text="Shine Opacity",      Default=0.82, Min=0,   Max=1, Rounding=2 })
PL:AddSlider("PSweepW",      {Text="Sweep Width (%)",    Default=40,   Min=10,  Max=80            })
PL:AddSlider("PSweepDur",    {Text="Sweep Duration (s)", Default=2.5,  Min=0.5, Max=8, Rounding=1 })
PL:AddSlider("PSweepGap",    {Text="Sweep Gap (s)",      Default=3.4,  Min=1,   Max=12,Rounding=1 })
PL:AddSlider("PSparkCount",  {Text="Sparkle Count",      Default=7,    Min=0,   Max=12            })
PL:AddSlider("PWarnThresh",  {Text="Warn Threshold (%)", Default=25,   Min=5,   Max=60            })
PL:AddSlider("PAuraSpread",  {Text="Aura Spread (px)",   Default=10,   Min=2,   Max=30            })
PL:AddDropdown("PFillDir",   {Values={"Left","Right"},   Default=1,    Text="Fill Direction"      })
PL:AddDropdown("PFont",      {Values=FONT_LIST,          Default=1,    Text="Bar Font"            })

local PT = Tabs.Player:AddRightGroupbox("Toggles")
PT:AddToggle("PShowBars",      {Text="Show Bars",              Default=true })
PT:AddToggle("PShowNumbers",   {Text="Show Numbers",           Default=true })
PT:AddToggle("PShowLabels",    {Text="Show Ability Labels",    Default=true })
PT:AddToggle("PShowReady",     {Text="Show READY Text",        Default=true })
PT:AddToggle("PShowPercent",   {Text="Percentage Mode",        Default=false})
PT:AddToggle("PShowBorder",    {Text="Border Stroke",          Default=true })
PT:AddToggle("PShowShine",     {Text="Shine + Shine Line",     Default=true })
PT:AddToggle("PShowGlow",      {Text="Glow Layers",            Default=true })
PT:AddToggle("PShowShadow",    {Text="Drop Shadow",            Default=true })
PT:AddToggle("PShowDepthRim",  {Text="Depth Rim",              Default=true })
PT:AddToggle("PShowGems",      {Text="Corner Gems",            Default=true })
PT:AddToggle("PShowTicks",     {Text="Tick Marks 25/50/75%",   Default=true })
PT:AddToggle("PShowReflect",   {Text="Reflection Strip",       Default=true })
PT:AddToggle("PShowEdge",      {Text="Edge Highlight",         Default=true })
PT:AddToggle("PShowSweep",     {Text="Enchant Sweep",          Default=true })
PT:AddToggle("PShowSparkles",  {Text="Sparkle Dots",           Default=true })
PT:AddToggle("PShowWarn",      {Text="Warning Overlay",        Default=true })
PT:AddToggle("PShowReadyAura", {Text="Ready Aura Ring",        Default=true })
PT:AddToggle("PColorByTime",   {Text="Dynamic Danger Tint",    Default=true })

-- ════════════════════════════════════════════════════════════════════════
-- §5  PLAYER COLORS
-- ════════════════════════════════════════════════════════════════════════
local function addAbilityColors(box, prefix)
    box:AddLabel("Fill Color"):AddColorPicker(prefix.."Fill",   {Default=Color3.fromRGB( 80,155,255)})
    box:AddLabel("Fill Danger"):AddColorPicker(prefix.."Dngr",  {Default=Color3.fromRGB(255, 70, 70)})
    box:AddLabel("Fill Warning"):AddColorPicker(prefix.."Warn", {Default=Color3.fromRGB(255,165, 30)})
    box:AddLabel("Number Color"):AddColorPicker(prefix.."Num",  {Default=Color3.fromRGB(210,235,255)})
    box:AddLabel("Background"):AddColorPicker(prefix.."BG",     {Default=Color3.fromRGB(  5,  8, 28)})
    box:AddLabel("Label Color"):AddColorPicker(prefix.."Lbl",   {Default=Color3.fromRGB(155,210,255)})
    box:AddLabel("Border Color"):AddColorPicker(prefix.."Bord", {Default=Color3.fromRGB( 65,130,255)})
    box:AddLabel("Glow Color"):AddColorPicker(prefix.."Glow",   {Default=Color3.fromRGB( 25, 90,255)})
    box:AddLabel("Shadow Color"):AddColorPicker(prefix.."Shad", {Default=Color3.fromRGB(  5, 18, 60)})
    box:AddLabel("Gem Color"):AddColorPicker(prefix.."Gem",     {Default=Color3.fromRGB(120,200,255)})
    box:AddLabel("Depth Rim"):AddColorPicker(prefix.."Rim",     {Default=Color3.fromRGB( 40, 80,180)})
    box:AddLabel("Ready Aura"):AddColorPicker(prefix.."Aura",   {Default=Color3.fromRGB(100,200,255)})
    box:AddLabel("Warn Overlay"):AddColorPicker(prefix.."WrnOv",{Default=Color3.fromRGB(255, 60, 60)})
end

local DC = Tabs.Colors:AddLeftGroupbox("◈ Dash (Front)")
addAbilityColors(DC, "PD")
-- Override defaults to electric-blue theme
Options["PDFill"].Value   = Color3.fromRGB( 80,155,255)
Options["PDDngr"].Value   = Color3.fromRGB(255, 70, 70)
Options["PDWarn"].Value   = Color3.fromRGB(255,165, 30)
Options["PDNum"].Value    = Color3.fromRGB(210,235,255)
Options["PDBG"].Value     = Color3.fromRGB(  5,  8, 28)
Options["PDLbl"].Value    = Color3.fromRGB(155,210,255)
Options["PDBord"].Value   = Color3.fromRGB( 65,130,255)
Options["PDGlow"].Value   = Color3.fromRGB( 25, 90,255)
Options["PDShad"].Value   = Color3.fromRGB(  5, 18, 60)
Options["PDGem"].Value    = Color3.fromRGB(120,200,255)
Options["PDRim"].Value    = Color3.fromRGB( 40, 80,180)
Options["PDAura"].Value   = Color3.fromRGB(100,200,255)
Options["PDWrnOv"].Value  = Color3.fromRGB(255, 60, 60)

local SC = Tabs.Colors:AddLeftGroupbox("◈ Side Dash")
SC:AddLabel("Fill Color"):AddColorPicker("PSFill",   {Default=Color3.fromRGB(255,195, 55)})
SC:AddLabel("Fill Danger"):AddColorPicker("PSDngr",  {Default=Color3.fromRGB(255, 60, 60)})
SC:AddLabel("Fill Warning"):AddColorPicker("PSWarn", {Default=Color3.fromRGB(255,140, 20)})
SC:AddLabel("Number Color"):AddColorPicker("PSNum",  {Default=Color3.fromRGB(255,245,195)})
SC:AddLabel("Background"):AddColorPicker("PSBG",     {Default=Color3.fromRGB( 22, 14,  3)})
SC:AddLabel("Label Color"):AddColorPicker("PSLbl",   {Default=Color3.fromRGB(255,215,100)})
SC:AddLabel("Border Color"):AddColorPicker("PSBord", {Default=Color3.fromRGB(225,165, 20)})
SC:AddLabel("Glow Color"):AddColorPicker("PSGlow",   {Default=Color3.fromRGB(200,130,  0)})
SC:AddLabel("Shadow Color"):AddColorPicker("PSShad", {Default=Color3.fromRGB( 50, 30,  0)})
SC:AddLabel("Gem Color"):AddColorPicker("PSGem",     {Default=Color3.fromRGB(255,225,110)})
SC:AddLabel("Depth Rim"):AddColorPicker("PSRim",     {Default=Color3.fromRGB(160,100, 10)})
SC:AddLabel("Ready Aura"):AddColorPicker("PSAura",   {Default=Color3.fromRGB(255,210, 80)})
SC:AddLabel("Warn Overlay"):AddColorPicker("PSWrnOv",{Default=Color3.fromRGB(255, 55, 55)})

local EC2 = Tabs.Colors:AddRightGroupbox("◈ Evasive")
EC2:AddLabel("Fill Color"):AddColorPicker("PEFill",   {Default=Color3.fromRGB(205, 65,255)})
EC2:AddLabel("Fill Danger"):AddColorPicker("PEDngr",  {Default=Color3.fromRGB(255, 45,120)})
EC2:AddLabel("Fill Warning"):AddColorPicker("PEWarn", {Default=Color3.fromRGB(255,120, 40)})
EC2:AddLabel("Number Color"):AddColorPicker("PENum",  {Default=Color3.fromRGB(235,200,255)})
EC2:AddLabel("Background"):AddColorPicker("PEBG",     {Default=Color3.fromRGB( 16,  4, 30)})
EC2:AddLabel("Label Color"):AddColorPicker("PELbl",   {Default=Color3.fromRGB(195,115,255)})
EC2:AddLabel("Border Color"):AddColorPicker("PEBord", {Default=Color3.fromRGB(175, 45,225)})
EC2:AddLabel("Glow Color"):AddColorPicker("PEGlow",   {Default=Color3.fromRGB(130, 15,200)})
EC2:AddLabel("Shadow Color"):AddColorPicker("PEShad", {Default=Color3.fromRGB( 36,  6, 60)})
EC2:AddLabel("Gem Color"):AddColorPicker("PEGem",     {Default=Color3.fromRGB(220,140,255)})
EC2:AddLabel("Depth Rim"):AddColorPicker("PERim",     {Default=Color3.fromRGB(110, 30,165)})
EC2:AddLabel("Ready Aura"):AddColorPicker("PEAura",   {Default=Color3.fromRGB(200, 90,255)})
EC2:AddLabel("Warn Overlay"):AddColorPicker("PEWrnOv",{Default=Color3.fromRGB(255, 45,100)})

local MiscC = Tabs.Colors:AddRightGroupbox("Shared")
MiscC:AddLabel("Ready Text"):AddColorPicker("PReadyClr",  {Default=Color3.fromRGB(140,255,195)})
MiscC:AddLabel("Flash Color"):AddColorPicker("PFlashClr", {Default=Color3.fromRGB(255,255,100)})
MiscC:AddLabel("Tick Color"):AddColorPicker("PTickClr",   {Default=Color3.fromRGB(255,255,255)})
MiscC:AddLabel("Sweep Color"):AddColorPicker("PSweepClr", {Default=Color3.fromRGB(255,255,255)})

-- ════════════════════════════════════════════════════════════════════════
-- §6  ENEMY BAR UI  —  Layout + Toggles
-- ════════════════════════════════════════════════════════════════════════
local EL = Tabs.Enemy:AddLeftGroupbox("Enemy Geometry")
EL:AddSlider("EWidth",       {Text="Bar Width",          Default=138,  Min=60,  Max=320           })
EL:AddSlider("EHeight",      {Text="Bar Height",         Default=20,   Min=6,   Max=60            })
EL:AddSlider("ESpacing",     {Text="Bar Spacing",        Default=7,    Min=0,   Max=30            })
EL:AddSlider("ECorner",      {Text="Corner Radius",      Default=5,    Min=0,   Max=16            })
EL:AddSlider("EStuds",       {Text="Studs Above Head",   Default=3.5,  Min=1,   Max=14,Rounding=1 })
EL:AddSlider("EBGTransp",    {Text="BG Opacity",         Default=0.22, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("ETextSize",    {Text="Number Size",        Default=11,   Min=6,   Max=28            })
EL:AddSlider("ELabelSize",   {Text="Label Size",         Default=9,    Min=6,   Max=22            })
EL:AddSlider("ELerpSpd",     {Text="Fill Lerp Speed",    Default=8,    Min=1,   Max=40            })
EL:AddSlider("EGlowSpread",  {Text="Glow Spread (px)",   Default=12,   Min=0,   Max=40            })
EL:AddSlider("EGlowAlpha",   {Text="Glow Alpha",         Default=0.80, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("EGemSize",     {Text="Corner Gem Size",    Default=5,    Min=0,   Max=14            })
EL:AddSlider("ETickAlpha",   {Text="Tick Alpha",         Default=0.50, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("EReflH",       {Text="Reflection Height",  Default=5,    Min=0,   Max=16            })
EL:AddSlider("EReflAlpha",   {Text="Reflection Alpha",   Default=0.76, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("EStrokeThick", {Text="Border Thickness",   Default=1.2,  Min=0.5, Max=4, Rounding=1 })
EL:AddSlider("EEdgeAlpha",   {Text="Edge Highlight",     Default=0.48, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("EShineAlpha",  {Text="Shine Opacity",      Default=0.84, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("ESweepW",      {Text="Sweep Width (%)",    Default=38,   Min=10,  Max=80            })
EL:AddSlider("ESweepDur",    {Text="Sweep Duration (s)", Default=2.2,  Min=0.5, Max=8, Rounding=1 })
EL:AddSlider("ESweepGap",    {Text="Sweep Gap (s)",      Default=3.0,  Min=1,   Max=12,Rounding=1 })
EL:AddSlider("ESparkCount",  {Text="Sparkle Count",      Default=5,    Min=0,   Max=10            })
EL:AddSlider("EWarnThresh",  {Text="Warn Threshold (%)", Default=25,   Min=5,   Max=60            })
EL:AddSlider("EStrokeOp",    {Text="Text Stroke Alpha",  Default=0.30, Min=0,   Max=1, Rounding=2 })
EL:AddSlider("EMaxDist",     {Text="Max Visible Studs",  Default=100,  Min=10,  Max=400           })
EL:AddDropdown("EFillDir",   {Values={"Left","Right"},   Default=1,    Text="Fill Direction"      })
EL:AddDropdown("EFont",      {Values=FONT_LIST,          Default=1,    Text="Enemy Font"          })

local ET = Tabs.Enemy:AddRightGroupbox("Enemy Toggles")
ET:AddToggle("EShowBars",      {Text="Show Enemy Bars",        Default=true })
ET:AddToggle("EOnlyCd",        {Text="Only Show On Cooldown",  Default=true })
ET:AddToggle("EAlTop",         {Text="Always On Top",          Default=false})
ET:AddToggle("EShowFill",      {Text="Show Fill Bar",          Default=true })
ET:AddToggle("EShowNum",       {Text="Show Numbers",           Default=true })
ET:AddToggle("EShowLbl",       {Text="Show Labels",            Default=true })
ET:AddToggle("EShowBorder",    {Text="Border Stroke",          Default=true })
ET:AddToggle("EShowShine",     {Text="Shine + Shine Line",     Default=true })
ET:AddToggle("EShowGlow",      {Text="Glow Layers",            Default=true })
ET:AddToggle("EShowGems",      {Text="Corner Gems",            Default=true })
ET:AddToggle("EShowTicks",     {Text="Tick Marks",             Default=true })
ET:AddToggle("EShowReflect",   {Text="Reflection Strip",       Default=true })
ET:AddToggle("EShowEdge",      {Text="Edge Highlight",         Default=true })
ET:AddToggle("EShowSweep",     {Text="Enchant Sweep",          Default=true })
ET:AddToggle("EShowSparkles",  {Text="Sparkle Dots",           Default=true })
ET:AddToggle("EShowWarn",      {Text="Warning Overlay",        Default=true })
ET:AddToggle("EShowReadyAura", {Text="Ready Aura Ring",        Default=true })
ET:AddToggle("EDistFade",      {Text="Distance Fade",          Default=true })

-- ════════════════════════════════════════════════════════════════════════
-- §7  ENEMY COLORS
-- ════════════════════════════════════════════════════════════════════════
local EDC = Tabs.EColors:AddLeftGroupbox("◈ Enemy Dash")
EDC:AddLabel("Fill Color"):AddColorPicker("EDFill",   {Default=Color3.fromRGB( 80,180,255)})
EDC:AddLabel("Fill Danger"):AddColorPicker("EDDngr",  {Default=Color3.fromRGB(255, 65, 65)})
EDC:AddLabel("Fill Warning"):AddColorPicker("EDWarn", {Default=Color3.fromRGB(255,160, 30)})
EDC:AddLabel("Number Color"):AddColorPicker("EDNum",  {Default=Color3.fromRGB(200,230,255)})
EDC:AddLabel("Background"):AddColorPicker("EDBG",     {Default=Color3.fromRGB(  4, 10, 30)})
EDC:AddLabel("Label Color"):AddColorPicker("EDLbl",   {Default=Color3.fromRGB(130,200,255)})
EDC:AddLabel("Border Color"):AddColorPicker("EDBord", {Default=Color3.fromRGB( 50,120,255)})
EDC:AddLabel("Glow Color"):AddColorPicker("EDGlow",   {Default=Color3.fromRGB( 20, 80,255)})
EDC:AddLabel("Gem Color"):AddColorPicker("EDGem",     {Default=Color3.fromRGB(110,190,255)})
EDC:AddLabel("Depth Rim"):AddColorPicker("EDRim",     {Default=Color3.fromRGB( 35, 75,175)})
EDC:AddLabel("Ready Aura"):AddColorPicker("EDAura",   {Default=Color3.fromRGB( 90,200,255)})
EDC:AddLabel("Warn Overlay"):AddColorPicker("EDWrnOv",{Default=Color3.fromRGB(255, 55, 55)})

local ESC2 = Tabs.EColors:AddLeftGroupbox("◈ Enemy Side")
ESC2:AddLabel("Fill Color"):AddColorPicker("ESFill",   {Default=Color3.fromRGB(255,200, 60)})
ESC2:AddLabel("Fill Danger"):AddColorPicker("ESDngr",  {Default=Color3.fromRGB(255, 55, 55)})
ESC2:AddLabel("Fill Warning"):AddColorPicker("ESWarn", {Default=Color3.fromRGB(255,140, 20)})
ESC2:AddLabel("Number Color"):AddColorPicker("ESNum",  {Default=Color3.fromRGB(255,240,180)})
ESC2:AddLabel("Background"):AddColorPicker("ESBG",     {Default=Color3.fromRGB( 20, 14,  4)})
ESC2:AddLabel("Label Color"):AddColorPicker("ESLbl",   {Default=Color3.fromRGB(255,210, 90)})
ESC2:AddLabel("Border Color"):AddColorPicker("ESBord", {Default=Color3.fromRGB(220,160, 20)})
ESC2:AddLabel("Glow Color"):AddColorPicker("ESGlow",   {Default=Color3.fromRGB(200,130,  0)})
ESC2:AddLabel("Gem Color"):AddColorPicker("ESGem",     {Default=Color3.fromRGB(255,220,100)})
ESC2:AddLabel("Depth Rim"):AddColorPicker("ESRim",     {Default=Color3.fromRGB(155, 95, 10)})
ESC2:AddLabel("Ready Aura"):AddColorPicker("ESAura",   {Default=Color3.fromRGB(255,205, 75)})
ESC2:AddLabel("Warn Overlay"):AddColorPicker("ESWrnOv",{Default=Color3.fromRGB(255, 50, 50)})

local EEC2 = Tabs.EColors:AddRightGroupbox("◈ Enemy Evasive")
EEC2:AddLabel("Fill Color"):AddColorPicker("EEFill",   {Default=Color3.fromRGB(200, 60,255)})
EEC2:AddLabel("Fill Danger"):AddColorPicker("EEDngr",  {Default=Color3.fromRGB(255, 40,120)})
EEC2:AddLabel("Fill Warning"):AddColorPicker("EEWarn", {Default=Color3.fromRGB(255,115, 40)})
EEC2:AddLabel("Number Color"):AddColorPicker("EENum",  {Default=Color3.fromRGB(230,190,255)})
EEC2:AddLabel("Background"):AddColorPicker("EEBG",     {Default=Color3.fromRGB( 14,  4, 28)})
EEC2:AddLabel("Label Color"):AddColorPicker("EELbl",   {Default=Color3.fromRGB(185,100,255)})
EEC2:AddLabel("Border Color"):AddColorPicker("EEBord", {Default=Color3.fromRGB(160, 40,220)})
EEC2:AddLabel("Glow Color"):AddColorPicker("EEGlow",   {Default=Color3.fromRGB(125, 12,200)})
EEC2:AddLabel("Gem Color"):AddColorPicker("EEGem",     {Default=Color3.fromRGB(215,135,255)})
EEC2:AddLabel("Depth Rim"):AddColorPicker("EERim",     {Default=Color3.fromRGB(105, 28,160)})
EEC2:AddLabel("Ready Aura"):AddColorPicker("EEAura",   {Default=Color3.fromRGB(195, 85,255)})
EEC2:AddLabel("Warn Overlay"):AddColorPicker("EEWrnOv",{Default=Color3.fromRGB(255, 40,100)})

local ESharedC = Tabs.EColors:AddRightGroupbox("Enemy Shared")
ESharedC:AddLabel("Ready Text"):AddColorPicker("EReadyClr",  {Default=Color3.fromRGB(140,255,195)})
ESharedC:AddLabel("Tick Color"):AddColorPicker("ETickClr",   {Default=Color3.fromRGB(255,255,255)})
ESharedC:AddLabel("Sweep Color"):AddColorPicker("ESweepClr", {Default=Color3.fromRGB(255,255,255)})

-- ════════════════════════════════════════════════════════════════════════
-- §8  EFFECTS TAB
-- ════════════════════════════════════════════════════════════════════════
local FXP = Tabs.Effects:AddLeftGroupbox("Trigger Pulse")
FXP:AddToggle("FXPulseOn",  {Text="Enable Pulse",     Default=true })
FXP:AddSlider("FXPulseDur", {Text="Duration (s)",     Default=0.38, Min=0.05, Max=2.0, Rounding=2})
FXP:AddSlider("FXPulseScX", {Text="Scale X",          Default=1.06, Min=1.01, Max=1.30, Rounding=2})
FXP:AddSlider("FXPulseScY", {Text="Scale Y",          Default=1.10, Min=1.01, Max=1.40, Rounding=2})

local FXF = Tabs.Effects:AddLeftGroupbox("Ready Flash")
FXF:AddToggle("FXFlashOn",  {Text="Enable Flash",     Default=true})
FXF:AddSlider("FXFlashCnt", {Text="Flash Count",      Default=3, Min=1, Max=10})
FXF:AddSlider("FXFlashSpd", {Text="Speed (s)",        Default=0.13, Min=0.04, Max=0.5, Rounding=2})

local FXB = Tabs.Effects:AddLeftGroupbox("Ready Breath")
FXB:AddToggle("FXBreathOn",  {Text="Enable Breathing",  Default=true})
FXB:AddSlider("FXBreathSpd", {Text="Speed (s)",         Default=1.0, Min=0.2, Max=5.0, Rounding=1})
FXB:AddSlider("FXBreathDim", {Text="Dim Alpha",         Default=0.56, Min=0, Max=1.0, Rounding=2})
FXB:AddSlider("FXBreathBrt", {Text="Bright Alpha",      Default=0.02, Min=0, Max=0.9, Rounding=2})

local FXW = Tabs.Effects:AddRightGroupbox("Warning Pulse")
FXW:AddToggle("FXWarnPulse", {Text="Warn Overlay Pulse", Default=true})
FXW:AddSlider("FXWarnSpd",   {Text="Speed (s)",          Default=0.55, Min=0.1, Max=2.0, Rounding=2})
FXW:AddSlider("FXWarnAlphaA",{Text="Max Alpha",          Default=0.30, Min=0, Max=0.8, Rounding=2})
FXW:AddSlider("FXWarnAlphaB",{Text="Min Alpha",          Default=0.0,  Min=0, Max=0.5, Rounding=2})

local FXA = Tabs.Effects:AddRightGroupbox("Ready Aura Pulse")
FXA:AddToggle("FXAuraPulse", {Text="Aura Pulse",         Default=true})
FXA:AddSlider("FXAuraSpd",   {Text="Speed (s)",          Default=0.85, Min=0.2, Max=3.0, Rounding=2})
FXA:AddSlider("FXAuraAlphaA",{Text="Max Alpha",          Default=0.42, Min=0, Max=0.9, Rounding=2})
FXA:AddSlider("FXAuraAlphaB",{Text="Min Alpha",          Default=0.75, Min=0, Max=1.0, Rounding=2})

-- ════════════════════════════════════════════════════════════════════════
-- §9  SCREEN GUI ROOT
-- ════════════════════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TSBPremiumBars"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 20
screenGui.Parent         = player:WaitForChild("PlayerGui")

-- ════════════════════════════════════════════════════════════════════════
-- §10  ABILITY CONFIGS
-- ════════════════════════════════════════════════════════════════════════
-- player ability config  (colour key prefix → matches §5 pickers)
local PCFG = {
    Dash = {
        label="◈  FRONT DASH", defaultCD=5,
        fk="PDFill", dk="PDDngr", wk="PDWarn", nk="PDNum", bgk="PDBG",
        lk="PDLbl",  bk="PDBord", gk="PDGlow", sk="PDShad",
        gmk="PDGem", rmk="PDRim", ak="PDAura", wok="PDWrnOv", order=1,
    },
    Side = {
        label="◈  SIDE DASH", defaultCD=2,
        fk="PSFill", dk="PSDngr", wk="PSWarn", nk="PSNum", bgk="PSBG",
        lk="PSLbl",  bk="PSBord", gk="PSGlow", sk="PSShad",
        gmk="PSGem", rmk="PSRim", ak="PSAura", wok="PSWrnOv", order=2,
    },
    Evasive = {
        label="◈  EVASIVE", defaultCD=30,
        fk="PEFill", dk="PEDngr", wk="PEWarn", nk="PENum", bgk="PEBG",
        lk="PELbl",  bk="PEBord", gk="PEGlow", sk="PEShad",
        gmk="PEGem", rmk="PERim", ak="PEAura", wok="PEWrnOv", order=3,
    },
}
local PORDER = {"Dash","Side","Evasive"}

-- enemy ability config
local ECFG = {
    Dash = {
        label="FRONT DASH", sym="◈", defaultCD=5,
        fk="EDFill", dk="EDDngr", wk="EDWarn", nk="EDNum", bgk="EDBG",
        lk="EDLbl",  bk="EDBord", gk="EDGlow",
        gmk="EDGem", rmk="EDRim", ak="EDAura", wok="EDWrnOv", order=1,
    },
    Side = {
        label="SIDE DASH", sym="◈", defaultCD=2,
        fk="ESFill", dk="ESDngr", wk="ESWarn", nk="ESNum", bgk="ESBG",
        lk="ESLbl",  bk="ESBord", gk="ESGlow",
        gmk="ESGem", rmk="ESRim", ak="ESAura", wok="ESWrnOv", order=2,
    },
    Evasive = {
        label="EVASIVE", sym="◈", defaultCD=30,
        fk="EEFill", dk="EEDngr", wk="EEWarn", nk="EENum", bgk="EEBG",
        lk="EELbl",  bk="EEBord", gk="EEGlow",
        gmk="EEGem", rmk="EERim", ak="EEAura", wok="EEWrnOv", order=3,
    },
}
local EORDER = {"Dash","Side","Evasive"}

-- ════════════════════════════════════════════════════════════════════════
-- §11  COLOUR UTILITY
-- ════════════════════════════════════════════════════════════════════════
local function blendColor(a, b, t)
    t = math.clamp(t, 0, 1)
    return Color3.new(
        a.R + (b.R - a.R)*t,
        a.G + (b.G - a.G)*t,
        a.B + (b.B - a.B)*t)
end

-- cdPct = fraction of cooldown elapsed (0=fresh  1=almost expired)
local function dynColor(cdPct, fClr, wClr, dClr, use)
    if not use then return fClr end
    if cdPct < 0.40 then return fClr end
    if cdPct < 0.65 then
        return blendColor(fClr, wClr, ((cdPct-0.40)/0.25)*0.60)
    end
    return blendColor(wClr, dClr, math.min((cdPct-0.65)/0.35, 0.85))
end

local function opt(k) -- safe Options get
    return Options[k] and Options[k].Value
end
local function tog(k) -- safe Toggles get
    return Toggles[k] and Toggles[k].Value
end

-- ════════════════════════════════════════════════════════════════════════
-- §12  BAR BUILDER HELPERS  (shared by player + enemy)
-- ════════════════════════════════════════════════════════════════════════

local function mkCorner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

-- Drop shadow
local function mkShadow(parent)
    local s = Instance.new("Frame")
    s.Name="DropShadow"; s.BackgroundColor3=C_BLACK
    s.BackgroundTransparency=0.65; s.BorderSizePixel=0; s.ZIndex=1
    s.Parent=parent
    mkCorner(s, 12)
    local g=Instance.new("UIGradient",s); g.Rotation=90
    g.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.42),
        NumberSequenceKeypoint.new(.5,0.60),
        NumberSequenceKeypoint.new(1, 0.82),
    })
    return s
end

-- Depth rim
local function mkDepthRim(parent, zidx)
    local r=Instance.new("Frame")
    r.Name="DepthRim"; r.BackgroundTransparency=1
    r.BorderSizePixel=0; r.ZIndex=zidx or 2; r.Parent=parent
    mkCorner(r, 10)
    local st=Instance.new("UIStroke",r)
    st.Thickness=1; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    st.Transparency=0.45
    return r, st
end

-- Outer halo glow
local function mkOuterGlow(parent)
    local g=Instance.new("Frame")
    g.Name="OuterGlow"; g.BackgroundTransparency=0.85
    g.BorderSizePixel=0; g.ZIndex=1; g.Parent=parent
    mkCorner(g, 24)
    local gr=Instance.new("UIGradient",g); gr.Rotation=90
    gr.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,  0.68),
        NumberSequenceKeypoint.new(.5, 0.82),
        NumberSequenceKeypoint.new(1,  0.96),
    })
    return g
end

-- Inner glow
local function mkInnerGlow(parent)
    local g=Instance.new("Frame")
    g.Name="InnerGlow"; g.BackgroundTransparency=0.72
    g.BorderSizePixel=0; g.ZIndex=2; g.Parent=parent
    mkCorner(g, 15)
    local gr=Instance.new("UIGradient",g); gr.Rotation=90
    gr.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.60),
        NumberSequenceKeypoint.new(1, 0.80),
    })
    return g
end

-- Ready aura frame + stroke
local function mkReadyAura(parent, r)
    local a=Instance.new("Frame")
    a.Name="ReadyAura"; a.BackgroundTransparency=1
    a.BorderSizePixel=0; a.ZIndex=1; a.Parent=parent
    mkCorner(a, r or 28)
    local st=Instance.new("UIStroke",a)
    st.Thickness=2; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    st.Transparency=1
    return a, st
end

-- Reflection strip
local function mkReflection(parent)
    local r=Instance.new("Frame")
    r.Name="Reflection"; r.BackgroundColor3=C_WHITE
    r.BackgroundTransparency=0.88; r.BorderSizePixel=0; r.ZIndex=2
    r.Parent=parent
    mkCorner(r, 4)
    local g=Instance.new("UIGradient",r); g.Rotation=90
    g.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,  0.70),
        NumberSequenceKeypoint.new(.6, 0.88),
        NumberSequenceKeypoint.new(1,  1.00),
    })
    return r
end

-- Bar background + BG gradient + border stroke
local function mkBarFrame(parent, zidx)
    local f=Instance.new("Frame")
    f.Name="BarFrame"; f.BorderSizePixel=0
    f.ZIndex=zidx or 3; f.ClipsDescendants=false; f.Parent=parent
    local co=mkCorner(f, 8)
    local bg=Instance.new("UIGradient")
    bg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C_WHITE),
        ColorSequenceKeypoint.new(0.45,GP_BGPURP),
        ColorSequenceKeypoint.new(1,   C_BLACK),
    })
    bg.Rotation=90
    bg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.78),
        NumberSequenceKeypoint.new(1, 0.52),
    })
    bg.Parent=f
    local st=Instance.new("UIStroke",f)
    st.Thickness=1.5; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    st.Transparency=0.12
    return f, co, st
end

-- Fill clip + fill bar + fill gradient
local function mkFillSystem(parent, zidx)
    local clip=Instance.new("Frame")
    clip.Name="FillClip"; clip.BackgroundTransparency=1
    clip.BorderSizePixel=0; clip.ClipsDescendants=true
    clip.ZIndex=zidx or 4
    clip.Size=UDim2.new(1,0,1,0); clip.Position=UDim2.new(0,0,0,0)
    clip.Parent=parent

    local fill=Instance.new("Frame")
    fill.Name="Fill"; fill.BorderSizePixel=0
    fill.ZIndex=zidx or 4; fill.ClipsDescendants=true
    fill.Parent=clip
    local fc=mkCorner(fill, 8)

    local fg=Instance.new("UIGradient")
    fg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C_WHITE),
        ColorSequenceKeypoint.new(0.30,GP_LAV),
        ColorSequenceKeypoint.new(0.60,GP_SKY),
        ColorSequenceKeypoint.new(1,   GP_DEEP),
    })
    fg.Rotation=90
    fg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.42),
        NumberSequenceKeypoint.new(0.38,0.58),
        NumberSequenceKeypoint.new(1,   0.10),
    })
    fg.Parent=fill
    return clip, fill, fc
end

-- Enchant sweep strip (parent = fill bar)
local function mkSweep(fill)
    local sw=Instance.new("Frame")
    sw.Name="Sweep"; sw.Size=UDim2.new(0.40,0,1.20,0)
    sw.AnchorPoint=Vector2.new(0.5,0)
    sw.Position=UDim2.new(-0.45,0,-0.10,0)
    sw.BackgroundColor3=C_WHITE; sw.BackgroundTransparency=0
    sw.BorderSizePixel=0; sw.ZIndex=6; sw.Parent=fill
    local sg=Instance.new("UIGradient"); sg.Rotation=0
    sg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,   1.00),
        NumberSequenceKeypoint.new(0.25,0.65),
        NumberSequenceKeypoint.new(0.50,0.48),
        NumberSequenceKeypoint.new(0.75,0.65),
        NumberSequenceKeypoint.new(1,   1.00),
    })
    sg.Parent=sw
    return sw
end

-- Shine hairline + shine overlay
local function mkShine(fill)
    local ln=Instance.new("Frame")
    ln.Name="ShineLine"; ln.Size=UDim2.new(0.82,0,0,2)
    ln.Position=UDim2.new(0.09,0,0,2)
    ln.BackgroundColor3=C_WHITE; ln.BackgroundTransparency=0.34
    ln.BorderSizePixel=0; ln.ZIndex=7; ln.Parent=fill
    mkCorner(ln,2)
    local ov=Instance.new("Frame")
    ov.Name="ShineOver"; ov.Size=UDim2.new(1,0,0.50,0)
    ov.Position=UDim2.new(0,0,0,0)
    ov.BackgroundColor3=C_WHITE; ov.BackgroundTransparency=0.82
    ov.BorderSizePixel=0; ov.ZIndex=5; ov.Parent=fill
    mkCorner(ov)
    return ln, ov
end

-- Edge highlight strip
local function mkEdge(fill)
    local e=Instance.new("Frame")
    e.Name="EdgeHL"; e.Size=UDim2.new(0,3,1,0)
    e.AnchorPoint=Vector2.new(1,0); e.Position=UDim2.new(1,0,0,0)
    e.BackgroundColor3=C_WHITE; e.BackgroundTransparency=0.50
    e.BorderSizePixel=0; e.ZIndex=8; e.Parent=fill
    local eg=Instance.new("UIGradient",e); eg.Rotation=90
    eg.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.30),
        NumberSequenceKeypoint.new(1, 0.80),
    })
    return e
end

-- Sparkle dots  (count dots spread across the fill)
local function mkSparkles(fill, count)
    local t={}
    count=math.clamp(count or 7, 0, 12)
    for i=1,count do
        local xp=(i-0.5)/count
        local sp=Instance.new("Frame")
        sp.Size=UDim2.new(0,3,0,3); sp.AnchorPoint=Vector2.new(0.5,0.5)
        sp.Position=UDim2.new(xp,0,0.50,0)
        sp.BackgroundColor3=C_WHITE; sp.BackgroundTransparency=1
        sp.BorderSizePixel=0; sp.ZIndex=9; sp.Parent=fill
        mkCorner(sp, 99)
        t[i]=sp
    end
    return t
end

-- Tick marks at 25 / 50 / 75 %
local function mkTicks(frame)
    local t={}
    for _,xp in ipairs({0.25,0.50,0.75}) do
        local tk=Instance.new("Frame")
        tk.Size=UDim2.new(0,1,0.60,0); tk.AnchorPoint=Vector2.new(0.5,0.5)
        tk.Position=UDim2.new(xp,0,0.5,0)
        tk.BackgroundColor3=C_WHITE; tk.BackgroundTransparency=0.55
        tk.BorderSizePixel=0; tk.ZIndex=8; tk.Parent=frame
        table.insert(t, tk)
    end
    return t
end

-- Warning overlay
local function mkWarnOverlay(frame, r)
    local w=Instance.new("Frame")
    w.Name="WarnOv"; w.Size=UDim2.new(1,0,1,0); w.Position=UDim2.new(0,0,0,0)
    w.BackgroundColor3=C_DANGER; w.BackgroundTransparency=1
    w.BorderSizePixel=0; w.ZIndex=7; w.Parent=frame
    mkCorner(w, r or 8)
    return w
end

-- Corner gem (accent circle)
local function mkGem(parent, isRight)
    local g=Instance.new("Frame")
    g.Name=isRight and "GemRight" or "GemLeft"
    g.AnchorPoint=Vector2.new(0.5,0.5)
    g.BackgroundColor3=C_WHITE; g.BackgroundTransparency=0.18
    g.BorderSizePixel=0; g.ZIndex=10; g.Parent=parent
    mkCorner(g, 99)
    return g
end

-- Ability label (above bar)
local function mkLabel(parent, text, zidx)
    local l=Instance.new("TextLabel")
    l.Name="AbilLabel"; l.BackgroundTransparency=1; l.BorderSizePixel=0
    l.Text=text; l.Font=Enum.Font.GothamBold; l.TextScaled=false
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Bottom
    l.TextStrokeTransparency=0.25; l.TextStrokeColor3=C_BLACK
    l.ZIndex=zidx or 5; l.Parent=parent
    return l
end

-- Number / time label
local function mkNumLabel(parent)
    local n=Instance.new("TextLabel")
    n.Name="NumLabel"; n.BackgroundTransparency=1
    n.Size=UDim2.new(1,-14,1,0); n.Position=UDim2.new(0,7,0,0)
    n.Font=Enum.Font.GothamBold; n.TextScaled=false
    n.TextXAlignment=Enum.TextXAlignment.Right
    n.TextYAlignment=Enum.TextYAlignment.Center
    n.TextStrokeTransparency=0.22; n.TextStrokeColor3=C_BLACK
    n.ZIndex=11; n.Parent=parent
    return n
end

-- ════════════════════════════════════════════════════════════════════════
-- §13  SWEEP ANIMATION LOOPS
-- ════════════════════════════════════════════════════════════════════════
local function loopSweep(sw, delay, isEnemy)
    task.spawn(function()
        if delay and delay>0 then task.wait(delay) end
        while sw and sw.Parent do
            local swWK  = isEnemy and "ESweepW"   or "PSweepW"
            local swDK  = isEnemy and "ESweepDur" or "PSweepDur"
            local swGK  = isEnemy and "ESweepGap" or "PSweepGap"
            local swTK  = isEnemy and "ESweepClr" or "PSweepClr"
            local swEnK = isEnemy and "EShowSweep" or "PShowSweep"
            local swW = (opt(swWK) or (isEnemy and 38 or 40)) / 100
            local swD = (opt(swDK) or (isEnemy and 2.2 or 2.5)) * (isEnemy and 0.80 or 1)
            local swG = (opt(swGK) or (isEnemy and 3.0 or 3.4)) * (isEnemy and 0.80 or 1)
            pcall(function()
                sw.Size     = UDim2.new(swW,0,1.20,0)
                sw.Position = UDim2.new(-(swW+0.05),0,-0.10,0)
                sw.BackgroundColor3 = opt(swTK) or C_WHITE
            end)
            if tog(swEnK) then
                local tw=TweenService:Create(sw,
                    TweenInfo.new(swD,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),
                    {Position=UDim2.new(1.15,0,-0.10,0)})
                tw:Play()
                task.wait(swG)
            else
                task.wait(1)
            end
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §14  SPARKLE ANIMATION LOOPS
-- ════════════════════════════════════════════════════════════════════════
local function loopSparkle(sp, delay, isEnemy)
    task.spawn(function()
        if delay and delay>0 then task.wait(delay) end
        local lo=isEnemy and 12 or 8
        local hi=isEnemy and 40 or 30
        while sp and sp.Parent do
            task.wait(math.random(lo,hi)*0.1)
            if not(sp and sp.Parent) then break end
            sp.BackgroundTransparency=0.05
            task.wait(0.055)
            sp.BackgroundTransparency=0.42
            task.wait(0.055)
            sp.BackgroundTransparency=0.05
            TweenService:Create(sp,
                TweenInfo.new(0.70,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {BackgroundTransparency=1}):Play()
        end
    end)
end

local function loopAllSparkles(sps, base, isEnemy)
    for i,sp in ipairs(sps) do
        loopSparkle(sp, (i-1)*0.44+(base or 0), isEnemy)
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §15  PLAYER BAR CONSTRUCTION  (full layer stack per ability)
-- ════════════════════════════════════════════════════════════════════════
local pBars = {}

local function buildPlayerBar(name, idx)
    local cfg=PCFG[name]

    local container=Instance.new("Frame")
    container.Name=name.."_Root"; container.BackgroundTransparency=1
    container.BorderSizePixel=0; container.ZIndex=2; container.Parent=screenGui

    local shadow    = mkShadow(container)
    local dRim, dRimSt = mkDepthRim(container, 2)
    local outerGlow = mkOuterGlow(container)
    local innerGlow = mkInnerGlow(container)
    local rAura, rAuraSt = mkReadyAura(container, 28)
    local reflect   = mkReflection(container)
    local ablLabel  = mkLabel(container, cfg.label, 5)
    local barFrame, barCo, barSt = mkBarFrame(container, 3)
    local ticks     = mkTicks(barFrame)
    local warnOv    = mkWarnOverlay(barFrame, 8)
    local fillClip, fill, fillCo = mkFillSystem(barFrame, 4)
    local sweep     = mkSweep(fill)
    loopSweep(sweep, (idx-1)*0.85, false)
    local sparkles  = mkSparkles(fill, opt("PSparkCount") or 7)
    loopAllSparkles(sparkles, (idx-1)*0.18, false)
    local shineLn, shineOv = mkShine(fill)
    local edgeHL    = mkEdge(fill)
    local gemL      = mkGem(barFrame, false)
    local gemR      = mkGem(barFrame, true)
    local numLabel  = mkNumLabel(barFrame)

    pBars[name] = {
        container=container, shadow=shadow,
        dRim=dRim, dRimSt=dRimSt,
        outerGlow=outerGlow, innerGlow=innerGlow,
        rAura=rAura, rAuraSt=rAuraSt,
        reflect=reflect, ablLabel=ablLabel,
        barFrame=barFrame, barCo=barCo, barSt=barSt,
        ticks=ticks, warnOv=warnOv,
        fillClip=fillClip, fill=fill, fillCo=fillCo,
        sweep=sweep, sparkles=sparkles,
        shineLn=shineLn, shineOv=shineOv,
        edgeHL=edgeHL, gemL=gemL, gemR=gemR,
        numLabel=numLabel,
        -- state
        time=0, duration=cfg.defaultCD, visRatio=0,
        prevOnCd=false, pulseActive=false,
        readyFlashing=false, breathActive=false,
        warnPulseActive=false, auraPulseActive=false,
    }
end

for i,n in ipairs(PORDER) do buildPlayerBar(n, i) end

-- ════════════════════════════════════════════════════════════════════════
-- §16  PLAYER EFFECT FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════

-- Trigger pulse
local function doPulse(bd)
    if not tog("FXPulseOn") then return end
    if bd.pulseActive then return end
    bd.pulseActive=true
    local f=bd.barFrame
    local half=(opt("FXPulseDur") or 0.38)*0.5
    local scX=opt("FXPulseScX") or 1.06
    local scY=opt("FXPulseScY") or 1.10
    local orig=f.Size
    local big=UDim2.new(
        orig.X.Scale*scX, orig.X.Offset*scX,
        orig.Y.Scale*scY, orig.Y.Offset*scY)
    TweenService:Create(f,TweenInfo.new(half,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=big}):Play()
    task.delay(half, function()
        TweenService:Create(f,TweenInfo.new(half,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=orig}):Play()
        task.delay(half+0.06, function() bd.pulseActive=false end)
    end)
end

-- Ready flash
local function doFlash(bd, fillClr)
    if not tog("FXFlashOn") then return end
    if bd.readyFlashing then return end
    bd.readyFlashing=true
    local fill=bd.fill
    local flash=opt("PFlashClr") or Color3.fromRGB(255,255,100)
    local orig=fillClr or fill.BackgroundColor3
    local cnt=opt("FXFlashCnt") or 3
    local spd=opt("FXFlashSpd") or 0.13
    local function step(n)
        if n<=0 then
            pcall(function() fill.BackgroundColor3=orig end)
            bd.readyFlashing=false; return
        end
        TweenService:Create(fill,TweenInfo.new(spd,Enum.EasingStyle.Linear),{BackgroundColor3=flash}):Play()
        task.delay(spd, function()
            TweenService:Create(fill,TweenInfo.new(spd,Enum.EasingStyle.Linear),{BackgroundColor3=orig}):Play()
            task.delay(spd, function() step(n-1) end)
        end)
    end
    task.spawn(step, cnt)
end

-- Ready breath
local function doBreath(bd)
    if bd.breathActive then return end
    bd.breathActive=true
    local function cycle()
        if not bd.breathActive then return end
        if not tog("FXBreathOn") then task.wait(0.5); if bd.breathActive then task.spawn(cycle) end; return end
        local spd=opt("FXBreathSpd") or 1.0
        local dim=opt("FXBreathDim") or 0.56
        local brt=opt("FXBreathBrt") or 0.02
        TweenService:Create(bd.barSt,  TweenInfo.new(spd,Enum.EasingStyle.Sine),{Transparency=brt}):Play()
        TweenService:Create(bd.innerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.40}):Play()
        TweenService:Create(bd.outerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.65}):Play()
        task.wait(spd)
        if not bd.breathActive then return end
        TweenService:Create(bd.barSt,  TweenInfo.new(spd,Enum.EasingStyle.Sine),{Transparency=dim}):Play()
        TweenService:Create(bd.innerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.86}):Play()
        TweenService:Create(bd.outerGlow,TweenInfo.new(spd,Enum.EasingStyle.Sine),{BackgroundTransparency=0.96}):Play()
        task.wait(spd)
        if bd.breathActive then task.spawn(cycle) end
    end
    task.spawn(cycle)
end
local function stopBreath(bd) bd.breathActive=false end

-- Warning overlay pulse
local function doWarnPulse(bd)
    if bd.warnPulseActive then return end
    bd.warnPulseActive=true
    local function cycle()
        if not bd.warnPulseActive then return end
        if not tog("FXWarnPulse") then task.wait(0.3); if bd.warnPulseActive then task.spawn(cycle) end; return end
        local spd=opt("FXWarnSpd") or 0.55
        local aA =opt("FXWarnAlphaA") or 0.30
        local aB =opt("FXWarnAlphaB") or 0.0
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

-- Aura pulse
local function doAuraPulse(bd)
    if bd.auraPulseActive then return end
    bd.auraPulseActive=true
    local function cycle()
        if not bd.auraPulseActive then return end
        if not(tog("PShowReadyAura") and tog("FXAuraPulse")) then
            task.wait(0.4); if bd.auraPulseActive then task.spawn(cycle) end; return end
        local spd=opt("FXAuraSpd") or 0.85
        local aA =opt("FXAuraAlphaA") or 0.42
        local aB =opt("FXAuraAlphaB") or 0.75
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

-- ════════════════════════════════════════════════════════════════════════
-- §17  PLAYER BAR UPDATE LOOP
-- ════════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function(dt)
    local width      = opt("PWidth") or 175
    local height     = opt("PHeight") or 28
    local spacing    = opt("PSpacing") or 14
    local cornerR    = opt("PCorner") or 8
    local posX       = opt("PPosX") or 0.5
    local posY       = opt("PPosY") or 0.85
    local bgTransp   = opt("PBGTransp") or 0.18
    local fillTransp = opt("PFillTransp") or 0
    local textSize   = opt("PTextSize") or 14
    local lblSize    = opt("PLabelSize") or 10
    local lerpSpd    = opt("PLerpSpd") or 9
    local glowSpr    = opt("PGlowSpread") or 18
    local glowAlpha  = opt("PGlowAlpha") or 0.80
    local shadowOff  = opt("PShadowOff") or 4
    local shadowAlpha= opt("PShadowAlpha") or 0.62
    local gemSize    = opt("PGemSize") or 7
    local tickAlpha  = opt("PTickAlpha") or 0.55
    local reflH      = opt("PReflH") or 6
    local reflAlpha  = opt("PReflAlpha") or 0.72
    local strokeThk  = opt("PStrokeThick") or 1.5
    local edgeAlpha  = opt("PEdgeAlpha") or 0.50
    local shineAlpha = opt("PShineAlpha") or 0.82
    local warnThr    = (opt("PWarnThresh") or 25)/100
    local fillDir    = opt("PFillDir") or "Left"
    local auraSpread = opt("PAuraSpread") or 10
    local font       = FONT_MAP[opt("PFont")] or Enum.Font.GothamBold

    local showBars    = tog("PShowBars")
    local showNums    = tog("PShowNumbers")
    local showLabels  = tog("PShowLabels")
    local showReady   = tog("PShowReady")
    local showPct     = tog("PShowPercent")
    local showBorder  = tog("PShowBorder")
    local showShine   = tog("PShowShine")
    local showGlow    = tog("PShowGlow")
    local showShadow  = tog("PShowShadow")
    local showDRim    = tog("PShowDepthRim")
    local showGems    = tog("PShowGems")
    local showTicks   = tog("PShowTicks")
    local showReflect = tog("PShowReflect")
    local showEdge    = tog("PShowEdge")
    local showWarn    = tog("PShowWarn")
    local showAura    = tog("PShowReadyAura")
    local colorByTime = tog("PColorByTime")

    local totalW = #PORDER*width + (#PORDER-1)*spacing
    local startX = -totalW/2
    local readyClr = opt("PReadyClr") or C_READY
    local tickClr  = opt("PTickClr")  or C_WHITE

    for i,name in ipairs(PORDER) do
        local bd  = pBars[name]
        local cfg = PCFG[name]
        if not bd then continue end

        if bd.time>0 then bd.time=math.max(bd.time-dt,0) end
        local realRatio = 1-(bd.time/math.max(bd.duration,0.001))
        local lf = math.min(lerpSpd*dt,1)
        bd.visRatio = bd.visRatio+(realRatio-bd.visRatio)*lf

        local isOnCd  = bd.time>0
        local ratio   = math.clamp(bd.visRatio,0,1)
        local hasFill = ratio>0.03
        local cdPct   = 1-realRatio

        -- state transitions
        if bd.prevOnCd and not isOnCd then
            task.spawn(doFlash, bd, opt(cfg.fk))
            task.spawn(doBreath, bd)
            task.spawn(doAuraPulse, bd)
            stopWarnPulse(bd)
        elseif not bd.prevOnCd and isOnCd then
            stopBreath(bd); stopAuraPulse(bd); stopWarnPulse(bd)
        end
        local inWarn = isOnCd and cdPct>(1-warnThr)
        if inWarn and showWarn and not bd.warnPulseActive then
            task.spawn(doWarnPulse, bd)
        elseif not inWarn and bd.warnPulseActive then
            stopWarnPulse(bd)
        end
        bd.prevOnCd = isOnCd

        -- geometry
        local xOff = startX+(i-1)*(width+spacing)
        local lblH  = showLabels and (lblSize+3) or 0
        local totH  = height+lblH+(showLabels and 2 or 0)
        bd.container.Size     = UDim2.new(0,width,0,totH)
        bd.container.Position = UDim2.new(posX,xOff,posY,-totH/2)

        -- colours
        local fClr  = opt(cfg.fk)  or C_WHITE
        local dClr  = opt(cfg.dk)  or C_DANGER
        local wClr  = opt(cfg.wk)  or C_WARNING
        local bgClr = opt(cfg.bgk) or C_BLACK
        local nClr  = opt(cfg.nk)  or C_WHITE
        local lClr  = opt(cfg.lk)  or C_WHITE
        local bClr  = opt(cfg.bk)  or C_WHITE
        local gClr  = opt(cfg.gk)  or C_WHITE
        local sClr  = opt(cfg.sk)  or C_BLACK
        local gmClr = opt(cfg.gmk) or fClr
        local rmClr = opt(cfg.rmk) or bClr
        local aClr  = opt(cfg.ak)  or fClr
        local wOvClr= opt(cfg.wok) or C_DANGER
        local dynF  = dynColor(cdPct, fClr, wClr, dClr, colorByTime)

        -- shadow
        bd.shadow.BackgroundColor3       = sClr
        bd.shadow.Size                   = UDim2.new(1,shadowOff*2,0,height+shadowOff*2)
        bd.shadow.Position               = UDim2.new(0,-shadowOff,0,lblH+shadowOff*0.4)
        bd.shadow.BackgroundTransparency = (showShadow and showBars) and (1-shadowAlpha) or 1

        -- depth rim
        bd.dRim.Size     = UDim2.new(1,2,0,height+2)
        bd.dRim.Position = UDim2.new(0,-1,0,lblH-1)
        bd.dRimSt.Color  = rmClr
        bd.dRimSt.Enabled = showDRim and showBars

        -- outer glow
        bd.outerGlow.BackgroundColor3       = gClr
        bd.outerGlow.Size                   = UDim2.new(0,width+glowSpr*2,0,height+glowSpr)
        bd.outerGlow.Position               = UDim2.new(0,-glowSpr,0,lblH-glowSpr*0.4)
        bd.outerGlow.Visible                = showGlow and hasFill and not bd.breathActive
        if bd.outerGlow.Visible then
            bd.outerGlow.BackgroundTransparency = 1-glowAlpha*0.45 end

        -- inner glow
        bd.innerGlow.BackgroundColor3       = gClr
        bd.innerGlow.Size                   = UDim2.new(0,width+10,0,height+8)
        bd.innerGlow.Position               = UDim2.new(0,-5,0,lblH-3)
        bd.innerGlow.Visible                = showGlow and hasFill and not bd.breathActive
        if bd.innerGlow.Visible then
            bd.innerGlow.BackgroundTransparency = 1-glowAlpha*0.72 end

        -- ready aura
        bd.rAura.Size     = UDim2.new(0,width+auraSpread*2,0,height+auraSpread)
        bd.rAura.Position = UDim2.new(0,-auraSpread,0,lblH-auraSpread*0.4)
        bd.rAuraSt.Color  = aClr
        bd.rAura.Visible  = showAura and not isOnCd
        if not showAura or isOnCd then bd.rAuraSt.Transparency=1 end

        -- reflection
        bd.reflect.Size     = UDim2.new(1,0,0,reflH)
        bd.reflect.Position = UDim2.new(0,0,0,lblH+height+2)
        bd.reflect.BackgroundColor3       = dynF
        bd.reflect.BackgroundTransparency = (showReflect and hasFill and showBars) and (1-reflAlpha) or 1

        -- ability label
        bd.ablLabel.Size     = UDim2.new(1,0,0,lblH)
        bd.ablLabel.Position = UDim2.new(0,2,0,0)
        bd.ablLabel.TextSize = lblSize; bd.ablLabel.Font=font
        bd.ablLabel.TextColor3=lClr; bd.ablLabel.Visible=showLabels

        -- bar frame
        bd.barFrame.Size               = UDim2.new(0,width,0,height)
        bd.barFrame.Position           = UDim2.new(0,0,0,lblH+(showLabels and 2 or 0))
        bd.barCo.CornerRadius          = UDim.new(0,cornerR)
        bd.barFrame.BackgroundColor3   = bgClr
        bd.barFrame.BackgroundTransparency = bgTransp
        bd.barSt.Enabled = showBorder; bd.barSt.Color=bClr; bd.barSt.Thickness=strokeThk
        if not bd.breathActive then bd.barSt.Transparency=0.10 end

        -- ticks
        for _,tk in ipairs(bd.ticks) do
            tk.Visible=showTicks; tk.BackgroundColor3=tickClr
            tk.BackgroundTransparency=1-tickAlpha end

        -- warn overlay
        bd.warnOv.BackgroundColor3=wOvClr
        if not inWarn then bd.warnOv.BackgroundTransparency=1 end

        -- fill
        bd.fillCo.CornerRadius = UDim.new(0,cornerR)
        bd.fill.BackgroundColor3=dynF; bd.fill.BackgroundTransparency=fillTransp
        if fillDir=="Left" then
            bd.fill.AnchorPoint=Vector2.new(0,0); bd.fill.Position=UDim2.new(0,0,0,0)
        else
            bd.fill.AnchorPoint=Vector2.new(1,0); bd.fill.Position=UDim2.new(1,0,0,0)
        end
        bd.fill.Size=UDim2.new(ratio,0,1,0)

        -- sparkles
        for _,sp in ipairs(bd.sparkles) do
            sp.BackgroundColor3=dynF; sp.Visible=tog("PShowSparkles") or false end

        -- shine
        bd.shineLn.Visible=showShine and hasFill
        bd.shineOv.Visible=showShine and hasFill
        if showShine then bd.shineOv.BackgroundTransparency=shineAlpha end

        -- edge highlight
        bd.edgeHL.Visible=showEdge and hasFill
        bd.edgeHL.BackgroundTransparency=1-edgeAlpha

        -- gems
        bd.gemL.Size=UDim2.new(0,gemSize,0,gemSize)
        bd.gemL.Position=UDim2.new(0,gemSize*0.6,0.5,0)
        bd.gemL.BackgroundColor3=gmClr
        bd.gemL.BackgroundTransparency=(showGems and hasFill) and 0.14 or 1
        bd.gemR.Size=UDim2.new(0,gemSize,0,gemSize)
        bd.gemR.Position=UDim2.new(1,-(gemSize*1.6),0.5,0)
        bd.gemR.BackgroundColor3=gmClr
        bd.gemR.BackgroundTransparency=(showGems and hasFill) and 0.14 or 1

        -- visibility gate
        if showBars then
            bd.container.Visible=true; bd.barFrame.Visible=true; bd.fill.Visible=true
        elseif showNums then
            bd.container.Visible=true; bd.barFrame.Visible=true; bd.fill.Visible=false
            bd.barFrame.BackgroundTransparency=1
        else
            bd.container.Visible=false
        end

        -- number label
        bd.numLabel.Font=font; bd.numLabel.TextSize=textSize
        if bd.container.Visible and showNums then
            if isOnCd then
                bd.numLabel.TextColor3=nClr
                bd.numLabel.Text = showPct
                    and string.format("%.0f%%",realRatio*100)
                    or  string.format("%.1f",bd.time)
            elseif showReady then
                bd.numLabel.Text="✦  READY  ✦"; bd.numLabel.TextColor3=readyClr
            else bd.numLabel.Text="" end
        else bd.numLabel.Text="" end
    end
end)

-- ════════════════════════════════════════════════════════════════════════
-- §18  LOCAL PLAYER  —  TRIGGER + ANIMATION DETECTION
-- ════════════════════════════════════════════════════════════════════════
local LOCAL_ANIMS = {
    {name="Dash", ids={10479335397,10491993682}},
    {name="Side", ids={10480793962,10480796021}},
}

local function triggerPlayer(name)
    local bd=pBars[name]; if not bd then return end
    bd.time=bd.duration; bd.prevOnCd=true
    stopBreath(bd); stopAuraPulse(bd)
    task.spawn(doPulse, bd)
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

-- Evasive  (local)
LiveFolder.DescendantAdded:Connect(function(child)
    if child.Name~="RagdollCancel" then return end
    if child.Parent==player.Character then triggerPlayer("Evasive") end
end)

-- ════════════════════════════════════════════════════════════════════════
-- §19  ENEMY OVERHEAD  —  BILLBOARD CONSTRUCTION
-- ════════════════════════════════════════════════════════════════════════
local eTracks = {}   -- [Player] = { _bill, Dash={...}, Side={...}, Evasive={...} }

local function buildOverhead(p)
    local char=p.Character; if not char then return end
    local head=char:FindFirstChild("Head"); if not head then return end
    if eTracks[p] and eTracks[p]._bill then
        pcall(function() eTracks[p]._bill:Destroy() end) end

    local ohW    = opt("EWidth")   or 138
    local ohH    = opt("EHeight")  or 20
    local ohSp   = opt("ESpacing") or 7
    local lblSz  = opt("ELabelSize") or 9
    local cornerR= opt("ECorner") or 5
    local ohFont = FONT_MAP[opt("EFont")] or Enum.Font.GothamBold
    local sOp    = opt("EStrokeOp") or 0.30
    local gemSz  = opt("EGemSize") or 5

    local lblH   = lblSz+2
    local entryH = ohH+lblH+4
    local totH   = #EORDER*entryH+(#EORDER-1)*ohSp

    local bill=Instance.new("BillboardGui")
    bill.Name="CDTracker"; bill.Adornee=head
    bill.Size=UDim2.new(0,ohW,0,totH)
    bill.StudsOffset=Vector3.new(0,opt("EStuds") or 3.5,0)
    bill.AlwaysOnTop=tog("EAlTop") or false
    bill.LightInfluence=0; bill.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    bill.Parent=head

    local ll=Instance.new("UIListLayout",bill)
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.HorizontalAlignment=Enum.HorizontalAlignment.Center
    ll.FillDirection=Enum.FillDirection.Vertical
    ll.Padding=UDim.new(0,ohSp)

    local rowRefs={}

    for idx,abn in ipairs(EORDER) do
        local cfg=ECFG[abn]

        local entry=Instance.new("Frame")
        entry.Name=abn.."_Row"; entry.Size=UDim2.new(1,0,0,entryH)
        entry.BackgroundTransparency=1; entry.BorderSizePixel=0
        entry.LayoutOrder=idx; entry.Visible=false; entry.Parent=bill

        -- outer glow
        local eOG=mkOuterGlow(entry)
        eOG.Size=UDim2.new(1,16,1,10); eOG.Position=UDim2.new(0,-8,0,-5)

        -- ready aura
        local eRA,eRASt=mkReadyAura(entry, cornerR+8)
        eRA.Size=UDim2.new(1,20,1,12); eRA.Position=UDim2.new(0,-10,0,-6)
        eRA.Visible=false

        -- depth rim
        local eRim,eRimSt=mkDepthRim(entry, 2)
        eRim.Size=UDim2.new(1,2,1,2); eRim.Position=UDim2.new(0,-1,0,-1)

        -- label
        local eLbl=mkLabel(entry, cfg.sym.."  "..cfg.label, 5)
        eLbl.Size=UDim2.new(1,0,0,lblH); eLbl.Position=UDim2.new(0,0,0,0)
        eLbl.TextSize=lblSz; eLbl.Font=ohFont
        eLbl.TextStrokeTransparency=sOp

        -- BG frame
        local eBG,eBGCo,eBGSt=mkBarFrame(entry, 3)
        eBG.Size=UDim2.new(1,0,0,ohH); eBG.Position=UDim2.new(0,0,0,lblH+2)
        eBGCo.CornerRadius=UDim.new(0,cornerR)
        eBGSt.Thickness=1.2

        -- ticks
        local eTks=mkTicks(eBG)

        -- warn overlay
        local eWOv=mkWarnOverlay(eBG, cornerR)

        -- fill
        local eFClip,eFill,eFCo=mkFillSystem(eBG, 4)
        eFCo.CornerRadius=UDim.new(0,cornerR)

        -- sweep
        local eSweep=mkSweep(eFill)
        loopSweep(eSweep,(idx-1)*0.65,true)

        -- sparkles
        local eSPCnt=math.clamp(opt("ESparkCount") or 5,0,10)
        local eSps={}
        for j=1,eSPCnt do
            local xp=(j-0.5)/eSPCnt
            local sp=Instance.new("Frame")
            sp.Size=UDim2.new(0,2,0,2); sp.AnchorPoint=Vector2.new(0.5,0.5)
            sp.Position=UDim2.new(xp,0,0.5,0)
            sp.BackgroundColor3=C_WHITE; sp.BackgroundTransparency=1
            sp.BorderSizePixel=0; sp.ZIndex=9; sp.Parent=eFill
            mkCorner(sp,99)
            eSps[j]=sp
            loopSparkle(sp,(j-1)*0.50+(idx-1)*0.22,true)
        end

        -- shine
        local eSLn,eSOv=mkShine(eFill)

        -- edge
        local eEdge=mkEdge(eFill)

        -- gems
        local eGemL=mkGem(eBG,false)
        local eGemR=mkGem(eBG,true)

        -- reflection
        local eRefl=mkReflection(entry)

        -- number label
        local eNum=mkNumLabel(eBG)
        eNum.TextSize=opt("ETextSize") or 11
        eNum.TextStrokeTransparency=sOp

        rowRefs[abn]={
            entry=entry, og=eOG, ra=eRA, raSt=eRASt,
            rim=eRim, rimSt=eRimSt,
            lbl=eLbl, bg=eBG, bgCo=eBGCo, bgSt=eBGSt,
            ticks=eTks, wov=eWOv,
            fclip=eFClip, fill=eFill, fco=eFCo,
            sweep=eSweep, sparks=eSps,
            shLn=eSLn, shOv=eSOv,
            edge=eEdge, gemL=eGemL, gemR=eGemR,
            refl=eRefl, num=eNum,
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
        if refs then
            for k,v in pairs(refs) do eTracks[p][abn][k]=v end
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §20  ENEMY  —  TRIGGER + SETUP + CLEANUP
-- ════════════════════════════════════════════════════════════════════════
local function triggerEnemy(p, abn)
    local cfg=ECFG[abn]; if not cfg then return end
    if not eTracks[p] then eTracks[p]={} end
    if not eTracks[p][abn] then eTracks[p][abn]={time=0,visRatio=0} end
    eTracks[p][abn].time=cfg.defaultCD
end

local ENEMY_ANIMS={
    {name="Dash", ids={10479335397,10491993682}},
    {name="Side", ids={10480793962,10480796021}},
}

local function setupEnemy(p)
    if p==player then return end
    eTracks[p]={}
    for abn in pairs(ECFG) do eTracks[p][abn]={time=0,visRatio=0} end

    local function onChar(char)
        char:WaitForChild("Head",10); task.wait(0.12)
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

-- Evasive  (enemies via RagdollCancel)
LiveFolder.DescendantAdded:Connect(function(child)
    if child.Name~="RagdollCancel" then return end
    local char=child.Parent
    if char==player.Character then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and p.Character==char then
            triggerEnemy(p,"Evasive"); break end
    end
end)

-- ════════════════════════════════════════════════════════════════════════
-- §21  ENEMY OVERHEAD BAR UPDATE LOOP
-- ════════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function(dt)
    local showEnemy  = tog("EShowBars")
    local onlyCd     = tog("EOnlyCd")
    local showFill   = tog("EShowFill")
    local showNum    = tog("EShowNum")
    local showLbl    = tog("EShowLbl")
    local showBord   = tog("EShowBorder")
    local showShine  = tog("EShowShine")
    local showGlow   = tog("EShowGlow")
    local showGems   = tog("EShowGems")
    local showTicks  = tog("EShowTicks")
    local showReflect= tog("EShowReflect")
    local showEdge   = tog("EShowEdge")
    local showAura   = tog("EShowReadyAura")
    local showWarn   = tog("EShowWarn")
    local distFade   = tog("EDistFade")
    local ohAlTop    = tog("EAlTop")
    local ohW        = opt("EWidth")   or 138
    local ohH        = opt("EHeight")  or 20
    local ohSp       = opt("ESpacing") or 7
    local lblSz      = opt("ELabelSize") or 9
    local ohSO       = opt("EStuds") or 3.5
    local ohBGT      = opt("EBGTransp") or 0.22
    local ohTxtSz    = opt("ETextSize") or 11
    local cornerR    = opt("ECorner") or 5
    local sOp        = opt("EStrokeOp") or 0.30
    local lerpSpd    = opt("ELerpSpd") or 8
    local fillDir    = opt("EFillDir") or "Left"
    local glowSpr    = opt("EGlowSpread") or 12
    local glowAlpha  = opt("EGlowAlpha") or 0.80
    local gemSz      = opt("EGemSize") or 5
    local tickAlpha  = opt("ETickAlpha") or 0.50
    local reflH      = opt("EReflH") or 5
    local reflAlpha  = opt("EReflAlpha") or 0.76
    local strokeThk  = opt("EStrokeThick") or 1.2
    local edgeAlpha  = opt("EEdgeAlpha") or 0.48
    local shineAlpha = opt("EShineAlpha") or 0.84
    local warnThr    = (opt("EWarnThresh") or 25)/100
    local maxDist    = opt("EMaxDist") or 100
    local ohFont     = FONT_MAP[opt("EFont")] or Enum.Font.GothamBold
    local tickClr    = opt("ETickClr")   or C_WHITE
    local readyClr   = opt("EReadyClr")  or C_READY

    local lblH   = lblSz+2
    local entryH = ohH+lblH+4
    local totH   = #EORDER*entryH+(#EORDER-1)*ohSp

    local cam    = Workspace.CurrentCamera
    local camPos = cam and cam.CFrame.Position or Vector3.new(0,0,0)

    for p,tracker in pairs(eTracks) do
        local bill=tracker._bill
        if bill then
            bill.Enabled=showEnemy or false
            bill.AlwaysOnTop=ohAlTop or false
            bill.StudsOffset=Vector3.new(0,ohSO,0)
            bill.Size=UDim2.new(0,ohW,0,totH)
        end

        local distMul=1.0
        if distFade and p.Character then
            local rp=p.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                local d=(rp.Position-camPos).Magnitude
                if d>maxDist then distMul=0
                elseif d>maxDist*0.75 then
                    distMul=1-((d-maxDist*0.75)/(maxDist*0.25)) end
            end
        end

        for abn,data in pairs(tracker) do
            if abn=="_bill" then continue end
            local cfg=ECFG[abn]; if not cfg then continue end

            if data.time>0 then data.time=math.max(data.time-dt,0) end
            data.visRatio=data.visRatio or 0
            local realRatio=1-(data.time/math.max(cfg.defaultCD,0.001))
            data.visRatio=data.visRatio+((realRatio-data.visRatio)*math.min(lerpSpd*dt,1))

            local isOnCd  = data.time>0
            local ratio   = math.clamp(data.visRatio,0,1)
            local hasFill = ratio>0.03
            local cdPct   = 1-realRatio

            local entry   = data.entry
            if not entry or not entry.Parent then continue end

            local shouldShow = showEnemy and (isOnCd or not onlyCd) and distMul>0
            entry.Visible=shouldShow
            if not shouldShow then continue end

            -- colours
            local fClr  = opt(cfg.fk)  or C_WHITE
            local dClr  = opt(cfg.dk)  or C_DANGER
            local wClr  = opt(cfg.wk)  or C_WARNING
            local bgClr = opt(cfg.bgk) or C_BLACK
            local nClr  = opt(cfg.nk)  or C_WHITE
            local lClr  = opt(cfg.lk)  or C_WHITE
            local bClr  = opt(cfg.bk)  or C_WHITE
            local gClr  = opt(cfg.gk)  or C_WHITE
            local gmClr = opt(cfg.gmk) or fClr
            local rmClr = opt(cfg.rmk) or bClr
            local aClr  = opt(cfg.ak)  or fClr
            local wOvClr= opt(cfg.wok) or C_DANGER
            local dynF  = dynColor(cdPct, fClr, wClr, dClr, true)

            local inWarn = isOnCd and cdPct>(1-warnThr)

            -- outer glow
            local og=data.og
            if og then
                og.BackgroundColor3=gClr
                og.Size=UDim2.new(1,glowSpr*2,1,glowSpr)
                og.Position=UDim2.new(0,-glowSpr,0,-glowSpr*0.4)
                og.BackgroundTransparency=(showGlow and hasFill) and (1-glowAlpha*0.45*distMul) or 1
            end

            -- ready aura
            local ra=data.ra
            if ra then
                ra.Visible=showAura and not isOnCd
                if data.raSt then
                    data.raSt.Color=aClr
                    data.raSt.Transparency=(showAura and not isOnCd) and 0.40 or 1
                end
            end

            -- depth rim
            if data.rim and data.rimSt then
                data.rimSt.Color=rmClr; data.rimSt.Enabled=showBord end

            -- label
            local lbl=data.lbl
            if lbl then
                lbl.Visible=showLbl; lbl.TextColor3=lClr
                lbl.Font=ohFont; lbl.TextSize=lblSz
                lbl.TextStrokeTransparency=sOp
            end

            -- bg frame
            local bg=data.bg
            if bg then
                bg.BackgroundColor3=bgClr
                bg.BackgroundTransparency=ohBGT
            end
            if data.bgCo then data.bgCo.CornerRadius=UDim.new(0,cornerR) end
            if data.bgSt then
                data.bgSt.Enabled=showBord; data.bgSt.Color=bClr
                data.bgSt.Thickness=strokeThk; data.bgSt.Transparency=0.12
            end

            -- ticks
            if data.ticks then
                for _,tk in ipairs(data.ticks) do
                    tk.Visible=showTicks; tk.BackgroundColor3=tickClr
                    tk.BackgroundTransparency=1-tickAlpha end
            end

            -- warn overlay
            local wov=data.wov
            if wov then
                wov.BackgroundColor3=wOvClr
                wov.BackgroundTransparency=(inWarn and showWarn)
                    and (1-(opt("FXWarnAlphaA") or 0.30)) or 1
            end

            -- fill bar
            local fill=data.fill
            if fill then
                fill.Visible=showFill
                fill.BackgroundColor3=dynF; fill.BackgroundTransparency=0
                if data.fco then data.fco.CornerRadius=UDim.new(0,cornerR) end
                if fillDir=="Left" then
                    fill.AnchorPoint=Vector2.new(0,0); fill.Position=UDim2.new(0,0,0,0)
                else
                    fill.AnchorPoint=Vector2.new(1,0); fill.Position=UDim2.new(1,0,0,0)
                end
                fill.Size=UDim2.new(ratio,0,1,0)
            end

            -- sparkles
            if data.sparks then
                for _,sp in ipairs(data.sparks) do
                    sp.BackgroundColor3=dynF
                    sp.Visible=tog("EShowSparkles") or false
                end
            end

            -- shine
            if data.shLn then data.shLn.Visible=showShine and hasFill end
            if data.shOv then
                data.shOv.Visible=showShine and hasFill
                if showShine then data.shOv.BackgroundTransparency=shineAlpha end
            end

            -- edge highlight
            if data.edge then
                data.edge.Visible=showEdge and hasFill
                data.edge.BackgroundTransparency=1-edgeAlpha
            end

            -- gems
            if data.gemL then
                data.gemL.Size=UDim2.new(0,gemSz,0,gemSz)
                data.gemL.Position=UDim2.new(0,gemSz*0.6,0.5,0)
                data.gemL.BackgroundColor3=gmClr
                data.gemL.BackgroundTransparency=(showGems and hasFill) and 0.16 or 1
            end
            if data.gemR then
                data.gemR.Size=UDim2.new(0,gemSz,0,gemSz)
                data.gemR.Position=UDim2.new(1,-(gemSz*1.6),0.5,0)
                data.gemR.BackgroundColor3=gmClr
                data.gemR.BackgroundTransparency=(showGems and hasFill) and 0.16 or 1
            end

            -- reflection
            if data.refl then
                data.refl.Size=UDim2.new(1,0,0,reflH)
                data.refl.Position=UDim2.new(0,0,0,entryH+2)
                data.refl.BackgroundColor3=dynF
                data.refl.BackgroundTransparency=(showReflect and hasFill)
                    and (1-reflAlpha*distMul) or 1
            end

            -- number label
            local num=data.num
            if num then
                num.Visible=showNum; num.Font=ohFont
                num.TextSize=ohTxtSz; num.TextStrokeTransparency=sOp
                if showNum then
                    if isOnCd then
                        num.TextColor3=nClr
                        num.Text=string.format("%.1f",data.time)
                    else
                        num.TextColor3=readyClr; num.Text="READY"
                    end
                else num.Text="" end
            end
        end
    end
end)
-- ════════════════════════════════════════════════════════════════════════
-- END OF SCRIPT
-- ════════════════════════════════════════════════════════════════════════
