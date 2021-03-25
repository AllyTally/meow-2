local self = {}

-- made by eir who is hella cute also    love eir    <3
--   eir cute
--       meow


--==============--
-- UI VARIABLES --
--==============--

self.font = "uidialoglilspace"
self.voice = "monsterfont"
self.effect = "[speed:1.5][effect:none][linespacing:6]"

self.text_x_offset = 0
self.max_character_width = 500
self.top = false


-- create sprites
self.menutextbox1 = CreateSprite("px", "Textbox")
self.menutextbox1.SetPivot(0, 0)
self.menutextbox1.Scale(578, 152)

self.menutextbox2 = CreateSprite("px", "Textbox")
self.menutextbox2.SetPivot(0, 0)
self.menutextbox2.Scale(578 - 12, 152 - 12)
self.menutextbox2.color = {0, 0, 0}
self.menutextbox2.SetParent(self.menutextbox1)
self.menutextbox2.SetAnchor(0, 0)
self.menutextbox2.MoveTo(6, 6)

self.menufacesprite = CreateSprite("spr_face_sans", "Textbox")
self.menufacesprite.SetAnchor(0,1)
self.menufacesprite.SetPivot(0,1)
self.menufacesprite.Scale(2,2)
--self.menufacesprite.MoveTo(66,480 - 40)
self.menufacesprite.MoveTo(67,480 - 350)
self.menufacesprite.alpha = 0


-- text object stuff
self.textParent = CreateSprite("empty", "Top")
self.textParent.SetParent(self.menutextbox2)
self.textParent.SetAnchor(0, 1)
self.textParent.y = self.textParent.y - 122

-- Calculate the width of one instance of "* "
local asteriskAndSpaceWidth

do
    -- Step 1: Get width of asterisk character
    local a = CreateText("[instant][font:" .. self.font .. "]" .. self.effect .. "[novoice]*", {0, 0}, 640)
    local asteriskWidth = a.GetTextWidth()

    -- Step 2: Get width of space character
    a.SetText("[instant][font:" .. self.font .. "]" .. self.effect .. "[novoice][charspacing:0]* *")
    local spaceWidth = a.GetTextWidth() - (asteriskWidth * 2)

    -- Step 3: Get character spacing of the font
    a.SetText("[font:" .. self.font .. "]" .. self.effect .. "[novoice]**")
    local charspacing = a.GetTextWidth()- (asteriskWidth * 2)
    a.DestroyText()

    asteriskAndSpaceWidth = asteriskWidth + charspacing + spaceWidth + charspacing
end

-- create text
self.textStars = CreateText("", {54, 183}, self.max_character_width + asteriskAndSpaceWidth, "Top")
self.textStars.HideBubble()
self.textStars.progressmode = "none"
self.textStars.SetParent(self.textParent)
self.textStars.MoveTo(self.text_x_offset + 16, 0)

self.text = CreateText("", {92, 183}, self.max_character_width, "Top")
self.text.HideBubble()
self.text.progressmode = "none"
self.text.SetParent(self.textParent)
self.text.MoveTo(self.text_x_offset + 40 + 16 - 9, 0)

self.textActive = false
self.textLines = 0

self.current_portrait = nil
self.current_settings = nil
self.current_progress = 1

