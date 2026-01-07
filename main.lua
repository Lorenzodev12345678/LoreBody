-- [[ LoreBody Hub 💎 ]] --
-- [[ Link: https://raw.githubusercontent.com/Lorenzodev12345678/LoreTcs/refs/heads/main/main.lua ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LoreBody Hub 🧬",
   LoadingTitle = "Modo Mbappé 50/14 (Windows 11 Ready)",
   LoadingSubtitle = "by LoreTcs",
   ConfigurationSaving = { Enabled = false }
})

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local speedEnabled = false
local realSpeedBody = 50  
local bypassValue = 1.4   

-- [[ 🛡️ PROTEÇÃO & BYPASS ]] --
local TabProt = Window:CreateTab("🛡️ Proteção", 4483345998)

TabProt:CreateButton({
   Name = "Ativar Blindagem (Disfarce 16)",
   Callback = function()
       local mt = getrawmetatable(game)
       setreadonly(mt, false)
       local oldIndex = mt.__index
       mt.__index = newcclosure(function(t, k)
           if not checkcaller() and t:IsA("Humanoid") and k == "WalkSpeed" then
               return 16
           end
           return oldIndex(t, k)
       end)
       setreadonly(mt, true)
       speedEnabled = true
       player.Character.Humanoid.WalkSpeed = realSpeedBody
       Rayfield:Notify({Title = "LoreBody", Content = "Bypass 50/14 ON!", Duration = 5})
   end,
})

-- [[ ⚽ SKILLS DE MBAPPÉ ]] --
local TabSkills = Window:CreateTab("⚽ Skills", 4483345998)

TabSkills:CreateButton({
   Name = "Lambreta + Pulo + Cabeçada",
   Callback = function()
       local ball = game.Workspace:FindFirstChild("TPS") or game.Workspace:FindFirstChild("Ball")
       local hrp = player.Character.HumanoidRootPart
       if ball and (hrp.Position - ball.Position).Magnitude < 10 then
           ball.AssemblyLinearVelocity = (hrp.CFrame.LookVector * 15) + Vector3.new(0, 45, 0)
           task.wait(0.3)
           player.Character.Humanoid.Jump = true
           task.wait(0.1)
           ball.AssemblyLinearVelocity = (hrp.CFrame.LookVector * 100) + Vector3.new(0, -35, 0)
       end
   end,
})

TabSkills:CreateButton({
   Name = "Roubo pela Esquerda (Limpo)",
   Callback = function()
       local hrp = player.Character.HumanoidRootPart
       local ball = game.Workspace:FindFirstChild("TPS") or game.Workspace:FindFirstChild("Ball")
       if ball and hrp then
           hrp.CFrame = CFrame.new(ball.Position + Vector3.new(-5, 0, 0), ball.Position)
       end
   end,
})

-- [[ ⚡ MOVIMENTO ]] --
local TabSpeed = Window:CreateTab("⚡ Movimento", 4483345998)
TabSpeed:CreateSlider({
   Name = "Ajuste Bypass Visual",
   Range = {1, 2},
   Increment = 0.1,
   CurrentValue = 1.4,
   Callback = function(v) bypassValue = v end,
})

-- LÓGICA DE CORRIDA (ANIMAÇÃO 100%)
RunService.Heartbeat:Connect(function(dt)
    if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        local hrp = player.Character.HumanoidRootPart
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * bypassValue * dt * 10)
            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(bypassValue * 1.1)
            end
        end
    end
end)
