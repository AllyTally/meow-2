return (function()
    local self
    self = { }

    self.current_coroutine = nil
    
    self.delay_timer = 0
    
    self.delay_from_textbox = false

    -- Main update function of the module
    function self.Update()
        if self.current_coroutine then
            if coroutine.status(self.current_coroutine) == "dead" then
                Overworld.cutscene_active = false
                Overworld.lock_player_input = false
                Overworld.can_open_menu = true
                self.current_coroutine = nil
                return
            end
            
            if coroutine.status(self.current_coroutine) == "suspended" then
                if self.delay_timer > 0 then
                    self.delay_timer = self.delay_timer - 1
                    if self.delay_timer == 0 then
                        coroutine.resume(self.current_coroutine)
                    end
                elseif self.delay_from_textbox then
                    if not OverworldTextbox.textActive then
                        self.delay_from_textbox = false
                        coroutine.resume(self.current_coroutine)
                    end
                end
            end
        end
    end
    
    function self.UnlockPlayerMovement()
        Overworld.lock_player_input = false
    end

    function self.LockPlayerMovement()
        Overworld.cutscene_active = true
        Overworld.lock_player_input = true
        Overworld.can_open_menu = false
    end

    function self.Delay(frames)
        self.delay_timer = frames
        coroutine.yield()
    end

    function self.Lock()
        if self.current_coroutine then
            coroutine.yield()
        end
    end

    function self.Unlock()
        if self.current_coroutine then
            coroutine.resume(self.current_coroutine)
        end
    end


    function self.Start(cutscene,silence_warning)
        if self.current_coroutine and coroutine.status(self.current_coroutine) ~= "dead" then
            if not silence_warning then
                DEBUG("WARNING: A cutscene is already active!")
            end
            self.current_coroutine = nil
        end

        local modpath = Overworld.GetModName()
        local func = nil

        if type(cutscene) == "string" then

            local scenes_folder = "/Maps/" .. Overworld.mapdata.internalname .. "/Scenes/"
            local folder = nil

            if Misc.DirExists(scenes_folder) then
                folder = scenes_folder
            elseif Misc.DirExists("/Scenes/") then
                -- It wasn't found in the maps scenes folder...
                folder = "/Scenes/"
            else
                error("Attempted to load scene \"" .. cutscene .. "\", but it wasn't found in either folder.")
            end

            func = dofile(modpath.modPath .. folder .. cutscene .. ".lua")
        elseif type(cutscene) == "function" then
            func = cutscene
        end

        Overworld.cutscene_active = true
        Overworld.lock_player_input = true
        Overworld.can_open_menu = false
        self.current_coroutine = coroutine.create(func)
        coroutine.resume(self.current_coroutine)
    end

    function self.SpawnTextbox(text,portrait,options)
        self.delay_from_textbox = true
        local top = true
        if options and options["top"] ~= nil then
            top = options["top"]
        else
            top = Overworld.player.y - Misc.cameraY < 230
        end
        OverworldTextbox.SetText(text,top,portrait,options)
        coroutine.yield()
    end

    return self 
end)()