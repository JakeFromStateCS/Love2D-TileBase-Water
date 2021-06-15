tiles = {};
tiles.stored = {};

function tiles.SetTile( x, y, tileTab )
	if( tiles.stored[y] == nil ) then
		tiles.stored[y] = {};
	end;
	tileTab.renderPos = {
		x = 0,
		y = 0
	}
	tiles.stored[y][x] = tileTab;
end;