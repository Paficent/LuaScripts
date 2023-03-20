local GUI = {}

local function FillTextBox(TextBox, Text)
    assert(TextBox:IsA("TextBox"))
    assert(TextBox.Text)

    TextBox.Text = tostring(Text)
end

local function TypeTextBox(TextBox, Text, Delay, RemoveOldText)
    assert(TextBox:IsA("TextBox"))
    assert(TextBox.Text)
    assert(type(Delay) == "number" or "nil")
    assert(type(RemoveOldText) == "boolean" or "nil")

    Delay = Delay or 0.05

    if RemoveOldText == true or RemoveOldText == nil then
        TextBox.Text = ""
    end

    for i = 1, #Text do
        task.wait(Delay)
        TextBox.Text = TextBox.Text .. string.sub(Text, i, i)
    end
end

local function LeftClickButton(Button)
    assert(Button:IsA("TextButton") or Button:IsA("ImageButton"))

    local _Activated = getconnections(Button.Activated)
    local _MB1Down = getconnections(Button.MouseButton1Down)
    local _MB1Up = getconnections(Button.MouseButton1Up)
    local _MB1Click = getconnections(Button.MouseButton1Click)


    if #_Activated >= 1 then
        local err, msg = pcall(function()
            _Activated[1]:Fire()
        end)
        assert(err, msg)
    elseif #_MB1Down >= 1 then
        local err, msg = pcall(function()
            _MB1Down[1]:Fire()
        end)
        assert(err, msg)
    elseif #_MB1Up >= 1 then
        local err, msg = pcall(function()
            _MB1Up[1]:Fire()
        end)
        assert(err, msg)
    elseif #_MB1Click >=1 then
        local err, msg = pcall(function()
            _MB1Click[1]:Fire()
        end)
        assert(err, msg)
    end
end

local function RightClickButton(Button)
    assert(Button:IsA("TextButton") or Button:IsA("ImageButton"))

    local _Activated = getconnections(Button.Activated)
    local _MB2Down = getconnections(Button.MouseButton2Down)
    local _MB2Up = getconnections(Button.MouseButton2Up)
    local _MB2Click = getconnections(Button.MouseButton2Click)


    if #_Activated >= 1 then
        local err, msg = pcall(function()
            _Activated[1]:Fire()
        end)
        assert(err, msg)
    elseif #_MB2Down >= 1 then
        local err, msg = pcall(function()
            _MB2Down[1]:Fire()
        end)
        assert(err, msg)
    elseif #_MB2Up >= 1 then
        local err, msg = pcall(function()
            _MB2Up[1]:Fire()
        end)
        assert(err, msg)
    elseif #_MB2Click >=1 then
        local err, msg = pcall(function()
            _MB2Click[1]:Fire()
        end)
        assert(err, msg)
    end
end


GUI.FillTextBox = FillTextBox
GUI.TypeTextBox = TypeTextBox
GUI.LeftClickButton = LeftClickButton
GUI.RightClickButton = RightClickButton

return GUI
