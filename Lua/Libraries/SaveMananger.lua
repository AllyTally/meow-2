return (function()
    local self
    self = { }

    function self.WriteSave(save_name, save_table)
        local file = Misc.OpenFile("Saves/" .. save_name, "w")
        file.Write(json.serialize(save_table),false)
    end

    function self.ReadSave(save_name)
        local file = Misc.OpenFile("Saves/" .. save_name, "r")
        
        all_lines = ""

        lines_table = file.ReadLines() 
        for line_index = 1, #lines_table do
            all_lines = all_lines .. lines_table[line_index]
            if line_index ~= #lines_table then
                all_lines = all_lines .. "\n"
            end
        end

        local ok, result = pcall(json.parse, all_lines)

        if ok then
            return result
        else
            return false
        end
    end



    return self 
end)()