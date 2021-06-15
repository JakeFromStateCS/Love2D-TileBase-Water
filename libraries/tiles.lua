tiles = tiles or {};
local tileSize = Base.Config.TileSize;

function tiles.GenerateChunk( x, y )
	for blockY=y, y + Base.Config.ChunkSize do
		if( tiles.stored[blockY] == nil ) then
			tiles.stored[blockY] = {};
		end;
		for blockX=x, x + Base.Config.ChunkSize do
			if( tiles.stored[blockY][blockX] == nil ) then
				if( blockY > 10 ) then
					local types = {
						"Air",
						"Dirt",
						"Sand"
					}
					local blockType = types[math.random( 1, 3 )];
					tiles.SetTileType( blockX, blockY, blockType );
				elseif( block == 10 ) then
					tiles.SetTileType( blockX, blockY, "Dirt" );
				else
					tiles.SetTileType( blockX, blockY, "Air" );
				end;
			end;
		end;
	end;
end;

function tiles.CoordToTile( x, y )
	local actualX, actualY = math.ceil( ( ( x - tileSize - camera.zoom ) + camera.position.x ) / ( tileSize - camera.zoom ) ) + 1, math.ceil( ( y + camera.position.y ) / ( tileSize - camera.zoom ) );
	return actualX, actualY;
end;

function tiles.TileToCoord( x, y )
	if( tiles.stored[y] ~= nil ) then
		if( tiles.stored[y][x] ~= nil ) then
			local actualX, actualY = math.ceil( ( ( x + tileSize - camera.zoom ) - camera.position.x ) / ( tileSize - camera.zoom ) ) - 1, math.ceil( ( y - camera.position.y ) / ( tileSize - camera.zoom ) );
			return actualX, actualY;
		end;
	end;
end;

function tiles.SetTileType( x, y, tileType )
	if( block.types[tileType] ~= nil ) then
		if( tiles.stored[y] == nil ) then
			tiles.stored[y] = {};
		end;
		tiles.stored[y][x] = {};
		for k,v in pairs( block.types[tileType] ) do
			tiles.stored[y][x][k] = v;
		end;
		tiles.stored[y][x].renderPos = {
			x = 0,
			y = 0
		};
		tiles.stored[y][x].renderSize = {
			w = 0,
			h = 0
		};
	end;
end;

function tiles.TileClick( x, y, button )
	local actualX, actualY = tiles.CoordToTile( x, y );
	if( button == "l" ) then
		--tiles.SetTileType( actualX, actualY, "Water" );
	elseif( button == "r" ) then
		--local fullness = tiles.stored[actualY][actualX].fullness or 0;
		--print( fullness );
	end;
end;
hook.Add( "MousePressed", "tiles.TileClick", tiles.TileClick );

function tiles.DrawTiles()
	local minX, maxX, minY, maxY = camera.GetBounds();
	for y=minY, maxY do
		for x=minX, maxX do
			local tileRow = tiles.stored[y];
			if( tileRow ~= nil ) then
				local tile = tileRow[x];
				if( tile ~= nil ) then
					if( tile.type ~= "Air" ) then
						if( tile.lightSource ) then
							--Fuk u
						end;
						local renderX, renderY = ( x - 1 ) * ( tileSize - camera.zoom ) - camera.position.x, ( y - 1 ) * ( tileSize - camera.zoom ) - camera.position.y;
						if( Base.Config.Drugs ) then
							renderY = renderY + math.cos( x + CurTime() * 5 ) * 5;
						end;
						if( Base.Config.Outline ) then
							surface.SetDrawColor( Color( 150, 150, 150 ) );
							surface.DrawRect( renderX + tile.renderPos.x, renderY + tile.renderPos.y, tileSize - camera.zoom, tileSize - camera.zoom );
							surface.SetDrawColor( tile.color );
							surface.DrawRect( renderX + tile.renderPos.x + 1, renderY + tile.renderPos.y + 1, tileSize - camera.zoom - 2, tileSize - camera.zoom - 2 );
						else
							if( tile.water == false and tile.lava == false ) then
								surface.SetDrawColor( tile.color );
								surface.DrawRect( renderX + tile.renderPos.x, renderY + tile.renderPos.y, tileSize - camera.zoom - tile.renderSize.w, tileSize - camera.zoom - tile.renderSize.h );
							else
								surface.SetDrawColor( tile.color );
								surface.DrawRect( renderX + tile.renderPos.x, renderY + tile.renderPos.y + ( tileSize * ( 1 - tile.fullness / 8 ) ), tileSize - camera.zoom - tile.renderSize.w, ( tileSize - camera.zoom ) * ( tile.fullness / 8 ) );
							end;
						end;
					end;
				else
					--print( "Generating " .. y .. ", " .. minX );
					tiles.GenerateChunk( x, y );
					--return;
				end;
			else
				--print( "Generating " .. y .. ", " .. minX );
				tiles.GenerateChunk( x, y );
				--return;
			end;
		end;
	end;
end;
hook.Add( "TileDraw", "tiles.drawTiles", tiles.DrawTiles );

