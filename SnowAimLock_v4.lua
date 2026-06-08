-- ╔══════════════════════════════════════════════════════════════════════════════════╗
-- ║                                                                                  ║
-- ║        ❄  S N O W   A I M L O C K   v 4  ·  U L T I M A T E   E D I T I O N  ❄ ║
-- ║                                                                                  ║
-- ║   Автор    :  AntiEmo Mobile Suite                                               ║
-- ║   Версия   :  4.0.0  "Blizzard"                                                  ║
-- ║   Зависимость : Antiz_Emolium_Ext.lua  (_G.AntiEmoAPI)                          ║
-- ║                                                                                  ║
-- ║   ──────────────────────────────────────────────────────────────────────────     ║
-- ║   ОСОБЕННОСТИ:                                                                   ║
-- ║   • Полная система частиц — снегопад по всей кнопке                              ║
-- ║   • Ледяные кристаллы — 6 уникальных форм на панели                              ║
-- ║   • Ореол / Glow — двойное свечение с анимацией пульсации                        ║
-- ║   • Ripple-эффект при каждом нажатии (расширяющееся кольцо)                      ║
-- ║   • Frost-шлейф — кристаллизация по краям кнопки при активации                  ║
-- ║   • Анимация перехода ON→OFF и OFF→ON с морозным взрывом                         ║
-- ║   • Плавающая снежинка-иконка: дыхание + вращение по оси                        ║
-- ║   • Ледяной шиммер — горизонтальная бегущая полоса света                         ║
-- ║   • Статусный HUD — имя цели + расстояние при локировании                       ║
-- ║   • Полностью перетаскиваемый интерфейс                                          ║
-- ║   • Анимация первого появления (ice-crack + слайд)                               ║
-- ║   • Авто-синхронизация состояния с API каждые 0.3с                               ║
-- ║   • Поддержка мобильного касания и ПК                                            ║
-- ║   • 100% оригинальная рендер-логика без внешних ассетов                          ║
-- ║                                                                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════════════
--  СЕРВИСЫ
-- ═══════════════════════════════════════════════════════════════
local Players     = game:GetService("Players")
local Camera      = workspace.CurrentCamera
local UIS         = game:GetService("UserInputService")
local TweenSvc    = game:GetService("TweenService")
local RunSvc      = game:GetService("RunService")
local LP          = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
--  ОЖИДАНИЕ API  (до 25 секунд)
-- ═══════════════════════════════════════════════════════════════
do
    local deadline = tick() + 25
    while not _G.AntiEmoAPI and tick() < deadline do
        task.wait(0.1)
    end
    if not _G.AntiEmoAPI then
        warn("╔══════════════════════════════════════════╗")
        warn("║  [SnowAimLock v4]  ОШИБКА ЗАПУСКА!       ║")
        warn("║  _G.AntiEmoAPI не найден.                 ║")
        warn("║  Сначала запусти Antiz_Emolium_Ext.lua    ║")
        warn("╚══════════════════════════════════════════╝")
        return
    end
end
local API = _G.AntiEmoAPI

-- ═══════════════════════════════════════════════════════════════
--  КОНСТАНТЫ ДИЗАЙНА  ──  Snow / Ice / Blizzard  Palette
-- ═══════════════════════════════════════════════════════════════
local PALETTE = {
    -- ── Холодная гамма ──────────────────────────────────
    VOID          = Color3.fromRGB(  2,   5,  18),   -- бездна
    ABYSS         = Color3.fromRGB(  5,  10,  32),   -- глубина льда
    DEEP_ICE      = Color3.fromRGB( 10,  25,  65),   -- тёмный лёд
    MID_ICE       = Color3.fromRGB( 22,  60, 130),   -- средний лёд
    PURE_ICE      = Color3.fromRGB( 80, 170, 240),   -- чистый лёд
    FROST         = Color3.fromRGB(160, 220, 255),   -- иней
    SNOWFLAKE     = Color3.fromRGB(200, 235, 255),   -- снежинка
    WHITE_SNOW    = Color3.fromRGB(230, 245, 255),   -- белый снег

    -- ── Активное состояние (мятный лёд) ─────────────────
    MINT_GLOW     = Color3.fromRGB(  0, 255, 180),   -- мятное свечение
    MINT_MID      = Color3.fromRGB(  0, 200, 140),   -- мятный средний
    MINT_DEEP     = Color3.fromRGB(  0,  80,  60),   -- мятная глубина
    MINT_ABYSS    = Color3.fromRGB(  0,  30,  25),   -- мятная бездна

    -- ── Акценты ──────────────────────────────────────────
    AURORA_1      = Color3.fromRGB( 50, 230, 255),   -- полярное сияние 1
    AURORA_2      = Color3.fromRGB(100, 180, 255),   -- полярное сияние 2
    SPARK         = Color3.fromRGB(220, 245, 255),   -- искра

    -- ── UI элементы ──────────────────────────────────────
    PANEL_BG      = Color3.fromRGB(  6,  12,  35),
    STROKE_IDLE   = Color3.fromRGB( 70, 140, 220),
    STROKE_HOT    = Color3.fromRGB(  0, 240, 200),
    TEXT_MAIN     = Color3.fromRGB(210, 235, 255),
    TEXT_DIM      = Color3.fromRGB(120, 170, 210),
    TEXT_ACTIVE   = Color3.fromRGB(255, 255, 255),

    -- ── Прозрачности ─────────────────────────────────────
    PANEL_ALPHA   = 0.18,    -- панель — почти непрозрачная
    GLOW_ALPHA    = 0.55,    -- ореол — полупрозрачный
    FROST_ALPHA   = 0.70,    -- иней — полупрозрачный
}

