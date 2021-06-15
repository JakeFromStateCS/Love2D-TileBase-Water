ents = ents;
ents.stored = {};

function ents.Create( class )
	ENT = {};
	include( "/entities/" .. class .. ".lua" );
	if( ENT.Name ~= nil ) then
		if( Base.Config.Debug ) then
			print( "Base | Created Ent: " .. ENT.Name );
		end;

		if( ents.stored[class] == nil ) then
			ents.stored[class] = {};
		end;
		ENT.UniqueID = #ents.stored[class] + 1;
		table.insert( ents.stored[class], ENT );

		return ents.stored[class][ENT.UniqueID];
	end;

	ENT = nil;
end;

function ents.Draw()
	for index, classTab in pairs( ents.stored ) do
		for index, entTab in pairs( classTab ) do
			if( entTab.Draw ~= nil ) then
				entTab:Draw();
			end;
		end;
	end;
end;
hook.Add( "EntDraw", "ents.Draw", ents.Draw );

function ents.MousePressed( x, y, button )
	if( button == "l" ) then
		--local Testes = ents.Create( "base" );
		--Testes:SetPos( math.random( 1, 100 ), math.random( 1, 100 ) );
	end;
end;
hook.Add( "MousePressed", "ents.MousePressed", ents.MousePressed );