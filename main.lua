-- [[ LoreBody Hub 💎 ]] --
-- [[ by LoreTcs - The Heart of Scripting ]] --
-- [[ Version: 2.0 (Anti-Detection) ]] --

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
local speedValue = 2.0
local ultraVisualEnabled = false
local defaultFOV = 70

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
       
       -- Bloqueia o jogo de resetar sua velocidade
       mt.__newindex = newcclosure(function(t, k, v)
           if not checkcaller() and t:IsA("Humanoid") and k == "WalkSpeed" and speedEnabled then
               return 
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
   Name = "Ultra Visual (FOV)",
   Info = "Dá efeito de velocidade extrema na tela!",
   CurrentValue = false,
   Callback = function(Value)
       ultraVisualEnabled = Value
       if not Value then
           camera.FieldOfView = defaultFOV
       end
   end,
})

TabSpeed:CreateSection("--- Bypass (Oculto/Bugado) ---")

TabSpeed:CreateToggle({
   Name = "Speed Bypass (CFrame)",
   Info = "Você fica rápido, mas pros outros você buga/trava.",
   CurrentValue = false,
   Callback = function(Value)
       speedEnabled = Value
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

            -- Efeito Visual (FOV)
            if ultraVisualEnabled and hum.MoveDirection.Magnitude > 0 then
                camera.FieldOfView = math.lerp(camera.FieldOfView, 120, deltaTime * 5)
            else
                camera.FieldOfView = math.lerp(camera.FieldOfView, defaultFOV, deltaTime * 5)
            end

            -- Movimento CFrame
            if speedEnabled and hrp and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speedValue * deltaTime * 10)
                hum.WalkSpeed = 16 -- Mantém 16 pro server não ver
            end
        end
    end)
end)

Rayfield:Notify({
   Title = "LoreBody Atualizado!",
   Content = "Visual e Bypass carregados, man!",
   Duration = 5,
})-- [[ 👤 ABA DO JOGADOR ]] --
local TabPlayer = Window:CreateTab("👤 Player", 4483345998)

-- Identifica o Executor (Delta ou outro)
local executorName, executorVersion = identifyexecutor()
local finalExecutor = executorName .. " " .. (executorVersion or "")

TabPlayer:CreateSection("--- Suas Informações ---")

-- Mostra seu Nome de Usuário
TabPlayer:CreateParagraph({
    Title = "Username:", 
    Content = "➔ " .. player.Name .. " (@" .. player.DisplayName .. ")"
})

-- Mostra o Executor que você está usando (Delta)
TabPlayer:CreateParagraph({
    Title = "Executor Ativo:", 
    Content = "➔ " .. finalExecutor
})

TabPlayer:CreateSection("--- Atalhos Rápidos ---")

TabPlayer:CreateButton({
   Name = "Reentrar no Servidor (Rejoin)",
   Callback = function()
       local ts = game:GetService("TeleportService")
       ts:Teleport(game.PlaceId, player)
   end,
})

TabPlayer:CreateButton({
   Name = "Copiar Link do Delta (Oficial)",
   Callback = function()
       setclipboard("https://deltaexploits.gg")
       Rayfield:Notify({Title = "LoreBody", Content = "Link copiado, rlk!", Duration = 5})
   end,
})

