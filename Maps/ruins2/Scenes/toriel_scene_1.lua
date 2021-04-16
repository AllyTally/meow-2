return (function()
    local self
    self = { }
    
    local toriel_event = Overworld.FindFirstEvent("npc_toriel")

    SceneManager.SpawnTextbox({
        "[voice:toriel]Welcome to your new home,[w:4] innocent one.",
        "[voice:toriel]Allow me to educate you in the operation of the RUINS."
    },{
        {"spr_face_torieltalk/0","spr_face_torieltalk/1"},
        {"spr_face_torieltalk/0","spr_face_torieltalk/1"}
    },{
        {animateNPC = "npc_toriel", offsetX = -9},
        {animateNPC = "npc_toriel", offsetX = -9},
    })

    NPCHelper.WalkToX(toriel_event,toriel_event.x + 160)
    NPCHelper.WalkToY(toriel_event,toriel_event.y + 80)
    NPCHelper.WalkToX(toriel_event,toriel_event.x - 80)
    NPCHelper.WalkToY(toriel_event,toriel_event.y + 40)
    NPCHelper.WalkToX(toriel_event,toriel_event.x + 30)
    toriel_event.animation = "IdleUp"
    local lever = Overworld.FindFirstEvent("wallswitch")
    lever.OnInteract()
    SceneManager.Delay(60)
    NPCHelper.WalkToX(toriel_event,toriel_event.x - 140)
    NPCHelper.WalkToY(toriel_event,toriel_event.y - 80)

    SceneManager.SpawnTextbox({
        "[voice:toriel]The RUINS are full of puzzles.",
        "[voice:toriel]Ancient fusions between diversions and doorkeys.",
        "[voice:toriel]One must solve them to move from room to room.",
        "[voice:toriel]Please adjust yourself to the sight of them."
    },{
        {"spr_face_torieltalk/0","spr_face_torieltalk/1"},
        {"spr_face_torieltalk/0","spr_face_torieltalk/1"},
        {"spr_face_torieltalk/0","spr_face_torieltalk/1"},
        {"spr_face_torieltalk/0","spr_face_torieltalk/1"}
    },{
        {animateNPC = "npc_toriel", offsetX = -9},
        {animateNPC = "npc_toriel", offsetX = -9},
        {animateNPC = "npc_toriel", offsetX = -9},
        {animateNPC = "npc_toriel", offsetX = -9}
    })

    return self 
end)