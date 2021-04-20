
local _OnDeath = OnDeath
function OnDeath()
    Encounter["BattleHandler"].gold = Encounter["BattleHandler"].gold + gold
    Encounter["BattleHandler"].xp = Encounter["BattleHandler"].xp + xp
    if _OnDeath then
        _OnDeath()
    else
        Kill()
    end
end


local _OnSpare = OnSpare
function OnSpare()
    Encounter["BattleHandler"].gold = Encounter["BattleHandler"].gold + gold
    if _OnSpare then
        OnSpare()
    else
        Spare()
    end
end