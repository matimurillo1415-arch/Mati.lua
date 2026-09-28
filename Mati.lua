local playerService = game:GetService("Players")
local localPlayer = playerService.LocalPlayer
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local virtualInput = game:GetService("VirtualInputManager")
local lighting = game:GetService("Lighting")
local floorFn = math.floor

-- Galaxy theme
local galaxyDark = Color3.fromRGB(8, 6, 24)
local galaxyPurple = Color3.fromRGB(105, 48, 195)
local galaxyBlue = Color3.fromRGB(45, 85, 255)
local galaxyCyan = Color3.fromRGB(45, 220, 255)
local galaxyPink = Color3.fromRGB(220, 70, 255)

local function checkWhitelist(userId)
    return userId == 9676922714
        or userId == 8672442115
        or userId == 2693243847
        or userId == 11726151541
        or userId == 7367626560
        or userId == 5561169821
        or userId == 7183441935
        or userId == 3576019090
        or userId == 2246798882
end

local function formatNumberShort(value)
    value = math.abs(value)
    if value >= 1e15 then return string.format("%.2fQ", value / 1e15) end
    if value >= 1e12 then return string.format("%.2fT", value / 1e12) end
    if value >= 1e9 then return string.format("%.2fB", value / 1e9) end
    if value >= 1e6 then return string.format("%.2fM", value / 1e6) end
    if value >= 1e3 then return string.format("%.2fK", value / 1e3) end
    return string.format("%.0f", value)
end

local function formatNumberSigned(value)
    local isNegative = value < 0
    local prefix = isNegative and "-" or ""
    value = math.abs(value)
    if value >= 1e15 then return prefix .. string.format("%.2fQa", value / 1e15) end
    if value >= 1e12 then return prefix .. string.format("%.2fT", value / 1e12) end
    if value >= 1e9 then return prefix .. string.format("%.2fB", value / 1e9) end
    if value >= 1e6 then return prefix .. string.format("%.2fM", value / 1e6) end
    if value >= 1e3 then return prefix .. string.format("%.2fK", value / 1e3) end
    return prefix .. string.format("%.2f", value)
end

local function equipToolByName(toolName)
    pcall(function()
        local tool = localPlayer.Backpack:FindFirstChild(toolName)
        if tool then
            localPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SCPPaidLoad"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 170)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -85)
mainFrame.BackgroundColor3 = galaxyDark
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.BackgroundColor3 = galaxyPurple
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame
Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 14)

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, galaxyPurple),
    ColorSequenceKeypoint.new(0.5, galaxyBlue),
    ColorSequenceKeypoint.new(1, galaxyPink)
})
headerGradient.Rotation = 15
headerGradient.Parent = headerFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = galaxyCyan
frameStroke.Thickness = 2
frameStroke.Transparency = 0.15
frameStroke.Parent = mainFrame

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, 0, 1, 0)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "Clan TAKKO private"
headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
headerLabel.TextSize = 20
headerLabel.Font = Enum.Font.GothamBold
headerLabel.Parent = headerFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.new(0, 0, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Verificando whitelist..."
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 15
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0, 30)
footerLabel.Position = UDim2.new(0, 0, 0, 128)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "Private Can't Buy"
footerLabel.TextColor3 = galaxyCyan
footerLabel.TextSize = 14
footerLabel.Font = Enum.Font.GothamBold
footerLabel.Parent = mainFrame

task.spawn(function()
    while screenGui.Parent do
        local phase = (math.sin(tick() * 1.8) + 1) / 2
        headerFrame.BackgroundColor3 = galaxyPurple:Lerp(galaxyBlue, phase)
        frameStroke.Color = galaxyCyan:Lerp(galaxyPink, phase)
        footerLabel.TextColor3 = galaxyCyan:Lerp(galaxyPink, phase)
        task.wait(0.03)
    end
end)

task.wait()

