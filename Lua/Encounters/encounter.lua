-- A basic overworld script skeleton you can copy and modify for your own creations.

music = "mus_ruins" -- The music your Overworld starts with.

map = "ruins1"

function OverworldStarting()
    -- Do something here! This is called after the Overworld module is initialized.
    Audio.Stop()
end

function BeforeSaveCreation() -- Before the save file is created, let's add a default plot value
    Overworld.save_data["plot"] = 0
end

function BeforeSave() -- The file is about to be saved, let's make sure the plot value is saved too
    Overworld.save_data["plot"] = plot
end

function AfterLoad(created) -- After the save file is loaded, let's write the saved value into our plot variable...
    if not created then     -- ...but only if we loaded an existing save file.
        plot = Overworld.save_data["plot"]
    end
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

Overworld = require("Libraries/Overworld")  -- The overworld library.