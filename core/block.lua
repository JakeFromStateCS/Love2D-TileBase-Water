block = {};
block.types = {};

function block.Add( name, blockTab )
	blockTab.type = name;
	block.types[name] = blockTab;
end;