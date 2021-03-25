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
    
    function self.Delay(frames)
        self.delay_timer = frames
        coroutine.yield()
    end
    
    
    function self.Start(cutscene)
        local modpath = Overworld.GetModName()
        local func = nil
        if type(cutscene) == "string" then
            func = dofile(modpath.modPath .. "/Scenes/" .. cutscene .. ".lua")
        elseif type(cutscene) == "function" then
            func = cutscene
        end

        Overworld.cutscene_active = true
        self.current_coroutine = coroutine.create(func)
        coroutine.resume(self.current_coroutine)
    end

    function self.SpawnTextbox(text,portrait,options)
        self.delay_from_textbox = true
        OverworldTextbox.SetText(text,Overworld.player.y - Misc.cameraY < 230, portrait,options)
        coroutine.yield()
    end



    return self 
end)()