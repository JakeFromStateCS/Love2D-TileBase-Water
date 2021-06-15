camera = camera or {};
camera.movespeed = 4;
camera.zoomspeed = 2;
camera.directions = {
	w = {
		y = camera.movespeed
	},
	s = {
		y = -camera.movespeed
	},
	a = {
		x = camera.movespeed,
	},
	d = {
		x = -camera.movespeed,
	}
};

function camera.KeyPressed( key, unicode )
	local velocity = camera.directions[key];
	if( velocity ~= nil ) then
		for dir,velocity in pairs( velocity ) do
			camera.velocity[dir] = velocity;
		end;
	end;
end;
hook.Add( "KeyPressed", "camera.KeyPressed", camera.KeyPressed );

function camera.KeyReleased( key, unicode )
	local velocity = camera.directions[key];
	if( velocity ~= nil ) then
		for dir,velocity in pairs( velocity ) do
			camera.velocity[dir] = 0;
		end;
	end;
end;
hook.Add( "KeyReleased", "camera.KeyReleased", camera.KeyReleased );

function camera.UpdateVelocity()
	camera.position.x = camera.position.x - camera.velocity.x;
	camera.position.y = camera.position.y - camera.velocity.y;
end;
hook.Add( "Think", "camera.UpdateVelocity", camera.UpdateVelocity );

function camera.Zoom( x, y, button )
	if( Base.Config.AllowZoom ) then
		if( button == "wu" ) then
			--Zoom in
			local mouseX, mouseY = tiles.CoordToTile( x, y );
			camera.zoom = camera.zoom - camera.zoomspeed;
			local afterX, afterY = tiles.CoordToTile( x, y );

			camera.position.x =  camera.position.x + mouseX * ( Base.Config.TileSize - camera.zoom ) - afterX * ( Base.Config.TileSize - camera.zoom );
			camera.position.y = camera.position.y + mouseY * ( Base.Config.TileSize - camera.zoom ) - afterY * ( Base.Config.TileSize - camera.zoom );
		elseif( button == "wd" ) then
			--Zoom out
			local mouseX, mouseY = tiles.CoordToTile( x, y );
			camera.zoom = camera.zoom + camera.zoomspeed;
			local afterX, afterY = tiles.CoordToTile( x, y );

			camera.position.x =  camera.position.x + mouseX * ( Base.Config.TileSize - camera.zoom ) - afterX * ( Base.Config.TileSize - camera.zoom );
			camera.position.y = camera.position.y + mouseY * ( Base.Config.TileSize - camera.zoom ) - afterY * ( Base.Config.TileSize - camera.zoom );
		end;
	end;
end;
hook.Add( "MousePressed", "camera.Zoom", camera.Zoom );