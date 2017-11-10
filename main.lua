
--[[
	This is a short example of how to use tilemaps

	by: Michael Binder Nov-2017

]]


require("libs/Tilemap")


local tilemap

function love.load()
	-- create a new tile map
	-- new(x, y, widthInTiles, heightInTiles, tileWidth, tileHeight, tilesetPath)
	tilemap = Tilemap:new(0, 0, 6, 6, 64, 64, "tileset.png")

	-- save the current map
	-- fileName must be WITHOUT file extention
	-- due to love's way of saving data to disk, the file is automatically saved to %appdata%
	-- > tilemap:save("fileName") <--

	-- to load a saved map
	-- fileName must be WITHOUT file extention
	-- the load function can be called without creating a new map first as it automatically creates a new map
	-- due to love's way of saving data to disk, the file is automatically loaded from %appdata%
	-- > tilemap = Tilemap:load("test") <--
end


function love.update()

end


function love.draw()
	-- draw the map with debug = true
	tilemap:draw(true)

	-- getting mouse position
	local mouseX, mouseY = love.mouse.getPosition()
	-- call getMouseTile() to get the tile (tileX, tileY) the mouse is hovering over
	local tileX, tileY = tilemap:getMouseTile()
	-- print the tileX tileY next to the cursor 
	love.graphics.print(tileX.." | "..tileY, mouseX+20, mouseY)
	-- if mouse clicked, change tile's frame number
	if love.mouse.isDown(1) then
		tilemap:setTile(tileX, tileY, 2)
	end

	-- save the map to file "test" when key "s" is pressed
	-- due to love's way of saving data to disk, the file is automatically saved to %appdata%
	if love.keyboard.isDown("s") then
		tilemap:save("test")
		print("map saved")
	end
end