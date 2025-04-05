-- Oyuncuyu ve gerekli değişkenleri tanımla
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local menuOpen = false
local currentKey = Enum.KeyCode.E
local espActive = false
local gunTpActive = false
local speedActive = false
local sprintActive = false
local jumpActive = false
local infiniteJumpActive = false
local clickTpActive = false
local gunTpTool = nil
local defaultWalkSpeed = 16
local sprintSpeed = 32
local defaultJumpPower = 50
local ctrlPressed = false
local shiftPressed = false
local language = "TR"
local correctKey = "BypasfanGeriDöndü"
local attempts = 3
local aliveCount = 0
local gameStarted = false

-- Dil tabloları
local lang = {
    TR = {
        menuTitle = "MM2 Hile Menüsü",
        developer = "Developer: Bypasfan",
        alive = "Hayatta: ",
        esp = "ESP:",
        espOff = "ESP: Kapalı",
        espOn = "ESP: Açık",
        gunTp = "Gun TP:",
        gunTpOff = "Gun TP: Kapalı",
        gunTpOn = "Gun TP: Açık",
        speed = "Speed:",
        speedOff = "Speed: Kapalı",
        speedOn = "Speed: Açık",
        sprint = "Sprint:",
        sprintOff = "Sprint: Kapalı",
        sprintOn = "Sprint: Açık",
        jump = "Jump:",
        jumpOff = "Jump: Kapalı",
        jumpOn = "Jump: Açık",
        infiniteJump = "Sınırsız Zıplama:",
        infiniteJumpOff = "Sınırsız Zıplama: Kapalı",
        infiniteJumpOn = "Sınırsız Zıplama: Açık",
        clickTp = "Click TP:",
        clickTpOff = "Click TP: Kapalı",
        clickTpOn = "Click TP: Açık",
        killAll = "Kill All:",
        killAllButton = "Kill All",
        killSheriff = "Kill Sheriff:",
        killSheriffButton = "Kill Sheriff",
        killMurderer = "Kill Murderer:",
        killMurdererButton = "Kill Murderer",
        key = "Aç/Kapat:",
        warningGun = "Silah düşmedi!",
        warningMurderer = "Katil değilsin!",
        warningSheriff = "Şerif değilsin!",
        warningDone = "Herkes öldürüldü!",
        keyPrompt = "Lütfen anahtarı giriniz:",
        keyButton = "Dene",
        getKey = "Anahtarı Al",
        wrongKey = "Yanlış anahtar! Kalan hak: ",
        noAttempts = "Haklar bitti! Oyundan atılıyorsun...",
        openMenuPrompt = "E TUŞUNA BASARAK MENÜYÜ AÇABİLİRSİNİZ",
        keyCopied = "Anahtar alma linki kopyalandı!"
    },
    EN = {
        menuTitle = "MM2 Cheat Menu",
        developer = "Developer: Bypasfan",
        alive = "Alive: ",
        esp = "ESP:",
        espOff = "ESP: Off",
        espOn = "ESP: On",
        gunTp = "Gun TP:",
        gunTpOff = "Gun TP: Off",
        gunTpOn = "Gun TP: On",
        speed = "Speed:",
        speedOff = "Speed: Off",
        speedOn = "Speed: On",
        sprint = "Sprint:",
        sprintOff = "Sprint: Off",
        sprintOn = "Sprint: On",
        jump = "Jump:",
        jumpOff = "Jump: Off",
        jumpOn = "Jump: On",
        infiniteJump = "Infinite Jump:",
        infiniteJumpOff = "Infinite Jump: Off",
        infiniteJumpOn = "Infinite Jump: On",
        clickTp = "Click TP:",
        clickTpOff = "Click TP: Off",
        clickTpOn = "Click TP: On",
        killAll = "Kill All:",
        killAllButton = "Kill All",
        killSheriff = "Kill Sheriff:",
        killSheriffButton = "Kill Sheriff",
        killMurderer = "Kill Murderer:",
        killMurdererButton = "Kill Murderer",
        key = "Toggle:",
        warningGun = "Gun not dropped!",
        warningMurderer = "You are not the murderer!",
        warningSheriff = "You are not the sheriff!",
        warningDone = "Everyone is killed!",
        keyPrompt = "Please enter the key:",
        keyButton = "Try",
        getKey = "Get Key",
        wrongKey = "Wrong key! Remaining attempts: ",
        noAttempts = "No attempts left! Kicking you out...",
        openMenuPrompt = "PRESS E TO OPEN THE MENU",
        keyCopied = "Key retrieval link copied!"
    }
}

