-- AnimationLogger.lua
-- LocalScript — помести в StarterPlayerScripts или StarterCharacterScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════════
--  НАСТРОЙКИ
-- ══════════════════════════════════════════════
local MAX_LOG_ENTRIES = 200          -- максимум строк в логе
local BLACKLIST_SAVE_KEY = "AnimLoggerBlacklist"

-- ══════════════════════════════════════════════
--  СОСТОЯНИЕ
-- ══════════════════════════════════════════════
local logEntries   = {}   -- { text, id, trackId, animName }
local blacklist    = {}   -- set: animId -> true
local trackedAnims = {}   -- trackId -> { anim, label, active }
local trackIdCounter = 0

-- ══════════════════════════════════════════════
--  GUI
-- ══════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "AnimationLogger"
screenGui.ResetOnSpawn    = false
screenGui.IgnoreGuiInset  = true
screenGui.DisplayOrder    = 999
screenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
screenGui.Parent          = PlayerGui

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name             = "MainFrame"
mainFrame.Size             = UDim2.new(0, 420, 0, 560)
mainFrame.Position         = UDim2.new(0, 20, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
mainFrame.BorderSizePixel  = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent           = screenGui

-- Скруглённые углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent       = mainFrame

-- Тонкая акцентная полоска сверху
local accent = Instance.new("Frame")
accent.Size             = UDim2.new(1, 0, 0, 2)
accent.Position         = UDim2.new(0, 0, 0, 0)
accent.BackgroundColor3 = Color3.fromRGB(0, 210, 140)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
accent.Parent           = mainFrame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 8)
accentCorner.Parent       = accent

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Name               = "Shadow"
shadow.Size               = UDim2.new(1, 40, 1, 40)
shadow.Position           = UDim2.new(0, -20, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image              = "rbxassetid://5554236805"
shadow.ImageColor3        = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency  = 0.5
shadow.ScaleType          = Enum.ScaleType.Slice
shadow.SliceCenter        = Rect.new(23, 23, 277, 277)
shadow.ZIndex             = 0
shadow.Parent             = mainFrame

-- ──────────────────────────────────────────────
--  ЗАГОЛОВОК (drag handle)
-- ──────────────────────────────────────────────
local titleBar = Instance.new("Frame")
titleBar.Name             = "TitleBar"
titleBar.Size             = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 3
titleBar.Parent           = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent       = titleBar

-- нижние углы заголовка прямые
local titleFix = Instance.new("Frame")
titleFix.Size             = UDim2.new(1, 0, 0.5, 0)
titleFix.Position         = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleFix.BorderSizePixel  = 0
titleFix.ZIndex           = 3
titleFix.Parent           = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text              = "⬡  ANIM LOGGER"
titleLabel.Size              = UDim2.new(1, -100, 1, 0)
titleLabel.Position          = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3        = Color3.fromRGB(0, 210, 140)
titleLabel.Font              = Enum.Font.Code
titleLabel.TextSize          = 13
titleLabel.TextXAlignment    = Enum.TextXAlignment.Left
titleLabel.ZIndex            = 4
titleLabel.Parent            = titleBar

-- Кнопка скрыть/показать
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text              = "▼"
toggleBtn.Size              = UDim2.new(0, 28, 0, 22)
toggleBtn.Position          = UDim2.new(1, -92, 0.5, -11)
toggleBtn.BackgroundColor3  = Color3.fromRGB(30, 30, 40)
toggleBtn.TextColor3        = Color3.fromRGB(180, 180, 200)
toggleBtn.Font              = Enum.Font.Code
toggleBtn.TextSize          = 11
toggleBtn.BorderSizePixel   = 0
toggleBtn.ZIndex            = 4
toggleBtn.Parent            = titleBar

local togBtnCorner = Instance.new("UICorner")
togBtnCorner.CornerRadius = UDim.new(0, 4)
togBtnCorner.Parent       = toggleBtn

-- Кнопка очистить
local clearBtn = Instance.new("TextButton")
clearBtn.Text             = "CLR"
clearBtn.Size             = UDim2.new(0, 32, 0, 22)
clearBtn.Position         = UDim2.new(1, -58, 0.5, -11)
clearBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
clearBtn.TextColor3       = Color3.fromRGB(255, 100, 100)
clearBtn.Font             = Enum.Font.Code
clearBtn.TextSize         = 11
clearBtn.BorderSizePixel  = 0
clearBtn.ZIndex           = 4
clearBtn.Parent           = titleBar

local clrCorner = Instance.new("UICorner")
clrCorner.CornerRadius = UDim.new(0, 4)
clrCorner.Parent       = clearBtn

-- ──────────────────────────────────────────────
--  ТЕЛО (скроллируемый лог)
-- ──────────────────────────────────────────────
local body = Instance.new("Frame")
body.Name             = "Body"
body.Size             = UDim2.new(1, 0, 1, -38)
body.Position         = UDim2.new(0, 0, 0, 38)
body.BackgroundTransparency = 1
body.ClipsDescendants = true
body.ZIndex           = 2
body.Parent           = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name             = "ScrollFrame"
scrollFrame.Size             = UDim2.new(1, -6, 1, -6)
scrollFrame.Position         = UDim2.new(0, 3, 0, 3)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel  = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 140)
scrollFrame.CanvasSize       = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ZIndex            = 2
scrollFrame.Parent            = body

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder    = Enum.SortOrder.LayoutOrder
listLayout.Padding      = UDim.new(0, 2)
listLayout.Parent       = scrollFrame

