time = {};
time.CurTime = os.time();
time.OldOSTime = os.time;

function time.UpdateTime( dt )
	time.CurTime = time.CurTime + dt;
end;
hook.Add( "Think", "time.UpdateTime", time.UpdateTime );

function CurTime()
	return time.CurTime;
end;

function os.time()
	return CurTime();
end;