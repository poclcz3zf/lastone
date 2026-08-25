-- ============================================
-- 🔗 KVN Server Binding System
-- ربط السكريبت بالسيرفر - منع النسخ
-- لو أوقفته من الموقع => يتقفل على الكل فوراً
-- ============================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local SERVER_URL = "http://kvnreal.online"
local SCRIPT_ID = "lolasdwa"
local localPlayer = Players.LocalPlayer

-- التحقق من حالة السكريبت من السيرفر
local function checkServerStatus()
    local url = SERVER_URL .. "/api/script-status/" .. SCRIPT_ID
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return false, "فشل الاتصال بالسيرفر"
    end
    
    local decoded
    local decodeSuccess = pcall(function()
        decoded = HttpService:JSONDecode(response)
    end)
    
    if not decodeSuccess or not decoded then
        return false, "خطأ في استجابة السيرفر"
    end
    
    if not decoded.active then
        return false, decoded.message or "⛔ السكريبت متوقف من قبل الأدمن"
    end
    
    return true, "✅ السكريبت شغال"
end

-- طرد اللاعب
local function kickPlayer(reason)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🔒 تم إيقاف السكريبت",
            Text = reason or "تم إيقاف هذا السكريبت من لوحة التحكم",
            Duration = 5
        })
    end)
    wait(1)
    pcall(function()
        localPlayer:Kick(reason or "⛔ السكريبت متوقف")
    end)
end

-- التحقق المستمر
local function startServerBinding()
    local isActive, msg = checkServerStatus()
    
    if not isActive then
        kickPlayer(msg)
        return false
    end
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🔗 السكريبت مربوط بالسيرفر",
            Text = "✅ إذا أوقفه الأدمن سيتوقف عندك فوراً",
            Duration = 3
        })
    end)
    
    -- كل 10 ثواني يتحقق
    spawn(function()
        while true do
            wait(10)
            local stillActive, kickMsg = checkServerStatus()
            if not stillActive then
                kickPlayer(kickMsg)
                break
            end
        end
    end)
    
    return true
end

if not startServerBinding() then
    return
end

-- ============================================
-- كودك الأصلي يبدأ من هنا
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== إعدادات الميزة ==========
local FakeName = "Real Is Here" -- الاسم المستعار
local NameHiderActive = false
local RenderConnection = nil

-- ========== الألوان الفخمة ==========
local C = {
    BG         = Color3.fromRGB(10, 10, 20),
    Panel      = Color3.fromRGB(16, 16, 32),
    Card       = Color3.fromRGB(24, 24, 48),
    Accent     = Color3.fromRGB(0, 210, 110), -- الأخضر
    AccentSoft = Color3.fromRGB(15, 60, 40),
    Text       = Color3.fromRGB(255, 255, 255),
    TextSoft   = Color3.fromRGB(160, 160, 190),
    Red        = Color3.fromRGB(255, 60, 80),
}

-- ========== إنشاء الواجهة GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KVN_NameHider_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.5, -180, 0.4, -120)
MainFrame.BackgroundColor3 = C.BG
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 4)
TopLine.BackgroundColor3 = C.Accent
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame
Instance.new("UICorner", TopLine).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 20, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "K V N — Name Hider"
Title.TextColor3 = C.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.Red
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, -40, 0, 140)
Card.Position = UDim2.new(0, 20, 0, 65)
Card.BackgroundColor3 = C.Card
Card.BorderSizePixel = 0
Card.Parent = MainFrame
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local Description = Instance.new("TextLabel")
Description.Size = UDim2.new(1, -20, 0, 50)
Description.Position = UDim2.new(0, 10, 0, 10)
Description.BackgroundTransparency = 1
Description.Text = "ترا بيتغير من جهتك فقط عشان التصوير بس!!"
Description.TextColor3 = C.TextSoft
Description.TextSize = 13
Description.Font = Enum.Font.Gotham
Description.TextWrapped = true
Description.TextXAlignment = Enum.TextXAlignment.Right
Description.Parent = Card

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -40, 0, 45)
ToggleBtn.Position = UDim2.new(0, 20, 1, -60)
ToggleBtn.BackgroundColor3 = C.Red
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "إخفاء الاسم: [ OFF ]"
ToggleBtn.TextColor3 = C.Text
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Card
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- ========== الفحص السلس والخفيف الحمي والذكي ==========
local function ProcessTextObject(v)
    if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
        local text = v.Text
        if text ~= "" then
            local changed = false
            -- استبدال الاسم الأساسي
            if string.find(text, LocalPlayer.Name) then
                text = string.gsub(text, LocalPlayer.Name, FakeName)
                changed = true
            end
            -- استبدال اسم العرض
            if string.find(text, LocalPlayer.DisplayName) then
                text = string.gsub(text, LocalPlayer.DisplayName, FakeName)
                changed = true
            end
            if changed then
                v.Text = text
            end
        end
    end
end

local function StartHider()
    if NameHiderActive then return end
    NameHiderActive = true
    
    -- تعديل اسم العرض الأساسي محلياً فوراً
    pcall(function()
        LocalPlayer.DisplayName = FakeName
    end)
    
    -- نظام المراقبة الفائق الخفة (يفحص فقط واجهة المستخدم للشاشات والشخصية)
    RenderConnection = RunService.RenderStepped:Connect(function()
        if not NameHiderActive then return end
        
        -- 1. فحص قائمة الصدارة والشات والواجهات المفتوحة حالياً فقط (بدءاً من الـ PlayerGui)
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, v in ipairs(playerGui:GetDescendants()) do
                if v.Name ~= "KVN_NameHider_Fixed" then -- تجنب فحص قائمتنا
                    ProcessTextObject(v)
                end
            end
        end
        
        -- 2. فحص لوحة الصدارة الأساسية التابعة لروبلوكس (CoreGui) لتعديل الاسم فيها بسلاسة
        local coreGui = game:GetService("CoreGui")
        local playerList = coreGui:FindFirstChild("PlayerList") or coreGui:FindFirstChild("RobloxGui")
        if playerList then
            for _, v in ipairs(playerList:GetDescendants()) do
                ProcessTextObject(v)
            end
        end
        
        -- 3. فحص الاسم المكتوب فوق رأس اللاعب (Overhead / Character Humanoid)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.DisplayName ~= FakeName then
                humanoid.DisplayName = FakeName
            end
            -- أي نصوص تظهر في الشخصية
            for _, child in ipairs(character:GetDescendants()) do
                ProcessTextObject(child)
            end
        end
    end)
end

local function StopHider()
    NameHiderActive = false
    if RenderConnection then
        RenderConnection:Disconnect()
        RenderConnection = nil
    end
    
    -- إرجاع الاسم الطبيعي محلياً
    pcall(function()
        LocalPlayer.DisplayName = game:GetService("Players"):GetNameFromUserIdAsync(LocalPlayer.UserId)
    end)
end

-- زر التفعيل والانتقال السلس للألوان
ToggleBtn.MouseButton1Click:Connect(function()
    if NameHiderActive then
        StopHider()
        ToggleBtn.Text = "إخفاء الاسم: [ OFF ]"
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.Red}):Play()
    else
        StartHider()
        ToggleBtn.Text = "إخفاء الاسم: [ ON ]"
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.Accent}):Play()
    end
end)

-- ========== نظام السحب والإفلات (Drag) بدون تعليق ==========
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("========================================")
print(" Real Is Here & K V N ")