-- function to show text box
function self.ShowTextBox(top,portrait)
	self.menutextbox1.alpha = 1
	self.menutextbox2.alpha = 1
    if portrait then
        self.menufacesprite.alpha = 1
    else
        self.menufacesprite.alpha = 0
    end
    self.top = top

    offsetX = 0
    offsetY = 0
    scaleX = 2
    scaleY = 2
    if self.current_settings then
        if self.current_settings[self.current_progress] then
            if self.current_settings[self.current_progress].offsetX then offsetX = self.current_settings[self.current_progress].offsetX end
            if self.current_settings[self.current_progress].offsetY then offsetX = self.current_settings[self.current_progress].offsetY end
            if self.current_settings[self.current_progress].scaleX  then scaleX  = self.current_settings[self.current_progress].scaleX  end
            if self.current_settings[self.current_progress].scaleY  then scaleY  = self.current_settings[self.current_progress].scaleY  end
        end
    end
    self.menufacesprite.Scale(scaleX,scaleY)

	-- Top of the screen
	if top then
		self.menutextbox1.MoveTo(Misc.cameraX + 32, Misc.cameraY + 318)
		self.textParent.MoveToAbs(Misc.cameraX + 32 + 6 + 7, Misc.cameraY + 318 + 6 + 100)
        self.menufacesprite.MoveToAbs(Misc.cameraX + 67 + offsetX,Misc.cameraY + 480 - 40 + offsetY)
	-- Bottom of the screen
	else
		self.menutextbox1.MoveTo(Misc.cameraX + 32, Misc.cameraY + 8)
		self.textParent.MoveToAbs(Misc.cameraX + 32 + 6 + 7, Misc.cameraY + 8 + 6 + 100)
        self.menufacesprite.MoveToAbs(Misc.cameraX + 67 + offsetX,Misc.cameraY + 480 - 350 + offsetY)
	end
end

-- function to show text box
function self.HideTextBox()
	self.menutextbox1.alpha = 0
	self.menutextbox2.alpha = 0
    self.menufacesprite.alpha = 0
end
self.HideTextBox()

-- function to set text
function self.SetText(str,top,portrait,options)
	local i = ${}
	if type(str) == "string" then
		i[1] = str
	else
		for j = 1, #str do
			i[j] = str[j]
		end
	end

    self.current_portrait = portrait
    self.current_settings = options

    if portrait then
        self.text_x_offset = 116
        self.max_character_width = 500 - 116
    else
        self.text_x_offset = 0
        self.max_character_width = 500
    end
    
    self.textStars.MoveTo(self.text_x_offset + 16, 0)
    self.text.MoveTo(self.text_x_offset + 40 + 16 - 9, 0)
    self.textStars.textMaxWidth = self.max_character_width + asteriskAndSpaceWidth
    self.text.textMaxWidth = self.max_character_width

    self.current_progress = 1
    if type(self.current_portrait) == "table" then
        if type(self.current_portrait[1]) == "table" then
            self.menufacesprite.SetAnimation(self.current_portrait[1], 8/60)
        elseif type(self.current_portrait[1]) == "string" then
            self.menufacesprite.SetAnimation(self.current_portrait, 8/60)
        end
    end

	self.ShowTextBox(top,portrait)

	-- Format the text from the SetDialog call
	local textStars, textTable = self.FormatText(i)

	table.insert(textStars, "")
	table.insert(textTable, "")

	-- Display the text
	self.textStars.SetText(textStars)
	self.text.SetText(textTable)

	self.textActive = true
	self.textLines = #i
end

-- update function
function self.Update()
	if self.textActive then
        if self.text.lineComplete then
            self.menufacesprite.StopAnimation()
            if type(self.current_portrait) == "table" then
                if type(self.current_portrait[self.current_progress]) == "table" then
                    self.menufacesprite.Set(self.current_portrait[self.current_progress][1])
                elseif type(self.current_portrait[self.current_progress]) == "string" then
                    self.menufacesprite.Set(self.current_portrait[1])
                end
            end
        end
		if self.text.lineComplete and Input.Confirm == 1 then
			self.NextLine()
		elseif self.text.currentLine == self.textLines then -- (Offset by 1 because of the extra line added to both text objects, see above)
			self.HideTextBox()
			self.textActive = false
		end
	end
end