-- ═══════════════════════════════════════════════════════════════
--  РАЗМЕРЫ КНОПКИ  (можно менять здесь)
-- ═══════════════════════════════════════════════════════════════
local CFG = {
    PANEL_W       = 110,   -- ширина панели px
    PANEL_H       =  78,   -- высота панели px
    PANEL_X       = 0.03,  -- позиция X (scale)
    PANEL_Y       = 0.60,  -- позиция Y (scale)
    CORNER_R      = 22,    -- радиус скругления
    SNOWFALL_COUNT = 14,   -- кол-во снежинок-частиц
    CRYSTAL_COUNT =  6,    -- кол-во ледяных кристаллов
    SYNC_RATE     = 0.30,  -- интервал синхронизации с API (сек)
}

-- ═══════════════════════════════════════════════════════════════
--  TWEEN-ШАБЛОНЫ
-- ═══════════════════════════════════════════════════════════════
local TW = {
    INSTANT   = TweenInfo.new(0.00),
    SNAP      = TweenInfo.new(0.08, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out),
    FAST      = TweenInfo.new(0.16, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out),
    MED       = TweenInfo.new(0.30, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out),
    SMOOTH    = TweenInfo.new(0.45, Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut),
    BOUNCE    = TweenInfo.new(0.50, Enum.EasingStyle.Back,   Enum.EasingDirection.Out),
    SPRING    = TweenInfo.new(0.60, Enum.EasingStyle.Elastic,Enum.EasingDirection.Out),
    PULSE     = TweenInfo.new(0.80, Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut),
    SLOW      = TweenInfo.new(1.20, Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut),
    DRIFT     = TweenInfo.new(2.50, Enum.EasingStyle.Sine,   Enum.EasingDirection.InOut),
    RISE      = TweenInfo.new(0.55, Enum.EasingStyle.Back,   Enum.EasingDirection.Out),
}

-- ═══════════════════════════════════════════════════════════════
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ═══════════════════════════════════════════════════════════════

-- Линейная интерполяция числа
local function lerp(a, b, t) return a + (b - a) * t end

-- Плавный tween одного свойства
local function tw(obj, info, props)
    local t = TweenSvc:Create(obj, info, props)
    t:Play()
    return t
end

-- Отложенный вызов
local function delay(t, fn) task.delay(t, fn) end

-- Случайное число в диапазоне
local function rnd(a, b) return a + math.random() * (b - a) end

-- Создание UICorner
local function corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r)
    return c
end

-- Создание UIStroke
local function stroke(parent, thickness, color, trans)
    local s = Instance.new("UIStroke", parent)
    s.Thickness = thickness or 2
    s.Color = color or Color3.new(1,1,1)
    s.Transparency = trans or 0
    return s
end

-- Создание UIGradient
local function gradient(parent, c1, c2, rot)
    local g = Instance.new("UIGradient", parent)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    }
    g.Rotation = rot or 90
    return g
end

-- ═══════════════════════════════════════════════════════════════
--  СОЗДАНИЕ SCREENGUI
-- ═══════════════════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name            = "SnowAimLock_v4"
gui.Parent          = (gethui and gethui()) or game:GetService("CoreGui")
gui.ResetOnSpawn    = false
gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset  = true
gui.DisplayOrder    = 999

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 0]  ВНЕШНЕЕ СВЕЧЕНИЕ  (самый нижний слой)
--  Большой полупрозрачный ореол позади всей панели
-- ═══════════════════════════════════════════════════════════════
local outerGlow = Instance.new("Frame")
outerGlow.Name               = "OuterGlow"
outerGlow.Parent             = gui
outerGlow.Size               = UDim2.new(0, CFG.PANEL_W + 50, 0, CFG.PANEL_H + 50)
outerGlow.Position           = UDim2.new(
    CFG.PANEL_X, -25,
    CFG.PANEL_Y, -25
)
outerGlow.BackgroundColor3   = PALETTE.PURE_ICE
outerGlow.BackgroundTransparency = 0.94
outerGlow.BorderSizePixel    = 0
outerGlow.ZIndex             = 5
corner(outerGlow, CFG.CORNER_R + 25)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 1]  ПАНЕЛЬ — основная рама
-- ═══════════════════════════════════════════════════════════════
local panel = Instance.new("Frame")
panel.Name                  = "IcePanel"
panel.Parent                = gui
panel.Size                  = UDim2.new(0, CFG.PANEL_W, 0, CFG.PANEL_H)
panel.Position              = UDim2.new(CFG.PANEL_X, 0, CFG.PANEL_Y, 0)
panel.BackgroundColor3      = PALETTE.PANEL_BG
panel.BackgroundTransparency = PALETTE.PANEL_ALPHA
panel.BorderSizePixel        = 0
panel.ZIndex                 = 10
panel.ClipsDescendants       = true
corner(panel, CFG.CORNER_R)

