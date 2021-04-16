local self
self = { }

-- TODO: "Ran away with {0} EXP\rand {1} GOLD."

self.xp = 0
self.gold = 0

self.custom_state = nil
self.selected_option = 0
self.old_encountertext = ""

self.text_object = CreateText("", {92,183}, 999, "Top")
self.text_object.progressmode = "none"
self.text_object.HideBubble()

self.EnteringStateDisabled = false

self.fleesprite = nil
self.fleeing = false
self.current_flee_success = 50

self.possible_flee_text = {
    "Escaped...",
    "Don't slow me down.",
    "I've got better to do.",
    "I'm outta here."
}

self.win_text = "YOU WON!\nYou earned {xp} XP and {gold} gold."

function self.ResetState()
    if self.fleesprite then
        self.fleesprite.Remove()
    end
    self.fleesprite = nil
    self.fleeing = false
    self.current_flee_success = 50
    self.custom_state = nil
    self.selected_option = 0
    Player.sprite.alpha = 1
end

function self.TrySpare()
    self.HideMercyMenu()
    for enemy_id = 1, #enemies do
        local enemy = enemies[enemy_id]
        enemy.call("Spare")
    end
end

function self.CalculateStats()
    -- ugh.
    self.gold = 0
    self.xp = 0
    for i = 1, #enemies do
        self.gold = self.gold + enemies[i]["gold"]
        self.xp = self.xp + enemies[i]["xp"]
    end
end

function self.CheckForSpare()
    for i = 1, #enemies do
        if enemies[i]["canspare"] then
            return true
        end
    end
    return false
end

function self.ShowMercyMenu()
    self.text_object.SetFont("uidialog")
    self.text_object.alpha = 1
    
    self.text_object.color = self.CheckForSpare() and {1,1,0} or {1,1,1}
    self.text_object.SetText("[instant]* Spare\n[color:ffffff]* Flee")
end

function self.HideMercyMenu()
    self.text_object.alpha = 0
    self.text_object.SetText("")
end

function callback()
    Overworld.ReturnFromBattle()
end

local _GetCurrentState = GetCurrentState
function GetCurrentState()
    if self.custom_state then
        return self.custom_state
    end
    return _GetCurrentState()
end

function self.StartFlee()
    self.fleeing = true
    self.HideMercyMenu()
    self.fleesprite = CreateSprite("spr_heartgtfo_0","Top")
    self.fleesprite.color = Player.sprite.color
    self.fleesprite.alpha = Player.sprite.alpha
    self.fleesprite.MoveToAbs(Player.absx,Player.absy)
    self.fleesprite.SetAnimation({"spr_heartgtfo_0","spr_heartgtfo_1"},1/10)
    Player.sprite.alpha = 0
    Audio.Stop()
    Audio.PlaySound("runaway")
    BattleDialogue({self.possible_flee_text[math.random(#self.possible_flee_text)],"[noskip][func:callback][starcolor:000000][instant]"})
end

local _State = State
function State(state)
    self.custom_state = nil
    if state == "MERCYMENU" then
        if encountertext ~= "[starcolor:000000][instant]" then
            self.old_encountertext = encountertext
        end
        encountertext = "[starcolor:000000][instant]"
        self.EnteringStateDisabled = true
        State("ACTIONSELECT")
        State("NONE")
        self.EnteringStateDisabled = false
        self.ShowMercyMenu()
        self.custom_state = "MERCYMENU"
        EnteringState("MERCYMENU",GetCurrentState())
    elseif state == "DONE" then
        callback()
    else
        _State(state)
    end
end

function self.Update()
    if self.fleeing then
        self.fleesprite.x = self.fleesprite.x - 1
    elseif self.custom_state == "MERCYMENU" then
        Player.MoveToAbs(65,190 - (self.selected_option * 30), true)
        if Input.Cancel == 1 then
            encountertext = "[noskip][noskip:off]" .. self.old_encountertext
            self.HideMercyMenu()
            State("ACTIONSELECT")
        elseif Input.Up == 1 or Input.Down == 1 then
            self.selected_option = 1 - self.selected_option
        elseif Input.Confirm == 1 then
            if self.selected_option == 0 then
                self.TrySpare()
            else
                Audio.PlaySound("menuconfirm")
                
                if fleesuccess then
                    self.StartFlee()
                elseif fleesuccess == false then -- gross, however i don't want nil to be caught
                    self.HideMercyMenu()
                    State("ENEMYDIALOGUE")
                elseif math.random(100) <= self.current_flee_success then
                    self.StartFlee()
                else
                    self.current_flee_success = self.current_flee_success + 10
                    self.HideMercyMenu()
                    State("ENEMYDIALOGUE")
                end
            end
        end
    end
end

local _EnteringState = EnteringState
function EnteringState(new_state,old_state)
    if self.EnteringStateDisabled then
        return
    end
    self.custom_state = nil
    if new_state == "MERCYMENU" then
        if not (flee == false) then -- If the flee option exists
            self.old_encountertext = encountertext
            encountertext = "[starcolor:000000][instant]"
            State("ACTIONSELECT")
            State("NONE")
            self.ShowMercyMenu()
            self.custom_state = "MERCYMENU"
        end
    elseif new_state == "DIALOGRESULT" then
        local thing = true
        for i=1, #enemies do
            if enemies[i]["isactive"] then
                thing = false
                break
            end
        end
        if thing then
            self.CalculateStats()
            BattleDialogue({self.win_text:gsub("{xp}",self.xp):gsub("{gold}",self.gold),"[noskip][func:callback][starcolor:000000][instant]"})
        end
    end
    if _EnteringState then
        _EnteringState(new_state,old_state)
    end
end
return self 
