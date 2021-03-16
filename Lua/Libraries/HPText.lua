-- All of this is copied from CYK

return (function()
    local self
    self = { }

    self.HPChangeTexts = { }

    function self.Update()
        for i = #HPChangeTexts, 1, -1 do
            local HPChangeText = HPChangeTexts[i]
            local frame = HPChangeText.frame
            -- Scale the sprites at the beginning of the animation
            if frame <= 8 then
                local xScale = 3 - frame * 0.25
                local yScale = 1 / xScale
                for j = 1, #HPChangeText do
                    HPChangeText[j].x = 20 * (#HPChangeText - j) * xScale
                    HPChangeText[j].Scale(xScale, yScale)
                end
            end

            -- X movement at the beginning of the animation
            if frame < 28 then
                HPChangeText.parent.x = HPChangeText.parent.x + (frame < 12 and 4 or frame < 16 and 2 or frame < 28 and 1)
            end
            -- Y movement at the beginning of the animation
            if frame < 32 then
                HPChangeText.parent.y = HPChangeText.parent.y + (frame < 12 and 1 or frame < 28 and -1 or frame < 32 and -3)

            -- Bounce time
            elseif frame <= 120 and (HPChangeText.yBounce ~= -16 or HPChangeText.yAccel ~= 0) then
                HPChangeText.yBounce = HPChangeText.yBounce + HPChangeText.yAccel
                HPChangeText.yAccel = HPChangeText.yAccel - 0.25
                -- Can't go under 16 pixels below the animation's original position
                if HPChangeText.yBounce < -16 then
                    HPChangeText.yBounce = -16
                    HPChangeText.yAccel = -HPChangeText.yAccel * 1/2
                    -- If the speed is lower than 1, stop the bounce
                    if HPChangeText.yAccel < 1 then
                        HPChangeText.yAccel = 0
                    end
                end
                HPChangeText.parent.absy = HPChangeText.y + HPChangeText.yBounce
            end

            -- Moves the numbers up and fades them
            if frame > 120 then
                HPChangeText.parent.y = HPChangeText.parent.y + 2
                for j = 1, #HPChangeText do
                    HPChangeText[j].yscale = HPChangeText[j].yscale + 1 / 30
                    HPChangeText[j].alpha = 1 - (frame - 120) / 30
                end
            end

            -- The animation has ended, you can remove all the sprites and destroy it
            if frame == 150 then
                for j = 1, #HPChangeText do
                    HPChangeText[j].Remove()
                end
                HPChangeText.parent.Remove()
                table.remove(HPChangeTexts, i)
            end
            HPChangeText.frame = HPChangeText.frame + 1
        end
    end

    function self.CreateHPChangeText(value, entity, color)
        -- Setup the data of the HP text
        local container = { }
        container.x = Player.absx + 30
        container.y = Player.absy
        container.entity = entity
        container.yBounce = -12
        container.yAccel = 2

        -- Parent sprite of the HP text
        local parent = CreateSprite("empty", "AboveBulletDark")
        parent.SetPivot(0, 0)
        parent.absx = container.x
        parent.absy = container.y
        container.parent = parent

        -- Add the numbers of the HP text in its data
        if value < 0 then
            value = -value
        end
        while value > 0 do
            local val = value % 10
            table.insert(container, val)
            value = math.floor(value / 10)
        end

        -- Create each number of the HP text
        for i = 1, #container do
            local HPNumber = CreateSprite("HPChange/" .. tostring(container[i]))
            HPNumber.SetParent(parent)
            HPNumber.SetPivot(1, 0)
            HPNumber.absx = container.x + 20 * (i - 1)
            HPNumber.absy = container.y
            HPNumber.color = color
            container[i] = HPNumber
        end
        container.frame = 0

        -- Insert the HP text's data in the table of active HP texts
        table.insert(HPChangeTexts, container)
    end

    return self 
end)()