local panelGrad = gradient(panel,
    Color3.fromRGB( 18,  40,  95),
    Color3.fromRGB(  4,   8,  28),
    135
)

local panelStroke = stroke(panel, 1.8, PALETTE.STROKE_IDLE, 0.15)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 2]  ВНУТРЕННЕЕ СВЕЧЕНИЕ  (поверх панели)
--  Тонкий засвет у верхнего края — эффект стекла
-- ═══════════════════════════════════════════════════════════════
local innerShine = Instance.new("Frame")
innerShine.Name               = "InnerShine"
innerShine.Parent             = panel
innerShine.Size               = UDim2.new(0.85, 0, 0, 2)
innerShine.Position           = UDim2.new(0.075, 0, 0, 3)
innerShine.BackgroundColor3   = PALETTE.WHITE_SNOW
innerShine.BackgroundTransparency = 0.6
innerShine.BorderSizePixel    = 0
innerShine.ZIndex             = 11
corner(innerShine, 2)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 3]  ШИММЕР — горизонтальная бегущая полоса света
--  Бесконечно ходит по кнопке слева направо
-- ═══════════════════════════════════════════════════════════════
local shimmer = Instance.new("Frame")
shimmer.Name                = "Shimmer"
shimmer.Parent              = panel
shimmer.Size                = UDim2.new(0, 30, 1, 0)
shimmer.Position            = UDim2.new(-0.4, 0, 0, 0)
shimmer.BackgroundColor3    = Color3.new(1,1,1)
shimmer.BackgroundTransparency = 0.88
shimmer.BorderSizePixel     = 0
shimmer.ZIndex              = 12
shimmer.Rotation            = 15

local shimGrad = Instance.new("UIGradient", shimmer)
shimGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(200,230,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(200,230,255)),
}
shimGrad.Rotation = 0

-- Запускаем петлю шиммера
task.spawn(function()
    while gui.Parent do
        tw(shimmer, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1.4, 0, 0, 0)
        })
        task.wait(2.2)
        shimmer.Position = UDim2.new(-0.4, 0, 0, 0)
        task.wait(rnd(0.5, 1.5))  -- случайная пауза между проходами
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 4]  ЛЕДЯНЫЕ КРИСТАЛЛЫ  — угловые декорации
--  6 маленьких осколков льда в углах и по краям
-- ═══════════════════════════════════════════════════════════════
local crystalDefs = {
    -- { X scale, Y scale, rotation, size, transparency }
    { 0.0,  0.0,  -30, 14, 0.60 },   -- верхний левый угол
    { 0.75, 0.0,   15, 11, 0.65 },   -- верхний правый
    { 0.88, 0.55,  45, 10, 0.70 },   -- правый край средний
    { 0.0,  0.65, -55,  9, 0.68 },   -- левый край нижний
    { 0.45, 0.0,    5,  7, 0.75 },   -- верхний центр
    { 0.0,  0.35,  20,  8, 0.72 },   -- левый центр
}

local crystalChars = { "◆", "◇", "✦", "✧", "⬡", "⬢" }
local crystals = {}

for i, def in ipairs(crystalDefs) do
    local cr = Instance.new("TextLabel")
    cr.Name                 = "Crystal_" .. i
    cr.Parent               = panel
    cr.Size                 = UDim2.new(0, def[4], 0, def[4])
    cr.Position             = UDim2.new(def[1], 0, def[2], 0)
    cr.Text                 = crystalChars[i] or "◆"
    cr.TextSize             = def[4]
    cr.Font                 = Enum.Font.GothamBold
    cr.BackgroundTransparency = 1
    cr.TextColor3           = PALETTE.FROST
    cr.TextTransparency     = def[5]
    cr.Rotation             = def[3]
    cr.ZIndex               = 13
    crystals[i] = cr
end

-- Медленно вращаем кристаллы
task.spawn(function()
    local time = 0
    while gui.Parent do
        time = time + task.wait(0.05)
        for i, cr in ipairs(crystals) do
            local offset  = i * 1.05   -- фаза каждого кристалла
            local scale   = 0.5 + 0.5 * math.sin(time * 0.4 + offset)
            cr.TextTransparency = lerp(crystalDefs[i][5], crystalDefs[i][5] - 0.25, scale)
            cr.Rotation = crystalDefs[i][3] + math.sin(time * 0.3 + offset) * 12
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 5]  СНЕГОПАД — система частиц внутри панели
--  CFG.SNOWFALL_COUNT снежинок, каждая с рандомной скоростью и позицией
-- ═══════════════════════════════════════════════════════════════
local snowChars   = { "·", "•", "❄", "❅", "❆", "*", "·" }
local snowflakes  = {}