-- function to go to the next line of text
function self.NextLine()
    self.current_progress = self.current_progress + 1
    offsetX = 0
    offsetY = 0
    scaleX = 2
    scaleY = 2
    if self.current_settings then
        if self.current_settings[self.current_progress] then
            if self.current_settings[self.current_progress].offsetX then offsetX = self.current_settings[self.current_progress].offsetX end
            if self.current_settings[self.current_progress].offsetY then offsetX = self.current_settings[self.current_progress].offsetY end
            if self.current_settings[self.current_progress].scaleX  then scaleX  = self.current_settings[self.current_progress].scaleX  end
            if self.current_settings[self.current_progress].scaleY  then scaleY  = self.current_settings[self.current_progress].scaleY  end
        end
    end
    self.menufacesprite.Scale(scaleX,scaleY)

	if self.top then
        self.menufacesprite.MoveToAbs(Misc.cameraX + 67 + offsetX,Misc.cameraY + 480 - 40 + offsetY)
	else
        self.menufacesprite.MoveToAbs(Misc.cameraX + 67 + offsetX,Misc.cameraY + 480 - 350 + offsetY)
	end
    if type(self.current_portrait) == "table" then
        self.text_x_offset = 116
        self.max_character_width = 500 - 116
        self.menufacesprite.alpha = 1
        if type(self.current_portrait[self.current_progress]) == "table" then
            self.menufacesprite.SetAnimation(self.current_portrait[self.current_progress], 8/60)
        elseif type(self.current_portrait[self.current_progress]) == "string" then
            self.menufacesprite.SetAnimation(self.current_portrait, 8/60)
        else
            self.menufacesprite.alpha = 0
            self.text_x_offset = 0
            self.max_character_width = 500
        end
    else
        self.menufacesprite.alpha = 0
    end
    self.textStars.x = self.text_x_offset + 16
    self.text.x = self.text_x_offset + 40 + 16 - 9
    self.textStars.textMaxWidth = self.max_character_width + asteriskAndSpaceWidth
    self.text.textMaxWidth = self.max_character_width

	self.text.NextLine()
	self.textStars.NextLine()
end



-- text formatter for overworld text
function self.FormatText(tab)
    if type(tab) == "string" then
        tab = {tab}
    end

    local textStarsTable = {}
    local textTable = {}

    for _, str in pairs(tab) do
        -- silence [func] commands and format
        local textToDisplay = "♪♪" .. str--[[:gsub("%[func:.-%]", "")]]:gsub("\r", "\n")
        table.insert(textTable, "[noskip][font:" .. self.font .. "][voice:" .. self.voice .. "]" .. self.effect .. "[color:ffffff][noskip:off]" .. textToDisplay:gsub("\n", "\n♪♪"))

        -- format for * only
        textToDisplay = ""
		local startingColor = "ffffff"
		local startingVoice = self.voice
		local startingFont  = self.font
        local skip = 0
        local asteriskVoiceString = "[voice:" .. self.voice .. "]"

        for i = 1, #str do
            if skip > 0 then
                skip = skip - 1
            else
                local char = str:sub(i, i)
                if char == "[" then
                    local command = str:sub(i, str:find("%]", i))
                    skip = #command - 1

                    if string.startsWith(command, "[co") and #textToDisplay == 0 then
                        startingColor = command:sub(8,-2)
                    elseif string.startsWith(command, "[font:") then
                        if #textToDisplay == 0 then
                            startingFont = command:sub(7, -2)
                        end
                    elseif string.startsWith(command, "[voice:") then
                        asteriskVoiceString = "[voice:" .. command:sub(8, -2) .. "]"
                        if #textToDisplay == 0 then
                            startingVoice = command:sub(8, -2)
                        end
                    elseif command == "[novoice]" then
                        asteriskVoiceString = "[novoice]"
                    end

                    textToDisplay = textToDisplay .. ((string.startsWith(command, "[w") or string.startsWith(command, "[i") or string.startsWith(command, "[ne") or string.startsWith(command, "[co")) and command or "")
                elseif char == "\n" then
                    textToDisplay = textToDisplay .. "\n[alpha:ff]" .. asteriskVoiceString .. "* [novoice][alpha:00]"
                elseif char == "\r" then
                    textToDisplay = textToDisplay .. "\n"
                else
                    textToDisplay = textToDisplay .. char
                end
            end
        end

        textToDisplay = "[color:" .. startingColor .. "][voice:" .. startingVoice .. "]* [novoice][alpha:00]" .. textToDisplay
        table.insert(textStarsTable, "[noskip][font:" .. startingFont .. "][novoice]" .. self.effect .. "[color:ffffff][noskip:off]" .. textToDisplay)
    end

    return textStarsTable, textTable
end



return self
