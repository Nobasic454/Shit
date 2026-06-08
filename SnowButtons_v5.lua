-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                                                                              ║
-- ║   ❄  A N T I E M O   S N O W   B U T T O N S   v 5  ·  B L I Z Z A R D   ❄ ║
-- ║                                                                              ║
-- ║   Запускать ПОСЛЕ Antiz_Emolium_Ext.lua                                     ║
-- ║   V = AimLock ближайший к касанию  |  X = Velocity                         ║
-- ║   Логика: 100% оригинальная из MobileButtons v2                             ║
-- ║   Стиль:  Snow / Ice  ·  квадратные кнопки  ·  полная анимация             ║
-- ║                                                                              ║
-- ║   ВИЗУАЛЬНЫЕ ЭФФЕКТЫ:                                                       ║
-- ║   • Снегопад-частицы внутри каждой кнопки (8 снежинок)                     ║
-- ║   • Shimmer — бегущая полоса света                                          ║
-- ║   • Frost Burst — осколки льда при нажатии                                  ║
-- ║   • Ripple — расширяющееся кольцо в точке касания                           ║
-- ║   • Pulsing Glow — внешний ореол при активном состоянии                     ║
-- ║   • Ice Crystals — угловые декоративные осколки                             ║
-- ║   • Entrance animation — слайд + мерцание при запуске                       ║
-- ║   • Press animation — сжатие при нажатии                                    ║
-- ║   • Breath animation — иконка «дышит»                                       ║
-- ║                                                                              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════════════
--  СЕРВИСЫ
-- ═══════════════════════════════════════════════════════════════
local Players  = game:GetService("Players")
local Camera   = workspace.CurrentCamera
local UIS      = game:GetService("UserInputService")
local TweenSvc = game:GetService("TweenService")
local RunSvc   = game:GetService("RunService")
local LP       = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
--  ОЖИДАНИЕ API  (до 25 секунд) — оригинальная логика v2
-- ═══════════════════════════════════════════════════════════════
local t0 = tick()
while not _G.AntiEmoAPI and (tick() - t0) < 25 do task.wait(0.1) end
if not _G.AntiEmoAPI then
    warn("[SnowButtons v5] _G.AntiEmoAPI не найден — сначала запусти главный скрипт")
    return
end
local API = _G.AntiEmoAPI

-- ═══════════════════════════════════════════════════════════════
--  SNOW / ICE  ПАЛИТРА
-- ═══════════════════════════════════════════════════════════════
local ICE = {
    -- базовые цвета льда
    VOID         = Color3.fromRGB(  2,   4,  14),
    ABYSS        = Color3.fromRGB(  5,   9,  28),
    DEEP         = Color3.fromRGB( 10,  22,  58),
    MID          = Color3.fromRGB( 22,  58, 128),
    PURE         = Color3.fromRGB( 80, 168, 238),
    FROST        = Color3.fromRGB(158, 218, 255),
    FLAKE        = Color3.fromRGB(200, 234, 255),
    WHITE        = Color3.fromRGB(230, 245, 255),
    -- активные (мятный лёд)
    MINT_HOT     = Color3.fromRGB(  0, 255, 178),
    MINT_MID     = Color3.fromRGB(  0, 190, 130),
    MINT_DEEP    = Color3.fromRGB(  0,  70,  55),
    MINT_ABYSS   = Color3.fromRGB(  0,  22,  18),
    -- velocity (янтарный лёд)
    AMBER_HOT    = Color3.fromRGB(255, 185,  30),
    AMBER_MID    = Color3.fromRGB(200, 130,  10),
    AMBER_DEEP   = Color3.fromRGB( 80,  45,   0),
    AMBER_ABYSS  = Color3.fromRGB( 22,  12,   0),
    -- UI
    TEXT         = Color3.fromRGB(210, 234, 255),
    TEXT_DIM     = Color3.fromRGB(120, 168, 210),
    TEXT_WHITE   = Color3.new(1, 1, 1),
    STROKE_IDLE  = Color3.fromRGB( 68, 138, 218),
    STROKE_AIM   = Color3.fromRGB(  0, 238, 198),
    STROKE_VEL   = Color3.fromRGB(255, 198,  50),
}

