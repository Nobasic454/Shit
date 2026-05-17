local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP         = Players.LocalPlayer

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo.."Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = true

local Window = Library:CreateWindow({
    Title = "Antiz",
    Footer = "1.3.1",
    ShowCustomCursor = true,
})

local Tabs = {
    Main      = Window:AddTab("Main",      "target"),
    Misc      = Window:AddTab("Misc",      "box"),
    Visuals   = Window:AddTab("Visuals",   "eye"),
    Trusting  = Window:AddTab("Trusting",  "flame"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local ANIMATION_IDS = {Uppercut = "10503381238", Lethal = "12296113986"}
local ANIM_NAME_BY_ID = {}
for n, id in pairs(ANIMATION_IDS) do ANIM_NAME_BY_ID[id] = n end

local EVENT_NAMES = {
    "PreRender","PreAnimation","PreSimulation",
    "PostSimulation","RenderStepped","Stepped","Heartbeat","BindToRenderStep",
}
local RS_MAP = {
    PreRender="PreRender",PreAnimation="PreAnimation",PreSimulation="PreSimulation",
    PostSimulation="PostSimulation",RenderStepped="RenderStepped",
    Stepped="Stepped",Heartbeat="Heartbeat",
}

-- ─── Player list + dropdown refs ─────────────────────────────────────────────
local playerNames     = {}
local ddTpTarget      = nil  -- reference set after AddDropdown
local ddTpContTargets = nil  -- reference set after AddDropdown

local function refreshPlayers()
    playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(playerNames, p.Name) end
    end
    -- SetValues() is the Obsidian/Linoria API to update a dropdown's list live
    if ddTpTarget      then pcall(function() ddTpTarget:SetValues(playerNames)      end) end
    if ddTpContTargets then pcall(function() ddTpContTargets:SetValues(playerNames) end) end
end

refreshPlayers()
Players.PlayerAdded:Connect(function()    task.wait(0.1); refreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshPlayers() end)

local function getTargetNames(opt)
    local v = opt.Value
    if type(v) == "string" and v ~= "" then return {v} end
    if type(v) ~= "table" then return {} end
    local out = {}
    for k, val in pairs(v) do
        if val == true then table.insert(out, k)
        elseif type(k) == "number" and type(val) == "string" then table.insert(out, val) end
    end
    return out
end

local function getSelectedEvents(opt)
    local v = opt.Value
    local out = {}
    if type(v) == "table" then
        for k, val in pairs(v) do if val == true then out[k] = true end end
    elseif type(v) == "string" then out[v] = true end
    return out
end

local function getFirstTarget()
    local names = getTargetNames(Options.TpContTargets)
    for _, name in ipairs(names) do
        local p = Players:FindFirstChild(name)
        if p and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then return p, root end
        end
    end
    return nil, nil
end

-- ─── State ────────────────────────────────────────────────────────────────────
local velocityEnabled  = false
local velocityArmed    = false
local velocityExpire   = 0
local velocityAnimExp  = 0
local velocityAnimConn = nil

local activeConstraints = {}
local plusModified      = {}
local highlightObj      = nil

-- ─── NoCollision helpers ──────────────────────────────────────────────────────
local function getParts(model)
    local t = {}
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then table.insert(t, v) end
    end
    return t
end

local function createNoclip(p)
    local char = LP.Character
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
    if not set then return end
    for part in pairs(set) do
        if part and part.Parent then pcall(function() part.CanCollide = true end) end
    end
    plusModified[p] = nil
end

local function clearAllPlus()
    for p in pairs(plusModified) do restorePlus(p) end
end

-- ─── NoCollision tick ─────────────────────────────────────────────────────────
local function noCollisionTick()
    local p, _ = getFirstTarget()
    if Toggles.TargetNoColl.Value then
        if p then createNoclip(p) end
        for ep in pairs(activeConstraints) do
            if ep ~= p then removeNoclip(ep) end
        end
    else
        clearAllNoclip()
    end
    if Toggles.NoCollPlus.Value then
        if p then applyPlus(p) end
        for ep in pairs(plusModified) do
            if ep ~= p then restorePlus(ep) end
        end
    else
        clearAllPlus()
    end
end
RunService.Heartbeat:Connect(noCollisionTick)

-- ─── Highlight tick ───────────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function()
    if not Toggles.HighlightToggle.Value then
        if highlightObj then highlightObj:Destroy(); highlightObj = nil end
        return
    end
    local p, _ = getFirstTarget()
    local newChar = p and p.Character or nil
    if not highlightObj or not highlightObj.Parent or highlightObj.Adornee ~= newChar then
        if highlightObj then highlightObj:Destroy(); highlightObj = nil end
        if newChar then
            highlightObj              = Instance.new("Highlight")
            highlightObj.FillColor    = Options.HighlightColor.Value
            highlightObj.OutlineColor = Options.HighlightColor.Value
            highlightObj.Adornee      = newChar
            highlightObj.Parent       = game.CoreGui
        end
    end
end)

-- ─── Velocity ─────────────────────────────────────────────────────────────────
local function isVelocityAllowed()
    if not Toggles.VelocityModify.Value then return false end
    local mode = Options.VelocityMode.Value
    if mode == "Keybind"          then return velocityEnabled
    elseif mode == "Keybind Once" then return velocityArmed
    elseif mode == "Keybind Time" then return tick() < velocityExpire
    elseif mode == "Animation"    then return tick() < velocityAnimExp
    end
    return false
end

local function modifyBodyVelocity(v)
    if not v:IsA("BodyVelocity") or v.Name ~= "moveme" then return end
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
            if not v.Parent then velocityAnimExp = 0; conn:Disconnect() end
        end)
    end
