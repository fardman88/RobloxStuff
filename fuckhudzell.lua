task.wait(3)
if game.PlaceId == 445664957 and not  _G.Loaded then -- Only run script if playing Parkour

    _G.Loaded = true
    print("Welcome to fuck hudzell.")

    -- Declare static variables
    local Version = "1.58"

    local Workspace         = game:GetService("Workspace")
    local Players           = game:GetService("Players")
    local LocalPlayer       = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local HttpService       = game:GetService("HttpService")
    local TeleportService   = game:GetService("TeleportService")
    local Ping              = ReplicatedStorage:WaitForChild("Ping")
    local PlayerData        = ReplicatedStorage:WaitForChild("PlayerData")
    local LocalPlayerData   = PlayerData:WaitForChild(LocalPlayer.Name)
    local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")
    local CoreGui           = game:GetService("CoreGui")
    local StarterGui        = game:GetService("StarterGui")
    local UserInputService  = game:GetService("UserInputService")

    local variables, mainEnv, encrypt

    local Rarities          = {"Common","Uncommon","Rare","Epic","Legendary","Ultimate","Resplendent"}
    local Moves             = {"slide","dropdown","ledgegrab","edgejump","longjump","vault","wallrun","springboard"}
    local Ban_Traps         = {"AttemptTeleport","FireToDieInstantly","LandWithForceField","LoadString","FlyRequest","FinishTimeTrial","Under3Seconds","UpdateDunceList","HighCombo","r","t","FF"}

    local Is_Synapse        = syn and syn.run_secure_lua
    local queueteleport     = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport

    -- Declare dynamic variables
    local BagESP_Enabled    = false
    local GodMode_Enabled   = false
    local RankedTP_Enabled  = false
    local Autosell_Enabled  = false
    local AutoDC_Disabled   = false
    local Modify_Trading    = false
    local Trading_Active    = false
    local FastXP_Active     = false
    local UNSAFE            = false
    local Beta_Tab_Open     = false
    local BulkTrade_Value   = 1
    local Autosell_Value    = 10000000
    local Combo_Value       = 5
    local Accept_Rarity     = "Epic"

    -- Declare config variables
    local Beta_Tab_Active = false

    -- Wait until loaded
    repeat task.wait() until game:IsLoaded()

    -- Keep GUI on rejoin/hop/ranked
    pcall(function()
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/fardman88/RobloxStuff/main/fuckhudzell.lua'))()")
    end)

    -- Misc Functions
    local function RairityCheck(Rarity)
        local function Value_to_Index(Value)
            for i,v in ipairs(Rarities) do
                if v == Value then
                    return i
                end
            end
            return nil
        end
        if Value_to_Index(Rarity) >= Value_to_Index(Accept_Rarity) then
            return true
        else
            return false
        end
    end

    local function RepeatTrade(TradeId, Action, Table)
        Trading_Active = true
        print("fuck hudzell - RepeatTrade: working with TradeId "..TradeId..": Add "..BulkTrade_Value..Table.name..Table.itemType)
        local x = 1
        while x < BulkTrade_Value do
            x = x + 1
            ReplicatedStorage.TradeAction:FireServer(TradeId, Action, Table)
        end
        print("fuck hudzell - RepeatTrade: finished with TradeId "..TradeId)
        Trading_Active = false
    end

    local function Notify(Text, Welcome)
        local Title
        if Welcome then Title = "Welcome" else Title = "Alert" end
        StarterGui:SetCore("SendNotification", {
            Title = Title;
            Text  = Text;
        })
    end

    -- Hooks
    --[[do
        local nc
        nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if not checkcaller() then
                if method == "FireServer" and table.find(Ban_Traps, self.Name) then
                    return
                elseif method == "FireServer" and self.Name == "SubmitCombo" and args[1] > 299 then
                    args[1] = math.random(250, 299)
                elseif method == "FireServer" and self.Name == "TradeAction" and args[2] == "additem" and Modify_Trading and not Trading_Active then
                    RepeatTrade(args[1], args[2], args[3])
                elseif method == "TakeDamage" and self.ClassName == "Humanoid" and GodMode_Enabled then
                    return
                end
            end
            return nc(self, unpack(args))
        end))

            local function onCharacterAdded(char)
            if (not char) then return end
            task.wait(1)
            local mainScript = LocalPlayer.Backpack:WaitForChild("Main")
            variables = getupvalue(getsenv(mainScript).charJump, 1)
            variables.adminLevel = 13
            getfenv().script = mainScript
            mainEnv = getsenv(mainScript)
            encrypt = function(str)
                local _, res = pcall(mainEnv.encrypt, str)
                return res
            end
        end

        onCharacterAdded(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    end]]--

    -- Fuck sirhurt
    if is_sirhurt_closure then
        ReplicatedStorage:WaitForChild("ResetLevel"):FireServer()
        task.wait(1)
        LocalPlayer:Kick("Fuck sirhurt. Don't support pedophiles.")
        while true do task.wait() end
    end

    -- Warn about using unsupported exploits
    if not Is_Synapse then
        Notify("fuck hudzell is intended to be used on Synapse X. Some features may not work.", false)
    end

    -- Init Bracket
    local Config = {
        WindowName = "fuck hudzell",
        Color      = Color3.fromRGB(205, 0, 0),
        Keybind    = Enum.KeyCode.Quote
    }

    local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/fardman88/RobloxStuff/main/BracketV3.lua"))()
    local MainUI = Bracket:CreateWindow(Config, CoreGui)

    -- Main Tab
    local MainTab = MainUI:CreateTab("Main")

    -- ESP section
    local ESP_Section = MainTab:CreateSection("ESP")
    local Do_BagESP = ESP_Section:CreateToggle("Bag ESP", nil, function(State)
        BagESP_Enabled = State
        while BagESP_Enabled do
            for _, v in pairs(Workspace:GetChildren()) do
                if v:FindFirstChild("BagTouchScript") and RairityCheck(v:FindFirstChild("Rarity").Value) then
                    if not v:FindFirstChild("Ping") then
                        local x = Ping:Clone()
                        x.GUI.TextLabel.Text = v.Rarity.Value .. " Bag"
                        x.GUI.Arrow.ImageColor3 = v.Main.Color
                        x.Part.Color = v.Main.Color
                        x.Parent = v
                        x.Part.Position = v.Main.Position
                    else
                        v.Ping.GUI.Dist.Text = tostring(math.floor(math.abs((v.Ping.Part.Position - LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude) / 3)) .. "m"
                    end
                elseif v:FindFirstChild("Ping") and not RairityCheck(v:FindFirstChild("Rarity").Value) then
                    v.Ping:Destroy()
                elseif not State then break end
            end
            task.wait(0.01)
        end
        for _, v in pairs(Workspace:GetChildren()) do
            if v:FindFirstChild("BagTouchScript") and v:FindFirstChild("Ping") then
                v.Ping:Destroy()
            end
        end
        task.wait(0.01)
    end)
    local Set_Rarity = ESP_Section:CreateDropdown("Minimum rarity", Rarities, function(x)
        Accept_Rarity = x
    end)  Set_Rarity:SetOption(Rarities[4])

    -- LocalPlayer section
    local LocalPlayer_Section = MainTab:CreateSection("LocalPlayer")
    local Set_GodMode = LocalPlayer_Section:CreateToggle("God Mode", nil, function(x)
        if x then Notify("God Mode is temporarily disabled.", false) end
        --GodMode_Enabled = x
    end)
    local Do_RankedTP = LocalPlayer_Section:CreateToggle("Ranked Teleport", nil, function(State)
        RankedTP_Enabled = State
        while RankedTP_Enabled do
            for _,v in pairs(game:GetService("Players"):GetChildren()) do
                if v.Name ~= LocalPlayer.Name and RankedTP_Enabled and #game:GetService("Players"):GetChildren() == 2 then
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = v.Character:WaitForChild("HumanoidRootPart").CFrame
                end
            end
            task.wait(1)
        end
    end)

    -- Points Section
    local Points_Section = MainTab:CreateSection("Points")

    local Do_Autosell = Points_Section:CreateToggle("Set Autosell", nil, function(State)
        Autosell_Enabled = State
        while Autosell_Enabled do
            local x = LocalPlayerData.Generic.Points.Value
            if x >= Autosell_Value then
                ReplicatedStorage.Reset:InvokeServer()
            end
            task.wait(5)
        end
    end)
    local Set_AutosellValue = Points_Section:CreateSlider("Autosell at", 10000,10000000,nil,true, function(x)
        Autosell_Value = x
    end)  Set_AutosellValue:SetValue(Autosell_Value)

    -- Combo section
    local Combo_Section = MainTab:CreateSection("Combo")
    local Set_Flow = Combo_Section:CreateToggle("Flow (!)", nil, function(x)
        if x then Notify("Flow is temporarily disabled.", false) end

        --[[if (not x) then return end

        while x and UNSAFE do
            variables.flowActive = true
            variables.flowDelta = 100
            task.wait()
        end--]]
    end)
    local Set_Combo = Combo_Section:CreateToggle("Set Combo (!)", nil, function(x)
        if x then Notify("Combo is temporarily disabled.", false) end

        --[[if (not x) then
            return mainEnv.breakCombo()
        end

        ReplicatedStorage.UpdateCombo:FireServer(Combo_Value)

        while x and UNSAFE do
            variables.comboTime = math.huge
            variables.comboHealth = math.huge
            variables.comboXp = math.huge
            variables.comboLevel = Combo_Value
            task.wait()
        end]]--
    end)
    local Set_ComboValue = Combo_Section:CreateSlider("Combo Level", 1,5,nil,true, function(x)
        Combo_Value = x
    end)  Set_ComboValue:SetValue(Combo_Value)

    -- Game Section
    local Game_Section = MainTab:CreateSection("Game")
    local Do_Rejoin = Game_Section:CreateButton("Rejoin server", function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
    local Do_ServerHop = Game_Section:CreateButton("Join new server", function()
        local x = {}
        for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
            if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                x[#x + 1] = v.id
            end
        end
        if #x > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
        else
            Notify("No servers available.", false)
        end
    end)

    -- Unlocks section
    local Unlocks_Section = MainTab:CreateSection("Unlocks")
    local Do_Spawns = Unlocks_Section:CreateButton("Unlock Spawns", function()
        for i, v in next, Workspace:GetChildren() do
            if (not v:IsA("SpawnLocation") or v.Name == "SpawnLocation" or not LocalPlayer.Character) then continue end

            LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
            task.wait(.5)
        end
    end)
    local Do_Badges = Unlocks_Section:CreateButton("Unlock Badges", function()
        for i, v in next, Workspace:GetChildren() do
            if (v.Name ~= "BadgeAwarder" or not LocalPlayer.Character) then continue end

            local part = v:FindFirstChildWhichIsA("Part")
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
        end
    end)

    -- Level Section
    local Level_Section = MainTab:CreateSection("Fast XP")
    if Is_Synapse then
        local Warning_Label = Level_Section:CreateLabel("Using this will give you 11m xp\nrepeatedly, stopping at lvl 450.")
        local Level_Button = Level_Section:CreateButton("Fast XP (!)", function()
            if UNSAFE and LocalPlayerData.Generic.Level.Value < 450 and not FastXP_Active then
                FastXP_Active = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/fardman88/RobloxStuff/main/hellalevels.lua"))()
                while task.wait(5) do
                    if LocalPlayerData.Generic.Level.Value >= 450 then
                        LocalPlayer.Character.Humanoid.Health = 0
                        break
                    end
                end
            elseif UNSAFE and LocalPlayerData.Generic.Level.Value >= 450 then
                Notify("FastXP cannot be used at level 450 or higher.")
            end
        end)
    elseif not Is_Synapse then
        local Error_label = Level_Section:CreateLabel("Fast XP requires\n Synapse X.")
    end

    -- Teleport Tab
    local TPTab = MainUI:CreateTab("Teleports")

    -- Towers Section
    local Tower_Section = TPTab:CreateSection("Towers")
    local Do_Elite = Tower_Section:CreateButton("Elite", function()
        LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(-448, 677, -147)
    end)
    local Do_Vertigo = Tower_Section:CreateButton("Vertigo", function()
        LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(-114, 749, -258)
    end)
    local Do_Vertex = Tower_Section:CreateButton("Vertex", function()
        LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(719, 1261, 760)
    end)
    local Do_Crest = Tower_Section:CreateButton("Crest", function() 
        LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(42, 1446, -1230)
    end)
    local Do_Apex = Tower_Section:CreateButton("Apex", function() 
        LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(369, 1087, -2056)
    end)
    local Do_Titan = Tower_Section:CreateButton("Titan", function() 
        LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(1388, 2500, 1751)
    end)

    -- Options Tab
    local OpTab = MainUI:CreateTab("Options / Misc")

    -- UNSAFE Section
    local UNSAFE_Section = OpTab:CreateSection("Unsafe mode")
    local Set_UNSAFE_Label = UNSAFE_Section:CreateLabel("Options marked with (!) are considered\nunsafe and will get you dunced\n or banned if used improperly.\nCheck the box below to enable them.")
    local Set_UNSAFE = UNSAFE_Section:CreateToggle("Enable unsafe options", nil, function(x)
        UNSAFE = x
    end)

    -- Playtime Section
    local Playtime_Section = OpTab:CreateSection("Check Playtime")
    local Print_Playtimes = Playtime_Section:CreateButton("Print playtimes", function()
        for _,v in pairs(Players:GetChildren()) do
            print(v.Name.." - "..string.format("%.2f", PlayerData[v.Name].Stats.Playtime.Value / 3600).." hours")
        end
    end)

    -- AutoDC Section
    local AutoDisconnect_Section = OpTab:CreateSection("Auto Disconnect")
    local AutoDisconect_Label = AutoDisconnect_Section:CreateLabel("fuck hudzell will automatically\ndisconnect you from the lobby\nif a staff member joins.\nCheck the box below to disable.")
    local AutoDisconnect_Toggle = AutoDisconnect_Section:CreateToggle("Disable AutoDC (!)", nil, function(x)
        AutoDC_Disabled = x
    end)

    -- Info Section
    local Info_Section = OpTab:CreateSection("Info")
    local Info_Label = Info_Section:CreateLabel("fuck hudzell "..Version.."\nfard man 88#6824")

    -- Beta Tab
    local function Show_Beta_Tab()
        if Beta_Tab_Active then
            Beta_Tab_Open = true
            warn("fuck hudzell - Beta tab enabled")
            local Beta_Tab = MainUI:CreateTab("Beta Features")

            --[[ Bulk Trading section
            local BulkTrade_Section = Beta_Tab:CreateSection("Bulk Trading")
            local BulkTrade_Toggle = BulkTrade_Section:CreateToggle("Enable bulk trading", nil, function(x)
                Modify_Trading = x
            end)
            local Set_BulkTrade_Value = BulkTrade_Section:CreateSlider("Amount to trade", 1,200,nil,true, function(x)
                BulkTrade_Value = x
            end)  Set_BulkTrade_Value:SetValue(BulkTrade_Value)]]--
        else
            Notify("No beta features are currently being tested.", false)
            task.wait(5)
        end
    end

    UserInputService.InputBegan:Connect(function(IO, Typing)
        if Typing then return end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and UserInputService:IsKeyDown(Enum.KeyCode.B) and not Beta_Tab_Open then
            Show_Beta_Tab()
        end
    end)

    -- AutoDC
    for _,v in pairs(Players:GetChildren()) do
        if v:GetRankInGroup(3468086) > 1 then
            LocalPlayer:Kick("fuck hudzell: In-game staff detected. You were disconnected for safety.")
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if player:GetRankInGroup(3468086) > 1 then
            if UNSAFE and AutoDC_Disabled then
                Notify("In-game staff detected.")
            else
                LocalPlayer:Kick("fuck hudzell: In-game staff detected. You were disconnected for safety.")
            end
        end
    end)

    Notify("Welcome to fuck hudzell. Press " ..UserInputService:GetStringForKeyCode(Config.Keybind).. " to toggle the gui.", true)
end