for i = 1, CFG.SNOWFALL_COUNT do
    local sf = Instance.new("TextLabel")
    sf.Name                 = "Snow_" .. i
    sf.Parent               = panel
    sf.Size                 = UDim2.new(0, 10, 0, 10)
    sf.Position             = UDim2.new(rnd(0, 0.95), 0, rnd(-0.1, -0.5), 0)
    sf.Text                 = snowChars[math.random(#snowChars)]
    sf.TextSize             = math.random(5, 9)
    sf.Font                 = Enum.Font.Code
    sf.BackgroundTransparency = 1
    sf.TextColor3           = PALETTE.SNOWFLAKE
    sf.TextTransparency     = rnd(0.3, 0.7)
    sf.ZIndex               = 14
    snowflakes[i] = {
        label   = sf,
        speedY  = rnd(0.012, 0.035),   -- скорость падения (scale/tick)
        speedX  = rnd(-0.004, 0.004),  -- снос ветром
        startX  = rnd(0, 0.95),        -- начальная X позиция
        wobble  = rnd(0, math.pi * 2), -- фаза качания
        wSpeed  = rnd(0.5, 1.5),       -- скорость качания
    }
end

-- Движок снегопада
task.spawn(function()
    local time = 0
    while gui.Parent do
        local dt = task.wait(0.033)  -- ~30 fps для снега
        time = time + dt
        for _, sf in ipairs(snowflakes) do
            local lbl = sf.label
            local py  = lbl.Position.Y.Scale + sf.speedY * dt * 30
            local wobbleX = math.sin(time * sf.wSpeed + sf.wobble) * 0.015
            local px  = sf.startX + wobbleX

            if py > 1.1 then
                -- переносим снежинку наверх
                py  = rnd(-0.15, 0.0)
                px  = rnd(0, 0.95)
                sf.startX = px
                lbl.Text = snowChars[math.random(#snowChars)]
                lbl.TextSize = math.random(5, 9)
                lbl.TextTransparency = rnd(0.3, 0.7)
            end

            lbl.Position = UDim2.new(px, 0, py, 0)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 6]  КНОПКА — основная интерактивная зона
-- ═══════════════════════════════════════════════════════════════
local btn = Instance.new("TextButton")
btn.Name                  = "AimBtn"
btn.Parent                = panel
btn.Size                  = UDim2.new(1, -8, 1, -8)
btn.Position              = UDim2.new(0, 4, 0, 4)
btn.Text                  = ""
btn.BackgroundColor3      = PALETTE.DEEP_ICE
btn.BackgroundTransparency = 0.05
btn.BorderSizePixel       = 0
btn.ZIndex                = 15
btn.AutoButtonColor       = false
corner(btn, CFG.CORNER_R - 4)

local btnGrad = gradient(btn,
    Color3.fromRGB( 55, 120, 210),
    Color3.fromRGB(  8,  20,  60),
    115
)

local btnStroke = stroke(btn, 1.5, PALETTE.STROKE_IDLE, 0.20)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 7]  ОСНОВНАЯ СНЕЖИНКА — иконка
-- ═══════════════════════════════════════════════════════════════
local mainFlake = Instance.new("TextLabel")
mainFlake.Name               = "MainFlake"
mainFlake.Parent             = btn
mainFlake.Size               = UDim2.new(0, 38, 0, 38)
mainFlake.Position           = UDim2.new(0.5, -19, 0, 4)
mainFlake.Text               = "❄"
mainFlake.Font               = Enum.Font.GothamBlack
mainFlake.TextScaled         = true
mainFlake.BackgroundTransparency = 1
mainFlake.TextColor3         = PALETTE.FROST
mainFlake.ZIndex             = 16

-- Градиент на иконке
local flakeGrad = Instance.new("UIGradient", mainFlake)
flakeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   PALETTE.WHITE_SNOW),
    ColorSequenceKeypoint.new(0.5, PALETTE.PURE_ICE),
    ColorSequenceKeypoint.new(1,   PALETTE.FROST),
}
flakeGrad.Rotation = 45

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 8]  СТАТУСНЫЕ МЕТКИ
-- ═══════════════════════════════════════════════════════════════

-- Главный текст кнопки
local labelMain = Instance.new("TextLabel")
labelMain.Name               = "LabelMain"
labelMain.Parent             = btn
labelMain.Size               = UDim2.new(1, -4, 0, 14)
labelMain.Position           = UDim2.new(0, 2, 1, -20)
labelMain.Text               = "AIM  LOCK"
labelMain.Font               = Enum.Font.GothamBold
labelMain.TextSize           = 9
labelMain.BackgroundTransparency = 1
labelMain.TextColor3         = PALETTE.TEXT_MAIN
labelMain.ZIndex             = 16
labelMain.TextXAlignment     = Enum.TextXAlignment.Center

