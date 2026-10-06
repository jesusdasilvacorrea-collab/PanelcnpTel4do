local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local NetworkSettings = nil
pcall(function() NetworkSettings = settings():GetService("NetworkSettings") end)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Mouse = player:GetMouse()

local CORRECT_PASSWORD = "TEL4DOSCRIPTS2027"
local CONFETE_USER = "COTERCITOPONYTOWN"
local isSpecialUser = (player.Name == CONFETE_USER)

local COLOR_OFF = Color3.fromRGB(200, 50, 50)
local COLOR_ON  = Color3.fromRGB(46, 139, 87)

--------------------------------------------------------
-- SPEED ESCALA
--------------------------------------------------------
local L = player
local GLITCH_ID = "GlitchMacro_UniqueKey"
local speedEscalaActive = false

local function startSpeedEscala()
    if shared[GLITCH_ID] then shared[GLITCH_ID]() end
    local conns = {}
    local SB, MS = 60, 280
    local gReady, mActive, isClimb, cSpam = false, false, false, 0
    local uT, cAD, uKey, isFast = 0, 0, "", false
    local uAY, dAnt, cG, uTG = 0, 0, 0, 0
    local camSp, tecSp = false, false
    local cDel = nil

    local function frena()
        local c = L.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local hrp = c.HumanoidRootPart
            local vY = hrp.Velocity.Y
            if math.abs(vY) > 350 then vY = 0 end
            hrp.Velocity = hrp.Velocity:Lerp(Vector3.new(0, vY, 0), 0.2)
        end
    end

    local function clean()
        gReady, mActive, cSpam, cAD, isFast, uKey = false, false, 0, 0, false, ""
        cG, uAY, dAnt, camSp, tecSp = 0, 0, 0, false, false
        frena()
    end

    local function checkGlitchState(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return false end
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local name = string.lower(track.Name)
                local animId = track.Animation and track.Animation.AnimationId or ""
                if string.find(name, "swim") or string.find(animId, "swim") then return true end
            end
        end
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local hitClose = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 1.8, params)
        local hitDown = workspace:Raycast(hrp.Position, -Vector3.yAxis * 2.5, params)
        if hitClose and hitDown then return true end
        return hum:GetState() == Enum.HumanoidStateType.Swimming
    end

    local cState, cAdd = nil, nil
    local function setup(char)
        clean()
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        if cState then cState:Disconnect() end
        if cAdd then cAdd:Disconnect() end
        if cDel then cDel:Disconnect() end
        cState = hum.StateChanged:Connect(function(_, st)
            isClimb = (st == Enum.HumanoidStateType.Climbing)
            if isClimb then mActive = false
            elseif gReady and (st == Enum.HumanoidStateType.Jumping or st == Enum.HumanoidStateType.Freefall) then mActive = true end
        end)
        table.insert(conns, cState)
        cAdd = char.ChildAdded:Connect(function(ch)
            if ch:IsA("Tool") and isClimb then
                cSpam = cSpam + 1
                if cSpam >= 3 then gReady = true end
            end
        end)
        table.insert(conns, cAdd)
        cDel = char.ChildRemoved:Connect(function(ch)
            if ch:IsA("Tool") then
                task.defer(function()
                    if char and not char:FindFirstChildOfClass("Tool") and mActive then clean() end
                end)
            end
        end)
        table.insert(conns, cDel)
    end

    if L.Character then setup(L.Character) end
    local cChar = L.CharacterAdded:Connect(setup)
    table.insert(conns, cChar)

    UserInputService.JumpRequest:Connect(function()
        local c = L.Character
        if c and checkGlitchState(c) then
            if c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.Velocity = Vector3.new(c.HumanoidRootPart.Velocity.X, 140, c.HumanoidRootPart.Velocity.Z)
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe or not mActive then return end
        if inp.KeyCode == Enum.KeyCode.A or inp.KeyCode == Enum.KeyCode.D then
            local act = inp.KeyCode.Name
            local t = os.clock()
            if (t - uT) > 0.3 then cAD = 1; tecSp = false
            else
                if act ~= uKey then
                    cAD = cAD + 1
                    if cAD >= 2 then tecSp = true end
                end
            end
            uT, uKey = t, act
        end
    end)

    RunService.RenderStepped:Connect(function()
        if isClimb or not mActive then return end
        local c = L.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") or not c:FindFirstChild("Humanoid") then return end
        local hrp = c.HumanoidRootPart
        if hrp.Velocity.Magnitude > 320 then
            local v = hrp.Velocity
            local clampY = math.clamp(v.Y, -180, 180)
            local capXZ = Vector3.new(v.X, 0, v.Z)
            local maxSpeed = isFast and MS or SB
            if capXZ.Magnitude > maxSpeed then capXZ = capXZ.Unit * maxSpeed end
            hrp.Velocity = Vector3.new(capXZ.X, clampY, capXZ.Z)
        end
        local tAct = os.clock()
        if c.Humanoid.FloorMaterial ~= Enum.Material.Air or (tAct - uT > 0.15 and tAct - uTG > 0.15) then
            if isFast then frena() end
            isFast, cAD, tecSp, camSp, cG = false, 0, false, false, 0
        end
        local _, aY, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
        local dAng = aY - uAY
        if dAng > math.pi then dAng = dAng - math.pi * 2
        elseif dAng < -math.pi then dAng = dAng + math.pi * 2 end
        if math.abs(dAng) > 0.08 then
            local dAct = math.sign(dAng)
            if dAct ~= dAnt then
                if tAct - uTG < 0.25 then
                    cG = cG + 1
                    if cG >= 3 then camSp = true end
                end
                dAnt, uTG = dAct, tAct
            end
        end
        uAY = aY
        if tecSp and camSp then isFast = true end
        if c.Humanoid.FloorMaterial == Enum.Material.Air then
            local md = c.Humanoid.MoveDirection
            if md.Magnitude > 0 then
                local vY = hrp.Velocity.Y
                local spd = isFast and MS or SB
                local targetVel = Vector3.new(md.X * spd, vY, md.Z * spd)
                hrp.Velocity = hrp.Velocity:Lerp(targetVel, 0.18)
            else
                frena()
            end
        end
    end)

    shared[GLITCH_ID] = function()
        clean()
        for _, cn in ipairs(conns) do if cn and cn.Connected then cn:Disconnect() end end
        shared[GLITCH_ID] = nil
    end
