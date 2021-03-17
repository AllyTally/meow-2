-- A basic overworld script skeleton you can copy and modify for your own creations.

--music = "field_of_hopes" -- The music you want to load!

map = "ruins3"

function OverworldStarting()
    -- Do something here! This is called after the Overworld module is initialized.
    Audio.Stop()
end

function Update()
    --  The Update() function, which gets called every frame.

    Overworld.Update()
end

player = "frisk" -- The player.

Overworld    = require("Libraries/Overworld"    )  -- The overworld library