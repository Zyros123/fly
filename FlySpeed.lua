
-- Universal Fly + Speed + Fling + Vanish
-- RightShift para minimizar

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local SpeedValue = 30
local FlySpeed = 50
local Flying = false
local SpeedOn = false
local FlingOn = false
local VanishOn = false
local BV, BG
local lastFling = 0
local SavedTransparency = {}

pcall(function()
    settings().Physics.AllowSleep = false
end)
pcall(function()
    sethiddenproperty(LocalPlayer, "MaximumSimulationRadius", math.huge)
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
end)

local function getHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
end

local function startFly()
    local hrp, hum = getHRP()
    if not hrp or Flying then return end
    Flying = true
    if hum then hum.PlatformStand = true end
    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.zero
    BV.Parent = hrp
    BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.P = 9e4
    BG.Parent = hrp
end

local function stopFly()
    Flying = false
    if BV then BV:Destroy() BV = nil end
    if BG then BG:Destroy() BG = nil end
    local _, hum = getHRP()
    if hum then hum.PlatformStand = false end
end

local function setSpeed(on)
    SpeedOn = on
    local _, hum = getHRP()
    if hum then hum.WalkSpeed = on and SpeedValue or 16 end
end

-- Vanish 