end

--------------------------------------------------------
-- VARIABLES
--------------------------------------------------------
local antiClickAtivo = false
local soundGunActive = false
local soundGunConnections = {}

--------------------------------------------------------
-- ANTI CLICK
--------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if antiClickAtivo then
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool.Enabled = false
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanTouch = false end
                end
            end
        end
    end
end)

--------------------------------------------------------
-- 🔫 SOUND GUN — TU CÓDIGO
--------------------------------------------------------
local function setupSoundGunSystem(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    local animator = humanoid and humanoid:WaitForChild("Animator", 10)

    local SOUND_ID = "rbxassetid://6968135315"
    local TARGET_TOOL_NAME = "Gun"
    local COOLDOWN_DURATION = 5

    local actionSound = Instance.new("Sound")
    actionSound.SoundId = SOUND_ID
    actionSound.Volume = 1
    actionSound.Parent = SoundService

    local lastUnequippedTime = 0
    local isStopping = false

    local animConn
    if animator then
        animConn = animator.AnimationPlayed:Connect(function(track)
            if not soundGunActive or isStopping then return end

            local tool = character:FindFirstChildOfClass("Tool")
            local isHoldingGun = (tool and tool.Name == TARGET_TOOL_NAME)
            local timeSinceUnequip = tick() - lastUnequippedTime
            local withinCooldown = timeSinceUnequip <= COOLDOWN_DURATION

            if isHoldingGun or withinCooldown then
                if track.Priority == Enum.AnimationPriority.Action then
                    isStopping = true
                    track:Stop()
                    task.wait()
                    isStopping = false
                end
            end
        end)
        table.insert(soundGunConnections, animConn)
    end

    local addConn = character.ChildAdded:Connect(function(child)
        if not soundGunActive then return end
        if child:IsA("Tool") and child.Name == TARGET_TOOL_NAME then
            actionSound:Play()
        end
    end)
    table.insert(soundGunConnections, addConn)

    local removeConn = character.ChildRemoved:Connect(function(child)
        if not soundGunActive then return end
        if child:IsA("Tool") and child.Name == TARGET_TOOL_NAME then
            actionSound:Play()
            lastUnequippedTime = tick()
        end
    end)
    table.insert(soundGunConnections, removeConn)
end

local function startSoundGun()
    soundGunActive = true
    soundGunConnections = {}
    if player.Character then
        setupSoundGunSystem(player.Character)
    end
end

local function stopSoundGun()
    soundGunActive = false
    for _, conn in ipairs(soundGunConnections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    soundGunConnections = {}
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    if soundGunActive then setupSoundGunSystem(char) end
end)

--------------------------------------------------------
-- LOGIN
--------------------------------------------------------
local loginGui = Instance.new("ScreenGui")
loginGui.Name = "LoginSecurityGui"
loginGui.ResetOnSpawn = false
loginGui.Parent = playerGui

local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 300, 0, 180)
loginFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
loginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loginFrame.Active = true; loginFrame.Draggable = true
loginFrame.Parent = loginGui
Instance.new("UICorner", loginFrame).CornerRadius = UDim.new(0, 10)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 40)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = isSpecialUser and "✨ Tel4do CNP — ACCESO COMPLETO ✨" or "🔐 Tel4do CNP Panel"
loginTitle.TextColor3 = isSpecialUser and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
loginTitle.Font = Enum.Font.SourceSansBold
loginTitle.TextSize = isSpecialUser and 16 or 18
loginTitle.Parent = loginFrame