-- Key ekranı oluştur
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.Name = "KeyMenu"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))}
    gradient.Parent = frame
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://1316045217"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ImageTransparency = 0.5
    shadow.Parent = frame

    local promptLabel = Instance.new("TextLabel")
    promptLabel.Size = UDim2.new(1, 0, 0, 40)
    promptLabel.Text = lang[language].keyPrompt
    promptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    promptLabel.BackgroundTransparency = 1
    promptLabel.Font = Enum.Font.GothamBold
    promptLabel.TextSize = 18
    promptLabel.Parent = frame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0, 200, 0, 40)
    keyInput.Position = UDim2.new(0.5, -100, 0, 70)
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextSize = 16
    keyInput.Parent = frame
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 8)
    keyInputCorner.Parent = keyInput

    local tryButton = Instance.new("TextButton")
    tryButton.Size = UDim2.new(0, 100, 0, 40)
    tryButton.Position = UDim2.new(0.5, -50, 0, 120)
    tryButton.Text = lang[language].keyButton
    tryButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    tryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tryButton.Font = Enum.Font.Gotham
    tryButton.TextSize = 16
    tryButton.Parent = frame
    local tryButtonCorner = Instance.new("UICorner")
    tryButtonCorner.CornerRadius = UDim.new(0, 8)
    tryButtonCorner.Parent = tryButton

    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Size = UDim2.new(0, 100, 0, 40)
    getKeyButton.Position = UDim2.new(0, 50, 0, 170)
    getKeyButton.Text = lang[language].getKey
    getKeyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyButton.Font = Enum.Font.Gotham
    getKeyButton.TextSize = 16
    getKeyButton.Parent = frame
    local getKeyButtonCorner = Instance.new("UICorner")
    getKeyButtonCorner.CornerRadius = UDim.new(0, 8)
    getKeyButtonCorner.Parent = getKeyButton

    local warningLabel = Instance.new("TextLabel")
    warningLabel.Size = UDim2.new(1, 0, 0, 30)
    warningLabel.Position = UDim2.new(0, 0, 1, -30)
    warningLabel.Text = ""
    warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Font = Enum.Font.GothamBold
    warningLabel.TextSize = 14
    warningLabel.Parent = frame

    return screenGui, keyInput, tryButton, getKeyButton, warningLabel
end

local keyScreenGui, keyInput, tryButton, getKeyButton, keyWarningLabel = createKeyGui()

