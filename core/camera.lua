camera = {};
camera.position = {
	x = 0,
	y = 0
};
camera.velocity = {
	x = 0,
	y = 0
};
camera.zoom = 0;

function camera.GetBounds()
	local minY, maxY = math.ceil( camera.position.y / ( Base.Config.TileSize - camera.zoom ) ), math.ceil( ( camera.position.y + Base.Config.TileSize - camera.zoom + Base.Config.Resolution.y ) / ( Base.Config.TileSize - camera.zoom ) );
	local minX, maxX = math.ceil( ( camera.position.x - Base.Config.TileSize - camera.zoom ) / ( Base.Config.TileSize - camera.zoom ) ), math.ceil( ( camera.position.x + Base.Config.Resolution.x ) / ( Base.Config.TileSize - camera.zoom ) );

	return minX, maxX, minY, maxY;
end;