return (function()
    local self
    self = { }
    
    self.currently_talking = nil
    self.animation_after = nil
    
    self.walking_events = {}

    function self.Animate(event)
        if not event.animationtimer then
            event.animationtimer = 0
            event.animationindex = 1
        end

        if event.animationtimer > event.animations[event.animation][2] then
            event.animationtimer = 0
            event.animationindex = (event.animationindex % #event.animations[event.animation][1] + 1)
        end

        if (event.animationindex > #event.animations[event.animation][1]) then
            event.animationindex = 1
            event.animationtimer = 0
        end
        

        event.sprite.Set(event.sprites_folder .. event.animations[event.animation][4] .. "/" .. event.animations[event.animation][1][event.animationindex])
        event.animationtimer = event.animationtimer + 1
    end

    function self.CalculateDir(x,y,x2,y2)
        local diff = { x - x2, y - y2 }
        local angle = (math.atan2(diff[1], diff[2]) + (math.pi*2)) % (math.pi*2)
        local dir = 2
        if     angle > math.pi/4   and angle <= 3*math.pi/4 then dir = 4
        elseif angle > 3*math.pi/4 and angle <= 5*math.pi/4 then dir = 8
        elseif angle > 5*math.pi/4 and angle <= 7*math.pi/4 then dir = 6
        end
        return dir
    end

    function self.FacePlayer(event)
        if Overworld.player.y > event.y + (event.depth_offset * Overworld.mapdata.scale.y) and Overworld.player.x + Overworld.player.hitbox_size.x > event.x + event.hitbox_offset.x and Overworld.player.x < event.x + (event.hitbox_size.x + event.hitbox_offset.x) * Overworld.mapdata.scale.x then
            event.animation = "IdleUp"
        elseif Overworld.player.y < event.y + (event.depth_offset * Overworld.mapdata.scale.y) and Overworld.player.x + Overworld.player.hitbox_size.x > event.x + event.hitbox_offset.x and Overworld.player.x < event.x + (event.hitbox_size.x + event.hitbox_offset.x) * Overworld.mapdata.scale.x then
            event.animation = "IdleDown"
        elseif Overworld.player.x > event.x then
            event.animation = "IdleRight"
        elseif Overworld.player.x < event.x then
            event.animation = "IdleLeft"
        end
    end
    
    function self.WalkTo(event,x,y,speed,animation)
        if not speed then
            speed = 3
        end
        if not animation then
            -- Figure out the animation automagically?
        end
        event.animation = animation
        event.walking_speed = speed
        event.target_x = x
        event.target_y = y
        event.walking = true
        table.insert(self.walking_events,event)
        SceneManager.Lock() -- Lock the scene if there's a cutscene active
    end
    
    function self.WalkToX(event,x,speed)
        if not speed then
            speed = 3
        end
        event.walking_speed = speed
        event.target_x = x
        event.walking_x = true
        event.walking_x_left = ((event.target_x - event.x) < 0)
        if (event.walking_x_left) then
            event.animation = "WalkLeft"
        else
            event.animation = "WalkRight"
        end

        table.insert(self.walking_events,event)
        SceneManager.Lock()
    end

    function self.WalkToY(event,y,speed)
        if not speed then
            speed = 3
        end
        event.walking_speed = speed
        event.target_y = y
        event.walking_y = true
        event.walking_y_down = ((event.target_y - event.y) < 0)
        if (event.walking_y_down) then
            event.animation = "WalkDown"
        else
            event.animation = "WalkUp"
        end

        table.insert(self.walking_events,event)
        SceneManager.Lock()
    end
    
    function self.Update()
        for event_id = #self.walking_events, 1, -1 do
            event = self.walking_events[event_id]
            if event.walking_x then
                if event.walking_x_left then
                    event.x = event.x - event.walking_speed
                    if event.x <= event.target_x then
                        event.x = event.target_x
                        event.walking_x = false
                        event.animation = "IdleLeft"
                        table.remove(self.walking_events,event_id)
                        SceneManager.Unlock()
                    end
                else
                    event.x = event.x + event.walking_speed
                    if event.x >= event.target_x then
                        event.x = event.target_x
                        event.walking_x = false
                        event.animation = "IdleRight"
                        table.remove(self.walking_events,event_id)
                        SceneManager.Unlock()
                    end
                end
            elseif event.walking_y then
                if event.walking_y_down then
                    event.y = event.y - event.walking_speed
                    if event.y <= event.target_y then
                        event.y = event.target_y
                        event.walking_y = false
                        event.animation = "IdleDown"
                        table.remove(self.walking_events,event_id)
                        SceneManager.Unlock()
                    end
                else
                    event.y = event.y + event.walking_speed
                    if event.y >= event.target_y then
                        event.y = event.target_y
                        event.walking_y = false
                        event.animation = "IdleUp"
                        table.remove(self.walking_events,event_id)
                        SceneManager.Unlock()
                    end
                end
            end
        end
    end


    function self.StartTalking(name,anim,anim_after)
        self.currently_talking = Overworld.FindFirstEvent(name)
        if not self.currently_talking then
            DEBUG("WARNING: Event " .. name .. " not found!")
            return
        end
        self.animation_after = anim_after

        if anim then
            self.currently_talking.animation = anim
        else
            if self.currently_talking.animation == "IdleDown" then
                self.currently_talking.animation = "TalkDown"
            elseif self.currently_talking.animation == "IdleLeft" then
                self.currently_talking.animation = "TalkLeft"
            elseif self.currently_talking.animation == "IdleRight" then
                self.currently_talking.animation = "TalkRight"
            elseif self.currently_talking.animation == "IdleUp" then
                self.currently_talking.animation = "TalkUp"
            end
        end
    end

    function self.StopTalking()
        if self.currently_talking then
            if self.animation_after then
                self.currently_talking.animation = self.animation_after
            else
                if self.currently_talking.animation == "TalkDown" then
                    self.currently_talking.animation = "IdleDown"
                elseif self.currently_talking.animation == "TalkLeft" then
                    self.currently_talking.animation = "IdleLeft"
                elseif self.currently_talking.animation == "TalkRight" then
                    self.currently_talking.animation = "IdleRight"
                elseif self.currently_talking.animation == "TalkUp" then
                    self.currently_talking.animation = "IdleUp"
                end
            end
        end
    end
    
    function self.AreEventsColliding(event1,event2)
        local event_rect1 = Overworld.GetEventRect(event1)
        local event_rect2 = Overworld.GetEventRect(event2)
        return Overworld.isColliding(event_rect1,event_rect2)
    end

    return self 
end)()