local loginInput = Instance.new("TextBox")
loginInput.Size = UDim2.new(0.85, 0, 0, 35)
loginInput.Position = UDim2.new(0.075, 0, 0, 55)
loginInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loginInput.TextColor3 = Color3.fromRGB(255, 255, 255)
loginInput.PlaceholderText = "Enter password..."
loginInput.ClearTextOnFocus = false
loginInput.Visible = not isSpecialUser
loginInput.Parent = loginFrame
Instance.new("UICorner", loginInput).CornerRadius = UDim.new(0, 6)

local loginButton = Instance.new("TextButton")
loginButton.Size = UDim2.new(0.85, 0, 0, 35)
loginButton.Position = UDim2.new(0.075, 0, 0, isSpecialUser and 60 or 105)
loginButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
loginButton.Text = isSpecialUser and "INGRESAR" or "LOGIN"
loginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loginButton.Font = Enum.Font.SourceSansBold
loginButton.Parent = loginFrame
Instance.new("UICorner", loginButton).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.Parent = loginFrame

--------------------------------------------------------
-- GUI PRINCIPAL
--------------------------------------------------------
local function createMainGui()
    loginGui:Destroy()

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "CNP_MainGui"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 210, 0, 340)
    mainFrame.Position = UDim2.new(0, 15, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.Active = true; mainFrame.Draggable = true
    mainFrame.Parent = mainGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -35, 0, 32)
    title.BackgroundTransparency = 1
    title.Text = isSpecialUser and "✨ Tel4do CNP — ACCESO COMPLETO ✨" or "Tel4do CNP Panel"
    title.TextColor3 = isSpecialUser and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 13
    title.Parent = mainFrame

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
    minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
    minimizeBtn.BackgroundColor3 = COLOR_OFF
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Parent = mainFrame
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -8, 1, -38)
    scroll.Position = UDim2.new(0, 4, 0, 34)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    scroll.Parent = mainFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 500)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = scroll

    local function createToggle(name, yPos, visible)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.92, 0, 0, 32)
        btn.Position = UDim2.new(0.04, 0, 0, yPos)
        btn.BackgroundColor3 = COLOR_OFF
        btn.Text = name .. ": Desativado"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.Visible = visible
        btn.Parent = contentFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end

    local btnESP         = createToggle("ESP", 5, true)
    local btnOldAnim     = createToggle("Old Animation", 42, true)
    local btnSpeedEscala  = createToggle("⚡ Speed Escala", 79, true)
    
    local instruccionLabel = Instance.new("TextLabel")
    instruccionLabel.Size = UDim2.new(0.92, 0, 0, 24)
    instruccionLabel.Position = UDim2.new(0.04, 0, 0, 111)
    instruccionLabel.BackgroundTransparency = 1
    instruccionLabel.Text = "Equipa y Saca 3 veces para encenderlo"
    instruccionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    instruccionLabel.Font = Enum.Font.SourceSans
    instruccionLabel.TextSize = 11
    instruccionLabel.Parent = contentFrame

    local btnAntiClick    = createToggle("Anti Click", 138, true)
    local btnSoundGun     = createToggle("🔫 Sound Gun", 175, true)
    local btnConfete     = createToggle("Confete", 212, isSpecialUser)
    local btnAntiCoins   = createToggle("Anti Coins", 249, true)
    local btnGoldBomb    = createToggle("Gold Bomb", 286, true)
    local btnEmotes      = createToggle("Emotes", 323, true)
    local btnCameraOld   = createToggle("Camera Old", 360, true)

    local minimizado = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimizado = not minimizado
        scroll.Visible = not minimizado
        mainFrame.Size = minimizado and UDim2.new(0, 210, 0, 32) or UDim2.new(0, 210, 0, 340)
        minimizeBtn.Text = minimizado and "+" or "-"
        minimizeBtn.BackgroundColor3 = minimizado and COLOR_ON or COLOR_OFF
    end)

    -- Speed Escala
    btnSpeedEscala.MouseButton1Click:Connect(function()
        speedEscalaActive = not speedEscalaActive
        if speedEscalaActive then
            btnSpeedEscala.Text = "⚡ Speed Escala: Ativado"
            btnSpeedEscala.BackgroundColor3 = COLOR_ON
            startSpeedEscala()
        else
            btnSpeedEscala.Text = "⚡ Speed Escala: Desativado"
            btnSpeedEscala.BackgroundColor3 = COLOR_OFF
            if shared[GLITCH_ID] then shared[GLITCH_ID]() end
        end
    end)

    -- Anti Click
    btnAntiClick.MouseButton1Click:Connect(function()
        antiClickAtivo = not antiClickAtivo
        btnAntiClick.Text = antiClickAtivo and "Anti Click: Ativado" or "Anti Click: Desativado"
        btnAntiClick.BackgroundColor3 = antiClickAtivo and COLOR_ON or COLOR_OFF
    end)

    -- 🔫 Sound Gun
    btnSoundGun.MouseButton1Click:Connect(function()
        soundGunActive = not soundGunActive
        if soundGunActive then
            btnSoundGun.Text = "🔫 Sound Gun: Ativado"
            btnSoundGun.BackgroundColor3 = COLOR_ON
            startSoundGun()
        else
            btnSoundGun.Text = "🔫 Sound Gun: Desativado"
            btnSoundGun.BackgroundColor3 = COLOR_OFF
            stopSoundGun()
        end
    end)

    -- ESP
    local espAtivado = false
    local espHighlights = {}
    local function createESP(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        if espHighlights[character] then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "Tel4doESP"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(0, 200, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.55
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        espHighlights[character] = highlight
    end
    btnESP.MouseButton1Click:Connect(function()
        espAtivado = not espAtivado
        btnESP.Text = espAtivado and "ESP: Ativado" or "ESP: Desativado"
        btnESP.BackgroundColor3 = espAtivado and COLOR_ON or COLOR_OFF
        if espAtivado then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then createESP(plr.Character) end
                plr.CharacterAdded:Connect(function() task.wait(0.3) createESP(plr.Character) end)
            end
        else
            for _, h in pairs(espHighlights) do if h then h:Destroy() end end
            table.clear(espHighlights)
        end
    end)

    -- Old Animation
    btnOldAnim.MouseButton1Click:Connect(function()
        local val = workspace.Retargeting == Enum.AnimatorRetargetingMode.Disabled
        workspace.Retargeting = val and Enum.AnimatorRetargetingMode.Default or Enum.AnimatorRetargetingMode.Disabled
        btnOldAnim.Text = val and "Old Animation: Desativado" or "Old Animation: Ativado"
        btnOldAnim.BackgroundColor3 = val and COLOR_OFF or COLOR_ON
    end)

    -- Confete
    if isSpecialUser and NetworkSettings then
        local confeteAtivado = false
        btnConfete.MouseButton1Click:Connect(function()
            confeteAtivado = not confeteAtivado
            btnConfete.Text = confeteAtivado and "Confete: Ativado ✨" or "Confete: Desativado"
            btnConfete.BackgroundColor3 = confeteAtivado and COLOR_ON or COLOR_OFF
        end)
    end

    -- Anti Coins
    local antiCoinsAtivado = false
    btnAntiCoins.MouseButton1Click:Connect(function()
        antiCoinsAtivado = not antiCoinsAtivado
        btnAntiCoins.Text = antiCoinsAtivado and "Anti Coins: Ativado" or "Anti Coins: Desativado"
        btnAntiCoins.BackgroundColor3 = antiCoinsAtivado and COLOR_ON or COLOR_OFF
    end)

    -- Gold Bomb
    btnGoldBomb.MouseButton1Click:Connect(function()
        btnGoldBomb.Text = "Gold Bomb: Ativado"
        btnGoldBomb.BackgroundColor3 = COLOR_ON
    end)

    -- Emotes
    btnEmotes.MouseButton1Click:Connect(function()
        btnEmotes.Text = "Emotes: Ativado"
        btnEmotes.BackgroundColor3 = COLOR_ON
    end)

    -- Camera Old
    btnCameraOld.MouseButton1Click:Connect(function()
        btnCameraOld.Text = "Camera Old: Ativado"
        btnCameraOld.BackgroundColor3 = COLOR_ON
    end)
end

if isSpecialUser then
    task.wait(0.5)
    createMainGui()
else
    loginButton.MouseButton1Click:Connect(function()
        if loginInput.Text == CORRECT_PASSWORD then
            statusLabel.Text = "✅ Correcto..."
            statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
            task.wait(0.5)
            createMainGui()
        else
            statusLabel.Text = "❌ Contraseña incorrecta"
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
end
