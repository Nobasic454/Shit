-- ╔══════════════════════════════════════════════════════════════╗
-- ║            PREMIUM LUA CONSOLE  •  GLOBAL HOOK              ║
-- ║   print / warn / error перехватываются ИЗ ВСЕХ ПОТОКОВ      ║
-- ╚══════════════════════════════════════════════════════════════╝
-- Версия: 3.0  |  getgenv() hook  |  setfenv fallback env

-- ── Очистка предыдущей копии ─────────────────────────────────
do
	local cg = game:GetService("CoreGui")
	local old = cg:FindFirstChild("PremiumConsole3")
	if old then old:Destroy() end
end

-- ── Сервисы ──────────────────────────────────────────────────
local Players   = game:GetService("Players")
local CoreGui   = game:GetService("CoreGui")
local UIS       = game:GetService("UserInputService")
local lp        = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════
--  ЦВЕТА
-- ══════════════════════════════════════════════════════════════
local C = {
	bg       = Color3.fromRGB(12, 12, 14),
	bar      = Color3.fromRGB(20, 20, 24),
	panel    = Color3.fromRGB(17, 17, 20),
	btn      = Color3.fromRGB(34, 34, 40),
	btnHov   = Color3.fromRGB(52, 52, 62),
	accent   = Color3.fromRGB(0, 200, 100),
	accentR  = Color3.fromRGB(200, 50, 50),
	accentB  = Color3.fromRGB(50, 130, 230),
	accentY  = Color3.fromRGB(220, 170, 0),
	accentP  = Color3.fromRGB(160, 80, 240),
	text     = Color3.fromRGB(215, 215, 215),
	dim      = Color3.fromRGB(90, 90, 100),
	sel      = Color3.fromRGB(35, 70, 150),
	white    = Color3.new(1, 1, 1),
	green    = Color3.fromRGB(80, 255, 130),
	yellow   = Color3.fromRGB(255, 210, 50),
	red      = Color3.fromRGB(255, 80, 80),
	blue     = Color3.fromRGB(90, 180, 255),
	cyan     = Color3.fromRGB(0, 220, 220),
	gray     = Color3.fromRGB(110, 110, 120),
	inputBg  = Color3.fromRGB(18, 18, 22),
	border   = Color3.fromRGB(45, 45, 55),
}

-- ══════════════════════════════════════════════════════════════
--  ХЕЛПЕРЫ UI
-- ══════════════════════════════════════════════════════════════
local function corner(obj, r)
	local c = Instance.new("UICorner", obj)
	c.CornerRadius = UDim.new(0, r or 5)
	return c
