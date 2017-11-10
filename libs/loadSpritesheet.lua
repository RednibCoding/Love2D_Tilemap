
--[[
	This function makes it easier to load and set up sprite sheets


	by: Michael Binder Nov-2017
]]

function loadSpritesheet(imagePath, cellWidth, cellHeight)
	local image = love.graphics.newImage(imagePath)
	if image == nil then
		error("Image "..imagePath.." does not exist")
		return nil
	end
	local imageWidth, imageHeight = image:getDimensions()
	-- check if imageWidth-/Height and cellWidth-/Height match
	-- so is it possible to get an even number of cells out of this image (and no float number)
	if math.fmod(imageWidth, cellWidth) ~= 0 or math.fmod(imageHeight, cellHeight) ~= 0 then
		error("Image dimensions and cell dimensions do not match")
		return nil
	end


	local numOfCellsX = imageWidth / cellWidth
	local numOfCellsY = imageHeight / cellHeight
	local frame = {}
	local frameNumber = {}

	-- extract image frames
	i = 1
	for x = 1, numOfCellsX do
		for y = 1, numOfCellsY do
			cellX = cellWidth*(x-1)
			cellY = cellHeight*(y-1)
			frame[i] = love.graphics.newQuad(cellX, cellY, cellWidth, cellHeight, image:getDimensions())
			frameNumber[i] = i
			i = i + 1
		end
	end

	frameCount = numOfCellsX * numOfCellsY

	return image, frame, frameNumber, frameCount
end
