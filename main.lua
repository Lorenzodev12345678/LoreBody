-- [[ LoreBody Hub 💎 ]] --
-- [[ by LoreTcs - The Heart of Scripting ]] --
-- [[ Version: 2.0 (TPS Street Soccer Edition) ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LoreBody Hub 🧬",
   LoadingTitle = "Injetando LoreBody Core...",
   LoadingSubtitle = "by LoreTcs",
   ConfigurationSaving = { Enabled = false }
})

-- VARIAVEIS
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera
local speedEnabled = false
local speedValue = 1.4 -- 14 no seu multiplicador (ajustado para o cálculo do script)
local ultraVisualEnabled = false
local defaultFOV = 70
local alvoGol = nil

-- [[ 🛡️ ABA DE PROTEÇÃO ]] --
local TabProt = Window:CreateTab("🛡️ Proteção", 4483345998)

TabProt:CreateButton({
   Name = "Ativar Blindagem LoreBody",
   Info = "Evita Kick no TPS e esconde os 50 de Speed!",
   Callback = function()
       local mt = getrawmetatable(game)
       local oldIndex = mt.__index
       local oldNewIndex = mt.__newindex
       setreadonly(mt, false)

       mt.__index = newcclosure(function(t, k)
           if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
               return (k == "WalkSpeed" and 16 or 50)
           end
           return oldIndex(t, k)
       end)
       
       mt.__newindex = newcclosure(function(t, k, v)
           if not checkcaller() and t:IsA("Humanoid") and k == "WalkSpeed" and speedEnabled then
               return 
           end
           return oldNewIndex(t, k, v)
       end)

       pcall(function() hookfunction(player.Kick, newcclosure(function() return nil end)) end)
       setreadonly(mt, true)
       Rayfield:Notify({Title = "LoreBody Shield", Content = "Blindagem Injetada, rlk!", Duration = 5})
   end,
})

-- [[ ⚡ ABA DE MOVIMENTAÇÃO ]] --
local TabSpeed = Window:CreateTab("⚡ Movimento", 4483345998)

TabSpeed:CreateSlider({
   Name = "WalkSpeed Físico (Padrão 50)",
   Info = "Aumenta a força do chute na bola TPS!",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v)
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = v
       end
   end,
})

TabSpeed:CreateSection("--- Bypass (Bugar Zagueiros) ---")

TabSpeed:CreateToggle({
   Name = "Speed Bypass (CFrame)",
   CurrentValue = false,
   Callback = function(Value) speedEnabled = Value end,
})

TabSpeed:CreateSlider({
   Name = "Intensidade Bypass (Seu 14)",
   Range = {0.1, 5},
   Increment = 0.1,
   CurrentValue = 1.4,
   Callback = function(v) speedValue = v end,
})

-- [[ 🤡 ABA TROLL (TPS SOCCER) ]] --
local TabTroll = Window:CreateTab("🤡 Troll", 4483345998)

TabTroll:CreateButton({
   Name = "Marcar Gol como Alvo",
   Info = "Fique dentro do gol deles e clique!",
   Callback = function()
       local hrp = player.Character:FindFirstChild("HumanoidRootPart")
       if hrp then
           alvoGol = hrp.Position
           Rayfield:Notify({Title = "LoreBody", Content = "Mira calibrada pro gol!", Duration = 3})
       end
   end,
})

TabTroll:CreateToggle({
   Name = "Auto-TPS Direcionado",
   Info = "Chuta a bola TPS direto pro alvo!",
   CurrentValue = false,
   Callback = function(Value)
       _G.AutoTPSAlvo = Value
       while _G.AutoTPSAlvo do
           local ball = game.Workspace:FindFirstChild("TPS") or game.Workspace:FindFirstChild("Ball")
           local hrp = player.Character:FindFirstChild("HumanoidRootPart")
           if ball and hrp and (hrp.Position - ball.Position).Magnitude < 15 then
               firetouchinterest(hrp, ball, 0)
               task.wait(0.01)
               firetouchinterest(hrp, ball, 1)
               if alvoGol then
                   local dir = (alvoGol - ball.Position).Unit
                   pcall(function() ball.Velocity = dir * 150 end)
               end
           end
           task.wait(0.1)
       end
   end,
})

-- [[ 👤 ABA PLAYER ]] --
local TabPlayer = Window:CreateTab("👤 Player", 4483345998)
local execName, execVer = identifyexecutor()

TabPlayer:CreateParagraph({Title = "Username:", Content = player.Name})
TabPlayer:CreateParagraph({Title = "Executor:", Content = execName .. " " .. (execVer or "")})
TabPlayer:CreateButton({Name = "Rejoin", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end})

-- LÓGICA CORE
RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            local hrp = player.Character.HumanoidRootPart

            if speedEnabled and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speedValue * dt * 10)
            end
        end
    end)
end)

Rayfield:Notify({Title = "LoreBody VIP", Content = "Pronto pra humilhar no TPS, rlk!", Duration = 5})