if localPlayer then
    if not localPlayer.Character then
        localPlayer.CharacterAdded:Wait()
    end

    localPlayer:WaitForChild("leaderstats", 15)
    task.wait(1)

    local isNotWhitelisted = not checkWhitelist(localPlayer.UserId)
    if isNotWhitelisted then
        statusLabel.Text = "NOT WHITELISTED! | ID: " .. tostring(localPlayer.UserId)
        statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        task.wait(3)
        screenGui:Destroy()
        localPlayer:Kick("NOT WHITELISTED! UserId: " .. tostring(localPlayer.UserId))
        return
    end

    statusLabel.Text = "Bienvenido, " .. localPlayer.Name .. " | ID: " .. tostring(localPlayer.UserId)
    statusLabel.TextColor3 = galaxyCyan
    task.wait(2)
    screenGui:Destroy()

    local playerName = localPlayer.Name
    local playerUserId = localPlayer.UserId
    local muscleEvent = localPlayer:WaitForChild("muscleEvent")
    local leaderstats = localPlayer:WaitForChild("leaderstats")
    local rebirthsStat = leaderstats:WaitForChild("Rebirths")

    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YoshiroScripts/Wspwsp/refs/heads/main/Decode", true))()
    local mainWindow = library:AddWindow("              Clan TAKKO private       |      Farming Script     |  Bienvenido " .. localPlayer.Name .. " ", {
        main_color = galaxyPurple,
        min_size = Vector2.new(700, 700),
        can_resize = true,
    })

    local displayName = localPlayer.DisplayName or localPlayer.Name

    local infoTab = mainWindow:AddTab("InfoTab")
    local separator = string.rep("\xe2\x95\x90", 38)
    infoTab:AddLabel(separator)

    local welcomeLabel = infoTab:AddLabel("BIENVENIDO " .. string.upper(localPlayer.Name) .. " A CLAN TAKKO PRIVATE")
    welcomeLabel.TextSize = 28
    task.spawn(function()
        while true do
            local phase = (math.sin(tick() * 1.6) + 1) / 2
            welcomeLabel.TextColor3 = galaxyPurple:Lerp(galaxyCyan, phase)
            task.wait(0.02)
        end
    end)

    infoTab:AddLabel(separator)
    infoTab:AddLabel("Made by: MatiClanTAKKO")
    infoTab:AddLabel("Version: MatiClanTAKKO")
    infoTab:AddLabel(separator)
    infoTab:AddLabel("TABS: Stats | Pack Rebs | Speed Farm | Rocks | Gifting | Settings")

    local statsTab = mainWindow:AddTab("STATS")
    local strengthStat = leaderstats:WaitForChild("Strength")
    local rebirthsStatRef = leaderstats:WaitForChild("Rebirths")
    local killsStat = leaderstats:WaitForChild("Kills")
    local durabilityStat = localPlayer:WaitForChild("Durability")
    local agilityStat = localPlayer:WaitForChild("Agility")
    local evilKarmaStat = localPlayer:WaitForChild("evilKarma")
    local goodKarmaStat = localPlayer:WaitForChild("goodKarma")

    local initialStrength = strengthStat.Value
    local initialDurability = durabilityStat.Value
    local initialRebirths = rebirthsStatRef.Value
    local sessionStartTime = os.time()

    statsTab:AddLabel("[ SESSION STATS ]")
    local timeLabel = statsTab:AddLabel("Time in server: 0d 0h 0m 0s")
    task.spawn(function()
        while task.wait(1) do
            local elapsed = os.time() - sessionStartTime
            timeLabel.Text = string.format(
                "Time in server: %dd %dh %dm %ds",
                floorFn(elapsed / 86400),
                floorFn(elapsed % 86400 / 3600),
                floorFn(elapsed % 3600 / 60),
                elapsed % 60
            )
        end
    end)

    statsTab:AddLabel(separator)
    statsTab:AddLabel("[ YOUR STATS ]")

    local strengthLabel = statsTab:AddLabel("Strength: 0 | Gained: 0")
    local durabilityLabel = statsTab:AddLabel("Durability: 0 | Gained: 0")
    local rebirthsLabel = statsTab:AddLabel("Rebirths: 0 | Gained: 0")
    local killsLabel = statsTab:AddLabel("Kills: 0")
    local agilityLabel = statsTab:AddLabel("Agility: 0")
    local evilKarmaLabel = statsTab:AddLabel("Evil Karma: 0")
    local goodKarmaLabel = statsTab:AddLabel("Good Karma: 0")

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                strengthLabel.Text = "Strength: " .. formatNumberShort(strengthStat.Value) .. " | Gained: " .. formatNumberShort(strengthStat.Value - initialStrength)
                durabilityLabel.Text = "Durability: " .. formatNumberShort(durabilityStat.Value) .. " | Gained: " .. formatNumberShort(durabilityStat.Value - initialDurability)
                rebirthsLabel.Text = "Rebirths: " .. formatNumberShort(rebirthsStatRef.Value) .. " | Gained: " .. formatNumberShort(rebirthsStatRef.Value - initialRebirths)
                killsLabel.Text = "Kills: " .. formatNumberShort(killsStat.Value)
                agilityLabel.Text = "Agility: " .. formatNumberShort(agilityStat.Value)
                evilKarmaLabel.Text = "Evil Karma: " .. formatNumberShort(evilKarmaStat.Value)
                goodKarmaLabel.Text = "Good Karma: " .. formatNumberShort(goodKarmaStat.Value)
            end)
        end
    end)

    statsTab:AddLabel(separator)
    statsTab:AddLabel("[ RATE TRACKER (Strength & Durability) ]")
    local strengthRateLabel = statsTab:AddLabel("Strength Rate: warming up...")
    local durabilityRateLabel = statsTab:AddLabel("Durability Rate: warming up...")

    local strengthSamples = {}
    local durabilitySamples = {}
    local rateTrackingStarted = false
    local rateWindow = 10

    task.spawn(function()
        local lastCalcTime = tick()
        while task.wait(0.05) do
            pcall(function()
                local now = tick()
                local currentStrength = strengthStat.Value

                if not rateTrackingStarted and currentStrength - initialStrength >= 1000000000 then
                    rateTrackingStarted = true
                    strengthSamples = {}
                    durabilitySamples = {}
                end

                if rateTrackingStarted then
                    table.insert(strengthSamples, { t = now, v = currentStrength })
                    table.insert(durabilitySamples, { t = now, v = durabilityStat.Value })

                    while #strengthSamples > 0 and now - strengthSamples[1].t > rateWindow do
                        table.remove(strengthSamples, 1)
                    end

                    while #durabilitySamples > 0 and now - durabilitySamples[1].t > rateWindow do
                        table.remove(durabilitySamples, 1)
                    end

                    if now - lastCalcTime >= rateWindow then
                        lastCalcTime = now
                        if #strengthSamples >= 2 then
                            local rate = (strengthSamples[#strengthSamples].v - strengthSamples[1].v) / rateWindow
                            strengthRateLabel.Text = "Str: " .. formatNumberShort(floorFn(rate * 3600)) .. "/hr | " .. formatNumberShort(floorFn(rate * 86400)) .. "/day"
                        end
                        if #durabilitySamples >= 2 then
                            local rate = (durabilitySamples[#durabilitySamples].v - durabilitySamples[1].v) / rateWindow
                            durabilityRateLabel.Text = "Dur: " .. formatNumberShort(floorFn(rate * 3600)) .. "/hr | " .. formatNumberShort(floorFn(rate * 86400)) .. "/day"
                        end
                    end
                end
            end)
        end
    end)

    statsTab:AddLabel(separator)
    statsTab:AddLabel("[ TRACK OTHER PLAYERS ]")

    local trackedPlayerLabel = statsTab:AddLabel("Player: -")
    local trackedStrengthLabel = statsTab:AddLabel("Strength: -")
    local trackedDurabilityLabel = statsTab:AddLabel("Durability: -")
    local trackedRebirthsLabel = statsTab:AddLabel("Rebirths: -")
    local trackedKillsLabel = statsTab:AddLabel("Kills: -")
    local trackedAgilityLabel = statsTab:AddLabel("Agility: -")
    local trackedPlayer = nil

    local function updateTrackedPlayer(player)
        if not player then
            trackedPlayerLabel.Text = "Player: Not Found"
            return
        end
        trackedPlayerLabel.Text = "Player: " .. player.Name .. " (" .. player.DisplayName .. ")"
        local stats = player:FindFirstChild("leaderstats")
        if stats then
            local str = stats:FindFirstChild("Strength")
            trackedStrengthLabel.Text = "Strength: " .. formatNumberShort(str and str.Value or 0)
            local reb = stats:FindFirstChild("Rebirths")
            trackedRebirthsLabel.Text = "Rebirths: " .. formatNumberShort(reb and reb.Value or 0)
            local kls = stats:FindFirstChild("Kills")
            trackedKillsLabel.Text = "Kills: " .. formatNumberShort(kls and kls.Value or 0)
        end
        local dur = player:FindFirstChild("Durability")
        trackedDurabilityLabel.Text = "Durability: " .. formatNumberShort(dur and dur.Value or 0)
        local agi = player:FindFirstChild("Agility")
        trackedAgilityLabel.Text = "Agility: " .. formatNumberShort(agi and agi.Value or 0)
    end

    statsTab:AddTextBox("Search player (name or display name)", function(input)
        local searchLower = input:lower()
        for _, plr in ipairs(playerService:GetPlayers()) do
            if plr.Name:lower():find(searchLower, 1, true) or plr.DisplayName:lower():find(searchLower, 1, true) then
                trackedPlayer = plr
                break
            end
        end
        updateTrackedPlayer(trackedPlayer)
    end, { clear = false, placeholder = "Type name..." })

    task.spawn(function()
        while task.wait(1) do
            if trackedPlayer then
                updateTrackedPlayer(trackedPlayer)
            end
        end
    end)

    local farmTab = mainWindow:AddTab("Farm V1")
    farmTab:AddLabel(separator)
    farmTab:AddLabel("AUTO KING (teleport to king position):")

    local kingPosition = CFrame.new(-8865, 430, -5749)

    farmTab:AddSwitch("Auto King", function(enabled)
        if enabled then
            getgenv().kingLockConnection = runService.Heartbeat:Connect(function()
                local character = localPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = kingPosition
                end
            end)
        else
            if getgenv().kingLockConnection then
                getgenv().kingLockConnection:Disconnect()
                getgenv().kingLockConnection = nil
            end
        end
    end)

    farmTab:AddLabel(separator)
    farmTab:AddLabel("REBIRTH FUNCTIONS:")

    local targetRebirthAmount = 0
    farmTab:AddTextBox("Target Rebirth Amount", function(input)
        targetRebirthAmount = tonumber(input) or 0
    end, { clear = false, placeholder = "Enter target rebirth amount" })

    farmTab:AddSwitch("Auto Rebirth", function(enabled)
        getgenv().autoRebirth = enabled
        if enabled then
            spawn(function()
                while getgenv().autoRebirth do
                    local stats = localPlayer:FindFirstChild("leaderstats")
                    if stats then
                        local rebirths = stats:FindFirstChild("Rebirths")
                        if rebirths and targetRebirthAmount > 0 and rebirths.Value >= targetRebirthAmount then
                            getgenv().autoRebirth = false
                            break
                        end
                        pcall(function()
                            replicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                        end)
                        task.wait(0.1)
                    end
                end
            end)
        end
    end)

    farmTab:AddLabel("═══ AUTO WEIGHT ═══")
    farmTab:AddSwitch("Auto Weight", function(enabled)
        getgenv().autoWeight = enabled
        if enabled then
            spawn(function()
                while getgenv().autoWeight do
                    pcall(function()
                        local tool = localPlayer.Backpack:FindFirstChild("Weight")
                        if tool then
                            localPlayer.Character.Humanoid:EquipTool(tool)
                        end
                        localPlayer.muscleEvent:FireServer("rep")
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end)

    farmTab:AddLabel("═══ FAST REP ═══")
    farmTab:AddSwitch("Fast Rep", function(enabled)
        getgenv().fastRepFarmV1 = enabled
        if enabled then
            task.spawn(function()
                while getgenv().fastRepFarmV1 do
                    pcall(function()
                        local character = localPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local tool = localPlayer.Backpack:FindFirstChild("Weight")
                        if tool and humanoid then
                            humanoid:EquipTool(tool)
                        end

                        -- Envía varias repeticiones por ciclo para acelerar las pesas
                        for _ = 1, 5 do
                            muscleEvent:FireServer("rep")
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end)

    farmTab:AddLabel("═══ AUTO SIZE 2 ═══")
    farmTab:AddSwitch("Auto Size 2", function(enabled)
        getgenv().autoSize2 = enabled
        if enabled then
            spawn(function()
                while getgenv().autoSize2 do
                    pcall(function()
                        replicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
                    end)
                    task.wait(0)
                end
            end)
        end
    end)

    farmTab:AddLabel(separator)
    farmTab:AddLabel("AUTO EQUIP TOOLS:")

    farmTab:AddSwitch("Auto Equip Weight", function(enabled)
        getgenv().autoWeightSp = enabled
        if enabled then
            spawn(function()
                while getgenv().autoWeightSp do
                    equipToolByName("Weight")
                    task.wait(0.2)
                end
            end)
        end
    end)

    farmTab:AddSwitch("Auto Equip Pushups", function(enabled)
        getgenv().autoPushupsSp = enabled
        if enabled then
            spawn(function()
                while getgenv().autoPushupsSp do
                    equipToolByName("Pushups")
                    task.wait(0.2)
                end
            end)
        end
    end)

    farmTab:AddSwitch("Auto Equip Situps", function(enabled)
        getgenv().autoSitupsSp = enabled
        if enabled then
            spawn(function()
                while getgenv().autoSitupsSp do
                    equipToolByName("Situps")
                    task.wait(0.2)
                end
            end)
        end
    end)

    farmTab:AddSwitch("Auto Equip Handstands", function(enabled)
        getgenv().autoHandstandsSp = enabled
        if enabled then
            spawn(function()
                while getgenv().autoHandstandsSp do
                    equipToolByName("Handstand")
                    task.wait(0.2)
                end
            end)
        end
    end)

    local fastRebirthTab = mainWindow:AddTab("Fast Rebirth")

    local fastRebirthActive = false
    local fastRebirthStartTick = 0
    local fastRebirthAccumulatedTime = 0
    local fastRebirthInitialRebirths = rebirthsStat.Value

    fastRebirthTab:AddLabel("Time:").TextSize = 20
    local fastRebirthTimeLabel = fastRebirthTab:AddLabel("0d 0h 0m 0s - Inactive")
    local paceLabel = fastRebirthTab:AddLabel("Pace: 0 / Hour | 0 / Day | 0 / Week")
    local avgPaceLabel = fastRebirthTab:AddLabel("Average Pace: 0 / Hour | 0 / Day | 0 / Week")

    paceLabel.TextSize = 17
    avgPaceLabel.TextSize = 17
    fastRebirthTimeLabel.TextSize = 17
    fastRebirthTimeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

    local rebirthsDisplayLabel = fastRebirthTab:AddLabel("Rebirths: " .. formatNumberShort(rebirthsStat.Value) .. " | Gained: 0")
    rebirthsDisplayLabel.TextSize = 17

    local previousRebirthValue = rebirthsStat.Value
    local paceCounter = 0
    local paceSamplesHr = {}
    local paceSamplesDay = {}
    local paceSamplesWeek = {}
    local maxPaceSamples = 20
    local lastPaceCalcTick = tick()
    local lastPaceRebirthValue = rebirthsStat.Value

    local function updateRebirthDisplay()
        rebirthsDisplayLabel.Text = string.format("Rebirths: %s | Gained: %s", formatNumberShort(rebirthsStat.Value), formatNumberShort(rebirthsStat.Value - fastRebirthInitialRebirths))
    end

    local function updateFastRebirthTimer(forceUpdate)
        local elapsed = fastRebirthActive and (tick() - fastRebirthStartTick + fastRebirthAccumulatedTime) or fastRebirthAccumulatedTime
        fastRebirthTimeLabel.Text = string.format(
            "%dd %dh %dm %ds - %s",
            floorFn(elapsed / 86400),
            floorFn(elapsed % 86400 / 3600),
            floorFn(elapsed % 3600 / 60),
            floorFn(elapsed % 60),
            fastRebirthActive and "Rebirthing" or "Paused"
        )
        fastRebirthTimeLabel.TextColor3 = fastRebirthActive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end

    local function calculatePace()
        paceCounter = paceCounter + 1
        if paceCounter < 2 then
            lastPaceCalcTick = tick()
            lastPaceRebirthValue = rebirthsStat.Value
            return
        end
        local now = tick()
        local gained = rebirthsStat.Value - lastPaceRebirthValue
        if gained > 0 then
            local timePer = (now - lastPaceCalcTick) / gained
            local perHour = 3600 / timePer
            local perDay = 86400 / timePer
            local perWeek = 604800 / timePer
            paceLabel.Text = string.format("Pace: %s / Hour | %s / Day | %s / Week", formatNumberShort(perHour), formatNumberShort(perDay), formatNumberShort(perWeek))
            table.insert(paceSamplesHr, perHour)
            table.insert(paceSamplesDay, perDay)
            table.insert(paceSamplesWeek, perWeek)
            if #paceSamplesHr > maxPaceSamples then
                table.remove(paceSamplesHr, 1)
                table.remove(paceSamplesDay, 1)
                table.remove(paceSamplesWeek, 1)
            end
            local function average(tbl)
                local sum = 0
                for _, val in ipairs(tbl) do
                    sum = sum + val
                end
                return #tbl > 0 and sum / #tbl or 0
            end
            avgPaceLabel.Text = string.format("Average Pace: %s / Hour | %s / Day | %s / Week", formatNumberShort(average(paceSamplesHr)), formatNumberShort(average(paceSamplesDay)), formatNumberShort(average(paceSamplesWeek)))
            lastPaceCalcTick = now
            lastPaceRebirthValue = rebirthsStat.Value
        end
    end

    rebirthsStat:GetPropertyChangedSignal("Value"):Connect(function()
        calculatePace()
        updateRebirthDisplay()
    end)

    local function unequipAllPets()
        pcall(function()
            local petsFolder = localPlayer.petsFolder
            for _, folder in pairs(petsFolder:GetChildren()) do
                if folder:IsA("Folder") then
                    for _, pet in pairs(folder:GetChildren()) do
                        replicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
                    end
                end
            end
        end)
        task.wait(0.1)
    end

    local function equipUniquePet(petName)
        unequipAllPets()
        task.wait(0.01)
        pcall(function()
            local uniqueFolder = localPlayer.petsFolder.Unique
            for _, pet in pairs(uniqueFolder:GetChildren()) do
                if pet.Name == petName then
                    replicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
                end
            end
        end)
    end

    local function useTropicalShake()
        pcall(function()
            local character = localPlayer.Character
            local shake = character:FindFirstChild("Tropical Shake")
            if shake then
                muscleEvent:FireServer("tropicalShake", shake)
            end
        end)
    end

    local autoTropicalShakeEnabled = false
    task.spawn(function()
        while true do
            if autoTropicalShakeEnabled then
                useTropicalShake()
                task.wait(450)
            else
                task.wait(1)
            end
        end
    end)

    local function useProteinEgg()
        pcall(function()
            local character = localPlayer.Character
            local egg = character:FindFirstChild("Protein Egg")
            if egg then
                muscleEvent:FireServer("proteinEgg", egg)
            end
        end)
    end

    local autoProteinEggEnabled = false
    task.spawn(function()
        while true do
            if autoProteinEggEnabled then
                useProteinEgg()
                task.wait(1800)
            else
                task.wait(1)
            end
        end
    end)

    local autoTropicalShake2Enabled = false
    task.spawn(function()
        while true do
            if autoTropicalShake2Enabled then
                useTropicalShake()
                task.wait(900)
            else
                task.wait(1)
            end
        end
    end)

    local function fastRebirthLoop()
        while fastRebirthActive do
            equipUniquePet("Swift Samurai")
            local requiredStrength = 5000 + rebirthsStat.Value * 2550
            while fastRebirthActive and localPlayer.leaderstats.Strength.Value < requiredStrength do
                local reps = localPlayer.MembershipType == Enum.MembershipType.Premium and 8 or 14
                for _ = 1, reps do
                    muscleEvent:FireServer("rep")
                end
                task.wait(0.02)
            end
            if fastRebirthActive and localPlayer.leaderstats.Strength.Value >= requiredStrength then
                equipUniquePet("Tribal Overlord")
                task.wait(0.25)
                local prevRebirths = rebirthsStat.Value
                replicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.05)
                if rebirthsStat.Value > prevRebirths or not fastRebirthActive then
                end
            end
            task.wait(0.5)
        end
    end

    fastRebirthTab:AddSwitch("Fast Rebirth", function(enabled)
        fastRebirthActive = enabled
        if enabled then
            fastRebirthStartTick = tick()
            task.spawn(fastRebirthLoop)
        else
            fastRebirthAccumulatedTime = fastRebirthAccumulatedTime + tick() - fastRebirthStartTick
            updateFastRebirthTimer(true)
        end
    end)

    rebirthsStat:GetPropertyChangedSignal("Value"):Connect(function()
        if fastRebirthActive then
            calculatePace()
        end
        updateRebirthDisplay()
    end)

    task.spawn(function()
        while true do
            updateFastRebirthTimer(false)
            task.wait(0.1)
        end
    end)

    local autoMinSizeEnabled = false
    local autoMinSizeCoroutine = nil

    fastRebirthTab:AddSwitch("Auto Size 1", function(enabled)
        autoMinSizeEnabled = enabled
        if enabled then
            autoMinSizeCoroutine = coroutine.create(function()
                while autoMinSizeEnabled do
                    replicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                    wait(0.01)
                end
            end)
            coroutine.resume(autoMinSizeCoroutine)
        end
    end)

    local function applyDarkMode()
        pcall(function()
            local playerGui = localPlayer:WaitForChild("PlayerGui")
            local lightingService = game:GetService("Lighting")

            for _, gui in pairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    gui:Destroy()
                end
            end

            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj:Destroy()
                end
            end

            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    obj:Destroy()
                end
            end

            for _, obj in pairs(lightingService:GetChildren()) do
                if obj:IsA("Sky") then
                    obj:Destroy()
                end
            end

            local darkSky = Instance.new("Sky")
            darkSky.Name = "DarkSky"
            darkSky.SkyboxBk = "rbxassetid://0"
            darkSky.SkyboxDn = "rbxassetid://0"
            darkSky.SkyboxFt = "rbxassetid://0"
            darkSky.SkyboxLf = "rbxassetid://0"
            darkSky.SkyboxRt = "rbxassetid://0"
            darkSky.SkyboxUp = "rbxassetid://0"
            darkSky.Parent = lightingService
            lightingService.Brightness = 0
            lightingService.ClockTime = 0
            lightingService.TimeOfDay = "00:00:00"
            lightingService.OutdoorAmbient = Color3.new(0, 0, 0)
            lightingService.Ambient = Color3.new(0, 0, 0)
            lightingService.FogColor = Color3.new(0, 0, 0)
            lightingService.FogEnd = 100

            task.spawn(function()
                while true do
                    wait(5)
                    if not lightingService:FindFirstChild("DarkSky") then
                        darkSky:Clone().Parent = lightingService
                    end
                    lightingService.Brightness = 0
                    lightingService.ClockTime = 0
                    lightingService.OutdoorAmbient = Color3.new(0, 0, 0)
                    lightingService.Ambient = Color3.new(0, 0, 0)
                    lightingService.FogColor = Color3.new(0, 0, 0)
                    lightingService.FogEnd = 100
                end
            end)
        end)
    end

    fastRebirthTab:AddButton("Dark Mode", applyDarkMode)

    fastRebirthTab:AddSwitch("Auto Fortune Wheel", function(enabled)
        _G.AutoSpinWheel = enabled
        if enabled then
            spawn(function()
                while _G.AutoSpinWheel do
                    pcall(function()
                        replicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", replicatedStorage.fortuneWheelChances["Fortune Wheel"])
                    end)
                    wait(1)
                end
            end)
        end
    end)

    fastRebirthTab:AddButton("Teleport to Fortune Wheel", function()
        local character = localPlayer.Character
        if character then
            character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8642.396484375, 6.7980651855, 2086.1030273)
            task.wait(0.2)
            virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    end)

    local lockPositionEnabled = false
    local lockPositionCoroutine = nil

    fastRebirthTab:AddSwitch("Lock Position", function(enabled)
        lockPositionEnabled = enabled
        if enabled then
            local character = localPlayer.Character
            if character then
                local rootPart = character:WaitForChild("HumanoidRootPart")
                local lockedPosition = rootPart.Position
                lockPositionCoroutine = coroutine.create(function()
                    while lockPositionEnabled do
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                        rootPart.RotVelocity = Vector3.new(0, 0, 0)
                        rootPart.CFrame = CFrame.new(lockedPosition)
                        wait(0.05)
                    end
                end)
                coroutine.resume(lockPositionCoroutine)
            end
        end
    end)

    fastRebirthTab:AddSwitch("Auto Tropical Shake", function(enabled)
        autoTropicalShakeEnabled = enabled
        if enabled then
            useTropicalShake()
        end
    end)

    fastRebirthTab:AddSwitch("Auto Protein Egg", function(enabled)
        autoProteinEggEnabled = enabled
        if enabled then
            useProteinEgg()
        end
    end)

    fastRebirthTab:AddSwitch("Auto Tropical Shake 2", function(enabled)
        autoTropicalShake2Enabled = enabled
        if enabled then
            useTropicalShake()
        end
    end)

    fastRebirthTab:AddSwitch("Auto Fortune Wheel 2", function(enabled)
        _G.AutoSpinWheel = enabled
        if enabled then
            spawn(function()
                while _G.AutoSpinWheel do
                    pcall(function()
                        replicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", replicatedStorage.fortuneWheelChances["Fortune Wheel"])
                    end)
                    wait(1)
                end
            end)
        end
    end)

    fastRebirthTab:AddButton("Teleport to Shop", function()
        local character = localPlayer.Character
        if character then
            character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8371.43359375, 6.79806327, 2858.8852539)
            task.wait(0.2)
            virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    end)

    fastRebirthTab:AddButton("Dark Mode 2", applyDarkMode)

    fastRebirthTab:AddButton("Equip Swift Samurai", function()
        unequipAllPets()
        equipUniquePet("Swift Samurai")
    end)

    local speedFarmTab = mainWindow:AddTab("Speed Farm")
    local initialStrengthSpeed = strengthStat.Value
    local initialDurabilitySpeed = durabilityStat.Value
    local speedFarmStrengthLabel = speedFarmTab:AddLabel("Strength: 0 | Gained: 0")
    local speedFarmDurabilityLabel = speedFarmTab:AddLabel("Durability: 0 | Gained: 0")
    speedFarmStrengthLabel.TextSize = 17
    speedFarmDurabilityLabel.TextSize = 17

    local speedFarmActive = false
    local speedFarmRunning = false
    local speedFarmStartTick = 0
    local speedFarmAccumulatedTime = 0
    local speedFarmStrSamples = {}
    local speedFarmDurSamples = {}
    local speedFarmRateWindow = 10

    local speedFarmTimeLabel = speedFarmTab:AddLabel("0d 0h 0m 0s - Inactive")
    speedFarmTimeLabel.TextSize = 17
    speedFarmTimeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

    local speedFarmStrPaceLabel = speedFarmTab:AddLabel("Strength Pace: warming up...")
    speedFarmStrPaceLabel.TextSize = 17
    local speedFarmDurPaceLabel = speedFarmTab:AddLabel("Durability Pace: warming up...")
    speedFarmDurPaceLabel.TextSize = 17
    local speedFarmAvgStrPaceLabel = speedFarmTab:AddLabel("Average Strength Pace: warming up...")
    speedFarmAvgStrPaceLabel.TextSize = 17
    local speedFarmAvgDurPaceLabel = speedFarmTab:AddLabel("Average Durability Pace: warming up...")
    speedFarmAvgDurPaceLabel.TextSize = 17

    local repsPerCycle = 1

    local function getPing()
        local ping = 0
        pcall(function()
            local stats = game:GetService("Stats")
            local perfStats = stats:FindFirstChild("PerformanceStats")
            local pingObj = perfStats and perfStats:FindFirstChild("Ping")
            if pingObj then
                ping = pingObj:GetValue()
            end
        end)
        return ping
    end

    speedFarmTab:AddTextBox("Reps per cycle", function(input)
        local num = tonumber(input)
        if num and num > 0 then
            repsPerCycle = floorFn(num)
        end
    end, { clear = false, placeholder = "1" })

    local function speedFarmLoop()
        while speedFarmActive do
            if getPing() < 350 then
                for _ = 1, repsPerCycle do
                    muscleEvent:FireServer("rep")
                end
                task.wait(0.02)
            else
                task.wait(1)
            end
        end
    end

    speedFarmTab:AddSwitch("Fast Rep", function(enabled)
        if enabled and not speedFarmActive then
            speedFarmActive = true
            task.spawn(speedFarmLoop)
        elseif not enabled and speedFarmActive then
            speedFarmActive = false
        end
    end)

    task.spawn(function()
        local lastTime = tick()
        while true do
            local now = tick()
            local currentStr = strengthStat.Value
            local currentDur = durabilityStat.Value

            speedFarmStrengthLabel.Text = "Strength: " .. formatNumberSigned(currentStr) .. " | Gained: " .. formatNumberSigned(currentStr - initialStrengthSpeed)
            speedFarmDurabilityLabel.Text = "Durability: " .. formatNumberSigned(currentDur) .. " | Gained: " .. formatNumberSigned(currentDur - initialDurabilitySpeed)

            if speedFarmActive then
                if not speedFarmRunning then
                    speedFarmRunning = true
                    speedFarmStartTick = tick()
                    speedFarmStrSamples = {}
                    speedFarmDurSamples = {}
                end

                local elapsed = speedFarmAccumulatedTime + now - speedFarmStartTick
                speedFarmTimeLabel.Text = string.format(
                    "%dd %dh %dm %ds - Fast Rep Running",
                    floorFn(elapsed / 86400),
                    floorFn(elapsed % 86400 / 3600),
                    floorFn(elapsed % 3600 / 60),
                    floorFn(elapsed % 60)
                )
                speedFarmTimeLabel.TextColor3 = Color3.fromRGB(50, 255, 50)

                table.insert(speedFarmStrSamples, { time = now, value = currentStr })
                table.insert(speedFarmDurSamples, { time = now, value = currentDur })

                while #speedFarmStrSamples > 0 and now - speedFarmStrSamples[1].time > speedFarmRateWindow do
                    table.remove(speedFarmStrSamples, 1)
                end
                while #speedFarmDurSamples > 0 and now - speedFarmDurSamples[1].time > speedFarmRateWindow do
                    table.remove(speedFarmDurSamples, 1)
                end

                if now - lastTime >= speedFarmRateWindow then
                    lastTime = now
                    if #speedFarmStrSamples >= 2 then
                        local rate = (speedFarmStrSamples[#speedFarmStrSamples].value - speedFarmStrSamples[1].value) / speedFarmRateWindow
                        speedFarmStrPaceLabel.Text = "Strength Pace: " .. formatNumberSigned(rate * 3600) .. "/Hour | " .. formatNumberSigned(rate * 86400) .. "/Day | " .. formatNumberSigned(rate * 604800) .. "/Week"
                    end
                    if #speedFarmDurSamples >= 2 then
                        local rate = (speedFarmDurSamples[#speedFarmDurSamples].value - speedFarmDurSamples[1].value) / speedFarmRateWindow
                        speedFarmDurPaceLabel.Text = "Durability Pace: " .. formatNumberSigned(rate * 3600) .. "/Hour | " .. formatNumberSigned(rate * 86400) .. "/Day | " .. formatNumberSigned(rate * 604800) .. "/Week"
                    end

                    if elapsed > 0 then
                        local avgStrRate = (currentStr - initialStrengthSpeed) / elapsed
                        speedFarmAvgStrPaceLabel.Text = "Average Strength Pace: " .. formatNumberSigned(avgStrRate * 3600) .. "/Hour | " .. formatNumberSigned(avgStrRate * 86400) .. "/Day | " .. formatNumberSigned(avgStrRate * 604800) .. "/Week"
                        local avgDurRate = (currentDur - initialDurabilitySpeed) / elapsed
                        speedFarmAvgDurPaceLabel.Text = "Average Durability Pace: " .. formatNumberSigned(avgDurRate * 3600) .. "/Hour | " .. formatNumberSigned(avgDurRate * 86400) .. "/Day | " .. formatNumberSigned(avgDurRate * 604800) .. "/Week"
                    end
                end
            else
                if speedFarmRunning then
                    speedFarmRunning = false
                    speedFarmAccumulatedTime = speedFarmAccumulatedTime + tick() - speedFarmStartTick
                    local elapsed = speedFarmAccumulatedTime
                    speedFarmTimeLabel.Text = string.format(
                        "%dd %dh %dm %ds - Fast Rep Stopped",
                        floorFn(elapsed / 86400),
                        floorFn(elapsed % 86400 / 3600),
                        floorFn(elapsed % 3600 / 60),
                        floorFn(elapsed % 60)
                    )
                    speedFarmTimeLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                    speedFarmStrPaceLabel.Text = "Strength Pace: 0 /Hour | 0 /Day | 0 /Week"
                    speedFarmDurPaceLabel.Text = "Durability Pace: 0 /Hour | 0 /Day | 0 /Week"
                    speedFarmAvgStrPaceLabel.Text = "Average Strength Pace: 0 /Hour | 0 /Day | 0 /Week"
                    speedFarmAvgDurPaceLabel.Text = "Average Durability Pace: 0 /Hour | 0 /Day | 0 /Week"
                    speedFarmStrSamples = {}
                    speedFarmDurSamples = {}
                end
            end

            task.wait(0.05)
        end
    end)
end