end

local function isTargetAnimPlaying()
    local char = LP.Character
    if not char then return false end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local anim = hum and hum:FindFirstChildOfClass("Animator")
    if not anim then return false end
    local sel = Options.VelocityAnimations.Value
    for _, track in pairs(anim:GetPlayingAnimationTracks()) do
        local a = track.Animation
        if a then
            local id = a.AnimationId:match("%d+")
            if id then
                for name, animId in pairs(ANIMATION_IDS) do
                    if sel[name] and id == animId then return true end
                end
            end
        end
    end
    return false
end

local function startAnimLoop()
    if velocityAnimConn then velocityAnimConn:Disconnect(); velocityAnimConn = nil end
    velocityAnimConn = RunService.Heartbeat:Connect(function()
        if not Toggles.VelocityModify.Value or Options.VelocityMode.Value ~= "Animation" then return end
        if isTargetAnimPlaying() then
            if Options.VelocityAnimMode.Value == "Time" then
                velocityAnimExp = tick() + Options.VelocityAnimTime.Value
            elseif Options.VelocityAnimMode.Value == "Once" and velocityAnimExp == 0 then
                velocityAnimExp = tick() + 999
            end
        end
    end)
end

local function stopAnimLoop()
    if velocityAnimConn then velocityAnimConn:Disconnect(); velocityAnimConn = nil end
    velocityAnimExp = 0
end

-- ─── Camera ───────────────────────────────────────────────────────────────────
local camConn = nil; local camBound = false
local camOrigSubject = nil; local camOrigType = nil
local cam = workspace.CurrentCamera

local function saveCamState()
    if not camOrigSubject then
        camOrigSubject = cam.CameraSubject
        camOrigType    = cam.CameraType
    end
end

local function restoreCamera()
    if camBound then pcall(function() RunService:UnbindFromRenderStep("_AntizCam") end); camBound = false end
    if camConn  then pcall(function() camConn:Disconnect() end); camConn = nil end
    if camOrigSubject then
        cam.CameraType    = camOrigType or Enum.CameraType.Custom
        cam.CameraSubject = camOrigSubject
        camOrigSubject = nil; camOrigType = nil
    end
end

local function applyCamera()
    restoreCamera()
    local mode = Options.CameraMode.Value
    if mode == "From Target" then
        saveCamState()
        local _, root = getFirstTarget()
        if root then cam.CameraType = Enum.CameraType.Custom; cam.CameraSubject = root end
        camConn = RunService.Heartbeat:Connect(function()
            local _, r = getFirstTarget()
            if r and cam.CameraSubject ~= r then cam.CameraSubject = r end
        end)
    elseif mode == "From Me" then
        saveCamState()
        cam.CameraType = Enum.CameraType.Scriptable
        local myChar   = LP.Character
        local myRoot   = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local camRelCF = myRoot and myRoot.CFrame:ToObjectSpace(cam.CFrame) or CFrame.new(0,0,-10)
        camBound = true
        RunService:BindToRenderStep("_AntizCam", Enum.RenderPriority.Camera.Value + 1, function()
            local c = LP.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r then cam.CFrame = r.CFrame * camRelCF end
        end)
    end
