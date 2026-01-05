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
local visualSpeedValue = 50 -- O quanto você vê de velocidade

-- [[ 🛡️ ABA DE PROTEÇÃO (ANTI-CHEAT) ]] --
local TabProt = Window:CreateTab("🛡️ Proteção", 4483345998)

TabProt:CreateButton({
   Name = "Ativar Blindagem LoreBody",
   Info = "Esconde sua velocidade real do servidor e evita detecção",
   Callback = function()
       local mt = getrawmetatable(game)
       local oldIndex = mt.__index
       setreadonly(mt, false)

       mt.__index = newcclosure(function(t, k)
           if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
               return (k == "WalkSpeed" and 16 or 50)
           end
           return oldIndex(t, k)
       end)

       hookfunction(player.Kick, newcclosure(function() return nil end))
       setreadonly(mt, true)
       
       Rayfield:Notify({Title = "LoreBody Shield", Content = "Blindagem injetada, rlk!", Duration = 5})
   end,
})

-- [[ ⚡ ABA DE MOVIMENTAÇÃO ]] --
local TabSpeed = Window:CreateTab("⚡ Movimento", 4483345998)

TabSpeed:CreateToggle({
   Name = "Velocidade Visível (Client)",
   Info = "Aumenta o WalkSpeed apenas para você ver (Cuidado: Desativa ao usar Bypass)",
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

TabSpeed:CreateSection("--- Bypass ---")

TabSpeed:CreateToggle({
   Name = "Speed Bypass (CFrame)",
   Info = "Oculta o Speed dos outros mas você ganha a velocidade real",
   CurrentValue = false,
   Callback = function(Value)
       speedEnabled = Value
       
       -- Lógica que você pediu, man: Se ativar o Bypass, o WalkSpeed visual reseta
       if speedEnabled then
           local hum = player.Character and player.Character:FindFirstChild("Humanoid")
           if hum then hum.WalkSpeed = 16 end
       end
   end,
})

TabSpeed:CreateSlider({
   Name = "Intensidade Bypass",
   Info = "Multiplicador do ganho real",
   Range = {1, 20},
   Increment = 0.5,
   CurrentValue = 2,
   Callback = function(v)
       speedValue = v
   end,
})

-- LÓGICA DE MOVIMENTO (HEARTBEAT PARA FICAR SMOOTH)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")

        -- Se o Bypass estiver ON, ganha velocidade via CFrame e mantém WalkSpeed em 16
        if speedEnabled and hrp then
            if hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speedValue / 10))
            end
            hum.WalkSpeed = 16 -- Garante que pros outros você tá normal
        
        -- Se só o Visual estiver ON, muda o WalkSpeed
        elseif visualSpeedEnabled then
            hum.WalkSpeed = visualSpeedValue
        else
            -- Reset padrão se nada estiver ativo
            hum.WalkSpeed = 16
        end
    end
end)

Rayfield:Notify({
   Title = "LoreBody Ativo!",
   Content = "O corpo do script carregou com sucesso, rlk!",
   Duration = 5,
   Image = 4483345998,
})