-- ═══════════════════════════════════════════════════════════════
--  TWEEN ШАБЛОНЫ
-- ═══════════════════════════════════════════════════════════════
local TW = {
    SNAP    = TweenInfo.new(0.08, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    FAST    = TweenInfo.new(0.16, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    MED     = TweenInfo.new(0.30, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    BOUNCE  = TweenInfo.new(0.45, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    SPRING  = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    PULSE   = TweenInfo.new(0.75, Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut),
    SLOW    = TweenInfo.new(1.20, Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut),
    RISE    = TweenInfo.new(0.50, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    SHINE   = TweenInfo.new(2.00, Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut),
}

-- ═══════════════════════════════════════════════════════════════
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ═══════════════════════════════════════════════════════════════
local function rnd(a, b) return a + math.random() * (b - a) end
local function lerp(a, b, t) return a + (b - a) * t end

local function tw(obj, info, props)
    TweenSvc:Create(obj, info, props):Play()
end

local function delay(t, fn) task.delay(t, fn) end

local function newCorner(parent, r)
    -- r=0 → квадрат; r>0 → мягкое скругление
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r)
    return c
end

local function newStroke(parent, thick, col, trans)
    local s = Instance.new("UIStroke", parent)
    s.Thickness    = thick or 2
    s.Color        = col   or ICE.STROKE_IDLE
    s.Transparency = trans or 0
    return s
end

local function newGrad(parent, c1, c2, rot)
    local g = Instance.new("UIGradient", parent)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    }
    g.Rotation = rot or 90
    return g
end

-- ═══════════════════════════════════════════════════════════════
--  SCREENGUI
-- ═══════════════════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name            = "AntiEmoMobileButtons"   -- сохраняем оригинальное имя
gui.Parent          = (gethui and gethui()) or game:GetService("CoreGui")
gui.ResetOnSpawn    = false
gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset  = true
gui.DisplayOrder    = 999

-- ═══════════════════════════════════════════════════════════════
--  ФАБРИКА КНОПКИ  (Snow / Ice, квадратная)
--  Возвращает: { root, btn, stroke, grad, labelTop, labelBot,
--               snowflakes, shimmer, crystals, glow }
-- ═══════════════════════════════════════════════════════════════
local CORNER_RADIUS = 4   -- 0 = чисто квадратная, 4 = едва заметное скругление

local function buildSnowButton(cfg)
    --[[
        cfg = {
            px, py        : начальная позиция (scale)
            idleTopColor  : верхний цвет градиента (выкл)
            idleBotColor  : нижний цвет градиента (выкл)
            onTopColor    : верхний цвет (вкл)
            onBotColor    : нижний цвет (вкл)
            strokeIdle    : цвет обводки выкл
            strokeOn      : цвет обводки вкл
            iconOff       : иконка/текст кнопки выкл
            iconOn        : иконка/текст кнопки вкл
            labelText     : подпись снизу
        }
    ]]

    -- ── ВНЕШНИЙ ОРЕОЛidle (под кнопкой) ──────────────────────
    local glow = Instance.new("Frame")
    glow.Name                   = "Glow"
    glow.Parent                 = gui
    glow.Size                   = UDim2.new(0, 92, 0, 62)
    glow.Position               = UDim2.new(cfg.px, -10, cfg.py, -9)
    glow.BackgroundColor3       = cfg.strokeIdle
    glow.BackgroundTransparency = 1.0
    glow.BorderSizePixel        = 0
    glow.ZIndex                 = 8
    newCorner(glow, CORNER_RADIUS + 8)

    -- ── КОРНЕВОЙ КОНТЕЙНЕР ────────────────────────────────────
    local root = Instance.new("Frame")
    root.Name                   = "BtnRoot"
    root.Parent                 = gui
    root.Size                   = UDim2.new(0, 72, 0, 44)
    root.Position               = UDim2.new(cfg.px, 0, cfg.py, 0)
    root.BackgroundColor3       = ICE.ABYSS
    root.BackgroundTransparency = 0.10
    root.BorderSizePixel        = 0
    root.ZIndex                 = 10
    root.ClipsDescendants       = true
    newCorner(root, CORNER_RADIUS)

    local rootGrad = newGrad(root,
        Color3.fromRGB(16, 36, 82),
        Color3.fromRGB( 4,  8, 24),
        130
    )

    local rootStroke = newStroke(root, 1.6, cfg.strokeIdle, 0.18)

    -- Верхний блик (стекло)
    local shine = Instance.new("Frame")
    shine.Parent               = root
    shine.Size                 = UDim2.new(0.80, 0, 0, 1)
    shine.Position             = UDim2.new(0.10, 0, 0, 2)
    shine.BackgroundColor3     = ICE.WHITE
    shine.BackgroundTransparency = 0.55
    shine.BorderSizePixel      = 0
    shine.ZIndex               = 11
    newCorner(shine, 1)

    -- ── SHIMMER — горизонтальная полоса света ─────────────────
    local shimmer = Instance.new("Frame")
    shimmer.Parent              = root
    shimmer.Size                = UDim2.new(0, 22, 1, 0)
    shimmer.Position            = UDim2.new(-0.4, 0, 0, 0)
    shimmer.BackgroundColor3    = Color3.new(1,1,1)
    shimmer.BackgroundTransparency = 0.86
    shimmer.BorderSizePixel     = 0
    shimmer.ZIndex              = 12
    shimmer.Rotation            = 14

    local shimGrad = Instance.new("UIGradient", shimmer)
    shimGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(180, 220, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(180, 220, 255)),
    }
    shimGrad.Rotation = 0

    -- ── ICE CRYSTALS — 4 угловых осколка ────────────────────
    local crystalData = {
        { UDim2.new(0, -1, 0, -1),  "◆",  8, -25, 0.62 },
        { UDim2.new(1, -7, 0, -1),  "◇",  7,  20, 0.65 },
        { UDim2.new(0, -1, 1, -7),  "✦",  6, -40, 0.68 },
        { UDim2.new(1, -6, 1, -6),  "✧",  6,  35, 0.66 },
    }
    local crystals = {}
    for i, cd in ipairs(crystalData) do
        local cr = Instance.new("TextLabel")
        cr.Parent               = root
        cr.Size                 = UDim2.new(0, cd[3], 0, cd[3])
        cr.Position             = cd[1]
        cr.Text                 = cd[2]
        cr.TextSize             = cd[3]
        cr.Font                 = Enum.Font.GothamBold
        cr.BackgroundTransparency = 1
        cr.TextColor3           = ICE.FROST
        cr.TextTransparency     = cd[5]
        cr.Rotation             = cd[4]
        cr.ZIndex               = 13
        crystals[i] = { label = cr, baseTrans = cd[5], baseRot = cd[4] }
    end

    -- ── СНЕГОПАД — 8 частиц ────────────────────────────────
    local snowChars   = { "·", "•", "❄", "❅", "*", "·", "❆", "·" }
    local snowflakes  = {}
    for i = 1, 8 do
        local sf = Instance.new("TextLabel")
        sf.Parent               = root
        sf.Size                 = UDim2.new(0, 8, 0, 8)
        sf.Position             = UDim2.new(rnd(0, 0.92), 0, rnd(-0.2, -0.8), 0)
        sf.Text                 = snowChars[i]
        sf.TextSize             = math.random(4, 8)
        sf.Font                 = Enum.Font.Code
        sf.BackgroundTransparency = 1
        sf.TextColor3           = ICE.FLAKE
        sf.TextTransparency     = rnd(0.35, 0.70)
        sf.ZIndex               = 14
        snowflakes[i] = {
            label  = sf,
            speedY = rnd(0.014, 0.038),
            startX = rnd(0, 0.92),
            wobble = rnd(0, math.pi * 2),
            wSpeed = rnd(0.6, 1.6),
        }
    end

    -- ── ОСНОВНАЯ КНОПКА ──────────────────────────────────────
    local btn = Instance.new("TextButton")
    btn.Name                = "Btn"
    btn.Parent              = root
    btn.Size                = UDim2.new(1, -4, 1, -4)
    btn.Position            = UDim2.new(0, 2, 0, 2)
    btn.Text                = ""
    btn.BackgroundColor3    = ICE.DEEP
    btn.BackgroundTransparency = 0.08
    btn.BorderSizePixel     = 0
    btn.ZIndex              = 15
    btn.AutoButtonColor     = false
    newCorner(btn, CORNER_RADIUS - 1)

    local btnGrad = newGrad(btn, cfg.idleTopColor, cfg.idleBotColor, 112)
    local btnStroke = newStroke(btn, 1.4, cfg.strokeIdle, 0.22)

    -- ── ИКОНКА  (большой символ) ──────────────────────────────
    local icon = Instance.new("TextLabel")
    icon.Parent               = btn
    icon.Size                 = UDim2.new(0, 28, 0, 28)
    icon.Position             = UDim2.new(0.5, -14, 0, 2)
    icon.Text                 = cfg.iconOff
    icon.Font                 = Enum.Font.GothamBlack
    icon.TextScaled           = true
    icon.BackgroundTransparency = 1
    icon.TextColor3           = ICE.FROST
    icon.ZIndex               = 16

    local iconGrad = Instance.new("UIGradient", icon)
    iconGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   ICE.WHITE),
        ColorSequenceKeypoint.new(0.5, ICE.PURE),
        ColorSequenceKeypoint.new(1,   ICE.FROST),
    }
    iconGrad.Rotation = 45

    -- ── ПОДПИСЬ СНИЗУ ─────────────────────────────────────────
    local lbl = Instance.new("TextLabel")
    lbl.Parent               = btn
    lbl.Size                 = UDim2.new(1, 0, 0, 12)
    lbl.Position             = UDim2.new(0, 0, 1, -14)
    lbl.Text                 = cfg.labelText
    lbl.Font                 = Enum.Font.GothamBold
    lbl.TextSize             = 8
    lbl.BackgroundTransparency = 1
    lbl.TextColor3           = ICE.TEXT_DIM
    lbl.ZIndex               = 16
    lbl.TextXAlignment       = Enum.TextXAlignment.Center

    -- ── НИЖНЯЯ ПОЛОСКА ИНДИКАТОРА ────────────────────────────
    local bar = Instance.new("Frame")
    bar.Parent              = btn
    bar.Size                = UDim2.new(0.55, 0, 0, 2)
    bar.Position            = UDim2.new(0.225, 0, 1, -4)
    bar.BackgroundColor3    = ICE.PURE
    bar.BackgroundTransparency = 0.25
    bar.BorderSizePixel     = 0
    bar.ZIndex              = 16
    newCorner(bar, 1)
    newGrad(bar, ICE.WHITE, ICE.PURE, 0)

    return {
        root     = root,
        btn      = btn,
        btnGrad  = btnGrad,
        btnStroke = btnStroke,
        rootGrad = rootGrad,
        rootStroke = rootStroke,
        glow     = glow,
        icon     = icon,
        iconGrad = iconGrad,
        lbl      = lbl,
        bar      = bar,
        shimmer  = shimmer,
        snowflakes = snowflakes,
        crystals = crystals,
    }
