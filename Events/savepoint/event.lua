function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 20,
        y = 20
    }

    self.hitbox_offset = {
        x = 0,
        y = 0
    }

    self.sprite_offset = {
        x = 0,
        y = 0
    }

    self.sprite_path = "0"

    self.solid = true

    self.in_save_menu = false
    
    self.saved = false

    function self.AfterLoad()
        self.sprite.Set(self.sprites_folder .. "0")
        self.sprite.Set(self.sprites_folder .. "1")
        self.sprite.SetAnimation({"0", "1"}, 0.2, self.sprites_folder)
    end

    function self.CalcTime()
        local minutes = math.floor(Overworld.last_save.playtime / 60)
        local seconds = math.floor(Overworld.last_save.playtime % 60)
        if seconds < 10 then
            seconds = "0" .. seconds
        end
        return minutes .. ":" .. seconds
    end

    function self.OpenSaveMenu()
        self.in_save_menu = true
        self.saved = false
        self.background_border = CreateSprite("px","Textbox")
        self.background_border.Scale(424,174)
        self.background_border.MoveTo(320,275)
        self.background = CreateSprite("px","Textbox")
        self.background.Scale(412,162)
        self.background.MoveTo(320,275)
        self.background.color = {0,0,0}

        self.text_name = CreateText("[instant][font:uidialogmedspacesave]" .. Overworld.last_save.playername, {141,314}, 999, "Textbox")
        self.text_name.progressmode = "none"
        self.text_name.HideBubble()

        self.text_lv = CreateText("[instant][font:uidialogmedspacesave]LV " .. Overworld.last_save.lv, {141 + 160,314}, 999, "Textbox")
        self.text_lv.progressmode = "none"
        self.text_lv.HideBubble()

        playtime = self.CalcTime()

        self.text_time = CreateText("[instant][font:uidialogmedspacesave]" .. playtime, {141 + 312,314}, 999, "Textbox")
        self.text_time.progressmode = "none"
        self.text_time.HideBubble()

        self.text_location = CreateText("[instant][font:uidialogmedspacesave]" .. Overworld.last_save.roomname, {141,314 - 40}, 999, "Textbox")
        self.text_location.progressmode = "none"
        self.text_location.HideBubble()

        self.text_save = CreateText("[instant][font:uidialogmedspacesave]Save", {141 + 30,214}, 999, "Textbox")
        self.text_save.progressmode = "none"
        self.text_save.HideBubble()

        self.text_return = CreateText("[instant][font:uidialogmedspacesave]Return", {141 + 30 + 180,214}, 999, "Textbox")
        self.text_return.progressmode = "none"
        self.text_return.HideBubble()

        self.choicer_soul = CreateSprite("spr_heartsmall", "Textbox")
        self.choicer_soul.Scale(2,2)
        self.choicer_soul.color = { 1, 0, 0 }
        self.choicer_soul.MoveTo(142 + 9,216 + 9)

        self.choice = 0
    end

    function self.Update()
        if self.in_save_menu then
            if self.saved then
                if Input.Confirm == 1 then
                    self.in_save_menu = false
                    self.background_border.Remove()
                    self.background.Remove()
                    self.text_name.Remove()
                    self.text_lv.Remove()
                    self.text_time.Remove()
                    self.text_location.Remove()
                    self.text_save.Remove()
                    SceneManager.Unlock()
                end
            else
                if Input.Left == 1 or Input.Right == 1 then
                    self.choice = 1 - self.choice
                    Audio.PlaySound("menumove")
                    self.choicer_soul.MoveTo(142 + 9 + (180 * self.choice),216 + 9)
                elseif Input.Confirm == 1 then
                    if self.choice == 0 then
                        Overworld.SaveGame()
                        Audio.PlaySound("saved")
                        self.saved = true
                        self.text_name.color = {1,1,0}
                        self.text_lv.color = {1,1,0}
                        self.text_time.color = {1,1,0}
                        self.text_location.color = {1,1,0}
                        self.text_save.color = {1,1,0}

                        self.text_name    .SetText("[instant][font:uidialogmedspacesave]" .. Overworld.last_save.playername)
                        self.text_lv      .SetText("[instant][font:uidialogmedspacesave]LV " .. Overworld.last_save.lv)
                        self.text_location.SetText("[instant][font:uidialogmedspacesave]" .. Overworld.last_save.roomname)

                        local playtime = self.CalcTime()
                        self.text_time.SetText("[instant][font:uidialogmedspacesave]" .. playtime, {141 + 312,314}, 999, "Textbox")

                        self.text_save.SetText("[instant][font:uidialogmedspacesave]File saved.")

                        self.text_return.Remove()
                        self.choicer_soul.Remove()
                    else
                        self.in_save_menu = false
                        self.background_border.Remove()
                        self.background.Remove()
                        self.text_name.Remove()
                        self.text_lv.Remove()
                        self.text_time.Remove()
                        self.text_location.Remove()
                        self.text_save.Remove()
                        self.text_return.Remove()
                        self.choicer_soul.Remove()
                        SceneManager.Unlock()
                    end
                end
            end
        end
    end
    function self.OnInteract()
        Audio.PlaySound("healsound")
        Player.hp = Player.maxhp

        local text_list = {}

        if self.properties["pages"] and self.properties["pages"] > 1 then
            for page = 1, self.properties["pages"] do
                local text = self.properties["text" .. page]
                text = text:gsub("\\r","\r")
                text = text:gsub("\\n","\n")
                table.insert(text_list, text)
            end
        elseif self.properties["text"] then
            local text = self.properties["text"]
            text = text:gsub("\\r","\r")
            text = text:gsub("\\n","\n")
            table.insert(text_list, text)
        end

        SceneManager.Start(function ()
            SceneManager.SpawnTextbox(text_list, nil)
            self.OpenSaveMenu()
            SceneManager.Lock()
        end)
    end

    return self -- Don't remove this line
end

return main() -- Don't remove this line