end

-- ─── Spin state ───────────────────────────────────────────────────────────────
local yawAngle = 0; local pitchAngle = 0; local rollAngle = 0
local jitterDir = 1; local jitterAngle = 0

-- ─── Trusting ─────────────────────────────────────────────────────────────────
local TRUST_MAP_KEYS = {
    ["HumanoidRootPart"] = "TrustHRP",
    ["Head"]      = "TrustHead",
    ["Torso"]     = "TrustTorso",
    ["Right Arm"] = "TrustRightArm",
    ["Left Arm"]  = "TrustLeftArm",
    ["Right Leg"] = "TrustRightLeg",
    ["Left Leg"]  = "TrustLeftLeg",
}

local function getTurnPos(p, hrpRoot)
    local partName = Options.TurnTargetPart.Value
    local selPart  = p.Character and p.Character:FindFirstChild(partName)
    local selPos   = selPart and selPart.Position or hrpRoot.Position
    if Toggles.TrustingEnabled.Value then
        local key   = TRUST_MAP_KEYS[partName] or "TrustTorso"
        local blend = Options[key] and Options[key].Value or 0.5
        return hrpRoot.Position:Lerp(selPos, blend)
    end
    return selPos
end

-- ─── TP Logic ─────────────────────────────────────────────────────────────────
local function getOffset(targetRoot, mode, dist)
    local lv = targetRoot.CFrame.LookVector
    local rv = targetRoot.CFrame.RightVector
    if mode == "above"      then return Vector3.new(0, dist, 0)
    elseif mode == "down"       then return Vector3.new(0, -dist, 0)
    elseif mode == "back"       then return -lv * dist
    elseif mode == "forward"    then return  lv * dist
    elseif mode == "right"      then return  rv * dist
    elseif mode == "left"       then return -rv * dist
    elseif mode == "Yaw Spin" then
        local d = Options.YawDir.Value == "Left" and 1 or -1
        yawAngle = yawAngle + math.rad(Options.SpinSpeed.Value * d)
        return Vector3.new(math.cos(yawAngle)*dist, 0, math.sin(yawAngle)*dist)
    elseif mode == "Pitch Spin" then
        local d = Options.PitchDir.Value == "Front" and 1 or -1
        pitchAngle = pitchAngle + math.rad(Options.SpinSpeed.Value * d)
        return (lv * math.cos(pitchAngle) + Vector3.new(0,1,0) * math.sin(pitchAngle)) * dist
    elseif mode == "Roll Spin" then
        local d = Options.RollDir.Value == "Front" and 1 or -1
        rollAngle = rollAngle + math.rad(Options.SpinSpeed.Value * d)
        return (rv * math.cos(rollAngle) + Vector3.new(0,1,0) * math.sin(rollAngle)) * dist
    elseif mode == "Jitter" then
        local ss = Options.JitterStartDir.Value == "Right" and 1 or -1
        local es = Options.JitterEndDir.Value   == "Right" and 1 or -1
        local aS = math.rad(Options.JitterStart.Value * ss)
        local aE = math.rad(Options.JitterEnd.Value   * es)
        jitterAngle = jitterAngle + Options.SpinSpeed.Value * 0.05 * jitterDir
        if jitterDir > 0 and jitterAngle >= 1 then jitterAngle = 1; jitterDir = -1
        elseif jitterDir < 0 and jitterAngle <= 0 then jitterAngle = 0; jitterDir = 1 end
        local a = aS + (aE - aS) * jitterAngle
        return Vector3.new(math.cos(a)*dist, 0, math.sin(a)*dist)
    end
    return Vector3.new(0, 3, 0)
end

local lastTpTime = 0; local lastTurnTime = 0

local function doTurn()
    if not Toggles.ContTpEnable.Value then return end
    local now = tick()
    if now - lastTurnTime < 1 / Options.TurnFPS.Value then return end
    lastTurnTime = now
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local p, hrpRoot = getFirstTarget()
    if not p or not hrpRoot then return end
    local tgtPos = getTurnPos(p, hrpRoot)
    local myPos  = myRoot.Position
    local dir    = tgtPos - myPos
    if dir.Magnitude > 0.01 then
        local baseCF    = CFrame.new(myPos, myPos + dir)
        local sign      = Options.TurnOffsetSide.Value == "Right" and -1 or 1
        local offsetRad = math.rad(Options.TurnOffset.Value) * sign
        myRoot.CFrame   = baseCF * CFrame.Angles(0, offsetRad, 0)
    end
