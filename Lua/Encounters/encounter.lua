-- A basic overworld script skeleton you can copy and modify for your own creations.

--music = "field_of_hopes" -- The music you want to load!

music = "mus_ruins"

map = "ruins1"

function OverworldStarting()
    -- Do something here! This is called after the Overworld module is initialized.
end

function Update()
    --  The Update() function, which gets called every frame.
    if Input.GetKey("G") == 1 then
        if not Overworld.inbattle then
            Overworld.EnterBattle("battle")
        else
            State("MERCYMENU")
        end
    end
    Overworld.Update()
end

player = "frisk" -- The player.

Overworld    = require("Libraries/Overworld")  -- The overworld library