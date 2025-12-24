-- [[ LoreBody - VELOCITY BYPASS 14 ]]
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Lorenzodev12345678/LoreBody/refs/heads/main/main.lua"))()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local pgui = player:WaitForChild("PlayerGui")

local speedActive = false
local currentSpeed = 16 
local fakeSpeed = 14 -- A velocidade que o dono do jogo vai ver no log

-- [[ 1. METATABLE BYPASS (A MENTIRA PERFEITA) ]]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    -- Se o jogo tentar ler a WalkSpeed do seu boneco
    if not checkcaller() and t:IsA("Humanoid") and k == "WalkSpeed" then
        return fakeSpeed -- Ele sempre acha que você está a 14
    end
    -- Se o jogo tentar ler a velocidade da sua peça principal (HRP)
    if not checkcaller() and t == hrp and k == "Velocity" then
        return Vector3.new(fakeSpeed, 0, fakeSpeed) -- Mente sobre a velocidade física
    end
    return oldIndex(t, k)
end)

hookfunction(player.Kick, newcclosure(function() return nil end))
setreadonly(mt, true)

-- [[ 2. NO-COLLIDE TPS BOLA ]]
task.spawn(function()
    while task.wait(0.5) do
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name == "TPS" or obj.Name == "Ball") then
                obj.CanCollide = false
            end
        end
    end
end)

-- [[ 3. VELOCIDADE VIA C-FRAME (MAIS DIFÍCIL DE BANIR QUE BODYVELOCITY) ]]
RunService.Stepped:Connect(function()
    if speedActive and hum.MoveDirection.Magnitude > 0 then
        -- Em vez de força, a gente "teleporta" milímetros pro lado
        -- Isso faz você correr sem o servidor notar o empurrão
        local multiplier = (currentSpeed / 16) * 0.15
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * multiplier)
    end
end)

-- [[ 4. INTERFACE ]]
if pgui:FindFirstChild("LoreBody_Hub") then pgui:FindFirstChild("LoreBody_Hub"):Destroy() end
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "LoreBody_Hub"

local MainFrame = Instance.new("Frame", sg)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 100)

local Input = Instance.new("TextBox", MainFrame)
Input.Size = UDim2.new(0.8, 0, 0, 40); Input.Position = UDim2.new(0.1, 0, 0.2, 0)
Input.PlaceholderText = "VELOCIDADE (Ex: 100)"; Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Input.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Input)

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40); ToggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleBtn.Text = "SPEED: OFF"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", ToggleBtn)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30); StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.Text = "LOG DO DONO: 14 KM/H"; StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    local val = tonumber(Input.Text)
    if val then
        currentSpeed = val
        speedActive = not speedActive
        ToggleBtn.Text = speedActive and "SPEED: ON ("..currentSpeed..")" or "SPEED: OFF"
        ToggleBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 0, 0)
    end
end)
