return (function()
    local self
    self = { }

    if not enemies then
        enemies = { }
    end

    self.debug_mode = true
    self.debug_ignore_collision = false

    -- Initializes the library
    local _EncounterStarting = EncounterStarting
    function EncounterStarting()
        State("NONE")

        -- Create the layers used in this module
        CreateLayer("OWBackground", "Top")
        CreateLayer("Tiles", "OWBackground")
        CreateLayer("Tiles2", "Tiles")
        CreateLayer("Objects", "Tiles2")
        CreateLayer("Player", "Objects")
        CreateLayer("Textbox","Player")
        CreateLayer("Fader","Textbox")

        OverworldTextbox = require "OverworldTextbox"
        SceneManager = require "SceneManager"

        -- Animation timer
        self.animationtimer = 0

        -- Stored tilesets
        self.loadedtilesets = {}

        self.animated_tiles = {}

        self.tile_layers = {}


        -- Dunno, comment later
        self.playerstart = {}
        self.turned = false
        self.murderdancing = false

        self.images = {}

        self.collision_rectangles = {}
        self.collision_triangles = {}

        self.cutscene_active = false

        -- Room transitioning
        self.transitioning_to_room = false
        self.transitioning_from_room = false
        self.map_to_load = map
        self.new_map_x = x
        self.new_map_y = y

        self.transition_fader = CreateSprite("px","Fader")
        self.transition_fader.color = {0,0,0}
        self.transition_fader.Scale(640,480)
        self.transition_fader.alpha = 0


        -- Create settings to be changed in EncounterStarting
        self.backgroundpath = "black" -- Black background by default

        -- Call the original EncounterStarting()
        if _EncounterStarting then
            _EncounterStarting()
        end

        -- Hides the main battle
        self.background = CreateSprite(self.backgroundpath, "OWBackground")

        -- Call the OverworldStarting function if it exists
        if OverworldStarting then
            OverworldStarting()
        end

        self.LoadMap(map)
        self.LoadPlayer(player)


        self.camera_pos_x = 0
        self.camera_pos_y = 0
    end

    function self.DEBUG(text)
        if self.debug_mode then
            DEBUG(text)
        end
    end

    -- Main update function of the module
    function self.Update()
        if self.debug_mode then
            if Input.GetKey("F10") == 1 then
                self.cutscene_active = false
                self.debug_ignore_collision = not self.debug_ignore_collision
            end
        end

		local old_x = self.player.x
		local old_y = self.player.y
        if not self.cutscene_active and not self.transitioning_to_room then
            self.TakeInput()
        end
        self.UpdatePlayerSprite(self.player.x ~= old_x or self.player.y ~= old_y or self.murderdancing)
        if self.mapdata.Update then self.mapdata.Update() end
        self.UpdateEvents()
        SceneManager.Update()
        OverworldTextbox.Update()
        self.UpdateCamera() -- TODO: Move to Camera.Update()
        self.UpdateTiles()
        self.UpdateAnimatedTiles()
        self.UpdateRoomTransition()


        if self.mapdata.Update then self.mapdata.Update() end
        self.animationtimer = self.animationtimer + 1

        --if not OverworldTextbox.textActive then
        --    self.cutscene_active = false
        --end
    end

    function self.UnloadMap()

        for layer_id = #self.tile_layers, 1, -1 do
            for tile_id = #self.tile_layers[layer_id], 1, -1 do
                local tile = self.tile_layers[layer_id][tile_id]

                if tile.sprite then
                    tile.sprite.sprite.Remove()
                    tile.sprite.mask.Remove()
                    tile.sprite = nil
                end
                tile = nil
            end
            self.tile_layers[layer_id] = nil
        end
        self.tile_layers = {}



        for event_id = #self.mapdata.events, 1, -1 do
            local event = self.mapdata.events[event_id]
            event.sprite.Remove()
            if event.OnUnload then event.OnUnload() end

        end
        self.mapdata.events = {}

        self.collision_rectangles = {}
        self.collision_triangles = {}
    end

    function self.UpdateRoomTransition()
        if self.transitioning_to_room then
            if self.transition_fader.alpha >= 1 then
                self.transitioning_to_room = false
                self.transitioning_from_room = true

                if self.mapdata.BeforeUnload then self.mapdata.BeforeUnload() end
                self.UnloadMap()
                self.LoadMap(self.map_to_load)
                self.player.x = self.new_map_x * self.mapdata.scale.x
                self.player.y = self.new_map_y * self.mapdata.scale.y
            else
                self.transition_fader.alpha = self.transition_fader.alpha + 0.06
            end
        elseif self.transitioning_from_room then
            if self.transition_fader.alpha <= 0 then
                self.transitioning_from_room = false
                if self.mapdata.AfterEnter then self.mapdata.AfterEnter() end
            else
                self.transition_fader.alpha = self.transition_fader.alpha - 0.06
            end
        else
            self.transition_fader.alpha = 0
        end
    end

    function self.GotoRoom(map,x,y)
        if self.transitioning_to_room then return end
        if self.mapdata.OnLeave then self.mapdata.OnLeave() end
        self.transitioning_to_room = true
        self.transitioning_from_room = false
        self.map_to_load = map
        self.new_map_x = x
        self.new_map_y = y
    end

    function self.SpawnSimpleTextbox(text,portrait,options)
        SceneManager.Start(function()
            SceneManager.SpawnTextbox(text,portrait,options)
        end)
    end

    function self.UpdateTiles()

        for layer_id = 1, #self.tile_layers do
            for tile_id = #self.tile_layers[layer_id], 1, -1 do
                local tile = self.tile_layers[layer_id][tile_id]

                if (tile.x > self.camera_pos_x - (self.tilemapdata.tilewidth * self.mapdata.scale.x)) and
                   (tile.x < self.camera_pos_x + 640) and
                   (tile.y > self.camera_pos_y) and
                   (tile.y < self.camera_pos_y + 480 + (self.tilemapdata.tileheight * self.mapdata.scale.y)) then
                    if not tile.sprite then
                        tile.sprite = self.CreateTileSprite(tile.tileset,tile.id,tile.x,tile.y,self.mapdata.internalname)
                    end
                else
                    if tile.sprite then
                        tile.sprite.sprite.Remove()
                        tile.sprite.mask.Remove()
                        tile.sprite = nil
                    end
                end
            end
        end
    end

    function self.UpdateCamera()
        self.camera_pos_x = math.min((self.tilemapdata.width  * self.tilemapdata.tilewidth  * self.mapdata.scale.x) - 640,math.max(0,self.player.x - 320))
        self.camera_pos_y = math.min((self.tilemapdata.height * self.tilemapdata.tileheight * self.mapdata.scale.y) - 480,math.max(0,self.player.y - 240))
        self.transition_fader.x = self.camera_pos_x + 320
        self.transition_fader.y = self.camera_pos_y + 240
        Misc.MoveCameraTo(self.camera_pos_x,self.camera_pos_y)
    end

    function self.LoadEvent(object)
        if object.name == "" then
            error("Missing event name")
        end
        -- Load the event from either the map folder or the root folder
        local events_folder = "/Maps/" .. self.mapdata.internalname .. "/Events/"
        local folder = nil

        if Misc.DirExists(events_folder) then
            if Misc.DirExists(events_folder .. object.name) then
                folder = events_folder .. object.name
            end
        end


        if not folder then
            -- It wasn't found in the maps events folder...
            events_folder = "/Events/"
            if Misc.DirExists(events_folder) then
                if Misc.DirExists(events_folder .. object.name) then
                    folder = events_folder .. object.name
                end
            end
        end

        if not folder then
            error("Attempted to load event \"" .. object.name .. "\", but it wasn't found in either folder.")
        end

        local modpath = self.GetModName()
        local event = dofile(modpath.modPath .. folder .. "/event.lua")

        event.internalname = object.name

        event.x = object.x * self.mapdata.scale.x
        event.y = ((self.tilemapdata.height * self.tilemapdata.tileheight) * self.mapdata.scale.y) - (object.y * self.mapdata.scale.y) - (object.height * self.mapdata.scale.y)

        event.data = object
        event.properties = object.properties

        if event.sprite_path then 
            event.sprites_folder = "../" .. folder .. "/Sprites/"
            event.sprite = CreateSprite(event.sprites_folder .. event.sprite_path, "Objects")
            event.sprite.xscale = self.mapdata.scale.x
            event.sprite.yscale = self.mapdata.scale.y

            event.sprite.SetPivot(0,0)
            event.sprite.SetAnchor(0,0)

            event.sprite.x = event.x + (event.sprite_offset.x * self.mapdata.scale.x ) + 0.01
            event.sprite.y = event.y + (event.sprite_offset.y * self.mapdata.scale.y ) + 0.01
        end

        event.removed = false
        function event.Destroy()
            for event_id = 1, #self.mapdata.events do
                if self.mapdata.events[event_id] == event then
                    event.sprite.Remove()
                    event.removed = true
                    table.remove(self.mapdata.events,event_id)
                    return
                end
            end
        end

        table.insert(self.mapdata.events,event)
    end

    function self.UpdateEvents()
        for event_id = #self.mapdata.events, 1, -1 do
            local event = self.mapdata.events[event_id]


            local event_rect = self.rect(
                                        (event.hitbox_offset.x * self.mapdata.scale.x) + event.x,
                                        (event.hitbox_offset.x * self.mapdata.scale.x) + event.x + (event.hitbox_size.x * self.mapdata.scale.x),
                                        (event.hitbox_offset.y * self.mapdata.scale.y) + event.y,
                                        (event.hitbox_offset.y * self.mapdata.scale.y) + event.y + (event.hitbox_size.y * self.mapdata.scale.y)
                                        )

            if event.OnCollide and not event.removed then
                local player_rect = self.rect(
                                            self.player.x,
                                            self.player.x+self.player.hitbox_size.x,
                                            self.player.y,
                                            self.player.y+self.player.hitbox_size.y
                                            )
                if self.isColliding(player_rect, event_rect) then
                    event.OnCollide()
                end
            end

            if event.OnInteract and not event.removed and not self.cutscene_active then
                if Input.Confirm == 1 then

                    local x_inc_1 = (self.player.dir == 0) and self.player.interaction_distance or 0
                    local x_inc_2 = (self.player.dir == 1) and self.player.interaction_distance or 0
                    local y_inc_1 = (self.player.dir == 3) and self.player.interaction_distance or 0
                    local y_inc_2 = (self.player.dir == 2) and self.player.interaction_distance or 0


                    local player_rect = self.rect(
                                                self.player.x                           - x_inc_1,
                                                self.player.x+self.player.hitbox_size.x + x_inc_2,
                                                self.player.y                           - y_inc_1,
                                                self.player.y+self.player.hitbox_size.y + y_inc_2
                                                )

                    if self.isColliding(player_rect, event_rect) then
                        event.OnInteract()
                        break
                    end
                end
            end


            if event.Update and not event.removed then event.Update() end

            if not event.removed then
                event.sprite.x = event.x + (event.sprite_offset.x * self.mapdata.scale.x ) + 0.01
                event.sprite.y = event.y + (event.sprite_offset.y * self.mapdata.scale.y ) + 0.01
            end
        end
    end

    function self.FindFirstEvent(name)
        for event_id = #self.mapdata.events, 1, -1 do
            local event = self.mapdata.events[event_id]
            if event.internalname == name then
                return event
            end
        end
        return nil
    end



    function self.FindEvents(name)
        local events = {}
        for event_id = #self.mapdata.events, 1, -1 do
            local event = self.mapdata.events[event_id]
            if event.internalname == name then
                table.insert(events,event)
            end
        end
        return events
    end


    -- Loads a map
    function self.LoadMap(mapname)
        -- Loads the map's data
        self.debug_ignore_collision = false
        self.DEBUG("Attemping to load map \"" .. mapname .. "\"")
        local modpath = self.GetModName()

        if Misc.DirExists("Maps") then
            self.mapdata     = dofile(modpath.modPath .. "/Maps/" .. mapname .. "/map.lua")
            self.tilemapdata = dofile(modpath.modPath .. "/Maps/" .. mapname .. "/tiledata.lua")
        else
            error("Missing \"Maps\" folder in root")
        end

        if self.mapdata.BeforeLoad then self.mapdata.BeforeLoad() end

        self.mapdata.internalname = mapname
        self.mapdata.events = {}

        for layer_id = 1, #self.tilemapdata.layers do
            local current_layer = self.tilemapdata.layers[layer_id]

            if current_layer.type == "tilelayer" then
                local layer_tiles = {}
                for y = 1, current_layer.height do
                    for x = 1, current_layer.width do
                        local current_tile_id = current_layer.data[((y - 1) * current_layer.width) + x]
                        if current_tile_id ~= 0 then

                            local tileset_id = self.GetTilesetFor(current_tile_id)
                            local tileset = self.tilemapdata.tilesets[tileset_id]

                            local tile_width  = tileset.tilewidth
                            local tile_height = tileset.tileheight

                            local x2 = ((x - 1) * (tile_width * self.mapdata.scale.x))
                            local y2 = 480 - ((y - 1) * (tile_height * self.mapdata.scale.y)) + (current_layer.height - (480 / (tile_height * self.mapdata.scale.y))) * (tile_height * self.mapdata.scale.y)

                            local tile = {}

                            tile.tileset = tileset
                            tile.x = x2
                            tile.y = y2
                            tile.id = current_tile_id


                            tile.sprite = nil



                            tile.animated = false
                            tile.animation_table = nil
                            for i = 1, #tileset.tiles do
                                if (current_tile_id - tileset.firstgid) == tileset.tiles[i].id then
                                    tile.animated = true
                                    tile.animation_table = tileset.tiles[i].animation
                                    tile.animation_timer = 0
                                    tile.animation_index = 1
                                    table.insert(self.animated_tiles,tile)
                                    break
                                end
                            end

                            --local sprite = self.CreateTileSprite(tileset,current_tile_id,x2,y2,mapname)

                            table.insert(layer_tiles,tile)
                        end
                    end
                end
                table.insert(self.tile_layers,layer_tiles)
            elseif current_layer.type == "objectgroup" and current_layer.name == "events" then
                self.DEBUG("Loading events")
                for object_id = 1, #current_layer.objects do
                    local object = current_layer.objects[object_id]
                    if object.name == "start" then
                        self.DEBUG("Player start found at (" .. object.x .. ", " .. object.y .. ")")
                        self.playerstart = {object.x, object.y}
                    else
                        self.DEBUG("Event " .. object.name .. " found")
                        self.LoadEvent(object)
                    end
                end
            elseif current_layer.type == "objectgroup" and current_layer.name == "collision" then

                for object_id = 1, #current_layer.objects do
                    local object = current_layer.objects[object_id]
                    if object.shape == "rectangle" then
                        self.DEBUG("Rectangle collision found at (" .. object.x * self.mapdata.scale.x .. ", " .. object.y * self.mapdata.scale.y .. ")")

                        local flipped_y = ((self.tilemapdata.height * self.tilemapdata.tileheight) - object.y)

                        local x  = (object.x) * self.mapdata.scale.x
                        local x2 = (object.x + object.width) * self.mapdata.scale.x
                        local y  = (flipped_y*self.mapdata.scale.y)
                        local y2 = (flipped_y - object.height) * self.mapdata.scale.y

                        local rect = self.rect(x,x2,y2,y)
                        table.insert(self.collision_rectangles,rect)
                    elseif object.shape == "polygon" then
                        self.DEBUG("Triangle collision found")

                        local x1 = object.polygon[1]["x"]*self.mapdata.scale.x
                        local x2 = object.polygon[2]["x"]*self.mapdata.scale.x
                        local x3 = object.polygon[3]["x"]*self.mapdata.scale.x
                        local x4 = object.x*self.mapdata.scale.x

                        local y1 = (-object.polygon[1]["y"])*self.mapdata.scale.y
                        local y2 = (-object.polygon[2]["y"])*self.mapdata.scale.y
                        local y3 = (-object.polygon[3]["y"])*self.mapdata.scale.y
                        local y4 = ((self.tilemapdata.height * self.tilemapdata.tileheight) - object.y)*self.mapdata.scale.y
                        --local y4 = object.y * 2

                        self.DEBUG("(" .. x4 .. "," .. y4 .. ")")

                        local triangle = {{x1,y1},{x2,y2},{x3,y3},{x4,y4}}
                        table.insert(self.collision_triangles,triangle)
                    end
                end
            elseif current_layer.type == "imagelayer" then
                local image = CreateSprite("../Maps/" .. mapname .. "/" .. current_layer.image:sub(1, -5),"Tiles2")
                image.SetPivot(0,1)
                image.x = current_layer.offsetx * self.mapdata.scale.x
                image.y = ((self.tilemapdata.height * self.tilemapdata.tileheight) - current_layer.offsety)*self.mapdata.scale.y
                image.Scale(self.mapdata.scale.x,self.mapdata.scale.y)
                table.insert(self.images,image)
            else
                self.DEBUG("UNSUPPORTED LAYER TYPE: " .. current_layer.type)
            end
        end
        if self.mapdata.OnLoad then self.mapdata.OnLoad() end
    end

    function self.CreateTileSprite(tileset,tile_id,x,y,mapname)
        local tile_id = tile_id - tileset.firstgid
        local tile = {}

        tile.mask = CreateSprite("px","Tiles")
        tile.mask.Scale(tileset.tilewidth * self.mapdata.scale.x, tileset.tileheight * self.mapdata.scale.y)
        tile.mask.Mask("stencil")
        tile.mask.SetPivot(0,1)
        tile.mask.SetAnchor(0,1)
        tile.mask.MoveToAbs(x, y)

        tile.sprite = CreateSprite("../Maps/" .. mapname .. "/" .. tileset.image:sub(1, -5),"Tiles")
        tile.sprite.SetParent(tile.mask)
        tile.sprite.Scale(self.mapdata.scale.x, self.mapdata.scale.y)
        tile.sprite.SetPivot(0,1)
        tile.sprite.SetAnchor(0,1)

        local tile_x = tile_id % tileset.columns
        local tile_y = (tile_id-tile_x) / tileset.columns

        tile.sprite.MoveToAbs(x - (tile_x * tileset.tilewidth * self.mapdata.scale.x), y + (tile_y * tileset.tileheight * self.mapdata.scale.y))

        tile.x = x
        tile.y = y

        return tile
    end

    function self.UpdateAnimatedTiles()
        for tile_id = 1, #self.animated_tiles do
            local tile = self.animated_tiles[tile_id]

            if tile.animation_timer >= (60 / 1000 * tile.animation_table[tile.animation_index].duration) then
                tile.animation_timer = 0
                tile.animation_index = tile.animation_index + 1

                if tile.animation_index > #tile.animation_table then
                    tile.animation_index = 1
                end

                local tile_id = tile.animation_table[tile.animation_index].tileid

                local tile_x = tile_id % tile.tileset.columns
                local tile_y = (tile_id-tile_x) / tile.tileset.columns

                if tile.sprite then
                    tile.sprite.sprite.MoveToAbs(tile.x - (tile_x * tile.tileset.tilewidth * self.mapdata.scale.x), tile.y + (tile_y * tile.tileset.tileheight * self.mapdata.scale.y))
                end
            end

            tile.animation_timer = tile.animation_timer + 1
        end
    end


    function self.GetTilesetFor(tile_id)
        local closest = -1
        local closest_index = -1

        for i = 1, #self.tilemapdata.tilesets do
            local loaded_tileset = self.tilemapdata.tilesets[i]
            if tile_id >= loaded_tileset.firstgid then
                if loaded_tileset.firstgid >= closest then
                    closest = loaded_tileset.firstgid
                    closest_index = i
                end
            end
        end

        return closest_index
    end

    function self.LoadPlayer(playername)
        -- Loads the player's data
        self.DEBUG("Attemping to load player \"" .. playername .. "\"")
        local modpath = self.GetModName()
        self.player = dofile(modpath.modPath .. "/Players/" .. playername .. "/player.lua")

        self.player.x = self.playerstart[1] * self.mapdata.scale.x
        self.player.y = ((self.tilemapdata.height * self.tilemapdata.tileheight) * self.mapdata.scale.y) - self.playerstart[2] * self.mapdata.scale.y
        -- Misc.MoveCameraTo(self.player.x,self.player.y)

        local spritepath = self.player.animations.IdleDown[4] .. "/" .. self.player.animations.IdleDown[1][1]
        self.player.sprite = CreateSprite("../Players/" .. playername .. "/Sprites/" .. spritepath, "Player")
        self.player.sprite.SetPivot(0,0)
        self.player.animation = "IdleDown"
        self.player.dir = 2
        self.player.animationindex = 1
        self.player.internalname = playername

        self.player.sprite.x = self.player.x
        self.player.sprite.y = self.player.y


        self.player.debugpoint = CreateSprite("px","Objects")
        self.player.debugpoint.Scale(4, 4)

        self.player.debugpoint.alpha = 0

    end

    function self.GetPlayerSpeed()
        if self.debug_mode then
            if Input.GetKey("Backspace") > 0 then
                return 10
            end
        end
        return self.player.speed
    end

    function self.TakeInput()
        -- Let's try and recreate Undertale's controls faithfully. Oh no.

        if Input.Left > 0 then
            self.MovePlayer(-self.GetPlayerSpeed(),0)
        elseif Input.Right > 0 then
            self.MovePlayer(self.GetPlayerSpeed(),0)
        end

        local collided = false

        self.murderdancing = false
        if Input.Up > 0 then
            collided = self.MovePlayer(0,self.GetPlayerSpeed())
            if (Input.Down > 0) and collided then
                self.murderdancing = true
            end
        elseif Input.Down > 0 then
            self.MovePlayer(0,-self.GetPlayerSpeed())
        end

        if collided and (Input.Down > 0) and (self.animationtimer % 4 >= 2) then
            self.MovePlayer(0,-self.GetPlayerSpeed() * 2)
        end

    end

    function self.MovePlayer(x,y)
        self.player.x = self.player.x + x
        self.player.y = self.player.y + y

        if self.debug_ignore_collision then
            return false
        end

        local collided = false

        for rectangle_id = 1, #self.collision_rectangles do
            local rectangle = self.collision_rectangles[rectangle_id]
            local player_rect = self.rect(self.player.x,self.player.x+self.player.hitbox_size.x,self.player.y,self.player.y+self.player.hitbox_size.y)
            local infbreaker = 0
            while self.isColliding(player_rect,rectangle) do
                self.player.x = self.player.x - self.sign(x)
                self.player.y = self.player.y - self.sign(y)
                player_rect = self.rect(self.player.x,self.player.x+self.player.hitbox_size.x,self.player.y,self.player.y+self.player.hitbox_size.y)
                collided = true
                infbreaker = infbreaker + 1
                if infbreaker > 1000 then
                    self.DEBUG("WARNING: Infinite loop broken out of in collision")
                    break
                end
            end

            if collided then
                break
            end
        end

        for event_id = 1, #self.mapdata.events do
            local event = self.mapdata.events[event_id]
            if event.solid then

                local event_rect = self.rect(
                            (event.hitbox_offset.x * self.mapdata.scale.x) + event.x,
                            (event.hitbox_offset.x * self.mapdata.scale.x) + event.x + (event.hitbox_size.x * self.mapdata.scale.x),
                            (event.hitbox_offset.y * self.mapdata.scale.y) + event.y,
                            (event.hitbox_offset.y * self.mapdata.scale.y) + event.y + (event.hitbox_size.y * self.mapdata.scale.y)
                            )

                local player_rect = self.rect(self.player.x,self.player.x+self.player.hitbox_size.x,self.player.y,self.player.y+self.player.hitbox_size.y)
                local infbreaker = 0
                while self.isColliding(player_rect,event_rect) do
                    self.player.x = self.player.x - self.sign(x)
                    self.player.y = self.player.y - self.sign(y)
                    player_rect = self.rect(self.player.x,self.player.x+self.player.hitbox_size.x,self.player.y,self.player.y+self.player.hitbox_size.y)
                    collided = true
                    infbreaker = infbreaker + 1
                    if infbreaker > 1000 then
                        self.DEBUG("WARNING: Infinite loop broken out of in collision")
                        break
                    end
                end
            end

            if collided then
                break
            end
        end

        self.player.debugpoint.color = {1, 1, 1}
        for triangle_id = 1, #self.collision_triangles do
            -- self.DEBUG(triangle_id)
            local t = self.collision_triangles[triangle_id]

            local point_hit = false
            local slope = -1
            local isAngleOnRight = false
            local isAboveLine = false

            point_hit, slope, isAngleOnRight, isAboveLine = self.isCollidingWithTriangle(self.player.x,self.player.y,t[1],t[2],t[3],t[4][1],t[4][2])

            if not point_hit then
                point_hit, slope, isAngleOnRight, isAboveLine = self.isCollidingWithTriangle(self.player.x+self.player.hitbox_size.x,self.player.y,t[1],t[2],t[3],t[4][1],t[4][2])
            end
            if not point_hit then
                point_hit, slope, isAngleOnRight, isAboveLine = self.isCollidingWithTriangle(self.player.x,self.player.y+self.player.hitbox_size.y,t[1],t[2],t[3],t[4][1],t[4][2])
            end
            if not point_hit then
                point_hit, slope, isAngleOnRight, isAboveLine = self.isCollidingWithTriangle(self.player.x+self.player.hitbox_size.x,self.player.y+self.player.hitbox_size.y,t[1],t[2],t[3],t[4][1],t[4][2])
            end

            if point_hit then
                self.player.debugpoint.color = {0, 1, 0}
                if (y < 0 and not isAboveLine) then
                    self.player.x = self.player.x + self.GetPlayerSpeed() * -slope
                end
                if (y > 0 and isAboveLine) then
                    self.player.x = self.player.x + self.GetPlayerSpeed() * slope
                end
                if (x < 0 and not isAngleOnRight) then
                    self.player.y = self.player.y + self.GetPlayerSpeed() * -slope
                end
                if (x > 0 and isAngleOnRight) then
                    self.player.y = self.player.y + self.GetPlayerSpeed() * slope
                end
            end
        end

        self.player.debugpoint.x = self.player.x
        self.player.debugpoint.y = self.player.y

        return collided
    end

    function self.TestPoints(ax,ay,bx,by,cx,cy)
        return (ax == bx or ay == by) and (ax == cx or ay == cy)
    end

    function self.isCollidingWithTriangle(player_x,player_y,a,b,c,offx,offy)
        local point_angle -- C
        local point_left  -- A
        local point_right -- B

        if (self.TestPoints(a[1],a[2],b[1],b[2],c[1],c[2])) then
            point_angle = {a[1],a[2]}

            point_left = {b[1],b[2]}
            point_right = {c[1],c[2]}
            if b[1] > c[1] then
                point_left = {c[1],c[2]}
                point_right = {b[1],b[2]}
            end

        elseif (self.TestPoints(b[1],b[2],a[1],a[2],c[1],c[2])) then
            point_angle = {b[1],b[2]}

            point_left = {a[1],a[2]}
            point_right = {c[1],c[2]}
            if a[1] > c[1] then
                point_left = {c[1],c[2]}
                point_right = {a[1],a[2]}
            end

        elseif (self.TestPoints(c[1],c[2],a[1],a[2],b[1],b[2])) then
            point_angle = {c[1],c[2]}

            point_left = {a[1],a[2]}
            point_right = {b[1],b[2]}
            if a[1] > b[1] then
                point_left = {b[1],b[2]}
                point_right = {a[1],a[2]}
            end
            
        else
            error("Collision triangle must be a right-triangle")
        end

        offx = offx + point_left[1]
        offy = offy + math.min(point_left[2], point_right[2])

        local point_x = player_x - offx
        local point_y = player_y - offy

        local use_point = point_left
        local use_point2 = point_right

        if point_right[1] == point_angle[1] then
            use_point = point_right
            use_point2 = point_left
        end

        slope = -(use_point[2] - point_angle[2]) / (use_point2[1] - use_point[1]) -- get the slope

        local isAboveLine = point_angle[2] == math.max(point_left[2], point_right[2])

        if isAboveLine then
            if point_left[1] < 0 then
                point_right[1] = point_right[1] - point_left[1]
                point_angle[1] = point_angle[1] - point_left[1]
                point_left[1] = 0
            end
            
            if point_left[2] < 0 or point_right[2] < 0 then
                local offset = math.min(point_left[2], point_right[2])
                point_right[2] = point_right[2] - offset
                point_left[2] = point_left[2] - offset
                point_angle[2] = point_angle[2] - offset
            end
        end

        local width  = point_right[1] - point_left[1]
        local height = math.max(point_left[2], point_right[2]) - math.min(point_left[2], point_right[2])

        local isSlopeIntercepting

        if isAboveLine then
            isSlopeIntercepting = point_y >= (slope * point_x) + point_left[2]
        else
            isSlopeIntercepting = point_y <= (slope * point_x) + (point_left[2] - point_angle[2])
        end

        local isColliding = 
               (point_x >= 0) and (point_x <= width) and
               (point_y >= 0) and (point_y <= height) and
               isSlopeIntercepting -- y = mx + b

        return isColliding, slope, point_angle[1] == point_right[1], isAboveLine
    end

    function self.sign(number)
        return number > 0 and 1 or number < 0 and -1 or 0
    end

    function self.rect(point1,point2,point3,point4)
        local _rect
        _rect = {}
        _rect.X1 = point1
        _rect.X2 = point2
        _rect.Y1 = point3
        _rect.Y2 = point4
        return _rect
    end

    function self.isColliding(r1,r2)
        return ((r1.X1 < r2.X2) and (r1.X2 > r2.X1) and (r1.Y1 < r2.Y2) and (r1.Y2 > r2.Y1))
    end

    function self.UpdatePlayerSprite(moving)
        -- Update the position of the sprite itself
        self.player.sprite.x = self.player.x
        self.player.sprite.y = self.player.y


        -- Animation code... this is very ugly, but it's accurate.

        if not self.cutscene_active and not self.transitioning_to_room then

            if Input.Left > 0 then
                self.turned = true
                if ((Input.Up > 0)   and self.player.animation == "WalkUp"  ) or
                ((Input.Down > 0) and self.player.animation == "WalkDown") then
                    self.turned = false
                end
                if self.turned then
                    self.player.dir = 0
                    self.player.animation = "WalkLeft"
                end
            end

            if (Input.Right > 0) and (Input.Left <= 0) then
                self.turned = true
                if ((Input.Up > 0)   and self.player.animation == "WalkUp"  ) or
                ((Input.Down > 0) and self.player.animation == "WalkDown") then
                    self.turned = false
                end
                if self.turned then
                    self.player.dir = 1
                    self.player.animation = "WalkRight"
                end
            end
            if Input.Up > 0 then
                self.turned = true
                if ((Input.Left > 0)  and self.player.animation == "WalkLeft" ) or
                ((Input.Right > 0) and self.player.animation == "WalkRight") then
                    self.turned = false
                end
                if self.turned then
                    self.player.dir = 2
                    self.player.animation = "WalkUp"
                end
            end
            if (Input.Down > 0) and (Input.Up <= 0) then
                self.turned = true
                if ((Input.Left > 0)  and self.player.animation == "WalkLeft" ) or
                ((Input.Right > 0) and self.player.animation == "WalkRight") then
                    self.turned = false
                end
                if self.turned then
                    self.player.dir = 3
                    self.player.animation = "WalkDown"
                end
            end

            if self.murderdancing then
                if ((self.animationtimer % 4) >= 2) then
                    self.player.dir = 2
                    self.player.animation = "WalkUp"
                else
                    self.player.dir = 3
                    self.player.animation = "WalkDown"
                end
            end
        end


        if not moving then
            if self.player.dir == 0 then
                self.player.animation = "IdleLeft"
            elseif self.player.dir == 1 then
                self.player.animation = "IdleRight"
            elseif self.player.dir == 2 then
                self.player.animation = "IdleUp"
            elseif self.player.dir == 3 then
                self.player.animation = "IdleDown"
            end
        end

        if self.animationtimer > self.player.animations[self.player.animation][2] then
            self.animationtimer = 0
            self.player.animationindex = (self.player.animationindex % #self.player.animations[self.player.animation][1]) + 1
        end
        -- Updates the Player's sprites

        self.player.sprite.Set("../Players/" .. self.player.internalname .. "/Sprites/"  .. self.player.animations[self.player.animation][4] .. "/" .. self.player.animations[self.player.animation][1][self.player.animationindex])
    end

    function self.GetModName()
        local _self = {}
        output = Misc.OpenFile("","w").filePath
        output = output:gsub("/", "\\")
        _self.modPath = output
        _self.modName = output:sub(0, output:find("\\[^\\]*$") - 1):sub(output:sub(0, output:find("\\[^\\]*$") - 1):find("\\[^\\]*$") + 1, output:len())
        return _self
    end

    return self 
end)()