-- Маленький статус-текст (имя цели или пустой)
local labelSub = Instance.new("TextLabel")
labelSub.Name                = "LabelSub"
labelSub.Parent              = btn
labelSub.Size                = UDim2.new(1, -4, 0, 10)
labelSub.Position            = UDim2.new(0, 2, 0, 4)
labelSub.Text                = ""
labelSub.Font                = Enum.Font.Code
labelSub.TextSize            = 7
labelSub.BackgroundTransparency = 1
labelSub.TextColor3          = PALETTE.TEXT_DIM
labelSub.ZIndex              = 16
labelSub.TextXAlignment      = Enum.TextXAlignment.Center

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 9]  НИЖНЯЯ ИНДИКАТОРНАЯ ПОЛОСКА
--  Показывает «заряженность» / состояние
-- ═══════════════════════════════════════════════════════════════
local barBg = Instance.new("Frame")
barBg.Name                 = "BarBg"
barBg.Parent               = btn
barBg.Size                 = UDim2.new(0.7, 0, 0, 3)
barBg.Position             = UDim2.new(0.15, 0, 1, -6)
barBg.BackgroundColor3     = PALETTE.DEEP_ICE
barBg.BackgroundTransparency = 0.4
barBg.BorderSizePixel      = 0
barBg.ZIndex               = 16
corner(barBg, 2)

local barFill = Instance.new("Frame")
barFill.Name               = "BarFill"
barFill.Parent             = barBg
barFill.Size               = UDim2.new(0, 0, 1, 0)
barFill.Position           = UDim2.new(0, 0, 0, 0)
barFill.BackgroundColor3   = PALETTE.PURE_ICE
barFill.BorderSizePixel    = 0
barFill.ZIndex             = 17
corner(barFill, 2)
gradient(barFill, PALETTE.WHITE_SNOW, PALETTE.PURE_ICE, 0)

-- Анимация заполнения полоски при входе
task.delay(0.8, function()
    tw(barFill, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
end)

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 10]  RIPPLE — расширяющийся круг при нажатии
--  Создаётся динамически при каждом нажатии
-- ═══════════════════════════════════════════════════════════════
local function spawnRipple(parent, x, y, color)
    color = color or PALETTE.PURE_ICE
    local ripple = Instance.new("Frame")
    ripple.Parent               = parent
    ripple.Size                 = UDim2.new(0, 4, 0, 4)
    ripple.Position             = UDim2.new(0, x - 2, 0, y - 2)
    ripple.BackgroundColor3     = color
    ripple.BackgroundTransparency = 0.35
    ripple.BorderSizePixel      = 0
    ripple.ZIndex               = 18
    corner(ripple, 999)

    local targetSize = 90
    TweenSvc:Create(ripple, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size                 = UDim2.new(0, targetSize, 0, targetSize),
        Position             = UDim2.new(0, x - targetSize/2, 0, y - targetSize/2),
        BackgroundTransparency = 1.0,
    }):Play()

    game:GetService("Debris"):AddItem(ripple, 0.6)
end

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 11]  FROST-ВЗРЫВ — при активации AimLock
--  8 маленьких ледяных осколков разлетаются от центра
-- ═══════════════════════════════════════════════════════════════
local function spawnFrostBurst(parent, isLocking)
    local color = isLocking and PALETTE.MINT_GLOW or PALETTE.PURE_ICE
    local chars  = { "❄", "❅", "·", "✦", "◆", "❆", "*", "◇" }
    local cx, cy = CFG.PANEL_W / 2, CFG.PANEL_H / 2 - 10

    for i = 1, 8 do
        local angle = (i - 1) * (math.pi * 2 / 8)
        local dist  = rnd(20, 45)
        local tx    = cx + math.cos(angle) * dist
        local ty    = cy + math.sin(angle) * dist

        local shard = Instance.new("TextLabel")
        shard.Parent               = parent
        shard.Size                 = UDim2.new(0, 10, 0, 10)
        shard.Position             = UDim2.new(0, cx - 5, 0, cy - 5)
        shard.Text                 = chars[i] or "·"
        shard.TextSize             = math.random(7, 12)
        shard.Font                 = Enum.Font.GothamBold
        shard.BackgroundTransparency = 1
        shard.TextColor3           = color
        shard.TextTransparency     = 0
        shard.ZIndex               = 19
        shard.Rotation             = math.random(0, 360)

        TweenSvc:Create(shard, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position         = UDim2.new(0, tx - 5, 0, ty - 5),
            TextTransparency = 1,
            Rotation         = shard.Rotation + math.random(90, 270),
        }):Play()

        game:GetService("Debris"):AddItem(shard, 0.6)
    end
end

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 12]  АКТИВНЫЙ ОРЕОЛvнижнего блеска кнопки
--  Появляется при включённом AimLock
-- ═══════════════════════════════════════════════════════════════
local activeGlow = Instance.new("Frame")
activeGlow.Name               = "ActiveGlow"
activeGlow.Parent             = gui
activeGlow.Size               = UDim2.new(0, CFG.PANEL_W + 36, 0, CFG.PANEL_H + 36)
activeGlow.BackgroundColor3   = PALETTE.MINT_GLOW
activeGlow.BackgroundTransparency = 1.0   -- скрыт по умолчанию
activeGlow.BorderSizePixel    = 0
activeGlow.ZIndex             = 6
corner(activeGlow, CFG.CORNER_R + 18)