-- Ana menü oluştur
local function createMainGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.Name = "MM2CheatMenu"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 400)
    frame.Position = UDim2.new(0.5, -200, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))}
    gradient.Parent = frame
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://1316045217"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.ImageTransparency = 0.4
    shadow.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = lang[language].menuTitle
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24
    title.Parent = frame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = title
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 80))}
    titleGradient.Parent = title

    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(0, 200, 0, 30)
    devLabel.Position = UDim2.new(0.5, -100, 0, 5)
    devLabel.Text = lang[language].developer
    devLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    devLabel.BackgroundTransparency = 1
    devLabel.Font = Enum.Font.GothamBold
    devLabel.TextSize = 16
    devLabel.Parent = screenGui

    local aliveLabel = Instance.new("TextLabel")
    aliveLabel.Size = UDim2.new(0, 150, 0, 30)
    aliveLabel.Position = UDim2.new(0, 10, 0, 50)
    aliveLabel.Text = lang[language].alive .. "0"
    aliveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    aliveLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    aliveLabel.BackgroundTransparency = 0.4
    aliveLabel.Font = Enum.Font.GothamBold
    aliveLabel.TextSize = 16
    aliveLabel.Parent = screenGui
    local aliveCorner = Instance.new("UICorner")
    aliveCorner.CornerRadius = UDim.new(0, 10)
    aliveCorner.Parent = aliveLabel

    local warningLabel = Instance.new("TextLabel")
    warningLabel.Size = UDim2.new(0, 300, 0, 60)
    warningLabel.Position = UDim2.new(0.5, -150, 0.5, -30)
    warningLabel.Text = ""
    warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    warningLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    warningLabel.BackgroundTransparency = 0.2
    warningLabel.Font = Enum.Font.GothamBold
    warningLabel.TextSize = 20
    warningLabel.Visible = false
    warningLabel.Parent = screenGui
    local warningCorner = Instance.new("UICorner")
    warningCorner.CornerRadius = UDim.new(0, 15)
    warningCorner.Parent = warningLabel

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(0, 360, 0, 350)
    scrollingFrame.Position = UDim2.new(0, 20, 0, 50)
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Dinamik olarak ayarlanacak
    scrollingFrame.Parent = frame
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 10)
    scrollCorner.Parent = scrollingFrame

    -- Görsel Hileler
    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(0, 80, 0, 20)
    espLabel.Position = UDim2.new(0, 10, 0, 10)
    espLabel.Text = lang[language].esp
    espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    espLabel.BackgroundTransparency = 1
    espLabel.Font = Enum.Font.Gotham
    espLabel.TextSize = 14
    espLabel.Parent = scrollingFrame

    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(0, 120, 0, 30)
    espButton.Position = UDim2.new(0, 100, 0, 5)
    espButton.Text = lang[language].espOff
    espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.Font = Enum.Font.Gotham
    espButton.TextSize = 12
    espButton.Parent = scrollingFrame
    local espButtonCorner = Instance.new("UICorner")
    espButtonCorner.CornerRadius = UDim.new(0, 8)
    espButtonCorner.Parent = espButton

    -- Hareket Hileleri
    local speedLabel = Instance.new("TextLabel")
    local speedValueLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 80, 0, 20)
    speedLabel.Position = UDim2.new(0, 10, 0, 45)
    speedLabel.Text = lang[language].speed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 14
    speedLabel.Parent = scrollingFrame
    speedValueLabel.Size = UDim2.new(0, 40, 0, 20)
    speedValueLabel.Position = UDim2.new(0, 220, 0, 45)
    speedValueLabel.Text = "16"
    speedValueLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    speedValueLabel.BackgroundTransparency = 1
    speedValueLabel.Font = Enum.Font.GothamBold
    speedValueLabel.TextSize = 12
    speedValueLabel.Parent = scrollingFrame

    local speedButton = Instance.new("TextButton")
    speedButton.Size = UDim2.new(0, 120, 0, 30)
    speedButton.Position = UDim2.new(0, 100, 0, 40)
    speedButton.Text = lang[language].speedOff
    speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedButton.Font = Enum.Font.Gotham
    speedButton.TextSize = 12
    speedButton.Parent = scrollingFrame
    local speedButtonCorner = Instance.new("UICorner")
    speedButtonCorner.CornerRadius = UDim.new(0, 8)
    speedButtonCorner.Parent = speedButton

    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0, 160, 0, 8)
    speedSlider.Position = UDim2.new(0, 100, 0, 75)
    speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    speedSlider.Parent = scrollingFrame
    local speedSliderCorner = Instance.new("UICorner")
    speedSliderCorner.CornerRadius = UDim.new(0, 4)
    speedSliderCorner.Parent = speedSlider

    local speedKnob = Instance.new("Frame")
    speedKnob.Size = UDim2.new(0, 12, 0, 20)
    speedKnob.Position = UDim2.new(0, 74, 0, -6)
    speedKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
    speedKnob.Parent = speedSlider
    local speedKnobCorner = Instance.new("UICorner")
    speedKnobCorner.CornerRadius = UDim.new(0, 4)
    speedKnobCorner.Parent = speedKnob

    local sprintLabel = Instance.new("TextLabel")
    sprintLabel.Size = UDim2.new(0, 80, 0, 20)
    sprintLabel.Position = UDim2.new(0, 10, 0, 95)
    sprintLabel.Text = lang[language].sprint
    sprintLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sprintLabel.BackgroundTransparency = 1
    sprintLabel.Font = Enum.Font.Gotham
    sprintLabel.TextSize = 14
    sprintLabel.Parent = scrollingFrame

    local sprintButton = Instance.new("TextButton")
    sprintButton.Size = UDim2.new(0, 120, 0, 30)
    sprintButton.Position = UDim2.new(0, 100, 0, 90)
    sprintButton.Text = lang[language].sprintOff
    sprintButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    sprintButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sprintButton.Font = Enum.Font.Gotham
    sprintButton.TextSize = 12
    sprintButton.Parent = scrollingFrame
    local sprintButtonCorner = Instance.new("UICorner")
    sprintButtonCorner.CornerRadius = UDim.new(0, 8)
    sprintButtonCorner.Parent = sprintButton

    local jumpLabel = Instance.new("TextLabel")
    local jumpValueLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 80, 0, 20)
    jumpLabel.Position = UDim2.new(0, 10, 0, 130)
    jumpLabel.Text = lang[language].jump
    jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Font = Enum.Font.Gotham
    jumpLabel.TextSize = 14
    jumpLabel.Parent = scrollingFrame
    jumpValueLabel.Size = UDim2.new(0, 40, 0, 20)
    jumpValueLabel.Position = UDim2.new(0, 220, 0, 130)
    jumpValueLabel.Text = "50"
    jumpValueLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    jumpValueLabel.BackgroundTransparency = 1
    jumpValueLabel.Font = Enum.Font.GothamBold
    jumpValueLabel.TextSize = 12
    jumpValueLabel.Parent = scrollingFrame

    local jumpButton = Instance.new("TextButton")
    jumpButton.Size = UDim2.new(0, 120, 0, 30)
    jumpButton.Position = UDim2.new(0, 100, 0, 125)
    jumpButton.Text = lang[language].jumpOff
    jumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpButton.Font = Enum.Font.Gotham
    jumpButton.TextSize = 12
    jumpButton.Parent = scrollingFrame
    local jumpButtonCorner = Instance.new("UICorner")
    jumpButtonCorner.CornerRadius = UDim.new(0, 8)
    jumpButtonCorner.Parent = jumpButton

    local jumpSlider = Instance.new("Frame")
    jumpSlider.Size = UDim2.new(0, 80, 0, 8)
    jumpSlider.Position = UDim2.new(0, 100, 0, 160)
    jumpSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    jumpSlider.Parent = scrollingFrame
    local jumpSliderCorner = Instance.new("UICorner")
    jumpSliderCorner.CornerRadius = UDim.new(0, 4)
    jumpSliderCorner.Parent = jumpSlider

    local jumpKnob = Instance.new("Frame")
    jumpKnob.Size = UDim2.new(0, 12, 0, 20)
    jumpKnob.Position = UDim2.new(0, 34, 0, -6)
    jumpKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
    jumpKnob.Parent = jumpSlider
    local jumpKnobCorner = Instance.new("UICorner")
    jumpKnobCorner.CornerRadius = UDim.new(0, 4)
    jumpKnobCorner.Parent = jumpKnob

    local infiniteJumpLabel = Instance.new("TextLabel")
    infiniteJumpLabel.Size = UDim2.new(0, 80, 0, 20)
    infiniteJumpLabel.Position = UDim2.new(0, 10, 0, 180)
    infiniteJumpLabel.Text = lang[language].infiniteJump
    infiniteJumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infiniteJumpLabel.BackgroundTransparency = 1
    infiniteJumpLabel.Font = Enum.Font.Gotham
    infiniteJumpLabel.TextSize = 14
    infiniteJumpLabel.Parent = scrollingFrame

    local infiniteJumpButton = Instance.new("TextButton")
    infiniteJumpButton.Size = UDim2.new(0, 120, 0, 30)
    infiniteJumpButton.Position = UDim2.new(0, 100, 0, 175)
    infiniteJumpButton.Text = lang[language].infiniteJumpOff
    infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    infiniteJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    infiniteJumpButton.Font = Enum.Font.Gotham
    infiniteJumpButton.TextSize = 12
    infiniteJumpButton.Parent = scrollingFrame
    local infiniteJumpButtonCorner = Instance.new("UICorner")
    infiniteJumpButtonCorner.CornerRadius = UDim.new(0, 8)
    infiniteJumpButtonCorner.Parent = infiniteJumpButton

    local clickTpLabel = Instance.new("TextLabel")
    clickTpLabel.Size = UDim2.new(0, 80, 0, 20)
    clickTpLabel.Position = UDim2.new(0, 10, 0, 215)
    clickTpLabel.Text = lang[language].clickTp
    clickTpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    clickTpLabel.BackgroundTransparency = 1
    clickTpLabel.Font = Enum.Font.Gotham
    clickTpLabel.TextSize = 14
    clickTpLabel.Parent = scrollingFrame

    local clickTpButton = Instance.new("TextButton")
    clickTpButton.Size = UDim2.new(0, 120, 0, 30)
    clickTpButton.Position = UDim2.new(0, 100, 0, 210)
    clickTpButton.Text = lang[language].clickTpOff
    clickTpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    clickTpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clickTpButton.Font = Enum.Font.Gotham
    clickTpButton.TextSize = 12
    clickTpButton.Parent = scrollingFrame
    local clickTpButtonCorner = Instance.new("UICorner")
    clickTpButtonCorner.CornerRadius = UDim.new(0, 8)
    clickTpButtonCorner.Parent = clickTpButton

    local gunTpLabel = Instance.new("TextLabel")
    gunTpLabel.Size = UDim2.new(0, 80, 0, 20)
    gunTpLabel.Position = UDim2.new(0, 10, 0, 250)
    gunTpLabel.Text = lang[language].gunTp
    gunTpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    gunTpLabel.BackgroundTransparency = 1
    gunTpLabel.Font = Enum.Font.Gotham
    gunTpLabel.TextSize = 14
    gunTpLabel.Parent = scrollingFrame

    local gunTpButton = Instance.new("TextButton")
    gunTpButton.Size = UDim2.new(0, 120, 0, 30)
    gunTpButton.Position = UDim2.new(0, 100, 0, 245)
    gunTpButton.Text = lang[language].gunTpOff
    gunTpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    gunTpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    gunTpButton.Font = Enum.Font.Gotham
    gunTpButton.TextSize = 12
    gunTpButton.Parent = scrollingFrame
    local gunTpButtonCorner = Instance.new("UICorner")
    gunTpButtonCorner.CornerRadius = UDim.new(0, 8)
    gunTpButtonCorner.Parent = gunTpButton

    -- Saldırı Hileleri
    local killAllLabel = Instance.new("TextLabel")
    killAllLabel.Size = UDim2.new(0, 80, 0, 20)
    killAllLabel.Position = UDim2.new(0, 10, 0, 285)
    killAllLabel.Text = lang[language].killAll
    killAllLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    killAllLabel.BackgroundTransparency = 1
    killAllLabel.Font = Enum.Font.Gotham
    killAllLabel.TextSize = 14
    killAllLabel.Parent = scrollingFrame

    local killAllButton = Instance.new("TextButton")
    killAllButton.Size = UDim2.new(0, 120, 0, 30)
    killAllButton.Position = UDim2.new(0, 100, 0, 280)
    killAllButton.Text = lang[language].killAllButton
    killAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    killAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    killAllButton.Font = Enum.Font.Gotham
    killAllButton.TextSize = 12
    killAllButton.Parent = scrollingFrame
    local killAllButtonCorner = Instance.new("UICorner")
    killAllButtonCorner.CornerRadius = UDim.new(0, 8)
    killAllButtonCorner.Parent = killAllButton

    local killSheriffLabel = Instance.new("TextLabel")
    killSheriffLabel.Size = UDim2.new(0, 80, 0, 20)
    killSheriffLabel.Position = UDim2.new(0, 10, 0, 320)
    killSheriffLabel.Text = lang[language].killSheriff
    killSheriffLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    killSheriffLabel.BackgroundTransparency = 1
    killSheriffLabel.Font = Enum.Font.Gotham
    killSheriffLabel.TextSize = 14
    killSheriffLabel.Parent = scrollingFrame

    local killSheriffButton = Instance.new("TextButton")
    killSheriffButton.Size = UDim2.new(0, 120, 0, 30)
    killSheriffButton.Position = UDim2.new(0, 100, 0, 315)
    killSheriffButton.Text = lang[language].killSheriffButton
    killSheriffButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    killSheriffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    killSheriffButton.Font = Enum.Font.Gotham
    killSheriffButton.TextSize = 12
    killSheriffButton.Parent = scrollingFrame
    local killSheriffButtonCorner = Instance.new("UICorner")
    killSheriffButtonCorner.CornerRadius = UDim.new(0, 8)
    killSheriffButtonCorner.Parent = killSheriffButton

    local killMurdererLabel = Instance.new("TextLabel")
    killMurdererLabel.Size = UDim2.new(0, 80, 0, 20)
    killMurdererLabel.Position = UDim2.new(0, 10, 0, 355)
    killMurdererLabel.Text = lang[language].killMurderer
    killMurdererLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    killMurdererLabel.BackgroundTransparency = 1
    killMurdererLabel.Font = Enum.Font.Gotham
    killMurdererLabel.TextSize = 14
    killMurdererLabel.Parent = scrollingFrame

    local killMurdererButton = Instance.new("TextButton")
    killMurdererButton.Size = UDim2.new(0, 120, 0, 30)
    killMurdererButton.Position = UDim2.new(0, 100, 0, 350)
    killMurdererButton.Text = lang[language].killMurdererButton
    killMurdererButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    killMurdererButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    killMurdererButton.Font = Enum.Font.Gotham
    killMurdererButton.TextSize = 12
    killMurdererButton.Parent = scrollingFrame
    local killMurdererButtonCorner = Instance.new("UICorner")
    killMurdererButtonCorner.CornerRadius = UDim.new(0, 8)
    killMurdererButtonCorner.Parent = killMurdererButton

    -- Ayarlar
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 80, 0, 20)
    keyLabel.Position = UDim2.new(0, 10, 0, 390)
    keyLabel.Text = lang[language].key
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.TextSize = 14
    keyLabel.Parent = scrollingFrame

    local keyInputMain = Instance.new("TextBox")
    keyInputMain.Size = UDim2.new(0, 80, 0, 30)
    keyInputMain.Position = UDim2.new(0, 100, 0, 385)
    keyInputMain.Text = "E"
    keyInputMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInputMain.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    keyInputMain.Font = Enum.Font.Gotham
    keyInputMain.TextSize = 12
    keyInputMain.Parent = scrollingFrame
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 8)
    keyInputCorner.Parent = keyInputMain

    local langLabel = Instance.new("TextLabel")
    langLabel.Size = UDim2.new(0, 80, 0, 20)
    langLabel.Position = UDim2.new(0, 10, 0, 425)
    langLabel.Text = language == "TR" and "Dil:" or "Language:"
    langLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    langLabel.BackgroundTransparency = 1
    langLabel.Font = Enum.Font.Gotham
    langLabel.TextSize = 14
    langLabel.Parent = scrollingFrame

    local langButtonTR = Instance.new("TextButton")
    langButtonTR.Size = UDim2.new(0, 60, 0, 30)
    langButtonTR.Position = UDim2.new(0, 100, 0, 420)
    langButtonTR.Text = "Türkçe"
    langButtonTR.BackgroundColor3 = language == "TR" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
    langButtonTR.TextColor3 = Color3.fromRGB(255, 255, 255)
    langButtonTR.Font = Enum.Font.Gotham
    langButtonTR.TextSize = 12
    langButtonTR.Parent = scrollingFrame
    local langButtonTRCorner = Instance.new("UICorner")
    langButtonTRCorner.CornerRadius = UDim.new(0, 8)
    langButtonTRCorner.Parent = langButtonTR

    local langButtonEN = Instance.new("TextButton")
    langButtonEN.Size = UDim2.new(0, 60, 0, 30)
    langButtonEN.Position = UDim2.new(0, 170, 0, 420)
    langButtonEN.Text = "English"
    langButtonEN.BackgroundColor3 = language == "EN" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
    langButtonEN.TextColor3 = Color3.fromRGB(255, 255, 255)
    langButtonEN.Font = Enum.Font.Gotham
    langButtonEN.TextSize = 12
    langButtonEN.Parent = scrollingFrame
    local langButtonENCorner = Instance.new("UICorner")
    langButtonENCorner.CornerRadius = UDim.new(0, 8)
    langButtonENCorner.Parent = langButtonEN

    -- Canvas boyutunu dinamik olarak ayarla
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 460)

    return screenGui, frame, espButton, gunTpButton, speedButton, sprintButton, jumpButton, infiniteJumpButton, clickTpButton, killAllButton, keyInputMain, warningLabel, aliveLabel, speedKnob, jumpKnob, title, devLabel, espLabel, gunTpLabel, speedLabel, sprintLabel, jumpLabel, infiniteJumpLabel, killAllLabel, keyLabel, clickTpLabel, langLabel, langButtonTR, langButtonEN, speedValueLabel, jumpValueLabel, killSheriffButton, killMurdererButton, killSheriffLabel, killMurdererLabel
