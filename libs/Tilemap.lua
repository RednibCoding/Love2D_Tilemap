
--[[
	Class TileMap
	This class represents a Tilemap

	by: Michael Binder Nov-2017

]]


-- importing the class lib for making classes available in lua
local class = require("libs/middleclass")

-- import loadSpritesheet function to make it easier to deal with spritesheets
require("libs/loadSpritesheet")

-- used for making it easier to save tables to file in lua
require("libs/tableShow")


Tilemap = class("Tilemap")


-- this is automatically called by new()
-- the argument "tileFrameNumber" is only used internally, so don't set it manually as argument
function Tilemap:initialize(x, y, width, height, tileWidth, tileHeight, tilesetPath, tileFrameNumber)
	-- storing all tiles (this is a 2D array)
	self._tile = {}
	-- stores the frame of each tile as plain number
	self._tileFrameNumber = {}
	-- path to the tileset
	self._tilesetPath = tilesetPath
	-- x and y coordinates of the map
	self._x = x
	self._y = y
	-- width and height in tiles of the map
	self._width = width
	self._height = height
	-- tileWidth/Height of a tile
	self._tileWidth = tileWidth
	self._tileHeight = tileHeight
	-- reference to the tileset and a table that holds each frame of the tileset as quad
	-- frameNumber holds the number of each tile (eg. first tile = 1, second = 2 ... etc.)
	self._tileset, self._frame, self._frameNumber = loadSpritesheet(tilesetPath, tileWidth, tileHeight)

	if self._tileset == nil then
		error("Tileset not found: "..tilesetPath)
	end
	-- tileFrameNumber is a 2D array of frame numbers as plain numbers of each tile
	-- this will only be set when Tilemap:load() is called by the user instead of Tilemap:new()
	self:_create(tileFrameNumber)
end

function Tilemap:_create(tileFrameNumber)
	-- this will be called when the map has to be loaded from file (Tilemap:load())
	if tileFrameNumber ~= nil then
		for x = 1, self._width do
			self._tile[x] = {}
			self._tileFrameNumber[x] = {}
			for y = 1, self._height do
				self._tile[x][y] = self._frame[tileFrameNumber[x][y]]
				self._tileFrameNumber[x][y] = tileFrameNumber[x][y]
			end
		end
	-- this will be called when a new map with default values has to be created
	else
		for x = 1, self._width do
			self._tile[x] = {}
			self._tileFrameNumber[x] = {}
			for y = 1, self._height do
				self._tile[x][y] = self._frame[1]
				self._tileFrameNumber[x][y] = 1
			end
		end
	end
end

-- Loads a map from file
-- filePath has to be WITHOUT file extention
-- due to love's way of saving data to disk, the file is automatically saved in %appdata%
function Tilemap:load(filePath)
	-- load map settings
	chunk = love.filesystem.load( filePath .."_settings.map" )
	if chunk == nil then error("File " .. filePath .. " not found") end
	chunk()
	local tilesetPath = settings[1]
	local x = settings[2]
	local y = settings[3]
	local width = settings[4]
	local height = settings[5]
	local tileWidth = settings[6]
	local tileHeight = settings[7]

	-- load map tiles
	chunk = love.filesystem.load( filePath .."_tiles.map" )
	if chunk == nil then error("File " .. filePath .. " not found") end
	chunk()
	local tileFrameNumber = {}
	tileFrameNumber = tiles

	-- call new() function with argument "tileFrameNumber"
	return self:new(x, y, width, height, tileWidth, tileHeight, tilesetPath, tileFrameNumber)
end

-- Saves the map to file
-- filePath has to be WITHOUT file extention
-- due to love's way of saving data to disk, the file is automatically loaded from %appdata%
function Tilemap:save(filePath)
	local settings = {}
	settings[1] = self._tilesetPath
	settings[2] = self._x
	settings[3] = self._y
	settings[4] = self._width
	settings[5] = self._height
	settings[6] = self._tileWidth
	settings[7] = self._tileHeight
	love.filesystem.write( filePath .."_settings.map", table.show(settings, "settings"))
	love.filesystem.write( filePath .."_tiles.map", table.show(self._tileFrameNumber, "tiles"))
end

-- draw the map
-- debug is optional - if true, it shows the tile number
function Tilemap:draw(debug)
	local i = 1 -- for debuging
	for y = 1, self._height do
		for x = 1, self._width do
			cellX = self._tileWidth * (x-1)
			cellY = self._tileHeight * (y-1)
			love.graphics.draw(self._tileset, self._tile[x][y], cellX+self._x, cellY+self._y)
			if debug == true then
				love.graphics.print("Tile: "..i, cellX+self._x, cellY+self._y)
				i = i + 1
			end
		end
	end
end

-- Returns the tileX and tileY of the tile the mouse is hovering over
function Tilemap:getMouseTile()
	local mouseX, mouseY = love.mouse.getPosition()
	tileX = (mouseX - self._x) / self._tileWidth
	tileY = (mouseY - self._y) / self._tileHeight
	-- +1 because lua tables start at 1 and not zero
	tileX = math.floor(tileX) + 1
	tileY = math.floor(tileY) + 1
	return tileX, tileY
end

function Tilemap:setX(x)
	self._x = x
end

function Tilemap:setY(y)
	self._y = y
end

function Tilemap:setPosition(x, y)
	self._x = x
	self._y = y
end

function Tilemap:setTile(tileX, tileY, frame)
	self._tile[tileX][tileY] = self._frame[frame]
	self._tileFrameNumber[tileX][tileY] = frame
	print("done")
end

function Tilemap:getX()
	return self._x
end

function Tilemap:getY()
	return self._y
end

function Tilemap:getPosition()
	return self._x, self._y
	
end

-- returns the frame number of tileX tileY
function Tilemap:getTile(tileX, tileY)
	return self._tileFrameNumber[tileX][tileY]
end