-- Позиционируем вместе с панелью (будет обновляться в sync)
local function syncGlowPos()
    activeGlow.Position = UDim2.new(
        panel.Position.X.Scale,
        panel.Position.X.Offset - 18,
        panel.Position.Y.Scale,
        panel.Position.Y.Offset - 18
    )
    outerGlow.Position = UDim2.new(
        panel.Position.X.Scale,
        panel.Position.X.Offset - 25,
        panel.Position.Y.Scale,
        panel.Position.Y.Offset - 25
    )
end
syncGlowPos()

-- ═══════════════════════════════════════════════════════════════
--  [LAYER 13]  АНИМАЦИЯ ДЫХАНИЯ СНЕЖИНКИ + ВРАЩЕНИЕ ОТТИСКА
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    local t = 0
    while gui.Parent do
        t = t + task.wait(0.04)
        -- дыхание: scale от 0.9 до 1.1
        local breathe = 0.5 + 0.5 * math.sin(t * 1.2)
        local scaleV  = lerp(0.92, 1.08, breathe)
        mainFlake.TextSize = 999   -- TextScaled=true, просто колышем прозрачность
        mainFlake.TextTransparency = lerp(0.0, 0.15, breathe)

        -- вращение градиента иконки
        flakeGrad.Rotation = (t * 18) % 360

        -- кристаллы мерцают по-разному
        for i, cr in ipairs(crystals) do
            local phase = t * 0.7 + i * 0.9
            cr.TextTransparency = lerp(
                crystalDefs[i][5],
                math.max(0, crystalDefs[i][5] - 0.30),
                0.5 + 0.5 * math.sin(phase)
            )
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  СОСТОЯНИЕ ВИЗУАЛА
-- ═══════════════════════════════════════════════════════════════
local isVisuallyLocked = false   -- текущее отображаемое состояние

-- ───  Переход в состояние ON  ────────────────────────────────
local function visualON(targetName)
    if isVisuallyLocked then return end
    isVisuallyLocked = true

    spawnFrostBurst(panel, true)

    -- Кнопка — мятный лёд
    tw(btnGrad, TW.FAST, {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, PALETTE.MINT_GLOW),
            ColorSequenceKeypoint.new(1, PALETTE.MINT_ABYSS),
        }
    })
    tw(btnStroke,  TW.FAST, { Color = PALETTE.STROKE_HOT, Transparency = 0 })
    tw(btn,        TW.BOUNCE, { BackgroundColor3 = Color3.fromRGB(0, 35, 30) })

    -- Панель — тёмный мятный
    tw(panelGrad, TW.MED, {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(  0, 55, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(  0, 15, 12)),
        }
    })
    tw(panelStroke, TW.FAST, { Color = PALETTE.STROKE_HOT, Transparency = 0.05 })

    -- Ореол — появляется
    tw(activeGlow,  TW.MED,  { BackgroundTransparency = 0.82 })
    tw(outerGlow,   TW.MED,  { BackgroundColor3 = PALETTE.MINT_GLOW, BackgroundTransparency = 0.88 })

    -- Иконка — белая
    tw(mainFlake,   TW.FAST, { TextColor3 = Color3.new(1,1,1) })

    -- Полоска — мятная
    tw(barFill,     TW.MED,  { BackgroundColor3 = PALETTE.MINT_GLOW })
    tw(barBg,       TW.MED,  { BackgroundColor3 = PALETTE.MINT_DEEP })

    -- Тексты
    labelMain.Text = "LOCKED  🔒"
    tw(labelMain,  TW.FAST,  { TextColor3 = PALETTE.TEXT_ACTIVE })
    if targetName and targetName ~= "" then
        labelSub.Text = "→ " .. targetName
        tw(labelSub, TW.FAST, { TextColor3 = PALETTE.MINT_GLOW })
    else
        labelSub.Text = "✓ TARGET"
        tw(labelSub, TW.FAST, { TextColor3 = PALETTE.MINT_MID })
    end

    -- Кристаллы — мятные
    for _, cr in ipairs(crystals) do
        tw(cr, TW.SLOW, { TextColor3 = PALETTE.MINT_GLOW })
    end

    -- Пульсация ореола (loop пока locked)
    task.spawn(function()
        while isVisuallyLocked and gui.Parent do
            tw(activeGlow, TW.PULSE, { BackgroundTransparency = 0.76 })
            task.wait(0.82)
            if not isVisuallyLocked then break end
            tw(activeGlow, TW.PULSE, { BackgroundTransparency = 0.87 })
            task.wait(0.82)
        end
    end)
end

