return (function()
    local self
    self = { }


    SceneManager.Delay(60)
    
    SceneManager.SpawnTextbox({"This is a cool Cutscene don't you Think"})

    SceneManager.Delay(30)

    SceneManager.SpawnTextbox({"Sick cutscene","Wow"})

    return self 
end)