end

local function doTeleport()
    if not Toggles.ContTpEnable.Value then return end
    local now = tick()
    if now - lastTpTime < 1 / Options.TpFPS.Value then return end
    lastTpTime = now
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local _, root = getFirstTarget()
    if not root then return end
    local offset = getOffset(root, Options.TpMode.Value, Options.TpDistance.Value)
    myRoot.CFrame = CFrame.new(root.Position + offset, root.Position)
end

-- ─── Connection manager ───────────────────────────────────────────────────────
local tpConns = {}; local turnConns = {}

local function disconnectAll(tbl)
    for _, c in ipairs(tbl) do pcall(function() c:Disconnect() end) end
    for k in pairs(tbl) do tbl[k] = nil end
end

local function bindEvents(evtOpt, fn, connTbl, tag, priorityOpt)
    disconnectAll(connTbl)
    pcall(function() RunService:UnbindFromRenderStep(tag) end)
    local evts     = getSelectedEvents(evtOpt)
    local priority = priorityOpt and Options[priorityOpt].Value or 200
    for name in pairs(evts) do
        if name == "BindToRenderStep" then
            RunService:BindToRenderStep(tag, priority, function() fn() end)
        elseif RS_MAP[name] and RunService[RS_MAP[name]] then
            table.insert(connTbl, RunService[RS_MAP[name]]:Connect(function() fn() end))
        end
    end
end

local function rebind()
    if Toggles.ContTpEnable.Value then
        bindEvents(Options.TurnEvents, doTurn,     turnConns, "_AntizTurn", "TurnBindPriority")
        bindEvents(Options.TpEvents,   doTeleport, tpConns,   "_AntizTp",   "TpBindPriority")
        applyCamera()
    else
        disconnectAll(tpConns)
        disconnectAll(turnConns)
        pcall(function() RunService:UnbindFromRenderStep("_AntizTp")   end)
        pcall(function() RunService:UnbindFromRenderStep("_AntizTurn") end)
        restoreCamera()
        clearAllNoclip()
        clearAllPlus()
    end
end

-- ─── GUI: Main ────────────────────────────────────────────────────────────────
local TpBox = Tabs.Main:AddLeftGroupbox("Teleport")

-- store ref so refreshPlayers() can call :SetValues()
ddTpTarget = TpBox:AddDropdown("TpTarget", {
    Values  = playerNames,
    Default = 1,
    Text    = "Target Player",
    Multi   = false,
})

TpBox:AddButton("Teleport Once", function()
    local name = Options.TpTarget.Value
    if not name or name == "" then return end
    local target = Players:FindFirstChild(name)
    if not target or not target.Character then return end
    local root   = target.Character:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not root or not myRoot then return end
    myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0), root.Position)
end)

local ContBox = Tabs.Main:AddRightGroupbox("Continuous")

ddTpContTargets = ContBox:AddDropdown("TpContTargets", {
    Values  = playerNames,
    Default = {},
    Multi   = true,
    Text    = "Players",
})

ContBox:AddDropdown("TpMode", {
    Values  = {"above","back","forward","right","left","down","Yaw Spin","Pitch Spin","Roll Spin","Jitter"},
    Default = 1,
    Text    = "Mode",
})
ContBox:AddSlider("TpDistance", {Text = "Distance", Default = 3, Min = 0, Max = 20, Rounding = 1, FormatDisplayValue = function(_, v) return v.." st" end})
ContBox:AddSlider("SpinSpeed",  {Text = "Spin / Jitter Speed", Default = 3, Min = 1, Max = 30, Rounding = 1})
ContBox:AddDropdown("YawDir",   {Values = {"Left","Right"},  Default = 1, Text = "Yaw Spin Direction"})
ContBox:AddDropdown("PitchDir", {Values = {"Front","Back"},  Default = 1, Text = "Pitch Spin Direction"})
ContBox:AddDropdown("RollDir",  {Values = {"Front","Back"},  Default = 1, Text = "Roll Spin Direction"})
ContBox:AddDivider()
ContBox:AddSlider("JitterStart",      {Text = "Jitter Start Angle", Default = 0,   Min = 0, Max = 360, Rounding = 0, FormatDisplayValue = function(_, v) return v.."°" end})
ContBox:AddDropdown("JitterStartDir", {Values = {"Right","Left"}, Default = 1, Text = "Jitter Start Side"})
ContBox:AddSlider("JitterEnd",        {Text = "Jitter End Angle",   Default = 180, Min = 0, Max = 360, Rounding = 0, FormatDisplayValue = function(_, v) return v.."°" end})
ContBox:AddDropdown("JitterEndDir",   {Values = {"Right","Left"}, Default = 1, Text = "Jitter End Side"})
ContBox:AddDivider()
ContBox:AddDropdown("CameraMode", {Values = {"Default","From Me","From Target"}, Default = 1, Text = "Camera Mode"})
ContBox:AddDivider()