-- ───  Переход в состояние OFF  ───────────────────────────────
local function visualOFF()
    if not isVisuallyLocked then return end
    isVisuallyLocked = false

    spawnFrostBurst(panel, false)

    -- Кнопка — ледяная
    tw(btnGrad, TW.FAST, {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB( 55, 120, 210)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(  8,  20,  60)),
        }
    })
    tw(btnStroke,  TW.FAST, { Color = PALETTE.STROKE_IDLE, Transparency = 0.20 })
    tw(btn,        TW.BOUNCE, { BackgroundColor3 = PALETTE.DEEP_ICE })

    -- Панель — тёмный лёд
    tw(panelGrad, TW.MED, {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB( 18,  40,  95)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(  4,   8,  28)),
        }
    })
    tw(panelStroke, TW.FAST, { Color = PALETTE.STROKE_IDLE, Transparency = 0.15 })

    -- Ореол — скрывается
    tw(activeGlow,  TW.MED,  { BackgroundTransparency = 1.0 })
    tw(outerGlow,   TW.MED,  { BackgroundColor3 = PALETTE.PURE_ICE, BackgroundTransparency = 0.94 })

    -- Иконка
    tw(mainFlake,   TW.FAST, { TextColor3 = PALETTE.FROST })

    -- Полоска
    tw(barFill,     TW.MED,  { BackgroundColor3 = PALETTE.PURE_ICE })
    tw(barBg,       TW.MED,  { BackgroundColor3 = PALETTE.DEEP_ICE })

    -- Тексты
    labelMain.Text = "AIM  LOCK"
    tw(labelMain,  TW.FAST,  { TextColor3 = PALETTE.TEXT_MAIN })
    labelSub.Text  = ""

    -- Кристаллы — ледяные
    for _, cr in ipairs(crystals) do
        tw(cr, TW.SLOW, { TextColor3 = PALETTE.FROST })
    end
end

-- ═══════════════════════════════════════════════════════════════
--  АНИМАЦИЯ НАЖАТИЯ  (press down / up)
-- ═══════════════════════════════════════════════════════════════
local pressedDown = false

local function onPressDown(localX, localY)
    if pressedDown then return end
    pressedDown = true

    -- Небольшое сжатие панели
    tw(panel, TW.SNAP, {
        Size     = UDim2.new(0, CFG.PANEL_W - 5, 0, CFG.PANEL_H - 4),
        Position = UDim2.new(
            panel.Position.X.Scale,
            panel.Position.X.Offset + 2,
            panel.Position.Y.Scale,
            panel.Position.Y.Offset + 2
        )
    })

    -- Тёмное перекрытие
    tw(btn, TW.SNAP, { BackgroundTransparency = 0.3 })

    -- Ripple в точке касания
    spawnRipple(btn, localX or 45, localY or 35,
        isVisuallyLocked and PALETTE.MINT_GLOW or PALETTE.PURE_ICE)
end

local function onPressUp(cx, cy)
    if not pressedDown then return end
    pressedDown = false

    -- Возврат размера
    tw(panel, TW.BOUNCE, {
        Size     = UDim2.new(0, CFG.PANEL_W, 0, CFG.PANEL_H),
        Position = UDim2.new(
            panel.Position.X.Scale,
            panel.Position.X.Offset - 2,
            panel.Position.Y.Scale,
            panel.Position.Y.Offset - 2
        )
    })
    tw(btn, TW.SNAP, { BackgroundTransparency = 0.05 })

    -- Синхронизируем позицию ореолов
    delay(0.15, syncGlowPos)
end

-- ═══════════════════════════════════════════════════════════════
--  DRAG  (перетаскивание)
-- ═══════════════════════════════════════════════════════════════
local dragState = {
    active   = false,
    start    = nil,
    origPos  = nil,
    moved    = false,
}

local DRAG_THRESH = 9   -- пикселей до регистрации перетаскивания

panel.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragState.active  = true
        dragState.start   = inp.Position
        dragState.origPos = panel.Position
        dragState.moved   = false

        -- Нажатие
        local btnAbs = btn.AbsolutePosition
        local lx = inp.Position.X - btnAbs.X
        local ly = inp.Position.Y - btnAbs.Y
        onPressDown(lx, ly)

        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragState.active = false
                onPressUp()
            end
        end)
    end
end)

panel.InputChanged:Connect(function(inp)
    if not dragState.active then return end
    if inp.UserInputType ~= Enum.UserInputType.Touch
    and inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end

    local delta = inp.Position - dragState.start
    if delta.Magnitude > DRAG_THRESH then
        dragState.moved = true
    end

    panel.Position = UDim2.new(
        dragState.origPos.X.Scale,
        dragState.origPos.X.Offset + delta.X,
        dragState.origPos.Y.Scale,
        dragState.origPos.Y.Offset + delta.Y
    )
    syncGlowPos()
end)

-- ═══════════════════════════════════════════════════════════════
--  ТРЕКИНГ КАСАНИЯ ИГРОВОЙ ЗОНЫ
-- ═══════════════════════════════════════════════════════════════
local lastTouchPos = nil

local function isOverPanel(pos)
    local a = panel.AbsolutePosition
    local s = panel.AbsoluteSize
    return pos.X >= a.X and pos.X <= a.X + s.X
       and pos.Y >= a.Y and pos.Y <= a.Y + s.Y
end

