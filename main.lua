-- [[ LoreTCS - TPS NO-COLLIDE & SPEED VELOCITY ]]
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Lorenzodev12345678/LoreTcs/refs/heads/main/main.lua"))()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local pgui = player:WaitForChild("PlayerGui")

local speedActive = false
local currentSpeed = 16 -- Velocidade padrão do Roblox

-- [[ 1. DESATIVAR FUNÇÃO DE KICK & BLINDAGEM ]]
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
        return 16 -- Engana o jogo dizendo que a velocidade está normal
    end
    return oldIndex(t, k)
end)
hookfunction(player.Kick, newcclosure(function() return nil end)) -- Bloqueia o Kick
setreadonly(mt, true)

-- [[ 2. SISTEMA DE PROCURAR TPS E DESATIVAR CANCOLLIDE ]]
task.spawn(function()
    while task.wait(0.5) do
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name == "TPS" or obj.Name == "Ball") then
                obj.CanCollide = false -- Desativa a colisão para você atravessar a bola
            end
        end
    end
end)

-- [[ 3. SISTEMA DE VELOCIDADE (BODYVELOCITY MODIFICADO) ]]
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5, 0, 1e5) -- Só empurra no chão, não pro alto (evita voar do nada)
bv.Velocity = Vector3.new(0, 0, 0)

RunService.Heartbeat:Connect(function()
    if speedActive and hum.MoveDirection.Magnitude > 0 then
        bv.Parent = hrp
        bv.Velocity = hum.MoveDirection * currentSpeed
    else
        bv.Parent = nil
    end
end)

-- [[ 4. INTERFACE COM BOTÃO E PAINEL ]]
if pgui:FindFirstChild("LoreSpeed_Hub") then pgui:FindFirstChild("LoreSpeed_Hub"):Destroy() end
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "LoreSpeed_Hub"

-- Botão de Abrir
local OpenBtn = Instance.new("TextButton", sg)
OpenBtn.Size = UDim2.new(0, 100, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "ABRIR PAINEL"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
Instance.new("UICorner", OpenBtn)

-- Painel Principal
local MainFrame = Instance.new("Frame", sg)
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 100)

-- Input de Velocidade
local Input = Instance.new("TextBox", MainFrame)
Input.Size = UDim2.new(0.8, 0, 0, 40)
Input.Position = UDim2.new(0.1, 0, 0.2, 0)
Input.PlaceholderText = "DIGITE A VELOCIDADE (Ex: 100)"
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Input)

-- Botão Ativar/Desativar
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleBtn.Text = "SPEED: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ToggleBtn)

-- Funcionalidades da UI
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

ToggleBtn.MouseButton1Click:Connect(function()
    local val = tonumber(Input.Text)
    if val then
        currentSpeed = val
        speedActive = not speedActive
        ToggleBtn.Text = speedActive and "SPEED: ON ("..currentSpeed..")" or "SPEED: OFF"
        ToggleBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 0, 0)
    else
        Input.Text = ""
        Input.PlaceholderText = "VALOR INVÁLIDO!"
        task.wait(1)
        Input.PlaceholderText = "DIGITE A VELOCIDADE (Ex: 100)"
    end
end)

print("LoreTCS: Script de Velocidade e No-Collide carregado, rlk!")
