--Hook Library

hook = {};
hook.Hooks = {};

function hook.Add( hookType, hookName, func )
	if( hook.Hooks[hookType] ~= nil ) then
		hook.Hooks[hookType][hookName] = func;
	else
		hook.Hooks[hookType] = {};
		hook.Hooks[hookType][hookName] = func;
	end;
end;

function hook.Remove( hookType, hookName )
	if( hook.Hooks[hookType] ~= nil ) then
		hook.Hooks[hookType][hookName] = nil;
	end;
end;

function hook.Call( hookType, hookName, args )
	if( hook.Hooks[hookType] ~= nil ) then
		if( hook.Hooks[hookType][hookName] ~= nil ) then
			if( args ~= nil ) then
				hook.Hooks[hookType][hookName]( args );
			else
				hook.Hooks[hookType][hookName]();
			end;
		end;
	end;
end;

function hook.CallHooks( hookType, args )
	if( hook.Hooks[hookType] ~= nil ) then
		for hookName,func in pairs( hook.Hooks[hookType] ) do
			local time = CurTime();
			if( args ~= nil ) then
				func( unpack( args ) );
			else
				func();
			end;
			if( Base.Config.Debug ) then
				if( CurTime() - time > 0.15 ) then
					print( "Base - Hook | Slow Hook: " .. hookName .. " ( " .. CurTime() - time .. "s )" );
				end;
			end;
		end;
	end;
end;