end

-- ═══════════════════════════════════════════════════════════════
--  СТРОИМ КНОПКИ
-- ═══════════════════════════════════════════════════════════════

-- ──  V · AIM LOCK  ────────────────────────────────────────────
local AIM = buildSnowButton({
    px            = 0.02,
    py            = 0.60,
    idleTopColor  = Color3.fromRGB( 50, 110, 200),
    idleBotColor  = Color3.fromRGB(  8,  18,  55),
    onTopColor    = ICE.MINT_HOT,
    onBotColor    = ICE.MINT_ABYSS,
    strokeIdle    = ICE.STROKE_IDLE,
    strokeOn      = ICE.STROKE_AIM,
    iconOff       = "❄",
    iconOn        = "🔒",
    labelText     = "V   AIM",
})

-- ──  X · VELOCITY  ────────────────────────────────────────────
local VEL = buildSnowButton({
    px            = 0.02,
    py            = 0.725,
    idleTopColor  = Color3.fromRGB(160,  75,  12),
    idleBotColor  = Color3.fromRGB( 20,   8,   0),
    onTopColor    = ICE.AMBER_HOT,
    onBotColor    = ICE.AMBER_ABYSS,
    strokeIdle    = Color3.fromRGB(200, 100, 10),
    strokeOn      = ICE.STROKE_VEL,
    iconOff       = "⚡",
    iconOn        = "⚡",
    labelText     = "X   VEL",
})

