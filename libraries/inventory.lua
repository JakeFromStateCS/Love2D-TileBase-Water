inventory = inventory or {};
inventory.blocks = {};
inventory.quickSelect = {};
inventory.selected = 1;
inventory.quickSlots = 10;
inventory.maxSlots = 30;

for k,v in pairs( block.types ) do
	table.insert( inventory.quickSelect, v );
end;

function inventory.AddBlock( type, blockTab )
	
end;

function inventory.MouseScroll( x, y, button )
	if( inventory.selected < inventory.quickSlots and button == "wd" ) then
		inventory.selected = inventory.selected + 1;
	elseif( inventory.selected > 1 and button == "wu" ) then
		inventory.selected = inventory.selected - 1;
	elseif( inventory.selected == inventory.quickSlots and button == "wd" ) then
		inventory.selected = 1;
	elseif( inventory.selected == 1 and button == "wu" ) then
		inventory.selected = inventory.quickSlots;
	elseif( button == "l" ) then
		local actualX, actualY = tiles.CoordToTile( x, y );
		local block = inventory.quickSelect[inventory.selected];
		if( block ~= nil ) then
			local blockType = inventory.quickSelect[inventory.selected].type;
			print( blockType );
			tiles.SetTileType( actualX, actualY, blockType );
		end;
	elseif( button == "r" ) then
		local actualX, actualY = tiles.CoordToTile( 0, 0 );
		for x=actualX, actualX + ( Base.Config.Resolution.x / ( Base.Config.TileSize - camera.zoom ) ) do
			tiles.SetTileType( x, actualY, "Sand" );
		end;
	end;
	--wd = mouse down
	--wu = mouse up
end;
hook.Add( "MousePressed", "inventory.MouseScroll", inventory.MouseScroll );

function inventory.DrawInventory()
	for i=1, inventory.quickSlots do
		local slot = inventory.quickSelect[i];
		local drawSize = 20;
		local bgColor = Color( 50, 50, 200 );
		if( i == inventory.selected ) then
			--drawSize = 25;
			bgColor = Color( 150, 150, 200 );
		end;
		surface.SetDrawColor( bgColor );
		surface.DrawRect( 20 + i * drawSize + i * 5, 20, drawSize, drawSize );
		if( slot ~= nil ) then
			surface.SetDrawColor( slot.color );
			surface.DrawRect( 20 + 10 + i * drawSize - 5 + i * 5, 20 + 5, drawSize - 10, drawSize - 10 );
		end;
	end;
end;
hook.Add( "HUDPaint", "inventory.DrawInventory", inventory.DrawInventory );