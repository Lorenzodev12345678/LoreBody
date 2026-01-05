-- [[ LoreBody Hub 💎 - O Coração da LoreTcs ]] --

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
local speedEnabled = false
local speedValue = 2.0
local visualSpeedEnabled = false
local visualSpeedValue = 50 

-- [[ 🛡️ ABA DE PROTEÇÃO (ANTI-CHEAT) ]] --
local TabProt = Window:CreateTab("🛡️ Proteção", 4483345998)

TabProt:CreateButton({
   Name = "Ativar Blindagem LoreBody",
   Info = "Esconde sua velocidade real e evita Kick",
   Callback = function()
       local mt = getrawmetatable(game)
       local oldIndex = mt.__index
       local oldNewIndex = mt.__newindex
       setreadonly(mt, false)

       -- Bloqueia o jogo de ler sua velocidade real
       mt.__index = newcclosure(function(t, k)
           if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
               return (k == "WalkSpeed" and 16 or 50)
           end
           return oldIndex(t, k)
       end)
       
       -- Bloqueia o jogo de resetar sua velocidade (Conserta o Visual Speed)
       mt.__newindex = newcclosure(function(t, k, v)
           if not checkcaller() and t:IsA("Humanoid") and k == "WalkSpeed" and (visualSpeedEnabled or speedEnabled) then
               return -- Ignora a tentativa do jogo de mudar sua velocidade
           end
           return oldNewIndex(t, k, v)
       end)

       hookfunction(player.Kick, newcclosure(function() return nil end))
       setreadonly(mt, true)
       
       Rayfield:Notify({Title = "LoreBody Shield", Content = "Blindagem injetada, rlk!", Duration = 5})
   end,
})

-- [[ ⚡ ABA DE MOVIMENTAÇÃO ]] --
local TabSpeed = Window:CreateTab("⚡ Movimento", 4483345998)

TabSpeed:CreateToggle({
   Name = "Velocidade Visível (Forçar)",
   Info = "Muda o WalkSpeed direto (Pode dar ban em jogos com AC forte)",
   CurrentValue = false,
   Callback = function(Value)
       visualSpeedEnabled = Value
   end,
})

TabSpeed:CreateSlider({
   Name = "Intensidade Visível",
   Range = {16, 150},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v)
       visualSpeedValue = v
   end,
})

TabSpeed:CreateSection("--- Bypass (Oculto) ---")

TabSpeed:CreateToggle({
   Name = "Speed Bypass (CFrame)",
   Info = "Ninguém vê que você está rápido. Use com moderação!",
   CurrentValue = false,
   Callback = function(Value)
       speedEnabled = Value
       if speedEnabled then visualSpeedEnabled = false end -- Desliga o visual pra não bugar
   end,
})

TabSpeed:CreateSlider({
   Name = "Intensidade Bypass",
   Info = "Multiplicador de deslize",
   Range = {0.1, 10},
   Increment = 0.1,
   CurrentValue = 2,
   Callback = function(v)
       speedValue = v
   end,
})

-- LÓGICA DE MOVIMENTO CORE
RunService.Heartbeat:Connect(function(deltaTime)
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")

            if speedEnabled and hrp and hum.MoveDirection.Magnitude > 0 then
                -- Bypass via CFrame (Calculado por deltaTime pra ficar liso em qualquer PC)
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speedValue * deltaTime * 10)
                hum.WalkSpeed = 16
            elseif visualSpeedEnabled then
                -- Força o valor toda hora pra o jogo não resetar
                hum.WalkSpeed = visualSpeedValue
            else
                -- Se nada estiver ativo, volta ao normal
                if hum.WalkSpeed ~= 16 and not (speedEnabled or visualSpeedEnabled) then
                    hum.WalkSpeed = 16
                end
            end
        end
    end)
end)

Rayfield:Notify({
   Title = "LoreBody Atualizado!",
   Content = "Visual corrigido e Bypass liso, man!",
   Duration = 5,
   Image = 4483345998,
})
