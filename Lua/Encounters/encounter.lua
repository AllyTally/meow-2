-- A basic overworld script skeleton you can copy and modify for your own creations.

--music = "field_of_hopes" -- The music you want to load!

map = "ruins2"

function OverworldStarting()
    -- Do something here! This is called after the Overworld module is initialized.
    Audio.Stop()
end

function Update()
    --  The Update() function, which gets called every frame.
    if Input.GetKey("G") == 1 then
        Overworld.SpawnSimpleTextbox({
            "[font:sansOW][voice:v_sans]yknow,[w:4] sans,[w:4] too,[w:4] is an acronym.",
            "[font:sansOW][voice:v_sans]it stands for.[w:4].[w:4].",
            "[font:sansOW][voice:v_sans]super awesome non-unfunny sans.",
            "[font:sansOW][voice:v_sans]what?[w:8] isn't it cool?",
            "[font:sansOW][voice:v_sans]that sans guy must be a real riot."
        },{
            {"spr_face_sans"},
            {"spr_face_sansblink"},
            {"spr_face_sanswink"},
            {"spr_face_sans"},
            {"spr_face_sanschuckle2"},
        })
    end
    Overworld.Update()
end

player = "frisk" -- The player.

Overworld    = require("Libraries/Overworld")  -- The overworld library