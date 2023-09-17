module hole( l )
{
difference()
{
rotate( [ 90, 0, 0 ] )
cylinder( r = 6, h = l*1.5, center = true );

for ( a = [ -1, +1 ] )
	translate( [ 0, a*l/2, 0 ] ) rotate( [ 90, 0, 0 ] )
		rotate_extrude()
			translate( [ 6, 0 ] ) circle( r = 3 );

	rotate( [ 90, 0, 0 ] )
	difference()
	{
		cylinder( r = 8, h = l, center = true );
		cylinder( r = 3, h = l*2, center = true );
	}
}
}


difference()
{
union()
{
difference()
{
top();
translate( [ 0, 0, -3 ] )
hole( 14.2, $fn = 24 );
}
center( $fn = 48 );
base( $fn = 48 );
}
for ( a = [ -1, +1 ] )
{
	translate( [ a*10, 0, 0 ] )
		cylinder( r = 4/2, h = 50, center = true );
	translate( [ a*10, 0, +4 ] )
		cylinder( r1 = 4/2, r2 = 10/2, h = 3, center = true );
}
}

module top()
{
intersection()
{
scale( [ 0.8, 1, 0.8 ] ) hull()
{
	translate( [ -50, 0, 0 ] ) sphere( r = 6, $fn = 40 );
	translate( [ +50, 0, 0 ] ) sphere( r = 6, $fn = 40 );
//	translate( [ +5, 0, 0 ] ) sphere( r = 10 );
//	translate( [ -5, 0, 0 ] ) sphere( r = 10 );
//	cube( [ 20, 20, 20 ], center = true );
translate( [ 0, 0, -3] ) scale( [ 2.5, 1, 1 ] ) cylinder( r = 10, h = 18, center = true );
}
translate( [ 0, 0, -6 ] ) cube( [ 120, 30, 25 ], center = true );
}
}

module center()
{
translate( [ 0, 0, -15 ] ) scale( [ 2.5*0.8, 1, 1 ] ) cylinder( r = 10, h = 12, center = true );
}

module base()
{
	translate( [ 0, 0, -20 ] ) scale( [ 2.5*0.8, 1, 1 ] )
	 cylinder( r1 = 12, r2 = 10, h = 4, center = true );
}

/*
intersection()
{
union()
{
scale( [ 1, 1.5, 1 ] ) rotate( [ 0, 90, 0 ] ) capsule( r = 5, h = 80 );

for ( a = [ 0, 180 ] ) rotate( [ 0, 0, a ] )
translate( [ 10, 0, -10 ] ) scale( [ 1, 1.5, 1 ] ) cylinder( r = 5, h = 20, center = true );
translate( [ 0, 0, -20 ] ) scale( [ 1.5, 1.5, 1 ] ) rotate( [ 0, 90, 0 ] ) capsule( r = 5, h = 16 );
}

translate( [ 0, 0, -9 ] ) cube( [ 100, 30, 22 ], center = true );
}
*/

module capsule( r, h )
{
	translate( [ 0, 0, +h/2 ] ) sphere( r = r, center = true );
	cylinder( r = r, h = h, center = true );
	translate( [ 0, 0, -h/2 ] ) sphere( r = r, center = true );
}
