

if _G.Loop and type(_G.Loop) == "thread" then
    coroutine.close(_G.Loop)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Character = Players.LocalPlayer.Character
local VirtualUser = game:GetService("VirtualUser")
local Remotes = game:GetService("ReplicatedStorage").Remotes
local Tycoon = workspace:FindFirstChild("Tycoons"):WaitForChild(Character.Name .. " Tycoon")

local GuideClient = require(Players.LocalPlayer.PlayerScripts.ClientMain.GuideClient)

local oldGui = CoreGui:FindFirstChild("GigaRolf")
if oldGui then
    oldGui:Destroy()
end

local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "GigaRolf"
local Frame = Instance.new("Frame", Gui)
Frame.Position = UDim2.new(0.5, 0, 0.15, 0)
local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 20

local MoneySpent = 0
local Status = "Initializing"

local function Tp(destination)
    for i = 1, 25 do
        Character.HumanoidRootPart.CFrame = CFrame.new(destination)
        task.wait(0.01)
    end
end

local function updateText()
    TextLabel.Text = "Status: " .. Status .. "\nMoney Spent: " .. MoneySpent
end

local function tpToButtons()
    local count = 0
    while task.wait(.9) do
        local _, Data = Remotes:FindFirstChild("GetData"):InvokeServer()
        local cheapest = GuideClient:GetClosestAffordableButton() -- paid $10 for medal to remove 15 lines of code i wrote (ur welcome)
        if cheapest and cheapest.Price and cheapest.Model then
            -- Remotes.ButtonPurchaseRequested:FireServer(cheapest.Model) works like half the time too lazy to fix
            Status = "Buying Buttons (" .. count .. ")"
            MoneySpent = MoneySpent + cheapest.Price
            updateText()

            Tp(cheapest.Model:FindFirstChild("Plate").CFrame.Position + Vector3.new(0, 2, 0))
            count = count + 1
        else
            break
        end
    end
end

local function collectMoney()
    Status = "Collecting Money"
    updateText()

    Remotes.HomeTeleportRequested:FireServer()
    task.wait(2)
    local pos = Character.HumanoidRootPart.Position
    Tp(Vector3.new(pos.X + 25, pos.Y, pos.Z)) -- Collect Money
end

local function antiAFK()
    local _time = math.floor(math.random(25, 45))
    for i = 1, 7 do
        Status = "Idling (" .. (i - 1) * _time .. "s/" .. _time * 7 .. "s)"
        updateText()

        Remotes.HomeTeleportRequested:FireServer()
        task.wait(_time - 1)
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end

local function main()
    updateText()
    task.wait(1)
    collectMoney()

    while true do
        tpToButtons()
        antiAFK()
        collectMoney()
    end
end

_G.Loop = coroutine.create(main)
coroutine.resume(_G.Loop)