end

-- Key kontrolü ve büyük uyarı
local mainGuiCreated = false
local mainScreenGui, mainFrame, espButton, gunTpButton, speedButton, sprintButton, jumpButton, infiniteJumpButton, clickTpButton, killAllButton, keyInputMain, warningLabel, aliveLabel, speedKnob, jumpKnob, title, devLabel, espLabel, gunTpLabel, speedLabel, sprintLabel, jumpLabel, infiniteJumpLabel, killAllLabel, keyLabel, clickTpLabel, langLabel, langButtonTR, langButtonEN, speedValueLabel, jumpValueLabel, killSheriffButton, killMurdererButton, killSheriffLabel, killMurdererLabel

tryButton.MouseButton1Click:Connect(function()
    if keyInput.Text == correctKey then
        keyScreenGui:Destroy()
        if not mainGuiCreated then
            mainScreenGui, mainFrame, espButton, gunTpButton, speedButton, sprintButton, jumpButton, infiniteJumpButton, clickTpButton, killAllButton, keyInputMain, warningLabel, aliveLabel, speedKnob, jumpKnob, title, devLabel, espLabel, gunTpLabel, speedLabel, sprintLabel, jumpLabel, infiniteJumpLabel, killAllLabel, keyLabel, clickTpLabel, langLabel, langButtonTR, langButtonEN, speedValueLabel, jumpValueLabel, killSheriffButton, killMurdererButton, killSheriffLabel, killMurdererLabel = createMainGui()
            mainGuiCreated = true
            setupMainGui()

            local promptGui = Instance.new("ScreenGui")
            promptGui.Parent = player:WaitForChild("PlayerGui")
            promptGui.Name = "OpenPrompt"
            local promptLabel = Instance.new("TextLabel")
            promptLabel.Size = UDim2.new(0, 600, 0, 100)
            promptLabel.Position = UDim2.new(0.5, -300, 0.5, -50)
            promptLabel.Text = lang[language].openMenuPrompt
            promptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            promptLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
            promptLabel.Font = Enum.Font.GothamBold
            promptLabel.TextSize = 30
            promptLabel.Parent = promptGui
            local promptCorner = Instance.new("UICorner")
            promptCorner.CornerRadius = UDim.new(0, 15)
            promptCorner.Parent = promptLabel
            wait(3)
            promptGui:Destroy()
        end
    else
        attempts = attempts - 1
        if attempts > 0 then
            keyWarningLabel.Text = lang[language].wrongKey .. attempts
        else
            keyWarningLabel.Text = lang[language].noAttempts
            wait(2)
            player:Kick(lang[language].noAttempts)
        end
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://t.me/keyler_bot")
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = lang[language].keyCopied,
        Color = Color3.fromRGB(0, 255, 0)
    })
