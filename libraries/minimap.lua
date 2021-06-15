minimap = {};
minimap.size = 100;

function minimap.Draw()
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	surface.DrawRect( ScrW() - minimap.size, 0, minimap.size, minimap.size );
	for y=1 + camera.position.y, minimap.size + camera.position.y do
		for x=1 + camera.position.x, minimap.size + camera.position.x do
			if( tiles.stored[y] ~= nil ) then
				if( tiles.stored[y][x] ~= nil ) then
					local tile = tiles.stored[y][x];
					surface.SetDrawColor( tile.color );
					surface.DrawPoint( ScrW() - minimap.size + x - camera.position.x, y - camera.position.y );
				end;
			end;
		end;
	end;
end;
--hook.Add( "PostTileDraw", "minimap.Draw", minimap.Draw );