ContBox:AddLabel("── Turn ──")
ContBox:AddDropdown("TurnTargetPart", {
    Values  = {"HumanoidRootPart","Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"},
    Default = 1,
    Text    = "Target Part",
})
ContBox:AddSlider("TurnOffset", {
    Text = "Turn Offset", Default = 0, Min = 0, Max = 180, Rounding = 0,
    FormatDisplayValue = function(_, v) return v.."°" end,
})
ContBox:AddDropdown("TurnOffsetSide", {Values = {"Left","Right"}, Default = 1, Text = "Offset Side"})
ContBox:AddDropdown("TurnEvents", {Values = EVENT_NAMES, Default = {"Heartbeat"}, Multi = true, Text = "Turn Events"})
ContBox:AddSlider("TurnFPS", {Text = "Turn FPS Limit", Default = 60, Min = 1, Max = 240, Rounding = 0, FormatDisplayValue = function(_, v) return v.."/s" end})
ContBox:AddSlider("TurnBindPriority", {Text = "Turn Bind Priority", Default = 200, Min = 0, Max = 2000, Rounding = 0})
ContBox:AddDivider()

ContBox:AddLabel("── Teleport ──")
ContBox:AddDropdown("TpEvents", {Values = EVENT_NAMES, Default = {"Heartbeat"}, Multi = true, Text = "TP Events"})
ContBox:AddSlider("TpFPS", {Text = "TP FPS Limit", Default = 60, Min = 1, Max = 240, Rounding = 0, FormatDisplayValue = function(_, v) return v.."/s" end})
ContBox:AddSlider("TpBindPriority", {Text = "TP Bind Priority", Default = 400, Min = 0, Max = 2000, Rounding = 0})
ContBox:AddDivider()
ContBox:AddToggle("ContTpEnable", {Text = "Enable", Default = false})

-- ─── GUI: Misc ────────────────────────────────────────────────────────────────
local NoCollBox     = Tabs.Misc:AddLeftGroupbox("No Collision")
local NoCollPlusBox = Tabs.Misc:AddLeftGroupbox("No Collision+")
local VelocityBox   = Tabs.Misc:AddRightGroupbox("Velocity")

NoCollBox:AddToggle("TargetNoColl", {Text = "No Collision Constraints", Default = false})

NoCollPlusBox:AddToggle("NoCollPlus", {Text = "No Collision+", Default = false})
NoCollPlusBox:AddDropdown("NoCollPlusParts", {
    Values  = {"Head","Torso","Right Arm","Left Arm","Right Leg","Left Leg","HumanoidRootPart"},
    Default = {"Head","Torso","Right Arm","Left Arm","Right Leg","Left Leg"},
    Multi   = true,
    Text    = "Parts",
})

VelocityBox:AddToggle("VelocityModify", {Text = "Velocity Speed Modify", Default = false})
VelocityBox:AddDropdown("VelocityMode", {
    Values = {"Keybind","Keybind Once","Keybind Time","Animation"},
    Default = 1, Text = "Velocity Mode",
})
VelocityBox:AddLabel("Velocity Key"):AddKeyPicker("VelocityKey", {Default = "X", Mode = "Toggle", SyncToggleState = false, Text = "Velocity Modify"})
VelocityBox:AddSlider("VelocityTime",  {Text = "Modify Time",    Default = 1,  Min = 0, Max = 5,   Rounding = 1, FormatDisplayValue = function(_, v) return v.." s" end})
VelocityBox:AddSlider("VelocityValue", {Text = "Velocity Value", Default = 54, Min = 0, Max = 165, Rounding = 0})
VelocityBox:AddDivider()
VelocityBox:AddDropdown("VelocityAnimations", {Values = {"Uppercut","Lethal"}, Default = {"Uppercut"}, Multi = true, Text = "Animation Filter"})
VelocityBox:AddDropdown("VelocityAnimMode", {Values = {"Once","Time"}, Default = 1, Text = "Animation Mode"})
VelocityBox:AddSlider("VelocityAnimTime", {Text = "Animation Time", Default = 1, Min = 0, Max = 5, Rounding = 1, FormatDisplayValue = function(_, v) return v.." s" end})