-- ═══════════════════════════════════════════════════════════════
--  ДВИЖОК СНЕГОПАДА  (общий для обеих кнопок)
-- ═══════════════════════════════════════════════════════════════
local snowCharsAll = { "·", "•", "❄", "❅", "*", "❆", "·", "•" }

task.spawn(function()
    local time = 0
    while gui.Parent do
        local dt = task.wait(0.033)
        time = time + dt

        for _, btnData in ipairs({ AIM, VEL }) do
            for _, sf in ipairs(btnData.snowflakes) do
                local lbl = sf.label
                local py  = lbl.Position.Y.Scale + sf.speedY * dt * 30
                local wobX = math.sin(time * sf.wSpeed + sf.wobble) * 0.014
                local px  = sf.startX + wobX

                if py > 1.1 then
                    py          = rnd(-0.15, 0.0)
                    px          = rnd(0, 0.92)
                    sf.startX   = px
                    lbl.Text    = snowCharsAll[math.random(#snowCharsAll)]
                    lbl.TextSize = math.random(4, 8)
                    lbl.TextTransparency = rnd(0.35, 0.70)
                end

                lbl.Position = UDim2.new(px, 0, py, 0)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  ДВИЖОК КРИСТАЛЛОВ  (мерцание + покачивание)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    local time = 0
    while gui.Parent do
        time = time + task.wait(0.04)

        for btnIdx, btnData in ipairs({ AIM, VEL }) do
            for i, cd in ipairs(btnData.crystals) do
                local phase = time * 0.65 + i * 1.1 + btnIdx * 2.3
                local s     = 0.5 + 0.5 * math.sin(phase)
                cd.label.TextTransparency = lerp(cd.baseTrans, cd.baseTrans - 0.28, s)
                cd.label.Rotation         = cd.baseRot + math.sin(phase * 0.8) * 10
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  ДВИЖОК ШИММЕРА  (бегущая полоса света)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    while gui.Parent do
        for _, btnData in ipairs({ AIM, VEL }) do
            TweenSvc:Create(btnData.shimmer, TW.SHINE, {
                Position = UDim2.new(1.4, 0, 0, 0)
            }):Play()
        end
        task.wait(2.0)
        for _, btnData in ipairs({ AIM, VEL }) do
            btnData.shimmer.Position = UDim2.new(-0.35, 0, 0, 0)
        end
        task.wait(rnd(0.8, 2.0))
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  RIPPLE — расширяющееся кольцо при нажатии
-- ═══════════════════════════════════════════════════════════════
local function spawnRipple(parent, x, y, color)
    local ripple = Instance.new("Frame")
    ripple.Parent               = parent
    ripple.Size                 = UDim2.new(0, 6, 0, 6)
    ripple.Position             = UDim2.new(0, x - 3, 0, y - 3)
    ripple.BackgroundColor3     = color or ICE.PURE
    ripple.BackgroundTransparency = 0.30
    ripple.BorderSizePixel      = 0
    ripple.ZIndex               = 18
    newCorner(ripple, 999)

    local sz = 80
    TweenSvc:Create(ripple,
        TweenInfo.new(0.50, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size                 = UDim2.new(0, sz, 0, sz),
            Position             = UDim2.new(0, x - sz/2, 0, y - sz/2),
            BackgroundTransparency = 1.0,
        }
    ):Play()
    game:GetService("Debris"):AddItem(ripple, 0.55)
end

-- ═══════════════════════════════════════════════════════════════
--  FROST BURST — осколки льда разлетаются при нажатии
-- ═══════════════════════════════════════════════════════════════
local burstChars = { "❄", "·", "✦", "◆", "❅", "◇", "*", "❆" }

local function spawnFrostBurst(parent, color)
    local cx, cy = 36, 22   -- центр кнопки примерно
    for i = 1, 6 do
        local angle = (i - 1) * (math.pi * 2 / 6) + rnd(-0.3, 0.3)
        local dist  = rnd(14, 30)
        local tx    = cx + math.cos(angle) * dist
        local ty    = cy + math.sin(angle) * dist

        local shard = Instance.new("TextLabel")
        shard.Parent               = parent
        shard.Size                 = UDim2.new(0, 9, 0, 9)
        shard.Position             = UDim2.new(0, cx - 4, 0, cy - 4)
        shard.Text                 = burstChars[math.random(#burstChars)]
        shard.TextSize             = math.random(6, 10)
        shard.Font                 = Enum.Font.GothamBold
        shard.BackgroundTransparency = 1
        shard.TextColor3           = color or ICE.PURE
        shard.TextTransparency     = 0
        shard.ZIndex               = 19
        shard.Rotation             = math.random(0, 360)

        TweenSvc:Create(shard,
            TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position         = UDim2.new(0, tx - 4, 0, ty - 4),
                TextTransparency = 1,
                Rotation         = shard.Rotation + math.random(80, 240),
            }
        ):Play()
        game:GetService("Debris"):AddItem(shard, 0.55)
    end
end

-- ═══════════════════════════════════════════════════════════════
--  АНИМАЦИЯ НАЖАТИЯ (press down / up)
-- ═══════════════════════════════════════════════════════════════
local pressStates = { [AIM] = false, [VEL] = false }

local function onPressDown(btnData, lx, ly)
    if pressStates[btnData] then return end
    pressStates[btnData] = true

    tw(btnData.root, TW.SNAP, {
        Size     = UDim2.new(0, 68, 0, 41),
        Position = UDim2.new(
            btnData.root.Position.X.Scale,
            btnData.root.Position.X.Offset + 2,
            btnData.root.Position.Y.Scale,
            btnData.root.Position.Y.Offset + 1
        )
    })
    tw(btnData.btn, TW.SNAP, { BackgroundTransparency = 0.28 })
end

local function onPressUp(btnData)
    if not pressStates[btnData] then return end
    pressStates[btnData] = false

    tw(btnData.root, TW.BOUNCE, {
        Size     = UDim2.new(0, 72, 0, 44),
        Position = UDim2.new(
            btnData.root.Position.X.Scale,
            btnData.root.Position.X.Offset - 2,
            btnData.root.Position.Y.Scale,
            btnData.root.Position.Y.Offset - 1
        )
    })
    tw(btnData.btn, TW.SNAP, { BackgroundTransparency = 0.08 })
end

-- ═══════════════════════════════════════════════════════════════
--  ВИЗУАЛЬНОЕ ОБНОВЛЕНИЕ КНОПКИ  (ON / OFF)
-- ═══════════════════════════════════════════════════════════════

-- Состояния
local aimVisualOn = false
local velVisualOn = false

local function setAimVisual(on)
    if on == aimVisualOn then return end
    aimVisualOn = on

    spawnFrostBurst(AIM.btn, on and ICE.MINT_HOT or ICE.PURE)

    if on then
        -- Кнопка → мятная
        tw(AIM.btnGrad, TW.FAST, {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ICE.MINT_HOT),
                ColorSequenceKeypoint.new(1, ICE.MINT_ABYSS),
            }
        })
        tw(AIM.btnStroke,   TW.FAST, { Color = ICE.STROKE_AIM,  Transparency = 0 })
        tw(AIM.rootStroke,  TW.FAST, { Color = ICE.STROKE_AIM,  Transparency = 0 })
        tw(AIM.rootGrad,    TW.MED,  {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(  0, 50, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(  0, 14, 11)),
            }
        })
        tw(AIM.glow,        TW.MED,  { BackgroundColor3 = ICE.MINT_HOT, BackgroundTransparency = 0.78 })
        tw(AIM.icon,        TW.FAST, { TextColor3 = ICE.TEXT_WHITE })
        tw(AIM.lbl,         TW.FAST, { TextColor3 = ICE.MINT_HOT })
        tw(AIM.bar,         TW.MED,  { BackgroundColor3 = ICE.MINT_HOT })
        AIM.icon.Text = "🔒"

        -- Пульсация ореола
        task.spawn(function()
            while aimVisualOn and gui.Parent do
                tw(AIM.glow, TW.PULSE, { BackgroundTransparency = 0.70 })
                task.wait(0.80)
                if not aimVisualOn then break end
                tw(AIM.glow, TW.PULSE, { BackgroundTransparency = 0.84 })
                task.wait(0.80)
            end
        end)
    else
        -- Кнопка → ледяная
        tw(AIM.btnGrad, TW.FAST, {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB( 50, 110, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(  8,  18,  55)),
            }
        })
        tw(AIM.btnStroke,   TW.FAST, { Color = ICE.STROKE_IDLE, Transparency = 0.22 })
        tw(AIM.rootStroke,  TW.FAST, { Color = ICE.STROKE_IDLE, Transparency = 0.18 })
        tw(AIM.rootGrad,    TW.MED,  {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 36, 82)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB( 4,  8, 24)),
            }
        })
        tw(AIM.glow,        TW.MED,  { BackgroundColor3 = ICE.STROKE_IDLE, BackgroundTransparency = 1.0 })
        tw(AIM.icon,        TW.FAST, { TextColor3 = ICE.FROST })
        tw(AIM.lbl,         TW.FAST, { TextColor3 = ICE.TEXT_DIM })
        tw(AIM.bar,         TW.MED,  { BackgroundColor3 = ICE.PURE })
        AIM.icon.Text = "❄"
    end
