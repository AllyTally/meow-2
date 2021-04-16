return (function()
    local self
    self = { }

    SceneManager.UnlockPlayerMovement()

    local toriel_event = Overworld.FindFirstEvent("npc_toriel")

    if toriel_event then
        NPCHelper.WalkToY(toriel_event,320,4)
        toriel_event.Destroy()
    end

    return self 
end)