local listPad = Instance.new("UIPadding")
listPad.PaddingLeft   = UDim.new(0, 6)
listPad.PaddingRight  = UDim.new(0, 6)
listPad.PaddingTop    = UDim.new(0, 4)
listPad.PaddingBottom = UDim.new(0, 4)
listPad.Parent        = scrollFrame

-- ══════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════
local function isBlacklisted(id)
    return blacklist[tostring(id)] == true
end

local function getAnimName(anim)
    -- Пробуем взять Name с самого трека, или с AnimationId
    local ok, res = pcall(function()
        return anim.Animation and anim.Animation.Name or ""
    end)
    if ok and res ~= "" and res ~= "Animation" then return res end
    ok, res = pcall(function()
        return anim.Name or ""
    end)
    if ok and res ~= "" then return res end
    return "?"
end

local function getAnimId(anim)
    local ok, id = pcall(function()
        return anim.Animation and anim.Animation.AnimationId or ""
    end)
    if ok and id ~= "" then return id end
    -- AnimationTrack иногда имеет .AnimationId напрямую
    ok, id = pcall(function() return anim.AnimationId or "" end)
    if ok and id ~= "" then return id end
    return "rbxassetid://0"
end

local function shortId(fullId)
    return fullId:match("%d+") or fullId
end