end)

-- Ana menü fonksiyonları
function setupMainGui()
    local function createGunTpTool()
        local tool = Instance.new("Tool")
        tool.Name = "GunTPTool"
        tool.RequiresHandle = false
        tool.Parent = player.Backpack
        return tool
    end

    -- Oyun başlangıcını ve hayatta kalanları takip et
    local function resetAliveCount()
        aliveCount = #game.Players:GetPlayers()
        aliveLabel.Text = lang[language].alive .. aliveCount
    end

    local function updateAliveCount()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Died:Connect(function()
                        if gameStarted then
                            aliveCount = aliveCount - 1
                            aliveLabel.Text = lang[language].alive .. aliveCount
                        end
                    end)
                end
            end
            plr.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid")
                hum.Died:Connect(function()
                    if gameStarted then
                        aliveCount = aliveCount - 1
                        aliveLabel.Text = lang[language].alive .. aliveCount
                    end
                end)
            end)
        end
    end

    -- Oyun başlangıcını tespit et
    local function detectGameStart()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Backpack:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Gun") then
                if not gameStarted then
                    gameStarted = true
                    resetAliveCount()
                    updateAliveCount()
                end
                break
            end
        end
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        detectGameStart()
    end)

    local dragging, dragInput, dragStart, startPos
    mainFrame:FindFirstChild("TextLabel").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame:FindFirstChild("TextLabel").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local speedSliding, speedSlideInput, speedSlideStart
    speedKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            speedSliding = true
            speedSlideStart = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    speedSliding = false
                end
            end)
        end
    end)

    speedKnob.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            speedSlideInput = input
        end
    end)

    local jumpSliding, jumpSlideInput, jumpSlideStart
    jumpKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            jumpSliding = true
            jumpSlideStart = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    jumpSliding = false
                end
            end)
        end
    end)

    jumpKnob.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            jumpSlideInput = input
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if speedSliding and speedSlideInput then
            local delta = speedSlideInput.Position.X - speedSlideStart.X
            local newX = math.clamp(speedKnob.Position.X.Offset + delta, 0, 148)
            speedKnob.Position = UDim2.new(0, newX, 0, -6)
            local speedValue = math.floor(16 + (newX / 148) * 64)
            speedValueLabel.Text = tostring(speedValue)
            if speedActive then
                humanoid.WalkSpeed = speedValue
            end
            speedSlideStart = speedSlideInput.Position
        end
        if jumpSliding and jumpSlideInput then
            local delta = jumpSlideInput.Position.X - jumpSlideStart.X
            local newX = math.clamp(jumpKnob.Position.X.Offset + delta, 0, 68)
            jumpKnob.Position = UDim2.new(0, newX, 0, -6)
            local jumpValue = math.floor(50 + (newX / 68) * 150)
            jumpValueLabel.Text = tostring(jumpValue)
            if jumpActive then
                humanoid.JumpPower = jumpValue
            end
            jumpSlideStart = jumpSlideInput.Position
        end
        if not gameStarted then
            aliveLabel.Text = lang[language].alive .. #game.Players:GetPlayers()
        end
    end)

    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == currentKey then
            menuOpen = not menuOpen
            if menuOpen then
                mainFrame.Visible = true
                mainFrame.Size = UDim2.new(0, 400, 0, 0)
                mainFrame.BackgroundTransparency = 1
                local openTween = game:GetService("TweenService"):Create(
                    mainFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 400, 0, 400), BackgroundTransparency = 0}
                )
                openTween:Play()
            else
                local closeTween = game:GetService("TweenService"):Create(
                    mainFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {Size = UDim2.new(0, 400, 0, 0), BackgroundTransparency = 1}
                )
                closeTween:Play()
                closeTween.Completed:Connect(function()
                    mainFrame.Visible = false
                end)
            end
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            ctrlPressed = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            shiftPressed = true
            if sprintActive then
                humanoid.WalkSpeed = sprintSpeed
            end
        elseif input.KeyCode == Enum.KeyCode.Space and infiniteJumpActive then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftControl then
            ctrlPressed = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            shiftPressed = false
            if sprintActive and not speedActive then
                humanoid.WalkSpeed = defaultWalkSpeed
            elseif sprintActive and speedActive then
                humanoid.WalkSpeed = tonumber(speedValueLabel.Text) or defaultWalkSpeed
            end
        end
    end)

    keyInputMain.FocusLost:Connect(function()
        local newKey = keyInputMain.Text:upper()
        local keyCode = Enum.KeyCode[newKey]
        if keyCode then
            currentKey = keyCode
            keyInputMain.Text = newKey
        else
            keyInputMain.Text = currentKey.Name
        end
    end)

    local function updateLanguage()
        title.Text = lang[language].menuTitle
        devLabel.Text = lang[language].developer
        espLabel.Text = lang[language].esp
        espButton.Text = espActive and lang[language].espOn or lang[language].espOff
        gunTpLabel.Text = lang[language].gunTp
        gunTpButton.Text = gunTpActive and lang[language].gunTpOn or lang[language].gunTpOff
        speedLabel.Text = lang[language].speed
        speedButton.Text = speedActive and lang[language].speedOn or lang[language].speedOff
        sprintLabel.Text = lang[language].sprint
        sprintButton.Text = sprintActive and lang[language].sprintOn or lang[language].sprintOff
        jumpLabel.Text = lang[language].jump
        jumpButton.Text = jumpActive and lang[language].jumpOn or lang[language].jumpOff
        infiniteJumpLabel.Text = lang[language].infiniteJump
        infiniteJumpButton.Text = infiniteJumpActive and lang[language].infiniteJumpOn or lang[language].infiniteJumpOff
        clickTpLabel.Text = lang[language].clickTp
        clickTpButton.Text = clickTpActive and lang[language].clickTpOn or lang[language].clickTpOff
        killAllLabel.Text = lang[language].killAll
        killAllButton.Text = lang[language].killAllButton
        killSheriffLabel.Text = lang[language].killSheriff
        killSheriffButton.Text = lang[language].killSheriffButton
        killMurdererLabel.Text = lang[language].killMurderer
        killMurdererButton.Text = lang[language].killMurdererButton
        keyLabel.Text = lang[language].key
        langLabel.Text = language == "TR" and "Dil:" or "Language:"
        langButtonTR.BackgroundColor3 = language == "TR" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
        langButtonEN.BackgroundColor3 = language == "EN" and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
    end

    langButtonTR.MouseButton1Click:Connect(function()
        language = "TR"
        updateLanguage()
    end)

    langButtonEN.MouseButton1Click:Connect(function()
        language = "EN"
        updateLanguage()
    end)

    local espBoxes = {}
    local function createESP(part, color)
        local box = Instance.new("BoxHandleAdornment")
        box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
        box.Adornee = part
        box.Color3 = color
        box.Transparency = 0.7
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Parent = part
        return box
    end

    local function getPlayerRole(plr)
        local backpack = plr:FindFirstChild("Backpack")
        local character = plr.Character
        if backpack and character then
            if backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife") then
                return "Murderer"
            elseif backpack:FindFirstChild("Gun") or character:FindFirstChild("Gun") then
                return "Sheriff"
            else
                return "Innocent"
            end
        end
        return "Unknown"
    end

    espButton.MouseButton1Click:Connect(function()
        espActive = not espActive
        espButton.Text = espActive and lang[language].espOn or lang[language].espOff
        espButton.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
        if not espActive then
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if espActive then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local parts = plr.Character:GetChildren()
                    local role = getPlayerRole(plr)
                    local color = (role == "Murderer" and Color3.fromRGB(255, 0, 0)) or (role == "Sheriff" and Color3.fromRGB(0, 0, 255)) or Color3.fromRGB(0, 255, 0)
                    for _, part in pairs(parts) do
                        if part:IsA("BasePart") then
                            if not espBoxes[part] then
                                espBoxes[part] = createESP(part, color)
                            else
                                espBoxes[part].Color3 = color
                            end
                        end
                    end
                end
            end
        end
    end)

    local function showWarning(text)
        warningLabel.Text = text
        warningLabel.Visible = true
        wait(2)
        warningLabel.Visible = false
    end

    local function isMurderer()
        local backpack = player:FindFirstChild("Backpack")
        local char = player.Character
        return (backpack and backpack:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife"))
    end

    local function isSheriff()
        local backpack = player:FindFirstChild("Backpack")
        local char = player.Character
        return (backpack and backpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun"))
    end

    gunTpButton.MouseButton1Click:Connect(function()
        gunTpActive = not gunTpActive
        gunTpButton.Text = gunTpActive and lang[language].gunTpOn or lang[language].gunTpOff
        gunTpButton.BackgroundColor3 = gunTpActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
        if gunTpActive and not gunTpTool then
            gunTpTool = createGunTpTool()
        elseif not gunTpActive and gunTpTool then
            gunTpTool:Destroy()
            gunTpTool = nil
        end
    end)

    speedButton.MouseButton1Click:Connect(function()
        speedActive = not speedActive
        speedButton.Text = speedActive and lang[language].speedOn or lang[language].speedOff
        speedButton.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
        if speedActive then
            humanoid.WalkSpeed = tonumber(speedValueLabel.Text) or defaultWalkSpeed
        else
            humanoid.WalkSpeed = defaultWalkSpeed
        end
    end)

    sprintButton.MouseButton1Click:Connect(function()
        sprintActive = not sprintActive
        sprintButton.Text = sprintActive and lang[language].sprintOn or lang[language].sprintOff
        sprintButton.BackgroundColor3 = sprintActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
        if not sprintActive and not shiftPressed then
            humanoid.WalkSpeed = speedActive and (tonumber(speedValueLabel.Text) or defaultWalkSpeed) or defaultWalkSpeed
        end
    end)

    jumpButton.MouseButton1Click:Connect(function()
        jumpActive = not jumpActive
        jumpButton.Text = jumpActive and lang[language].jumpOn or lang[language].jumpOff
        jumpButton.BackgroundColor3 = jumpActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
        if jumpActive then
            humanoid.JumpPower = tonumber(jumpValueLabel.Text) or defaultJumpPower
        else
            humanoid.JumpPower = defaultJumpPower
        end
    end)

    infiniteJumpButton.MouseButton1Click:Connect(function()
        infiniteJumpActive = not infiniteJumpActive
        infiniteJumpButton.Text = infiniteJumpActive and lang[language].infiniteJumpOn or lang[language].infiniteJumpOff
        infiniteJumpButton.BackgroundColor3 = infiniteJumpActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
    end)

    clickTpButton.MouseButton1Click:Connect(function()
        clickTpActive = not clickTpActive
        clickTpButton.Text = clickTpActive and lang[language].clickTpOn or lang[language].clickTpOff
        clickTpButton.BackgroundColor3 = clickTpActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 100)
    end)

    killAllButton.MouseButton1Click:Connect(function()
        if not isMurderer() then
            showWarning(lang[language].warningMurderer)
            return
        end

        local alivePlayers = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                table.insert(alivePlayers, plr)
            end
        end

        for _, target in pairs(alivePlayers) do
            local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = target.Character and target.Character:FindFirstChild("Humanoid")
            if targetRoot and targetHumanoid then
                while targetHumanoid.Health > 0 do
                    rootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 2, -2)
                    wait(0.1)
                end
            end
        end
        showWarning(lang[language].warningDone)
    end)

    killSheriffButton.MouseButton1Click:Connect(function()
        if not isMurderer() then
            showWarning(lang[language].warningMurderer)
            return
        end

        local sheriff = nil
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and getPlayerRole(plr) == "Sheriff" and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                sheriff = plr
                break
            end
        end

        if sheriff then
            local sheriffRoot = sheriff.Character:FindFirstChild("HumanoidRootPart")
            local sheriffHumanoid = sheriff.Character:FindFirstChild("Humanoid")
            if sheriffRoot and sheriffHumanoid then
                local knife = player.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")
                if knife then
                    knife.Parent = character
                    rootPart.CFrame = sheriffRoot.CFrame + Vector3.new(0, 2, -2)
                    wait(0.1)
                    knife:Activate()
                    wait(0.5)
                    if sheriffHumanoid.Health <= 0 then
                        showWarning(lang[language].warningDone)
                    end
                end
            end
        end
    end)

    killMurdererButton.MouseButton1Click:Connect(function()
        if not isSheriff() then
            showWarning(lang[language].warningSheriff)
            return
        end

        local murderer = nil
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and getPlayerRole(plr) == "Murderer" and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                murderer = plr
                break
            end
        end

        if murderer then
            local murdererRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
            local murdererHumanoid = murderer.Character:FindFirstChild("Humanoid")
            if murdererRoot and murdererHumanoid then
                local gun = player.Backpack:FindFirstChild("Gun") or character:FindFirstChild("Gun")
                if gun then
                    gun.Parent = character
                    rootPart.CFrame = murdererRoot.CFrame + Vector3.new(5, 2, 5)
                    wait(0.1)
                    gun:Activate()
                    wait(0.5)
                    if murdererHumanoid.Health <= 0 then
                        showWarning(lang[language].warningDone)
                    end
                end
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if gunTpActive then
                local tool = character:FindFirstChild("GunTPTool")
                if tool then
                    local gunDrop = game.Workspace:FindFirstChild("GunDrop")
                    if not gunDrop then
                        showWarning(lang[language].warningGun)
                        return
                    end
                    local oldPosition = rootPart.CFrame
                    rootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 5, 0)
                    wait(0.1)
                    rootPart.CFrame = oldPosition
                end
            end

            if clickTpActive and ctrlPressed then
                local target = mouse.Hit
                if target then
                    rootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 5, 0))
                end
            end
        end
    end)

    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = newCharacter:WaitForChild("Humanoid")
        rootPart = newCharacter:WaitForChild("HumanoidRootPart")
        if espActive then
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}
        end
        if gunTpActive and not character:FindFirstChild("GunTPTool") and not player.Backpack:FindFirstChild("GunTPTool") then
            gunTpTool = createGunTpTool()
        end
        if not speedActive then
            humanoid.WalkSpeed = defaultWalkSpeed
        else
            humanoid.WalkSpeed = tonumber(speedValueLabel.Text) or defaultWalkSpeed
        end
        if not jumpActive then
            humanoid.JumpPower = defaultJumpPower
        else
            humanoid.JumpPower = tonumber(jumpValueLabel.Text) or defaultJumpPower
        end
    end)

    updateLanguage()
end