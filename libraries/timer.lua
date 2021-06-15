timer = timer or {};

function timer.RunTimers()
	for name,timerTab in pairs( timer.stored ) do
		if( os.time() > timerTab.insertTime + timerTab.delay ) then
			if( Base.Config.Debug ) then
				print( "Base - Timer | Calling Timer: " .. name );
			end;
			timerTab.callFunc();
			timerTab.ranReps = timerTab.ranReps + 1;
			timerTab.insertTime = os.time();
			if( timerTab.ranReps == timerTab.reps ) then
				timer.Destroy( name );
			end;
		end;
	end;
end;
hook.Add( "Think", "timer.RunTimers", timer.RunTimers );