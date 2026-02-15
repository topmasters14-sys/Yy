-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BodyChangerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle Button (100x100)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(100, 100)
ToggleBtn.Position = UDim2.fromOffset(20, 20)
ToggleBtn.Text = "BODY"
ToggleBtn.TextColor3 = Color3.new(0,0,0)
ToggleBtn.BackgroundColor3 = Color3.new(1,1,1)
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 16)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.new(1,1,1)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(450, 300)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.new(0,0,0)
Main.Visible = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

-- Glowing Outline
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255,255,255)
MainStroke.Thickness = 3
MainStroke.Transparency = 0.2
MainStroke.Parent = Main

-- Glow Animation
RunService.RenderStepped:Connect(function()
	MainStroke.Transparency = 0.15 + math.abs(math.sin(tick() * 2)) * 0.35
end)

-- Dragging
local dragging, dragStart, startPos

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Toggle open / hide
ToggleBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- Button creator
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(200, 50)
	btn.Position = UDim2.fromOffset(125, yPos)
	btn.Text = text
	btn.TextColor3 = Color3.new(0,0,0)
	btn.BackgroundColor3 = Color3.new(1,1,1)
	btn.Parent = Main

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(1,1,1)
	stroke.Thickness = 2
	stroke.Parent = btn

	return btn
end

-- Buttons
local Button1 = createButton("R6 Blocky", 80)
local Button2 = createButton("R6 Girl", 160)

-- Change body WITHOUT changing head
local function applyBundle(bundleId)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	local originalDesc = humanoid:GetAppliedDescription()
	local newDesc = Players:GetHumanoidDescriptionFromBundleId(bundleId)

	-- Keep head
	newDesc.Head = originalDesc.Head

	humanoid:ApplyDescription(newDesc)
end

-- Button actions
Button1.MouseButton1Click:Connect(function()
	applyBundle(155839511828543) -- R6 Blocky
end)

Button2.MouseButton1Click:Connect(function()
	applyBundle(156673720893102) -- R6 Girl
end)