-- ─── GUI: Visuals ─────────────────────────────────────────────────────────────
local VisualBox = Tabs.Visuals:AddLeftGroupbox("Effects")
VisualBox:AddToggle("HighlightToggle", {Text = "Highlight", Default = false})
    :AddColorPicker("HighlightColor", {Default = Color3.fromRGB(255, 0, 0)})

-- ─── GUI: Trusting ────────────────────────────────────────────────────────────
local TrustBox = Tabs.Trusting:AddLeftGroupbox("Part Trust")
TrustBox:AddToggle("TrustingEnabled", {Text = "Trusting", Default = true})
TrustBox:AddSlider("TrustHRP",      {Text = "HumanoidRootPart", Default = 0.00, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustHead",     {Text = "Head",             Default = 0.35, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustTorso",    {Text = "Torso",            Default = 0.65, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustRightArm", {Text = "Right Arm",        Default = 0.30, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustLeftArm",  {Text = "Left Arm",         Default = 0.30, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustRightLeg", {Text = "Right Leg",        Default = 0.30, Min = 0, Max = 1, Rounding = 2})
TrustBox:AddSlider("TrustLeftLeg",  {Text = "Left Leg",         Default = 0.30, Min = 0, Max = 1, Rounding = 2})

-- ─── GUI: UI Settings ────────────────────────────────────────────────────────
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(v) Library.KeybindFrame.Visible = v end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind

-- ─── Callbacks ────────────────────────────────────────────────────────────────
Toggles.ContTpEnable:OnChanged(rebind)
Options.TpEvents:OnChanged(function()         if Toggles.ContTpEnable.Value then rebind() end end)
Options.TurnEvents:OnChanged(function()       if Toggles.ContTpEnable.Value then rebind() end end)
Options.TpBindPriority:OnChanged(function()   if Toggles.ContTpEnable.Value then rebind() end end)
Options.TurnBindPriority:OnChanged(function() if Toggles.ContTpEnable.Value then rebind() end end)
Options.CameraMode:OnChanged(function()       if Toggles.ContTpEnable.Value then applyCamera() end end)

Options.VelocityMode:OnChanged(function()
    if Options.VelocityMode.Value == "Animation" then startAnimLoop()
    else stopAnimLoop(); velocityEnabled = false; velocityArmed = false; velocityExpire = 0 end
end)

Options.VelocityKey:OnClick(function()
    if not Toggles.VelocityModify.Value then return end
    local mode = Options.VelocityMode.Value
    if mode == "Keybind"          then velocityEnabled = not velocityEnabled
    elseif mode == "Keybind Once" then velocityArmed = true
    elseif mode == "Keybind Time" then velocityExpire = tick() + Options.VelocityTime.Value
    end
end)

Options.HighlightColor:OnChanged(function()
    if highlightObj then
        highlightObj.FillColor    = Options.HighlightColor.Value
        highlightObj.OutlineColor = Options.HighlightColor.Value
    end
end)

-- ─── Character hook ───────────────────────────────────────────────────────────
local function onCharAdded(char)
    clearAllNoclip(); clearAllPlus()
    velocityEnabled = false; velocityArmed = false
    velocityExpire  = 0;     velocityAnimExp = 0
    char.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
end

LP.CharacterAdded:Connect(onCharAdded)
if LP.Character then
    LP.Character.DescendantAdded:Connect(modifyBodyVelocity)
    if Options.VelocityMode.Value == "Animation" then startAnimLoop() end
end

Players.PlayerRemoving:Connect(function(p) removeNoclip(p); restorePlus(p) end)

-- ─── Save / Theme ─────────────────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("AntizTP")
SaveManager:SetFolder("AntizTP/configs")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
