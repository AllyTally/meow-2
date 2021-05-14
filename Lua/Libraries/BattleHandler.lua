local self
self = { }

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

self.flee_text_gold = "Ran away with {xp} EXP\rand {gold} GOLD."

self.win_text = "YOU WON!\nYou earned {xp} XP and {gold} gold."
self.win_text_love = "YOU WON!\nYou earned {xp} XP and {gold} gold.\nYour LOVE increased."

self.level_up_table = { 10, 30, 70, 120, 200, 300, 500, 800, 1200, 1700, 2500, 3500, 5000, 7000, 10000, 15000, 25000, 50000, 99999, 100000 };

function self.ResetState()
    if self.fleesprite then
        self.fleesprite.Remove()
    end
    self.xp = 0
    self.gold = 0
    self.fleesprite = nil
    self.fleeing = false
    self.current_flee_success = 50
    self.custom_state = nil
    self.selected_option = 0
    Player.sprite.alpha = 1
end

function self.SpawnEnemies()
    local enemy_objects = {} -- Temporary table to store the enemy objects

    for enemy_index = 1, #enemies do -- For all enemies in the table,
        local enemy_string = enemies[enemy_index]
        local enemy_position = enemypositions[enemy_index]
        local enemy = CreateEnemy(enemy_string,enemy_position[1],enemy_position[2]) -- Spawn the enemies
        
        enemy.Call("require","Libraries/MonsterWrapper")
        
        table.insert(enemy_objects,enemy) -- Put the enemy objects in the temporary table
    end

    enemies = enemy_objects -- Now that we've finished reading from the table, we can set it to the object table
    enemy_objects = nil -- Cleanup! this isn't required probably but it makes me feel better
end

function self.TrySpare()
    self.HideMercyMenu()
    local enemies_left = false
    for enemy_id = 1, #enemies do
        local enemy = enemies[enemy_id]
        if enemy["canspare"] then
            self.EnteringStateDisabled = true
            enemy.call("OnSpare")
            self.EnteringStateDisabled = false
        else
            enemies_left = true
        end
    end

    if enemies_left then
        State("ENEMYDIALOGUE")
    else
        self.BattleResults(true)
    end
end

function self.BattleResults(spare)
    self.custom_state = nil
    
    leveled_up = self.CheckLevel()

    self.EnteringStateDisabled = true
    if leveled_up then
        Audio.PlaySound("levelup")
        BattleDialogue({self.win_text_love:gsub("{xp}",self.xp):gsub("{gold}",self.gold),"[noskip][func:callback][starcolor:000000][instant]"})
    else
        BattleDialogue({self.win_text:gsub("{xp}",self.xp):gsub("{gold}",self.gold),"[noskip][func:callback][starcolor:000000][instant]"})
    end
    self.EnteringStateDisabled = false
end

function self.CheckForSpare()
    for i = 1, #enemies do
        if enemies[i]["isactive"] then
            if enemies[i]["canspare"] then
                return true
            end
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
    if self.gold ~= 0 or self.xp ~= 0 then
        BattleDialogue({self.flee_text_gold:gsub("{xp}",self.xp):gsub("{gold}",self.gold),"[noskip][func:callback][starcolor:000000][instant]"})
        leveled_up = self.CheckLevel()
        if leveled_up then
            Audio.PlaySound("levelup")
        end
    else
        self.CheckLevel()
        BattleDialogue({self.possible_flee_text[math.random(#self.possible_flee_text)],"[noskip][func:callback][starcolor:000000][instant]"})
    end
end

function self.CheckLevel()
    Overworld.player.xp = Overworld.player.xp + self.xp
    Overworld.player.gold = Overworld.player.gold + self.gold
    Overworld.player.hp = Player.hp
    if (Overworld.player.lv > 20) then
        Player.lv = Overworld.player.lv
        return false
    end
    for i = 1, #self.level_up_table do
        if (Overworld.player.xp < self.level_up_table[i]) then
            if (Overworld.player.lv == i) then
                Player.lv = Overworld.player.lv
                return false
            end
            Overworld.player.lv = i
            Player.lv = i
            Overworld.player.hp = Player.hp
            Overworld.player.maxhp = Player.maxhp
            return true
        end
    end
    Player.lv = Overworld.player.lv
    return false
end

local _State = State
function State(state)
    self.custom_state = nil
    if state == "MERCYMENU" then
        self.fleeing = false
        Player.sprite.alpha = 1
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
            self.BattleResults(false)
        end
    end
    if _EnteringState then
        _EnteringState(new_state,old_state)
    end
end
return self 