end

local function setVelVisual(on)
    if on == velVisualOn then return end
    velVisualOn = on

    spawnFrostBurst(VEL.btn, on and ICE.AMBER_HOT or Color3.fromRGB(200,110,20))

    if on then
        tw(VEL.btnGrad, TW.FAST, {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ICE.AMBER_HOT),
                ColorSequenceKeypoint.new(1, ICE.AMBER_ABYSS),
            }
        })
        tw(VEL.btnStroke,   TW.FAST, { Color = ICE.STROKE_VEL,  Transparency = 0 })
        tw(VEL.rootStroke,  TW.FAST, { Color = ICE.STROKE_VEL,  Transparency = 0 })
        tw(VEL.rootGrad,    TW.MED,  {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB( 70, 40,  0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB( 18,  9,  0)),
            }
        })
        tw(VEL.glow,        TW.MED,  { BackgroundColor3 = ICE.AMBER_HOT, BackgroundTransparency = 0.76 })
        tw(VEL.icon,        TW.FAST, { TextColor3 = ICE.TEXT_WHITE })
        tw(VEL.lbl,         TW.FAST, { TextColor3 = ICE.AMBER_HOT })
        tw(VEL.bar,         TW.MED,  { BackgroundColor3 = ICE.AMBER_HOT })

        task.spawn(function()
            while velVisualOn and gui.Parent do
                tw(VEL.glow, TW.PULSE, { BackgroundTransparency = 0.68 })
                task.wait(0.60)
                if not velVisualOn then break end
                tw(VEL.glow, TW.PULSE, { BackgroundTransparency = 0.80 })
                task.wait(0.60)
            end
        end)
    else
        tw(VEL.btnGrad, TW.FAST, {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 75, 12)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB( 20,  8,  0)),
            }
        })
        tw(VEL.btnStroke,   TW.FAST, { Color = Color3.fromRGB(200,100,10), Transparency = 0.22 })
        tw(VEL.rootStroke,  TW.FAST, { Color = Color3.fromRGB(200,100,10), Transparency = 0.18 })
        tw(VEL.rootGrad,    TW.MED,  {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 36, 82)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB( 4,  8, 24)),
            }
        })
        tw(VEL.glow,        TW.MED,  { BackgroundColor3 = Color3.fromRGB(200,100,10), BackgroundTransparency = 1.0 })
        tw(VEL.icon,        TW.FAST, { TextColor3 = ICE.FROST })
        tw(VEL.lbl,         TW.FAST, { TextColor3 = ICE.TEXT_DIM })
        tw(VEL.bar,         TW.MED,  { BackgroundColor3 = ICE.PURE })
    end
