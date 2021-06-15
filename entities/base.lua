--Base ent that other ents will..be based on?..lol
ENT = ENT or {};
ENT.Pos = {
	x = 0,
	y = 0
};
ENT.Velocity = {
	x = 0,
	y = 0
};
ENT.Color = Color( 255, 255, 255 );
ENT.UniqueID = 0;


ENT.Name = "Base";
ENT.Author = "Blasphemy";



--Getting and setting things
function ENT:GetPos()
	return self.Pos;
end;

function ENT:SetPos( x, y )
	self.Pos.x = x;
	self.Pos.y = y;
end;

function ENT:GetVelocity()
	return self.Velocity;
end;

function ENT:SetVelocity( x, y )
	self.Velocity.x = x;
	self.Velocity.y = y;
end;

function ENT:UniqueID()
	return self.UniqueID;
end;

function ENT:SetColor( color )
	self.Color = color;
end;

function ENT:Remove()
	if( ents.stored[self.UniqueID] ~= nil ) then
		table.remove( ents.stored, self.UniqueID );
	end;
end;



--Hooks and stuff
function ENT:Draw()
	local renderX, renderY = self.Pos.x - camera.position.x, self.Pos.y - camera.position.y;
	surface.SetDrawColor( self.Color );
	surface.DrawRect( renderX, renderY, 10, 10 );
end;

function ENT:Think()

end;