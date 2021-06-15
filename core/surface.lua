--Surface Shit son

function Color( r, g, b, a )
	local col = {
		r = r,
		g = g,
		b = b,
		a = 255
	};
	if( a ~= nil ) then
		col.a = a;
	end;
	return col;
end;

function HSL(hue, saturation, lightness, alpha)
    if hue < 0 or hue > 360 then
        return 0, 0, 0, alpha
    end
    if saturation < 0 or saturation > 1 then
        return 0, 0, 0, alpha
    end
    if lightness < 0 or lightness > 1 then
        return 0, 0, 0, alpha
    end
    local chroma = (1 - math.abs(2 * lightness - 1)) * saturation
    local h = hue/60
    local x =(1 - math.abs(h % 2 - 1)) * chroma
    local r, g, b = 0, 0, 0
    if h < 1 then
        r,g,b=chroma,x,0
    elseif h < 2 then
        r,b,g=x,chroma,0
    elseif h < 3 then
        r,g,b=0,chroma,x
    elseif h < 4 then
        r,g,b=0,x,chroma
    elseif h < 5 then
        r,g,b=x,0,chroma
    else
        r,g,b=chroma,0,x
    end
    local m = lightness - chroma/2
    return r+m,g+m,b+m,alpha
end

surface = {};
surface.Font = love.graphics.newFont( 12 );
surface.DrawColor = Color( 255, 255, 255, 255 );

function surface.SetDrawColor( color )
	if( surface.DrawColor.r == color.r and surface.DrawColor.g == color.g and surface.DrawColor.b == color.b and surface.DrawColor.a == color.a ) then
		return;
	end;
	surface.DrawColor = color;
	love.graphics.setColor( surface.DrawColor.r, surface.DrawColor.g, surface.DrawColor.b, surface.DrawColor.a );
end;

function surface.DrawRect( x, y, w, h )
	love.graphics.rectangle( "fill", x, y, w, h );
end;

function surface.DrawCircle( x, y, radius )
	love.graphics.circle( "fill", x, y, radius );
end;

function surface.DrawTexturedRect( x, y, texture )
	love.graphics.draw( texture, x, y );
end;

function surface.SetTextSize( size )
	surface.Font = love.graphics.newFont( size );
end;

function surface.DrawText( x, y, text )
	love.graphics.setFont( surface.Font );
	love.graphics.print( text, x, y );
end;

function surface.DrawPoint( x, y )
	love.graphics.point( x, y );
end;