end

-- ═══════════════════════════════════════════════════════════════
--  DRAG — ОРИГИНАЛЬНАЯ ЛОГИКА v2  (перетаскивание по root)
-- ═══════════════════════════════════════════════════════════════
local function makeDraggable(btnData)
    local dragging = false
    local dragStart, startPos = nil, nil
    local moved = false

    btnData.root.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = i.Position
            startPos  = btnData.root.Position
            moved     = false

            -- Нажатие
            local abs = btnData.btn.AbsolutePosition
            local lx  = i.Position.X - abs.X
            local ly  = i.Position.Y - abs.Y
            onPressDown(btnData, lx, ly)

            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    onPressUp(btnData)
                end
            end)
        end
    end)

    btnData.root.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch
                      or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = i.Position - dragStart
            if d.Magnitude > 8 then moved = true end
            btnData.root.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + d.X,
                startPos.Y.Scale,
                startPos.Y.Offset + d.Y
            )
            -- двигаем ореол синхронно
            btnData.glow.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + d.X - 10,
                startPos.Y.Scale,
                startPos.Y.Offset + d.Y - 9
            )
        end
    end)

    return function() return moved end  -- wasMovedFn — как в v2
end

local aimMoved = makeDraggable(AIM)
local velMoved = makeDraggable(VEL)

