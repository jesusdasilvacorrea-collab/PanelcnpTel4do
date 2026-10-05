local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- ⚠️ NetworkSettings protegido con pcall
local NetworkSettings = nil
pcall(function() NetworkSettings = settings():GetService("NetworkSettings") end)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Mouse = player:GetMouse()

-- Contraseña y usuario especial
local CORRECT_PASSWORD = "TEL4DOSCRIPTS2027"
local CONFETE_USER = "COTERCITOPONYTOWN"
local isSpecialUser = (player.Name == CONFETE_USER)

-- Colores
local COLOR_OFF = Color3.fromRGB(200, 50, 50)
local COLOR_ON  = Color3.fromRGB(46, 139, 87)

--------------------------------------------------------
-- 1. PANTALLA DE LOGIN
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
-- 2. GUI PRINCIPAL
--------------------------------------------------------
local function createMainGui()
	loginGui:Destroy()

	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "CNP_MainGui"
	mainGui.ResetOnSpawn = false
	mainGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 210, 0, 280)
	mainFrame.Position = UDim2.new(0, 15, 0.3, 0)
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
	scroll.CanvasSize = UDim2.new(0, 0, 0, 380)
	scroll.Parent = mainFrame

	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 0, 380)
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

	-- Orden de botones — ESP primero ✅
	local btnESP       = createToggle("ESP", 5, true)
	local btnOldAnim   = createToggle("Old Animation", 42, true)
	local btnSistema   = createToggle("Sistema 170", 79, true)
	local btnSoundGun  = createToggle("Sound Gun", 116, true)
	local btnConfete   = createToggle("Confete", 153, isSpecialUser) -- ✅ SOLO visible para él
	local btnAntiCoins = createToggle("Anti Coins", 190, true)
	local btnGoldBomb  = createToggle("Gold Bomb", 227, true)
	local btnEmotes    = createToggle("Emotes Tool", 264, true)
	local btnCameraOld = createToggle("Camera Old", 301, true)

	local minimizado = false
	minimizeBtn.MouseButton1Click:Connect(function()
		minimizado = not minimizado
		scroll.Visible = not minimizado
		mainFrame.Size = minimizado and UDim2.new(0, 210, 0, 32) or UDim2.new(0, 210, 0, 280)
		minimizeBtn.Text = minimizado and "+" or "-"
		minimizeBtn.BackgroundColor3 = minimizado and COLOR_ON or COLOR_OFF
	end)

	--------------------------------------------------------
	-- 👁️ ESP — AÑADIDO ✅
	--------------------------------------------------------
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

	local function removeESP(character)
		if espHighlights[character] then
			espHighlights[character]:Destroy()
			espHighlights[character] = nil
		end
	end

	local function refreshESP()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				if espAtivado then
					createESP(plr.Character)
				else
					removeESP(plr.Character)
				end
			end
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			plr.CharacterAdded:Connect(function()
				task.wait(0.3)
				if espAtivado then createESP(plr.Character) end
			end)
		end
	end

	Players.PlayerRemoving:Connect(function(plr)
		if plr.Character then removeESP(plr.Character) end
	end)

	btnESP.MouseButton1Click:Connect(function()
		espAtivado = not espAtivado
		if espAtivado then
			btnESP.Text = "ESP: Ativado"
			btnESP.BackgroundColor3 = COLOR_ON
			refreshESP()
		else
			btnESP.Text = "ESP: Desativado"
			btnESP.BackgroundColor3 = COLOR_OFF
			for _, h in pairs(espHighlights) do if h then h:Destroy() end end
			table.clear(espHighlights)
		end
	end)

	--------------------------------------------------------
	-- Old Animation
	--------------------------------------------------------
	local oldAnimAtivado = false
	btnOldAnim.MouseButton1Click:Connect(function()
		oldAnimAtivado = not oldAnimAtivado
		if oldAnimAtivado then
			workspace.Retargeting = Enum.AnimatorRetargetingMode.Disabled
			btnOldAnim.Text = "Old Animation: Ativado"
			btnOldAnim.BackgroundColor3 = COLOR_ON
		else
			workspace.Retargeting = Enum.AnimatorRetargetingMode.Default
			btnOldAnim.Text = "Old Animation: Desativado"
			btnOldAnim.BackgroundColor3 = COLOR_OFF
		end
	end)

	--------------------------------------------------------
	-- Sistema 170
	--------------------------------------------------------
	local sistemaAtivado = false
	local humanoid, connSistema = nil, nil

	local function setupChar(c)
		humanoid = c:WaitForChild("Humanoid")
		if connSistema then connSistema:Disconnect() end
		connSistema = humanoid.StateChanged:Connect(function(_, ns)
			humanoid.WalkSpeed = sistemaAtivado and (ns==Enum.HumanoidStateType.Jumping or ns==Enum.HumanoidStateType.Freefall) and 170 or 16
		end)
	end
	if player.Character then setupChar(player.Character) end
	player.CharacterAdded:Connect(setupChar)

	btnSistema.MouseButton1Click:Connect(function()
		sistemaAtivado = not sistemaAtivado
		btnSistema.Text = sistemaAtivado and "Sistema 170: Ativado" or "Sistema 170: Desativado"
		btnSistema.BackgroundColor3 = sistemaAtivado and COLOR_ON or COLOR_OFF
		if not sistemaAtivado and humanoid then humanoid.WalkSpeed = 16 end
	end)

	--------------------------------------------------------
	-- Sound Gun
	--------------------------------------------------------
	local sndGunAtivado, snd, conns = false, nil, {}
	btnSoundGun.MouseButton1Click:Connect(function()
		sndGunAtivado = not sndGunAtivado
		btnSoundGun.Text = sndGunAtivado and "Sound Gun: Ativado" or "Sound Gun: Desativado"
		btnSoundGun.BackgroundColor3 = sndGunAtivado and COLOR_ON or COLOR_OFF
		if sndGunAtivado then
			snd = Instance.new("Sound")
			snd.SoundId = "rbxassetid://6968135315"; snd.Volume = 1; snd.Parent = SoundService
			local connChar
			connChar = player.CharacterAdded:Connect(function(c)
				c.ChildAdded:Connect(function(ch)
					if ch:IsA("Tool") and ch.Name=="Gun" then snd:Play() end
				end)
			end)
			table.insert(conns, connChar)
		else
			for _,c in ipairs(conns) do c:Disconnect() end
			table.clear(conns)
			if snd then snd:Destroy() end
		end
	end)

	--------------------------------------------------------
	-- 🎆 CONFETE — SOLO PARA COTERCITOPONYTOWN
	--------------------------------------------------------
	local confeteAtivado = false
	if isSpecialUser and NetworkSettings then
		local LAG_DURATION = 1.5
		local REPLICATION_LAG = 5.0

		local function simulateLag()
			if not confeteAtivado then return end
			pcall(function()
				NetworkSettings.IncomingReplicationLag = REPLICATION_LAG
				NetworkSettings.OutgoingReplicationLag = REPLICATION_LAG
			end)
			task.wait(LAG_DURATION)
			pcall(function()
				NetworkSettings.IncomingReplicationLag = 0
				NetworkSettings.OutgoingReplicationLag = 0
			end)
		end

		local function monitorChar(c)
			local hum = c:FindFirstChildOfClass("Humanoid")
			if hum then hum.Died:Connect(simulateLag) end
		end

		for _,p in ipairs(Players:GetPlayers()) do
			if p.Character then monitorChar(p.Character) end
			p.CharacterAdded:Connect(monitorChar)
		end
		Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(monitorChar) end)

		local function toggleConfete()
			confeteAtivado = not confeteAtivado
			btnConfete.Text = confeteAtivado and "Confete: Ativado ✨" or "Confete: Desativado"
			btnConfete.BackgroundColor3 = confeteAtivado and COLOR_ON or COLOR_OFF
			if not confeteAtivado then
				pcall(function()
					NetworkSettings.IncomingReplicationLag = 0
					NetworkSettings.OutgoingReplicationLag = 0
				end)
			end
		end

		btnConfete.MouseButton1Click:Connect(toggleConfete)
		UserInputService.InputBegan:Connect(function(i,g)
			if not g and i.KeyCode==Enum.KeyCode.Y then toggleConfete() end
		end)
	end

	--------------------------------------------------------
	-- Anti Coins
	--------------------------------------------------------
	local antiCoinsAtivado, connAC = false, nil
	local function procObj(o)
		if antiCoinsAtivado and o:IsA("BasePart") and (o.Name:find("Coin")) then
			o.CanTouch = false
		end
	end
	btnAntiCoins.MouseButton1Click:Connect(function()
		antiCoinsAtivado = not antiCoinsAtivado
		btnAntiCoins.Text = antiCoinsAtivado and "Anti Coins: Ativado" or "Anti Coins: Desativado"
		btnAntiCoins.BackgroundColor3 = antiCoinsAtivado and COLOR_ON or COLOR_OFF
		if antiCoinsAtivado then
			for _,d in ipairs(workspace:GetDescendants()) do procObj(d) end
			connAC = workspace.DescendantAdded:Connect(procObj)
		else
			if connAC then connAC:Disconnect() end
			for _,d in ipairs(workspace:GetDescendants()) do
				if d:IsA("BasePart") and d.Name:find("Coin") then d.CanTouch = true end
			end
		end
	end)

	--------------------------------------------------------
	-- Gold Bomb
	--------------------------------------------------------
	local goldBombAtivado, bombGui, dropBomb, cd = false, nil, nil, {t=2,ok=true}
	local function makePart()
		local p=Instance.new("Part")
		p.Size=Vector3.new(1.8,0.7,1.2)
		p.Color=Color3.fromRGB(255,180,50)
		p.Material=Enum.Material.Metal
		return p
	end
	local function giveTool()
		local bp=player.Backpack; if not bp then return end
		if bp:FindFirstChild("Gold Bomb TAWA") or (player.Character and player.Character:FindFirstChild("Gold Bomb TAWA")) then return end
		local t=Instance.new("Tool"); t.Name="Gold Bomb TAWA"; t.RequiresHandle=true
		local h=makePart(); h.Name="Handle"; h.Parent=t
		t.Activated:Connect(function()
			if not cd.ok then return end
			local c=player.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
			cd.ok=false
			if dropBomb then dropBomb:Destroy() end
			dropBomb=makePart(); dropBomb.CFrame=hrp.CFrame*CFrame.new(0,-3.2,0); dropBomb.Parent=workspace
			local bv=Instance.new("BodyVelocity"); bv.MaxForce=Vector3.new(1e5,1e5,1e5)
			local dir=(Mouse.Hit.Position-hrp.Position)
			dir=dir.Magnitude>0 and dir.Unit or Vector3.new(1,0,0)
			bv.Velocity=dir*25+Vector3.new(0,10,0); bv.Parent=dropBomb
			task.wait(cd.t); if dropBomb then dropBomb:Destroy(); dropBomb=nil end; cd.ok=true
		end)
		t.Parent=bp
	end
	local function makeMenu()
		bombGui=Instance.new("ScreenGui"); bombGui.ResetOnSpawn=false; bombGui.Parent=playerGui
		local tgl=Instance.new("TextButton"); tgl.Size=UDim2.new(0,60,0,40); tgl.Text="MENU C4"
		tgl.BackgroundColor3=Color3.fromRGB(255,215,0); tgl.Active=true; tgl.Draggable=true; tgl.Parent=bombGui
		local frm=Instance.new("Frame"); frm.Size=UDim2.new(0,180,0,100); frm.Position=UDim2.new(0.5,-90,0.4,0)
		frm.BackgroundColor3=Color3.fromRGB(30,30,30); frm.Visible=false; frm.Parent=bombGui
		Instance.new("UICorner",frm).CornerRadius=UDim.new(0,8)
		local inp=Instance.new("TextBox"); inp.Size=UDim2.new(0.8,0,0,30); inp.Position=UDim2.new(0.1,0,0.2,0)
		inp.Text=tostring(cd.t); inp.BackgroundColor3=Color3.fromRGB(50,50,50); inp.Parent=frm
		local okBtn=Instance.new("TextButton"); okBtn.Size=UDim2.new(0.8,0,0,30); okBtn.Position=UDim2.new(0.1,0,0.55,0)
		okBtn.Text="PRONTO!"; okBtn.BackgroundColor3=Color3.fromRGB(255,215,0); okBtn.Parent=frm
		tgl.MouseButton1Click:Connect(function() frm.Visible=not frm.Visible end)
		okBtn.MouseButton1Click:Connect(function() cd.t=tonumber(inp.Text) or 2; frm.Visible=false end)
	end
	btnGoldBomb.MouseButton1Click:Connect(function()
		goldBombAtivado=not goldBombAtivado
		btnGoldBomb.Text=goldBombAtivado and "Gold Bomb: Ativado" or "Gold Bomb: Desativado"
		btnGoldBomb.BackgroundColor3=goldBombAtivado and COLOR_ON or COLOR_OFF
		if goldBombAtivado then makeMenu(); giveTool()
			player.CharacterAdded:Connect(function() task.wait(1); giveTool() end)
		else
			if bombGui then bombGui:Destroy() end
			if dropBomb then dropBomb:Destroy() end
			for _,n in ipairs({"Backpack","Character"}) do
				local p=player[n]; if p then local t=p:FindFirstChild("Gold Bomb TAWA") if t then t:Destroy() end end
			end
		end
	end)

	--------------------------------------------------------
	-- Emotes Tool
	--------------------------------------------------------
	local emotesAtivado = false
	local function sendT()
		VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.T,false,game)
		task.wait(0.01)
		VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.T,false,game)
	end
	btnEmotes.MouseButton1Click:Connect(function()
		emotesAtivado = not emotesAtivado
		btnEmotes.Text = emotesAtivado and "Emotes Tool: Ativado" or "Emotes Tool: Desativado"
		btnEmotes.BackgroundColor3 = emotesAtivado and COLOR_ON or COLOR_OFF
		if emotesAtivado then
			local function add() local bp=player.Backpack; if not bp then return end
				if bp:FindFirstChild("Emotes Tool") then return end
				local t=Instance.new("Tool"); t.Name="Emotes Tool"; t.RequiresHandle=false
				t.Activated:Connect(sendT); t.Parent=bp
			end
			add(); player.CharacterAdded:Connect(function() task.wait(0.5); add() end)
		else
			for _,n in ipairs({"Backpack","Character"}) do
				local p=player[n]; if p then local t=p:FindFirstChild("Emotes Tool") if t then t:Destroy() end end
			end
		end
	end)

	--------------------------------------------------------
	-- Camera Old
	--------------------------------------------------------
	local camOldAtivado, connCam = false, nil
	local cam = workspace.CurrentCamera
	btnCameraOld.MouseButton1Click:Connect(function()
		camOldAtivado = not camOldAtivado
		btnCameraOld.Text = camOldAtivado and "Camera Old: Ativado" or "Camera Old: Desativado"
		btnCameraOld.BackgroundColor3 = camOldAtivado and COLOR_ON or COLOR_OFF
		if camOldAtivado then
			connCam = RunService.RenderStepped:Connect(function()
				if (cam.Focus.Position - cam.CFrame.Position).Magnitude > 1 then
					cam.CFrame = cam.CFrame + Vector3.new(0, 0.3, 0)
				end
			end)
		else
			if connCam then connCam:Disconnect() end
		end
	end)
end

--------------------------------------------------------
-- ACCESO
--------------------------------------------------------
if isSpecialUser then
	task.wait(0.5)
	createMainGui()
else
	loginButton.MouseButton1Click:Connect(function()
		if loginInput.Text == CORRECT_PASSWORD then
			statusLabel.TextColor3 = Color3.fromRGB(80,255,80)
			statusLabel.Text = "Access granted!"
			task.wait(0.4)
			createMainGui()
		else
			statusLabel.TextColor3 = Color3.fromRGB(255,80,80)
			statusLabel.Text = "Wrong password!"
			loginInput.Text = ""
		end
	end)
	loginInput.FocusLost:Connect(function(e) if e then loginButton:Fire() end end)
end
