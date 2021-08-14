require "tiles"

function split(inputstr, sep)
    sep=sep or '%s' local t={}
    for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
        table.insert(t,field)
        if s=="" then return t
        end
    end
end

function loadMap(mapName)
    local map, _ = love.filesystem.read("maps/" .. mapName)
    for p,i in ipairs(split(map,",")) do
        local objects = {}
        if string.match(i,"&") then
            for _,j in ipairs(split(i,"&")) do
                table.insert(objects,j)
            end
        else
            table.insert(objects,i)
        end
    end
end

function love.load()
    --constants
    tilemaps = {["bg"]=love.graphics.newImage("tilemaps/bg.png"),
                ["fg"]=love.graphics.newImage("tilemaps/fg.png")}
    tiles = sd
    moveDelay = 0.15
    --not constants
    bgObjects = {}
    fgObjects = {{
        name="Player",
        x=0,
        y=0,
        rotation=0
    }}
    mapW, mapH = 25, 18
    moveTimer = 0
end

function getTilesByName(list,name)
    local out = {}
    for _,v in ipairs(list) do
        if(v.name==name) then
            table.insert(out,v)
        end
    end
    return out
end

function getImageQuad(tileData,orientation)
    local o = 0
    if tileData.rotation == 1 then
        o = orientation
    end
    local y = tileData.spriteY*32
    local x = (tileData.spriteX+o)*32
    return love.graphics.newQuad(x,y,32,32,tilemaps[tileData.tilemap])
end

function love.update(dt)
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and moveTimer <= 0 then
        for _,t in ipairs(getTilesByName(fgObjects,"Player")) do
            if t.x < mapW - 1 then
                t.x = t.x + 1
                moveTimer = moveDelay
            end
            t.rotation = 0
        end  
    elseif (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and moveTimer <= 0 then
        for _,t in ipairs(getTilesByName(fgObjects,"Player")) do
            if t.y < mapH - 1 then
                t.y = t.y + 1
                moveTimer = moveDelay
            end
            t.rotation = 1
        end
    elseif (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and moveTimer <= 0 then
        for _,t in ipairs(getTilesByName(fgObjects,"Player")) do
            if t.x > 0 then
                t.x = t.x - 1
                moveTimer = moveDelay
            end
            t.rotation = 2
        end
    elseif (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and moveTimer <= 0 then
        for _,t in ipairs(getTilesByName(fgObjects,"Player")) do
            if t.y > 0 then
                t.y = t.y - 1
                moveTimer = moveDelay
            end
            t.rotation = 3
        end
    end
    if moveTimer > 0 then
        moveTimer = moveTimer - (dt)
    end
end

function love.draw()
    for _,v in ipairs(bgObjects) do
        love.graphics.draw(tilemaps[tiles[v.name].tilemap],getImageQuad(tiles[v.name],v.rotation),v.x*32,v.y*32)
    end
    for _,v in ipairs(fgObjects) do
        love.graphics.draw(tilemaps[tiles[v.name].tilemap],getImageQuad(tiles[v.name],v.rotation),v.x*32,v.y*32)
    end
end