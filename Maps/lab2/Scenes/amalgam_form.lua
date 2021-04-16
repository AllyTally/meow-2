return (function()
    local self
    self = { }
    
    NewAudio.CreateChannel("generate")

    local monitor = Overworld.FindFirstEvent("monitor")
    if plot ~= 1 then
        return
    end
    
    local scene = Overworld.FindFirstEvent("scene")
    scene.Destroy()

    Audio.Stop()

    local amalgam = Overworld.FindFirstEvent("amalgam")
    
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam2")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam3")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam4")
    amalgam.sprite.loopmode = "ONESHOT"
    amalgam.sprite.SetAnimation({"amalgam2","amalgam3","amalgam4"}, 10/60, amalgam.sprites_folder)

    NewAudio.PlaySound("generate", "mus_sfx_generate")
    NewAudio.SetPitch("generate",0.9)

    SceneManager.Delay(120)

    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam5")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam6")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam7")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam8")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam9")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam10")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam11")
    amalgam.sprite.Set(amalgam.sprites_folder .. "amalgam12")
    amalgam.sprite.loopmode = "ONESHOT"
    amalgam.sprite.SetAnimation({"amalgam5","amalgam6","amalgam7","amalgam8","amalgam9","amalgam10","amalgam11","amalgam12"}, 4/60, amalgam.sprites_folder)

    NewAudio.PlaySound("generate", "mus_sfx_generate")
    NewAudio.SetPitch("generate",0.7)

    SceneManager.Delay(90)

    NewAudio.DestroyChannel("generate")

    Overworld.EnterBattle("battle")

    return self 
end)