UIS.TouchStarted:Connect(function(touch, _gp)
    local pos = Vector2.new(touch.Position.X, touch.Position.Y)
    if not isOverPanel(pos) then
        lastTouchPos           = pos
        _G.AntiEmoLastTouchPos = pos
    end
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = Vector2.new(inp.Position.X, inp.Position.Y)
        if not isOverPanel(pos) then
            lastTouchPos           = pos
            _G.AntiEmoLastTouchPos = pos
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ  (живой игрок, поиск ближайшего)
-- ═══════════════════════════════════════════════════════════════
local function isAlive(p)
    if not p.Character then return false end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getDistanceTo(p)
    if not p.Character then return 9999 end
    local root = p.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root and myRoot then
        return (root.Position - myRoot.Position).Magnitude
    end
    return 9999
end

local function getNearestToScreen(screenPos)
    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and isAlive(p) then
            local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local vp, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local d = (Vector2.new(vp.X, vp.Y) - screenPos).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
    end
    return best
end

-- ═══════════════════════════════════════════════════════════════
--  ЛОГИКА НАЖАТИЯ КНОПКИ  AimLock
-- ═══════════════════════════════════════════════════════════════
btn.MouseButton1Click:Connect(function()
    if dragState.moved then return end  -- не реагируем на перетаскивание

    local touchPos = lastTouchPos or UIS:GetMouseLocation()
    local target   = getNearestToScreen(touchPos)

    if API.isLocked() then
        -- снять лок
        API.toggleAimLock()
        visualOFF()
    elseif target and API.lockOnPlayer then
        -- залочиться на ближайшего
        API.lockOnPlayer(target)
        local dist = math.floor(getDistanceTo(target))
        visualON(target.DisplayName or target.Name)
        -- обновляем подпись с расстоянием
        delay(0.05, function()
            labelSub.Text = "→ " .. (target.DisplayName or target.Name) .. "  " .. dist .. "m"
        end)
    else
        -- fallback
        API.toggleAimLock()
        if API.isLocked() then
            visualON(nil)
        else
            visualOFF()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  СИНХРОНИЗАЦИЯ С API  (каждые CFG.SYNC_RATE секунд)
--  Защита от рассинхрона если лок сбрасывается снаружи
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    local prev = nil
    while task.wait(CFG.SYNC_RATE) do
        if not gui.Parent then break end
        local locked = API.isLocked()

        if locked ~= prev then
            prev = locked
            if locked then
                if not isVisuallyLocked then
                    -- ищем текущую цель для подписи
                    local targetName = nil
                    if API.getTarget then
                        local t = API.getTarget()
                        if t then targetName = t.DisplayName or t.Name end
                    end
                    visualON(targetName)
                end
            else
                if isVisuallyLocked then
                    visualOFF()
                end
            end
        end

        -- Обновляем расстояние до цели если залочены
        if locked and API.getTarget then
            local t = API.getTarget()
            if t and isAlive(t) then
                local dist = math.floor(getDistanceTo(t))
                labelSub.Text = "→ " .. (t.DisplayName or t.Name) .. "  " .. dist .. "m"
            end
        end

        -- Синхронизируем позицию ореолов после возможного перетаскивания
        syncGlowPos()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  АНИМАЦИЯ ПОЯВЛЕНИЯ  —  ice crack + slide up
-- ═══════════════════════════════════════════════════════════════
do
    -- Начальное состояние: ниже экрана, полностью прозрачный
    local origPos  = panel.Position
    local slideAmt = 100

    panel.Position              = UDim2.new(origPos.X.Scale, origPos.X.Offset,
                                            origPos.Y.Scale, origPos.Y.Offset + slideAmt)
    panel.BackgroundTransparency = 1.0
    btn.BackgroundTransparency   = 1.0
    mainFlake.TextTransparency   = 1.0
    labelMain.TextTransparency   = 1.0
    labelSub.TextTransparency    = 1.0

    for _, cr in ipairs(crystals) do
        cr.TextTransparency = 1.0
    end

    -- Фаза 1: пауза
    task.wait(0.25)

    -- Фаза 2: кристаллы появляются по одному
    for i, cr in ipairs(crystals) do
        delay(i * 0.06, function()
            tw(cr, TW.SPRING, { TextTransparency = crystalDefs[i][5] })
        end)
    end
    task.wait(0.15)

    -- Фаза 3: панель взлетает
    tw(panel, TW.RISE, {
        Position             = origPos,
        BackgroundTransparency = PALETTE.PANEL_ALPHA,
    })
    task.wait(0.20)

    -- Фаза 4: кнопка проявляется
    tw(btn,       TW.FAST, { BackgroundTransparency = 0.05 })
    tw(mainFlake, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { TextTransparency = 0 })
    tw(labelMain, TW.MED,  { TextTransparency = 0 })
    tw(labelSub,  TW.MED,  { TextTransparency = 0 })

    -- Фаза 5: ripple-приветствие
    delay(0.35, function()
        spawnRipple(btn, 45, 35, PALETTE.PURE_ICE)
        spawnFrostBurst(panel, false)
    end)

    -- Синхронизируем ореолы
    delay(0.4, syncGlowPos)
end

-- ═══════════════════════════════════════════════════════════════
--  ГОТОВО
-- ═══════════════════════════════════════════════════════════════
print("╔══════════════════════════════════════════════════╗")
print("║   ❄  SnowAimLock v4  «Blizzard»  — LOADED  ❄    ║")
print("║                                                  ║")
print("║   Нажми кнопку ❄ для AimLock на ближайшего      ║")
print("║   Перетащи для перемещения                       ║")
print("║   Нажми снова для снятия лока                    ║")
print("╚══════════════════════════════════════════════════╝")