-- ═══════════════════════════════════════════════════════════════
--  ТРЕКИНГ КАСАНИЯ ИГРОВОЙ ЗОНЫ  — ОРИГИНАЛЬНАЯ ЛОГИКА v2
-- ═══════════════════════════════════════════════════════════════
local lastGameTouchPos = nil

local function isOnButton(pos)
    local function hitTest(root)
        local abs = root.AbsolutePosition
        local sz  = root.AbsoluteSize
        return pos.X >= abs.X and pos.X <= abs.X + sz.X
           and pos.Y >= abs.Y and pos.Y <= abs.Y + sz.Y
    end
    return hitTest(AIM.root) or hitTest(VEL.root)
end

UIS.TouchStarted:Connect(function(touch, _gp)
    local pos = Vector2.new(touch.Position.X, touch.Position.Y)
    if not isOnButton(pos) then
        lastGameTouchPos       = pos
        _G.AntiEmoLastTouchPos = pos
    end
end)

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = Vector2.new(i.Position.X, i.Position.Y)
        if not isOnButton(pos) then
            lastGameTouchPos       = pos
            _G.AntiEmoLastTouchPos = pos
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ  — ОРИГИНАЛЬНАЯ ЛОГИКА v2
-- ═══════════════════════════════════════════════════════════════
local function isAlive(p)
    if not p.Character then return false end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getNearestToScreenPos(screenPos)
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
--  REFRESH ФУНКЦИИ  — ОРИГИНАЛЬНАЯ ЛОГИКА v2
-- ═══════════════════════════════════════════════════════════════
local function refreshAim()
    local on = API.isLocked()
    setAimVisual(on)
end

local function refreshVel()
    local on = API.isVelOn() or API.isVelArmed()
    setVelVisual(on)
end

-- ═══════════════════════════════════════════════════════════════
--  НАЖАТИЯ  — ОРИГИНАЛЬНАЯ ЛОГИКА v2
-- ═══════════════════════════════════════════════════════════════