-- ──────────────────────────────────────────────
--  Добавить строку в лог
-- ──────────────────────────────────────────────
local function addLogRow(data)
    -- data = { text, animId, trackId, event }
    if isBlacklisted(data.animId) then return end

    -- Цвет по событию
    local color = Color3.fromRGB(160, 160, 180)
    if data.event == "PLAY"  then color = Color3.fromRGB(80, 220, 140) end
    if data.event == "STOP"  then color = Color3.fromRGB(220, 90, 90)  end
    if data.event == "LOOP"  then color = Color3.fromRGB(80, 170, 255) end

    -- Удаляем старые строки
    if #logEntries >= MAX_LOG_ENTRIES then
        local oldest = table.remove(logEntries, 1)
        if oldest.row and oldest.row.Parent then
            oldest.row:Destroy()
        end
    end

    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    row.BorderSizePixel  = 0
    row.LayoutOrder      = #logEntries + 1
    row.ClipsDescendants = false
    row.Parent           = scrollFrame

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 4)
    rowCorner.Parent       = row

    -- Цветная полоска слева
    local bar = Instance.new("Frame")
    bar.Size             = UDim2.new(0, 3, 1, -4)
    bar.Position         = UDim2.new(0, 0, 0, 2)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel  = 0
    bar.Parent           = row
    local barC = Instance.new("UICorner")
    barC.CornerRadius = UDim.new(0, 2)
    barC.Parent = bar

    -- Метка события
    local evLabel = Instance.new("TextLabel")
    evLabel.Text      = data.event
    evLabel.Size      = UDim2.new(0, 38, 1, 0)
    evLabel.Position  = UDim2.new(0, 6, 0, 0)
    evLabel.BackgroundTransparency = 1
    evLabel.TextColor3 = color
    evLabel.Font       = Enum.Font.Code
    evLabel.TextSize   = 10
    evLabel.TextXAlignment = Enum.TextXAlignment.Left
    evLabel.Parent     = row

    -- Текст
    local lbl = Instance.new("TextLabel")
    lbl.Text      = data.text
    lbl.Size      = UDim2.new(1, -120, 1, 0)
    lbl.Position  = UDim2.new(0, 48, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 200, 215)
    lbl.Font       = Enum.Font.Code
    lbl.TextSize   = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent     = row

    -- Кнопка "Копировать ID"
    local copyBtn = Instance.new("TextButton")
    copyBtn.Text             = "⧉"
    copyBtn.Size             = UDim2.new(0, 22, 0, 18)
    copyBtn.Position         = UDim2.new(1, -50, 0.5, -9)
    copyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    copyBtn.TextColor3       = Color3.fromRGB(0, 210, 140)
    copyBtn.Font             = Enum.Font.Code
    copyBtn.TextSize         = 12
    copyBtn.BorderSizePixel  = 0
    copyBtn.ZIndex           = 3
    copyBtn.Parent           = row

    local cpC = Instance.new("UICorner")
    cpC.CornerRadius = UDim.new(0, 3)
    cpC.Parent = copyBtn

    -- Кнопка "Блеклист"
    local blBtn = Instance.new("TextButton")
    blBtn.Text             = "✕"
    blBtn.Size             = UDim2.new(0, 22, 0, 18)
    blBtn.Position         = UDim2.new(1, -25, 0.5, -9)
    blBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
    blBtn.TextColor3       = Color3.fromRGB(255, 80, 80)
    blBtn.Font             = Enum.Font.Code
    blBtn.TextSize         = 12
    blBtn.BorderSizePixel  = 0
    blBtn.ZIndex           = 3
    blBtn.Parent           = row

    local blC = Instance.new("UICorner")
    blC.CornerRadius = UDim.new(0, 3)
    blC.Parent = blBtn

    -- Копировать
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(data.animId)
        copyBtn.Text = "✓"
        task.delay(1.2, function()
            if copyBtn and copyBtn.Parent then
                copyBtn.Text = "⧉"
            end
        end)
    end)

    -- Блеклист: скрываем все строки с этим ID
    blBtn.MouseButton1Click:Connect(function()
        blacklist[tostring(data.animId)] = true
        -- Убираем все строки с этим ID
        for _, entry in ipairs(logEntries) do
            if tostring(entry.animId) == tostring(data.animId) and entry.row and entry.row.Parent then
                entry.row:Destroy()
            end
        end
    end)

    local entry = {
        text   = data.text,
        animId = data.animId,
        trackId = data.trackId,
        event  = data.event,
        row    = row,
    }
    table.insert(logEntries, entry)

    -- Авто-скролл вниз
    task.defer(function()
        scrollFrame.CanvasPosition = Vector2.new(0, math.huge)
    end)
end

-- ══════════════════════════════════════════════
--  ОТСЛЕЖИВАНИЕ ТРЕКОВ
-- ══════════════════════════════════════════════
local function hookTrack(track)
    local animId   = getAnimId(track)
    local animName = getAnimName(track)
    local sid      = shortId(animId)

    if isBlacklisted(animId) then return end

    trackIdCounter += 1
    local tid = trackIdCounter

    local function logEvent(ev)
        addLogRow({
            text    = string.format("[%s] %s  •  id:%s", animName, ev, sid),
            animId  = animId,
            trackId = tid,
            event   = ev,
        })
    end

    track:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        logEvent(track.IsPlaying and "PLAY" or "STOP")
    end)

    -- Looped
    track.DidLoop:Connect(function()
        logEvent("LOOP")
    end)

    -- Первичный лог при первом подключении
    if track.IsPlaying then
        logEvent("PLAY")
    end
