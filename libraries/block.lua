block = block or {};

block.Add( "Air", {
	color = Color( 0, 0, 0 ),
	hardness = 0,
	physics = {
		enabled = false
	},
	water = false,
	lava = false
} );

block.Add( "Dirt", {
	color = Color( 158, 81, 25 ),
	hardness = 1,
	physics = {
		enabled = false
	},
	water = false,
	lava = false,
} );

block.Add( "Sand", {
	color = Color( 245, 222, 179 ),
	hardness = 1,
	physics = {
		enabled = true,
		y = 1.5,
		x = 0,
		simulate = function( self )
			self.renderPos.y = self.renderPos.y + self.physics.y;
		end
	},
	water = false,
	lava = false
} );

block.Add( "Water", {
	color = Color( 50, 50, 200, 150 ),
	hardness = 1,
	physics = {
		enabled = true,
		y = 4,
		x = 0
	},
	fullness = 8,
	water = true,
	lava = false
} );


