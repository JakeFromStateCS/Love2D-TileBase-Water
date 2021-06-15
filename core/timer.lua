timer = {};
timer.stored = {};

function timer.Create( name, delay, reps, callFunc )
	if( Base.Config.Debug ) then
		print( "Base - Timer | Creating Timer: " .. name );
	end;
	timer.stored[name] = {
		insertTime = os.time(),
		delay = delay,
		reps = reps,
		ranReps = 0,
		callFunc = callFunc
	};
end;

function timer.Simple( delay, callFunc )
	local name = "timer_" .. ( #timer.stored + 1 );
	timer.Create( name, delay, 1, callFunc );
end;

function timer.Destroy( name )
	if( Base.Config.Debug ) then
		print( "Base - Timer | Destroying Timer: " .. name );
	end;
	timer.stored[name] = nil;
end;