end

-- ──────────────────────────────────────────────
--  Подключаемся к Animator
-- ──────────────────────────────────────────────
local function hookAnimator(animator)
    -- Уже играющие треки
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        hookTrack(track)
    end

    -- Новые треки
    animator.AnimationPlayed:Connect(function(track)
        hookTrack(track)
    end)
end

local function hookCharacter(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 10)
    end
    if not animator then return end

    hookAnimator(animator)
end

-- Текущий персонаж
if LocalPlayer.Character then
    task.spawn(hookCharacter, LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(hookCharacter)

-- ══════════════════════════════════════════════
--  DRAG (перетаскивание окна)
-- ══════════════════════════════════════════════
do
    local dragging    = false
    local dragStart   = Vector2.zero
    local frameStart  = Vector2.zero

    titleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            dragStart  = Vector2.new(inp.Position.X, inp.Position.Y)
            frameStart = Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = Vector2.new(inp.Position.X - dragStart.X, inp.Position.Y - dragStart.Y)
            mainFrame.Position = UDim2.new(0, frameStart.X + delta.X, 0, frameStart.Y + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ══════════════════════════════════════════════
--  TOGGLE (скрыть / показать тело)
-- ══════════════════════════════════════════════
local bodyVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    bodyVisible = not bodyVisible
    body.Visible   = bodyVisible
    mainFrame.Size = bodyVisible
        and UDim2.new(0, 420, 0, 560)
        or  UDim2.new(0, 420, 0, 38)
    toggleBtn.Text = bodyVisible and "▼" or "▲"
end)

-- ══════════════════════════════════════════════
--  CLEAR
-- ══════════════════════════════════════════════
clearBtn.MouseButton1Click:Connect(function()
    for _, entry in ipairs(logEntries) do
        if entry.row and entry.row.Parent then
            entry.row:Destroy()
        end
    end
    logEntries = {}
end)

-- ══════════════════════════════════════════════
--  BLACKLIST VIEWER (Shift+B открывает список)
-- ══════════════════════════════════════════════
local function openBlacklistPanel()
    -- Удаляем старую панель если есть
    local old = screenGui:FindFirstChild("BlacklistPanel")
    if old then old:Destroy(); return end

    local panel = Instance.new("Frame")
    panel.Name             = "BlacklistPanel"
    panel.Size             = UDim2.new(0, 300, 0, 240)
    panel.Position         = UDim2.new(0, 450, 0, 60)
    panel.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
    panel.BorderSizePixel  = 0
    panel.ZIndex           = 10
    panel.Parent           = screenGui

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 8)
    pCorner.Parent = panel

    local pTitle = Instance.new("TextLabel")
    pTitle.Text      = "⛔  BLACKLIST  (Shift+B)"
    pTitle.Size      = UDim2.new(1, 0, 0, 30)
    pTitle.BackgroundColor3 = Color3.fromRGB(20, 14, 28)
    pTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
    pTitle.Font       = Enum.Font.Code
    pTitle.TextSize   = 11
    pTitle.BorderSizePixel = 0
    pTitle.ZIndex     = 11
    pTitle.Parent     = panel

    local ptC = Instance.new("UICorner")
    ptC.CornerRadius = UDim.new(0, 8)
    ptC.Parent = pTitle

    local ptFix = Instance.new("Frame")
    ptFix.Size = UDim2.new(1,0,0.5,0)
    ptFix.Position = UDim2.new(0,0,0.5,0)
    ptFix.BackgroundColor3 = Color3.fromRGB(20, 14, 28)
    ptFix.BorderSizePixel = 0
    ptFix.ZIndex = 11
    ptFix.Parent = pTitle

    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size   = UDim2.new(1, -6, 1, -36)
    pScroll.Position = UDim2.new(0, 3, 0, 33)
    pScroll.BackgroundTransparency = 1
    pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 3
    pScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 80)
    pScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pScroll.CanvasSize = UDim2.new(0,0,0,0)
    pScroll.ZIndex = 11
    pScroll.Parent = panel

    local pList = Instance.new("UIListLayout")
    pList.SortOrder = Enum.SortOrder.LayoutOrder
    pList.Padding   = UDim.new(0, 2)
    pList.Parent    = pScroll

    local pPad = Instance.new("UIPadding")
    pPad.PaddingLeft = UDim.new(0,4); pPad.PaddingRight = UDim.new(0,4)
    pPad.PaddingTop  = UDim.new(0,2)
    pPad.Parent = pScroll

    local hasAny = false
    for id, _ in pairs(blacklist) do
        hasAny = true
        local bRow = Instance.new("Frame")
        bRow.Size = UDim2.new(1,0,0,24)
        bRow.BackgroundColor3 = Color3.fromRGB(20,16,24)
        bRow.BorderSizePixel = 0
        bRow.ZIndex = 12
        bRow.Parent = pScroll

        local bC = Instance.new("UICorner"); bC.CornerRadius = UDim.new(0,4); bC.Parent = bRow

        local bLbl = Instance.new("TextLabel")
        bLbl.Text = id
        bLbl.Size = UDim2.new(1,-30,1,0)
        bLbl.Position = UDim2.new(0,6,0,0)
        bLbl.BackgroundTransparency = 1
        bLbl.TextColor3 = Color3.fromRGB(180,160,180)
        bLbl.Font = Enum.Font.Code
        bLbl.TextSize = 9
        bLbl.TextXAlignment = Enum.TextXAlignment.Left
        bLbl.TextTruncate = Enum.TextTruncate.AtEnd
        bLbl.ZIndex = 12
        bLbl.Parent = bRow

        local unblBtn = Instance.new("TextButton")
        unblBtn.Text = "✓"
        unblBtn.Size = UDim2.new(0,22,0,18)
        unblBtn.Position = UDim2.new(1,-24,0.5,-9)
        unblBtn.BackgroundColor3 = Color3.fromRGB(20,40,20)
        unblBtn.TextColor3 = Color3.fromRGB(80,220,80)
        unblBtn.Font = Enum.Font.Code
        unblBtn.TextSize = 12
        unblBtn.BorderSizePixel = 0
        unblBtn.ZIndex = 13
        unblBtn.Parent = bRow

        local ubC = Instance.new("UICorner"); ubC.CornerRadius = UDim.new(0,3); ubC.Parent = unblBtn

        unblBtn.MouseButton1Click:Connect(function()
            blacklist[id] = nil
            bRow:Destroy()
        end)
    end

    if not hasAny then
        local empty = Instance.new("TextLabel")
        empty.Text = "Блеклист пуст"
        empty.Size = UDim2.new(1,0,0,30)
        empty.BackgroundTransparency = 1
        empty.TextColor3 = Color3.fromRGB(100,100,120)
        empty.Font = Enum.Font.Code
        empty.TextSize = 11
        empty.ZIndex = 12
        empty.Parent = pScroll
    end

    -- drag panel
    local pdrag, pdStart, pfStart = false, Vector2.zero, Vector2.zero
    pTitle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            pdrag  = true
            pdStart = Vector2.new(inp.Position.X, inp.Position.Y)
            pfStart = Vector2.new(panel.Position.X.Offset, panel.Position.Y.Offset)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not pdrag then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = Vector2.new(inp.Position.X - pdStart.X, inp.Position.Y - pdStart.Y)
            panel.Position = UDim2.new(0, pfStart.X + d.X, 0, pfStart.Y + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then pdrag = false end
    end)
end

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.B and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        openBlacklistPanel()
    end
end)

-- ══════════════════════════════════════════════
--  ГОТОВО
-- ══════════════════════════════════════════════
addLogRow({
    text    = "Logger запущен. Shift+B = блеклист",
    animId  = "rbxassetid://0",
    trackId = 0,
    event   = "INFO",
})