function tiles.SimulateLiquid( x, y )
	local tileRow = tiles.stored[y];
	local tile = tileRow[x];
	local blocks = {
		left = tiles.stored[y][x-1],
		right = tiles.stored[y][x+1],
		up = tiles.stored[y-1][x],
		down = tiles.stored[y+1][x]
	};

	if( blocks.down ~= nil ) then
		if( blocks.down.type == "Air" ) then
			local fullness = tile.fullness;
			tiles.SetTileType( x, y, "Air" );
			tiles.SetTileType( x, y + 1, tile.type );
			tiles.stored[y+1][x].fullness = fullness;
		else
			if( blocks.down.type == "Water" ) then
				local level = blocks.down.fullness;
				if( level < 8 and level >= 1 ) then
					if( tile.fullness >= 2 ) then
						local addAmount = 1;
						tile.fullness = tile.fullness - addAmount;
						blocks.down.fullness = blocks.down.fullness + addAmount;
					elseif( tile.fullness < 2 ) then
						tiles.SetTileType( x, y, "Air" );
					else
						tiles.SetTileType( x, y, "Air" );
						blocks.down.fullness = 8;
					end;
				end;
			end;
		end;
	end;
	if( blocks.left ~= nil ) then
		if( blocks.left.type == "Air" ) then
			if( tile.fullness >= 2 ) then
				tile.fullness = tile.fullness - 1;
				tiles.SetTileType( x - 1, y, "Water" );
				tiles.stored[y][x-1].fullness = 1;
			elseif( tile.fullness < 2 ) then
				tiles.SetTileType( x, y, "Air" );
			else
				tiles.SetTileType( x, y, "Air" );
				tiles.SetTileType( x - 1, y, "Water" );
				tiles.stored[y][x-1].fullness = tile.fullness;
			end;
		end;
		if( blocks.left.type == "Water" ) then
			if( tile.fullness > blocks.left.fullness ) then
				local addAmount = 1
				tile.fullness = tile.fullness - addAmount;
				blocks.left.fullness = blocks.left.fullness + addAmount;
			elseif( tile.fullness < blocks.left.fullness ) then
				local addAmount = -1
				tile.fullness = tile.fullness - addAmount;
				blocks.left.fullness = blocks.left.fullness + addAmount;
			end;
		end;
	end;
	if( blocks.right ~= nil ) then
		if( blocks.right.type == "Air" ) then
			if( tile.fullness >= 2 ) then
				tile.fullness = tile.fullness / 2;
				tiles.SetTileType( x + 1, y, "Water" );
				tiles.stored[y][x+1].fullness = tile.fullness;
			elseif( tile.fullness < 2 ) then
				tiles.SetTileType( x, y, "Air" );
			else
			tiles.SetTileType( x, y, "Air" );
			tiles.SetTileType( x + 1, y, "Water" );
			tiles.stored[y][x+1].fullness = tile.fullness;
			end;
		end;
		if( blocks.right.type == "Water" ) then
			if( tile.fullness > blocks.right.fullness ) then
				local addAmount = 1
				tile.fullness = tile.fullness - addAmount;
				blocks.right.fullness = blocks.right.fullness + addAmount;
			elseif( tile.fullness < blocks.right.fullness ) then
				local addAmount = -1
				tile.fullness = tile.fullness - addAmount;
				blocks.right.fullness = blocks.right.fullness + addAmount;
			end;
		end;
	end;
end;

function tiles.SimulateTiles( dt )
	local minX, maxX, minY, maxY = camera.GetBounds();
	for y=minY - Base.Config.ChunkSize, maxY + Base.Config.ChunkSize do
		for x=minX - Base.Config.ChunkSize, maxX + Base.Config.ChunkSize do
			local tileRow = tiles.stored[y];
			if( tileRow ~= nil ) then
				local tile = tileRow[x];
				if( tile ~= nil ) then
					if( tile.type == "Sand" ) then
						--for k,v in pairs( tile ) do
						--	if( type( v ) == "table" ) then
						--		print( k );
						--		for k,v in pairs( v ) do
						--			print( tostring( k ) .. " " .. tostring( v ) );
						--		end;
						--	else
						--		print( tostring( k ) .. " " .. tostring( v ) );
						--	end;
						--end;
						--print( "==================" );
						--return;

						--block.types["Sand"].physics.enabled = false;
					end;
					if( tile.physics.enabled ) then
						if( tile.water == false and tile.lava == false ) then
							--tile.renderPos.x = tile.renderPos.x + tile.physics.x;

							local belowTileRow = tiles.stored[y+1];
							local belowTile = nil;
							if( belowTileRow ) then
								belowTile = belowTileRow[x];
							end;
							if( belowTile ~= nil ) then
								if( belowTile.type == "Air" or belowTile.type == tile.type and belowTile.renderPos.y > 0 ) then
									if( tile.renderPos.y >= Base.Config.TileSize ) then

										--tile.renderPos.y = 0;
										local speed = tile.physics.y;
										tiles.SetTileType( x, y, "Air" );
										tiles.SetTileType( x, y + 1, tile.type );
										--tiles.stored[y+1][x].physics.y = speed;
										--tile.renderPos.y = 0;
										--return;
									else
										--print( tile.renderPos.y );
										--print( tile.renderPos.y );
										tile.renderPos.y = tile.renderPos.y + tile.physics.y;
										--tile.physics.y = tile.physics.y + Base.Config.GravityAccel;
										--print( block.types["Sand"].renderPos.y );
										--return
									end;
								end;
							end;
						else
							tiles.SimulateLiquid( x, y );
						end;
					end;
				end;
			end;
		end;
	end;
end;
hook.Add( "Think", "tiles.SimulateTiles", tiles.SimulateTiles );
