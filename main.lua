-- [[ LoreBody Hub 💎 ]] --
-- [[ by LoreTcs - The Heart of Scripting ]] --
-- [[ Version: 2.5 (Configuração Automática) ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LoreBody Hub 🧬",
   LoadingTitle = "Carregando Modo 50/14...",
   LoadingSubtitle = "by LoreTcs",
   ConfigurationSaving = { Enabled = false }
})

-- VARIAVEIS (Valores de rlk já definidos)
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local speedEnabled = false
local realSpeedBody = 50  -- Força do chute
local bypassValue = 1.4   -- O "14" visual (CFrame)
local alvoGol = nil

-- [[ 🛡️ ABA DE PROTEÇÃO ]] --
local TabProt = Window:CreateTab("🛡️ Proteção", 4483345998)

TabProt:CreateButton({
   Name = "Ativar Blindagem e Modo 50/14",
   Info = "Esconde a velocidade e ativa o modo artilheiro!",
   Callback = function()
       local mt = getrawmetatable(game)
       local oldIndex = mt.__index
       local oldNewIndex = mt.__newindex
       setreadonly(mt, false)

       -- Faz o servidor ler sempre 16 (Bypass de leitura)
       mt.__index = newcclosure(function(t, k)
           if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
               return (k == "WalkSpeed" and 16 or 50)
           end
           return oldIndex(t, k)
       end)
       
       -- Bloqueia o servidor de baixar sua velocidade
       mt.__newindex = newcclosure(function(t, k, v)
           if not checkcaller() and t:IsA("Humanoid") and k == "WalkSpeed" then
               return 
           end
           return oldNewIndex(t, k, v)
       end)

       setreadonly(mt, true)

       -- Aplica a força 50 e o Bypass 14 na hora
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = realSpeedBody
           speedEnabled = true
       end
       
       Rayfield:Notify({Title = "LoreBody Shield", Content = "Blindagem Ativa! 50/14 Aplicado.", Duration = 5})
   end,
})

-- [[ ⚡ ABA DE MOVIMENTAÇÃO ]] --
local TabSpeed = Window:CreateTab("⚡ Movimento", 4483345998)

TabSpeed:CreateSlider({
   Name = "Velocidade Real (Corpo)",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
       realSpeedBody = v 
       if player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = v
       end
   end,
})

TabSpeed:CreateSlider({
   Name = "Bypass (O que os outros vêem)",
   Range = {0.1, 5},
   Increment = 0.1,
   CurrentValue = 1.4,
   Callback = function(v) bypassValue = v end,
})

-- [[ 🤡 ABA TROLL (TPS SOCCER) ]] --
local TabTroll = Window:CreateTab("🤡 Troll", 4483345998)

TabTroll:CreateButton({
   Name = "Marcar Gol",
   Callback = function()
       if player.Character:FindFirstChild("HumanoidRootPart") then
           alvoGol = player.Character.HumanoidRootPart.Position
           Rayfield:Notify({Title = "LoreBody", Content = "Posição do gol salva!", Duration = 2})
       end
   end,
})

TabTroll:CreateToggle({
   Name = "Auto-TPS Mira",
   Info = "Chuta a bola TPS usando o toque físico!",
   CurrentValue = false,
   Callback = function(Value)
       _G.AutoTPS = Value
       while _G.AutoTPS do
           local ball = game.Workspace:FindFirstChild("TPS") or game.Workspace:FindFirstChild("Ball")
           local hrp = player.Character:FindFirstChild("HumanoidRootPart")
           if ball and hrp and (hrp.Position - ball.Position).Magnitude < 15 then
               -- Simula o toque na bola (o chute vem da velocidade 50)
               firetouchinterest(hrp, ball, 0)
               task.wait(0.01)
               firetouchinterest(hrp, ball, 1)
           end
           task.wait(0.1)
       end
   end,
})

-- [[ 👤 ABA PLAYER ]] --
local TabPlayer = Window:CreateTab("👤 Player", 4483345998)
local execName, execVer = identifyexecutor()

TabPlayer:CreateParagraph({Title = "Username:", Content = "➔ " .. player.Name})
TabPlayer:CreateParagraph({Title = "Executor:", Content = "➔ " .. execName .. " " .. (execVer or "")})
TabPlayer:CreateButton({Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end})

-- LÓGICA DE MOVIMENTO
RunService.Heartbeat:Connect(function(dt)
    if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        local hrp = player.Character.HumanoidRootPart
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * bypassValue * dt * 10)
        end
    end
end)

Rayfield:Notify({Title = "LoreBody 2.5", Content = "Configurado e pronto, man!", Duration = 5})
