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
   Name = "Speed Bypass (CFrame)",
   Info = "Ande rápido sem que o script do jogo perceba",
   CurrentValue = false,
   Callback = function(Value)
       speedEnabled = Value
   end,
})

TabSpeed:CreateSlider({
   Name = "Intensidade",
   Info = "Ajuste o multiplicador da sua velocidade",
   Range = {1, 20},
   Increment = 0.5,
   CurrentValue = 2,
   Callback = function(v)
       speedValue = v
   end,
})

-- LÓGICA DE MOVIMENTO
RunService.Stepped:Connect(function()
    if speedEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speedValue / 10))
        end
    end
end)

Rayfield:Notify({
   Title = "LoreBody Ativo!",
   Content = "O corpo do script carregou com sucesso, rlk!",
   Duration = 5,
   Image = 4483345998,
})