-- Ripple при нажатии кнопок
AIM.btn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        local abs = AIM.btn.AbsolutePosition
        spawnRipple(AIM.btn,
            i.Position.X - abs.X,
            i.Position.Y - abs.Y,
            aimVisualOn and ICE.MINT_HOT or ICE.PURE
        )
    end
end)

VEL.btn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        local abs = VEL.btn.AbsolutePosition
        spawnRipple(VEL.btn,
            i.Position.X - abs.X,
            i.Position.Y - abs.Y,
            velVisualOn and ICE.AMBER_HOT or ICE.PURE
        )
    end
end)

-- Основные обработчики нажатий — 100% логика из v2
AIM.btn.MouseButton1Click:Connect(function()
    if aimMoved() then return end  -- это было перетаскивание, не клик

    local touchPos = lastGameTouchPos or UIS:GetMouseLocation()
    local target   = getNearestToScreenPos(touchPos)

    if API.isLocked() then
        -- уже залочен — снимаем лок
        API.toggleAimLock()
    elseif target and API.lockOnPlayer then
        -- есть lockOnPlayer → используем его
        API.lockOnPlayer(target)
    else
        -- fallback
        API.toggleAimLock()
    end

    refreshAim()
end)

VEL.btn.MouseButton1Click:Connect(function()
    if velMoved() then return end

    API.triggerVelocity()
    refreshVel()
end)

-- ═══════════════════════════════════════════════════════════════
--  СИНХРОНИЗАЦИЯ  — ОРИГИНАЛЬНАЯ ЛОГИКА v2 (каждые 0.4 сек)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.4) do
        if not gui.Parent then break end
        refreshAim()
        refreshVel()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  АНИМАЦИЯ ПОЯВЛЕНИЯ  (слайд снизу + мерцание)
-- ═══════════════════════════════════════════════════════════════
do
    -- Начальное скрытое состояние
    for _, btnData in ipairs({ AIM, VEL }) do
        local op = btnData.root.Position
        btnData.root.Position = UDim2.new(op.X.Scale, op.X.Offset,
                                          op.Y.Scale, op.Y.Offset + 100)
        btnData.root.BackgroundTransparency = 1.0
        btnData.btn.BackgroundTransparency  = 1.0
        btnData.icon.TextTransparency       = 1.0
        btnData.lbl.TextTransparency        = 1.0
        for _, cd in ipairs(btnData.crystals) do
            cd.label.TextTransparency = 1.0
        end
    end

    -- AIM поднимается первой
    task.wait(0.20)
    do
        local op = AIM.root.Position
        tw(AIM.root, TW.RISE, {
            Position             = UDim2.new(op.X.Scale, op.X.Offset, op.Y.Scale, op.Y.Offset - 100),
            BackgroundTransparency = 0.10,
        })
        tw(AIM.btn,  TW.MED,  { BackgroundTransparency = 0.08 })
        tw(AIM.icon, TW.BOUNCE, { TextTransparency = 0 })
        tw(AIM.lbl,  TW.MED,  { TextTransparency = 0 })
        -- кристаллы по очереди
        for i, cd in ipairs(AIM.crystals) do
            delay(i * 0.05, function()
                tw(cd.label, TW.SPRING, { TextTransparency = cd.baseTrans })
            end)
        end
        -- ripple приветствие
        delay(0.35, function()
            spawnRipple(AIM.btn, 36, 22, ICE.PURE)
        end)
    end

    -- VEL поднимается с небольшой задержкой
    task.wait(0.15)
    do
        local op = VEL.root.Position
        tw(VEL.root, TW.RISE, {
            Position             = UDim2.new(op.X.Scale, op.X.Offset, op.Y.Scale, op.Y.Offset - 100),
            BackgroundTransparency = 0.10,
        })
        tw(VEL.btn,  TW.MED,  { BackgroundTransparency = 0.08 })
        tw(VEL.icon, TW.BOUNCE, { TextTransparency = 0 })
        tw(VEL.lbl,  TW.MED,  { TextTransparency = 0 })
        for i, cd in ipairs(VEL.crystals) do
            delay(i * 0.05, function()
                tw(cd.label, TW.SPRING, { TextTransparency = cd.baseTrans })
            end)
        end
        delay(0.35, function()
            spawnRipple(VEL.btn, 36, 22, Color3.fromRGB(200, 130, 20))
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
print("[SnowButtons v5] ✓  ❄  Готово.")
print("  V (❄) = AimLock на ближайшего к касанию")
print("  X (⚡) = Velocity")