end
local function pad(obj, l, r, t, b)
	local p = Instance.new("UIPadding", obj)
	p.PaddingLeft   = UDim.new(0, l or 0)
	p.PaddingRight  = UDim.new(0, r or 0)
	p.PaddingTop    = UDim.new(0, t or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	return p
end
local function stroke(obj, col, thick)
	local s = Instance.new("UIStroke", obj)
	s.Color = col or C.border
	s.Thickness = thick or 1
	return s
end
local function gradient(obj, c0, c1, rot)
	local g = Instance.new("UIGradient", obj)
	g.Color = ColorSequence.new(c0, c1)
	g.Rotation = rot or 90
	return g
end
local function listLayout(parent, dir, align, pad_)
	local l = Instance.new("UIListLayout", parent)
	l.FillDirection  = dir or Enum.FillDirection.Vertical
	l.SortOrder      = Enum.SortOrder.LayoutOrder
	l.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
	if pad_ then l.Padding = UDim.new(0, pad_) end
	return l
end

-- ══════════════════════════════════════════════════════════════
--  ЭКРАН
-- ══════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name           = "PremiumConsole3"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999

-- ── TopBar (перетаскиваемый) ─────────────────────────────────
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size             = UDim2.new(0, 210, 0, 32)
TopBar.Position         = UDim2.new(0, 30, 0, 24)
TopBar.BackgroundColor3 = C.bar
TopBar.Active           = true
TopBar.Draggable        = true
corner(TopBar, 8)
stroke(TopBar, C.border)
gradient(TopBar,
	Color3.fromRGB(28, 28, 34),
	Color3.fromRGB(18, 18, 22), 90)

local TopIcon = Instance.new("TextLabel", TopBar)
TopIcon.Size               = UDim2.new(0, 26, 1, 0)
TopIcon.Position           = UDim2.new(0, 8, 0, 0)
TopIcon.BackgroundTransparency = 1
TopIcon.Text               = "⌨"
TopIcon.TextColor3         = C.accent
TopIcon.Font               = Enum.Font.Code
TopIcon.TextSize           = 14

local TopTitle = Instance.new("TextLabel", TopBar)
TopTitle.Size              = UDim2.new(1, -72, 1, 0)
TopTitle.Position          = UDim2.new(0, 34, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text              = "LUA CONSOLE  v3"
TopTitle.TextColor3        = C.text
TopTitle.Font              = Enum.Font.Code
TopTitle.TextSize          = 12
TopTitle.TextXAlignment    = Enum.TextXAlignment.Left

local ToggleBtn = Instance.new("TextButton", TopBar)
ToggleBtn.Size             = UDim2.new(0, 26, 0, 22)
ToggleBtn.Position         = UDim2.new(1, -30, 0, 5)
ToggleBtn.BackgroundColor3 = C.btn
ToggleBtn.Text             = "▼"
ToggleBtn.TextColor3       = C.dim
ToggleBtn.Font             = Enum.Font.Code
ToggleBtn.TextSize         = 11
corner(ToggleBtn, 4)

-- ── Главная рамка ────────────────────────────────────────────
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size             = UDim2.new(0, 760, 0, 520)
Frame.Position         = UDim2.new(0, 30, 0, 60)
Frame.BackgroundColor3 = C.bg
Frame.ClipsDescendants = true
corner(Frame, 8)
stroke(Frame, C.border)

-- тонкий акцентный градиент сверху
local AccentLine = Instance.new("Frame", Frame)
AccentLine.Size             = UDim2.new(1, 0, 0, 2)
AccentLine.BackgroundColor3 = C.accent
gradient(AccentLine,
	Color3.fromRGB(0, 200, 100),
	Color3.fromRGB(50, 130, 230), 0)

-- ── Заголовок ────────────────────────────────────────────────
local Header = Instance.new("Frame", Frame)
Header.Size             = UDim2.new(1, 0, 0, 30)
Header.Position         = UDim2.new(0, 0, 0, 2)
Header.BackgroundColor3 = C.bar
Header.BorderSizePixel  = 0
gradient(Header,
	Color3.fromRGB(24, 24, 30),
	Color3.fromRGB(17, 17, 22), 90)

local HLeft = Instance.new("TextLabel", Header)
HLeft.Size               = UDim2.new(0.55, 0, 1, 0)
HLeft.Position           = UDim2.new(0, 10, 0, 0)
HLeft.BackgroundTransparency = 1
HLeft.Text               = "●  " .. lp.Name .. "  ·  " .. os.date("%H:%M:%S")
HLeft.TextColor3         = C.dim
HLeft.Font               = Enum.Font.Code
HLeft.TextSize           = 11
HLeft.TextXAlignment     = Enum.TextXAlignment.Left

local LineCountLbl = Instance.new("TextLabel", Header)
LineCountLbl.Size            = UDim2.new(0.45, -10, 1, 0)
LineCountLbl.Position        = UDim2.new(0.55, 0, 0, 0)
LineCountLbl.BackgroundTransparency = 1
LineCountLbl.Text            = "0 lines"
LineCountLbl.TextColor3      = C.dim
LineCountLbl.Font            = Enum.Font.Code
LineCountLbl.TextSize        = 11
LineCountLbl.TextXAlignment  = Enum.TextXAlignment.Right
pad(LineCountLbl, 0, 10)

-- ── Тулбар ───────────────────────────────────────────────────
local Toolbar = Instance.new("Frame", Frame)
Toolbar.Size             = UDim2.new(1, 0, 0, 30)
Toolbar.Position         = UDim2.new(0, 0, 0, 32)
Toolbar.BackgroundColor3 = C.panel
Toolbar.BorderSizePixel  = 0

local TBLayout = Instance.new("UIListLayout", Toolbar)
TBLayout.FillDirection       = Enum.FillDirection.Horizontal
TBLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
TBLayout.Padding             = UDim.new(0, 3)
pad(Toolbar, 5, 5, 3, 3)

local function ToolBtn(label, col)
	local b = Instance.new("TextButton", Toolbar)
	b.Size             = UDim2.new(0, 0, 1, -2)
	b.AutomaticSize    = Enum.AutomaticSize.X
	b.BackgroundColor3 = col or C.btn
	b.TextColor3       = C.white
	b.Font             = Enum.Font.Code
	b.TextSize         = 11
	b.Text             = "  " .. label .. "  "
	corner(b, 4)
	local base = col or C.btn
	b.MouseEnter:Connect(function()  b.BackgroundColor3 = C.btnHov end)
	b.MouseLeave:Connect(function()  b.BackgroundColor3 = base    end)
	return b
end

local BtnCopyAll    = ToolBtn("📋 Copy All")
local BtnCopySel    = ToolBtn("📌 Copy Sel")
local BtnClearAll   = ToolBtn("🗑 Clear All",  C.accentR)
local BtnClearSel   = ToolBtn("✂ Clear Sel",  C.accentY)
local BtnClearInput = ToolBtn("⌫ Input",       C.btn)
local BtnSelAll     = ToolBtn("☰ Sel All",    C.accentB)
local BtnDesel      = ToolBtn("✕ Desel")
local BtnHistory    = ToolBtn("↕ History",    C.accentP)

-- ── Область вывода ───────────────────────────────────────────
local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size                 = UDim2.new(1, -2, 1, -120)
Scroll.Position             = UDim2.new(0, 1, 0, 63)
Scroll.BackgroundColor3     = Color3.fromRGB(9, 9, 11)
Scroll.BorderSizePixel      = 0
Scroll.ScrollBarThickness   = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
Scroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
Scroll.ElasticBehavior      = Enum.ElasticBehavior.Never

local OLayout = Instance.new("UIListLayout", Scroll)
OLayout.SortOrder = Enum.SortOrder.LayoutOrder
OLayout.Padding   = UDim.new(0, 0)
pad(Scroll, 4, 8, 3, 3)

-- разделитель
local Divider = Instance.new("Frame", Frame)
Divider.Size             = UDim2.new(1, 0, 0, 1)
Divider.Position         = UDim2.new(0, 0, 1, -57)
Divider.BackgroundColor3 = C.border
Divider.BorderSizePixel  = 0

-- ── Поле ввода + кнопка RUN ──────────────────────────────────
local BottomBar = Instance.new("Frame", Frame)
BottomBar.Size             = UDim2.new(1, 0, 0, 56)
BottomBar.Position         = UDim2.new(0, 0, 1, -56)
BottomBar.BackgroundColor3 = C.panel
BottomBar.BorderSizePixel  = 0
gradient(BottomBar,
	Color3.fromRGB(20, 20, 25),
	Color3.fromRGB(14, 14, 18), 90)

local Input = Instance.new("TextBox", BottomBar)
Input.Size              = UDim2.new(1, -108, 1, -10)
Input.Position          = UDim2.new(0, 6, 0, 5)
Input.BackgroundColor3  = C.inputBg
Input.TextColor3        = C.text
Input.PlaceholderText   = "  > Введи Lua код..."
Input.PlaceholderColor3 = C.dim
Input.Font              = Enum.Font.Code
Input.TextSize          = 13
Input.MultiLine         = true
Input.ClearTextOnFocus  = false
Input.TextXAlignment    = Enum.TextXAlignment.Left
Input.TextYAlignment    = Enum.TextYAlignment.Top
corner(Input, 5)
stroke(Input, C.border)
pad(Input, 6, 6, 5, 4)

local RunBtn = Instance.new("TextButton", BottomBar)
RunBtn.Size             = UDim2.new(0, 94, 1, -10)
RunBtn.Position         = UDim2.new(1, -100, 0, 5)
RunBtn.BackgroundColor3 = C.accent
RunBtn.Text             = "▶  RUN"
RunBtn.TextColor3       = Color3.fromRGB(10, 10, 10)
RunBtn.Font             = Enum.Font.GothamBold
RunBtn.TextSize         = 13
corner(RunBtn, 5)
RunBtn.MouseEnter:Connect(function()  RunBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 115) end)
RunBtn.MouseLeave:Connect(function()  RunBtn.BackgroundColor3 = C.accent end)

-- ══════════════════════════════════════════════════════════════
--  СИСТЕМА СТРОК
-- ══════════════════════════════════════════════════════════════
local lines       = {}
local lineOrder   = 0
local selectedSet = {}
local history     = {}
local histIdx     = 0
local showHist    = false
local histFrame   = nil  -- popup для истории

-- теги → цвет тега
local TAG_COLOR = {
	IN  = C.blue,
	OUT = C.cyan,
	ERR = C.red,
	SYN = C.red,
	WRN = C.yellow,
	RET = C.green,
	SYS = C.accentP,
	GLB = C.accentY,   -- глобальный перехват
}

local function ScrollToBottom()
	task.defer(function()
		Scroll.CanvasSize     = UDim2.new(0, 0, 0, OLayout.AbsoluteContentSize.Y + 8)
		Scroll.CanvasPosition = Vector2.new(0, math.huge)
	end)
end

local function UpdateCount()
	LineCountLbl.Text = #lines .. " lines"
end

local function AddLine(text, color, tag)
	lineOrder += 1
	local lo = lineOrder

	local row = Instance.new("Frame", Scroll)
	row.LayoutOrder        = lo
	row.Size               = UDim2.new(1, -8, 0, 0)
	row.AutomaticSize      = Enum.AutomaticSize.Y
	row.BackgroundTransparency = 1
	row.BorderSizePixel    = 0

	-- тег (цветная плашка слева)
	local tagBg = Instance.new("Frame", row)
	tagBg.Size             = UDim2.new(0, 34, 0, 16)
	tagBg.Position         = UDim2.new(0, 0, 0, 2)
	tagBg.BackgroundColor3 = TAG_COLOR[tag] or C.dim
	tagBg.BackgroundTransparency = 0.55
	corner(tagBg, 3)

	local tagLbl = Instance.new("TextLabel", tagBg)
	tagLbl.Size            = UDim2.new(1, 0, 1, 0)
	tagLbl.BackgroundTransparency = 1
	tagLbl.Text            = tag or "?"
	tagLbl.TextColor3      = TAG_COLOR[tag] or C.dim
	tagLbl.Font            = Enum.Font.Code
	tagLbl.TextSize        = 10
	tagLbl.TextXAlignment  = Enum.TextXAlignment.Center

	-- текст
	local lbl = Instance.new("TextLabel", row)
	lbl.Size              = UDim2.new(1, -42, 0, 0)
	lbl.Position          = UDim2.new(0, 40, 0, 0)
	lbl.AutomaticSize     = Enum.AutomaticSize.Y
	lbl.BackgroundTransparency = 1
	lbl.Text              = tostring(text)
	lbl.TextColor3        = color or C.text
	lbl.Font              = Enum.Font.Code
	lbl.TextSize          = 13
	lbl.TextWrapped       = true
	lbl.TextXAlignment    = Enum.TextXAlignment.Left
	lbl.RichText          = false
	pad(lbl, 0, 0, 1, 1)

	-- кнопка выделения (поверх)
	local selBtn = Instance.new("TextButton", row)
	selBtn.Size              = UDim2.new(1, 0, 1, 0)
	selBtn.BackgroundTransparency = 1
	selBtn.Text              = ""
	selBtn.ZIndex            = 5

	local entry = {row=row, lbl=lbl, text=tostring(text), lo=lo, selected=false}
	table.insert(lines, entry)

	selBtn.MouseButton1Click:Connect(function()
		entry.selected = not entry.selected
		if entry.selected then
			selectedSet[lo]           = true
			row.BackgroundColor3      = C.sel
			row.BackgroundTransparency = 0.45
		else
			selectedSet[lo]           = nil
			row.BackgroundTransparency = 1
		end
	end)

	UpdateCount()
	ScrollToBottom()
	return entry
end

local function Sep()
	local lo = lineOrder + 1; lineOrder = lo
	local row = Instance.new("Frame", Scroll)
	row.LayoutOrder        = lo
	row.Size               = UDim2.new(1, -8, 0, 8)
	row.BackgroundTransparency = 1

	local line = Instance.new("Frame", row)
	line.Size             = UDim2.new(1, 0, 0, 1)
	line.Position         = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	line.BorderSizePixel  = 0

	ScrollToBottom()
end

-- ══════════════════════════════════════════════════════════════
--  ГЛОБАЛЬНЫЙ ХУК  (ключевая фишка — всё попадает в консоль)
-- ══════════════════════════════════════════════════════════════
--  Сохраняем оригиналы
local _print = print
local _warn  = warn
local _error = error

--  Переопределяем глобально через getgenv()
--  (работает в Synapse X, Krnl, Script-Ware, Fluxus, Celery и др.)
if getgenv then
	local genv = getgenv()

	genv.print = function(...)
		local t = {}
		for _, v in ipairs({...}) do table.insert(t, tostring(v)) end
		local s = table.concat(t, "\t")
		AddLine(s, C.text, "GLB")  -- GLB = перехвачено глобально
	end

	genv.warn = function(...)
		local t = {}
		for _, v in ipairs({...}) do table.insert(t, tostring(v)) end
		AddLine("⚠  " .. table.concat(t, "\t"), C.yellow, "WRN")
	end

	-- error — НЕ ломаем глобально (игра рухнет), только в env
else
	-- fallback — нет getgenv (старый движок)
	AddLine("getgenv() недоступен — только локальный перехват", C.accentY, "SYS")
end

-- ══════════════════════════════════════════════════════════════
--  ОКРУЖЕНИЕ ДЛЯ EXECUTE
-- ══════════════════════════════════════════════════════════════
local execEnv = setmetatable({
	print = function(...)
		local t = {}
		for _, v in ipairs({...}) do table.insert(t, tostring(v)) end
		AddLine(table.concat(t, "\t"), C.text, "OUT")
	end,
	warn = function(...)
		local t = {}
		for _, v in ipairs({...}) do table.insert(t, tostring(v)) end
		AddLine("⚠  " .. table.concat(t, "\t"), C.yellow, "WRN")
	end,
	error = function(msg, _)
		AddLine("✖  " .. tostring(msg), C.red, "ERR")
	end,
	-- стандартные глобали
	tostring=tostring, tonumber=tonumber, pairs=pairs, ipairs=ipairs,
	next=next, select=select, type=type, pcall=pcall, xpcall=xpcall,
	setmetatable=setmetatable, getmetatable=getmetatable,
	rawget=rawget, rawset=rawset, rawequal=rawequal, rawlen=rawlen,
	unpack = unpack or table.unpack,
	require=require, loadstring=loadstring,
	game=game, workspace=workspace,
	math=math, table=table, string=string, os=os, bit=bit,
	task=task, wait=task.wait, spawn=task.spawn, delay=task.delay,
	tick=tick, time=time, typeof=typeof,
	Enum=Enum, Vector2=Vector2, Vector3=Vector3,
	Color3=Color3, CFrame=CFrame, UDim=UDim, UDim2=UDim2,
	Instance=Instance, Players=Players,
	player=lp, lp=lp, game_=game,
	-- инструменты отладки
	getgenv=getgenv, gethiddenproperty=gethiddenproperty,
	sethiddenproperty=sethiddenproperty, checkcaller=checkcaller,
	hookfunction=hookfunction, newcclosure=newcclosure,
	Drawing=(typeof(Drawing)=="table" and Drawing or nil),
}, {__index = function(_, k)
	-- fallback → getgenv → _G → глобальный fenv
	if getgenv and getgenv()[k] ~= nil then return getgenv()[k] end
	if _G      and _G[k]      ~= nil then return _G[k]           end
	return (getfenv and getfenv()[k]) or nil
end})

-- ══════════════════════════════════════════════════════════════
--  ВЫПОЛНЕНИЕ КОДА
-- ══════════════════════════════════════════════════════════════
local function Execute(code)
	if not code or code:match("^%s*$") then return end

	-- история
	if history[1] ~= code then
		table.insert(history, 1, code)
		if #history > 200 then table.remove(history) end
	end
	histIdx = 0

	-- покажем ввод
	local preview = code:gsub("\n", " ↵ ")
	if #preview > 80 then preview = preview:sub(1, 77) .. "..." end
	AddLine("> " .. preview, C.blue, "IN")

	-- компиляция
	local fn, err = loadstring(code)
	if not fn then
		AddLine("Синтаксис: " .. tostring(err), C.red, "SYN")
		Sep()
		return
	end

	-- применяем окружение
	if setfenv then
		setfenv(fn, execEnv)
	end

	-- запуск с перехватом ошибок
	local results = table.pack(pcall(fn))
	local ok = results[1]

	if not ok then
		AddLine("Ошибка: " .. tostring(results[2]), C.red, "ERR")
	else
		for i = 2, results.n do
			if results[i] ~= nil then
				AddLine("= " .. tostring(results[i]), C.green, "RET")
			end
		end
	end

	Sep()
end

-- ══════════════════════════════════════════════════════════════
--  КОПИРОВАНИЕ В БУФЕР
-- ══════════════════════════════════════════════════════════════
local function CopyText(text)
	local fn = setclipboard or toclipboard
	if fn then
		fn(text)
		AddLine("✔ Скопировано (" .. #text .. " символов)", C.accent, "SYS")
	else
		Input.Text = text:sub(1, 4000)
		AddLine("⚠ setclipboard недоступен — вставлено в поле ввода", C.yellow, "SYS")
	end
end

-- ══════════════════════════════════════════════════════════════
--  ТУЛБАР — КНОПКИ
-- ══════════════════════════════════════════════════════════════
BtnCopyAll.MouseButton1Click:Connect(function()
	local p = {}
	for _, e in ipairs(lines) do table.insert(p, e.text) end
	CopyText(table.concat(p, "\n"))
end)

BtnCopySel.MouseButton1Click:Connect(function()
	local p = {}
	for _, e in ipairs(lines) do
		if e.selected then table.insert(p, e.text) end
	end
	if #p == 0 then
		AddLine("⚠ Нет выделенных строк", C.yellow, "SYS")
	else
		CopyText(table.concat(p, "\n"))
	end
end)

BtnClearAll.MouseButton1Click:Connect(function()
	for _, e in ipairs(lines) do e.row:Destroy() end
	lines = {}; selectedSet = {}; lineOrder = 0
	Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	UpdateCount()
	AddLine("Консоль очищена", C.dim, "SYS")
end)

BtnClearSel.MouseButton1Click:Connect(function()
	local kept, n = {}, 0
	for _, e in ipairs(lines) do
		if e.selected then e.row:Destroy(); n += 1
		else table.insert(kept, e) end
	end
	lines = kept; selectedSet = {}
	UpdateCount(); ScrollToBottom()
	if n == 0 then AddLine("⚠ Нет выделенных строк", C.yellow, "SYS")
	else AddLine("Удалено строк: " .. n, C.dim, "SYS") end
end)

BtnClearInput.MouseButton1Click:Connect(function()
	Input.Text = ""; Input:CaptureFocus()
end)

BtnSelAll.MouseButton1Click:Connect(function()
	for _, e in ipairs(lines) do
		e.selected = true; selectedSet[e.lo] = true
		e.row.BackgroundColor3      = C.sel
		e.row.BackgroundTransparency = 0.45
	end
end)

BtnDesel.MouseButton1Click:Connect(function()
	for _, e in ipairs(lines) do
		e.selected = false; e.row.BackgroundTransparency = 1
	end
	selectedSet = {}
end)

-- История — всплывающее окно
BtnHistory.MouseButton1Click:Connect(function()
	showHist = not showHist
	if histFrame then histFrame:Destroy(); histFrame = nil end
	if not showHist then return end
	if #history == 0 then
		AddLine("История пуста", C.dim, "SYS"); showHist = false; return
	end

	histFrame = Instance.new("Frame", ScreenGui)
	histFrame.Size             = UDim2.new(0, 420, 0, math.min(#history * 22 + 10, 300))
	histFrame.Position         = UDim2.new(0, 30, 0, 60 + 32 + 30 + 4)
	histFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	histFrame.ZIndex           = 20
	corner(histFrame, 6)
	stroke(histFrame, C.accentP)

	local hScroll = Instance.new("ScrollingFrame", histFrame)
	hScroll.Size               = UDim2.new(1, -2, 1, -2)
	hScroll.Position           = UDim2.new(0, 1, 0, 1)
	hScroll.BackgroundTransparency = 1
	hScroll.ScrollBarThickness = 4
	hScroll.ScrollBarImageColor3 = C.accentP
	hScroll.CanvasSize         = UDim2.new(0, 0, 0, #history * 24 + 6)
	hScroll.ElasticBehavior    = Enum.ElasticBehavior.Never

	local hLayout = Instance.new("UIListLayout", hScroll)
	hLayout.SortOrder = Enum.SortOrder.LayoutOrder
	hLayout.Padding   = UDim.new(0, 1)
	pad(hScroll, 3, 3, 3, 3)

	for i, cmd in ipairs(history) do
		local hRow = Instance.new("TextButton", hScroll)
		hRow.LayoutOrder       = i
		hRow.Size              = UDim2.new(1, 0, 0, 22)
		hRow.BackgroundColor3  = (i % 2 == 0) and Color3.fromRGB(22,22,28) or Color3.fromRGB(18,18,24)
		hRow.BackgroundTransparency = 0
		hRow.TextColor3        = C.text
		hRow.Font              = Enum.Font.Code
		hRow.TextSize          = 11
		hRow.TextXAlignment    = Enum.TextXAlignment.Left
		hRow.TextTruncate      = Enum.TextTruncate.AtEnd
		hRow.Text              = "  " .. cmd
		hRow.ZIndex            = 21
		corner(hRow, 3)
		hRow.MouseEnter:Connect(function()  hRow.BackgroundColor3 = Color3.fromRGB(35, 35, 50) end)
		hRow.MouseLeave:Connect(function()  hRow.BackgroundColor3 = (i%2==0) and Color3.fromRGB(22,22,28) or Color3.fromRGB(18,18,24) end)
		hRow.MouseButton1Click:Connect(function()
			Input.Text = cmd
			histFrame:Destroy(); histFrame = nil; showHist = false
			Input:CaptureFocus()
		end)
	end
end)

-- ══════════════════════════════════════════════════════════════
--  КНОПКА RUN
-- ══════════════════════════════════════════════════════════════
RunBtn.MouseButton1Click:Connect(function()
	local code = Input.Text
	Input.Text = ""
	Execute(code)
end)

-- Enter = запуск (без Shift)
Input.FocusLost:Connect(function(enter)
	if enter and not Input.Text:find("\n") then
		local code = Input.Text
		Input.Text = ""
		Execute(code)
	end
end)

-- ↑ / ↓ по истории команд
UIS.InputBegan:Connect(function(inp, gp)
	if gp then return end
	if not Input:IsFocused() then return end
	if inp.KeyCode == Enum.KeyCode.Up then
		if #history == 0 then return end
		histIdx = math.min(histIdx + 1, #history)
		Input.Text = history[histIdx]
		-- курсор в конец
		task.defer(function() Input.CursorPosition = #Input.Text + 1 end)
	elseif inp.KeyCode == Enum.KeyCode.Down then
		if histIdx <= 0 then return end
		histIdx = histIdx - 1
		Input.Text = histIdx == 0 and "" or history[histIdx]
		task.defer(function() Input.CursorPosition = #Input.Text + 1 end)
	end
end)

-- ══════════════════════════════════════════════════════════════
--  ТОГЛ + СИНХРОНИЗАЦИЯ ПОЗИЦИИ
-- ══════════════════════════════════════════════════════════════
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	Frame.Visible = isOpen
	ToggleBtn.Text = isOpen and "▼" or "▲"
end)

TopBar:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	local p = TopBar.AbsolutePosition
	Frame.Position = UDim2.new(0, p.X, 0, p.Y + 36)
end)

-- ══════════════════════════════════════════════════════════════
--  ПРИВЕТСТВИЕ
-- ══════════════════════════════════════════════════════════════
AddLine("PREMIUM LUA CONSOLE  v3.0  •  " .. os.date("%X") .. "  •  " .. lp.Name, C.accent, "SYS")

if getgenv then
	AddLine("✔ Глобальный хук активен (getgenv) — print/warn перехватываются ВЕЗДЕ", C.green, "SYS")
else
	AddLine("⚠ getgenv недоступен — только локальный перехват (setfenv)", C.yellow, "SYS")
end

AddLine("Теги:  GLB=глобальный  OUT=локальный  IN=ввод  RET=возврат  ERR/WRN=ошибки", C.dim, "SYS")
AddLine("↑ / ↓ — история команд  |  Клик по строке — выделение  |  Enter — запуск", C.dim, "SYS")
AddLine("Переменные:  player / lp = LocalPlayer  |  game_ = game", C.dim, "SYS")
Sep()
