// GENERAL SETTINGS
compx = 52;	// Size of compartments, X
compy = 70;	// Size of compartments, Y
wall = 2.5;		// Width of wall
nox = 2;		// Number of compartments, X
noy = 3;		// Number of compartments, Y
deep = 45;		// Depth of compartments
tolerance=.15;	// Tolerance around lid.  If it's too tight, increase this. 
				// If it's too loose, decrease it.

// WHAT TO RENDER
showbox=true;	// Whether or not to render the box
showlid=true;	// Whether or not to render the lid


// LID SETTINGS
lidtype=1;	// 0=Flat lid.  Use "1" for lid that slides off in the x direction
includethumbhole=false;
includecoinslot=true;
coinx=2.5;	// US coinage (penny, nickel, quarter dime) in X direction
coiny=26;	// swap values for slot in Y direction
ztolerance=0;
				// Z tolerance can be tweaked separately, to make the top of the sliding lid
				// be flush with the top of the box itself.  Default is zero.  Warning: this also
				// adds wiggle room to the lid, so !
lidoffset=3;		// This is how far away from the box to print the lid
lidheight=16;		// Height of lid (duh) MUST be greater than wall width for a type=0 lid to work.



totalheight = deep + (lidtype*wall);
thumbrad = min(20,noy*(compy+wall)/3);

if (showbox) {
difference() {
	cube ( size = [nox * (compx + wall) + wall, noy * (compy + wall) + wall, (totalheight + wall)], center = false);


	for ( ybox = [ 0 : noy - 1])
		{
             for( xbox = [ 0 : nox - 1])
			{
			translate([ xbox * ( compx + wall ) + wall, ybox * ( compy + wall ) + wall, wall])
			cube ( size = [ compx, compy, totalheight+1 ]);
			}
		}
	if (lidtype==1) {
			translate ([0,wall/2,deep+wall]) 
			polyhedron ( points = [   
							[0,0,0], 
							[0,noy*(compy+wall),0], 
							[nox*(compx+wall)+wall/2,0,0], 
							[nox*(compx+wall)+wall/2,noy*(compy+wall),0],
							[0,wall/2,wall], 
							[0,noy*(compy+wall)-wall/2,wall], 
							[nox*(compx+wall)+wall/2,wall/2,wall], 
							[nox*(compx+wall)+wall/2,noy*(compy+wall)-wall/2,wall]
							],
						triangles = [ 
							[0,2,1], [1,2,3], [4,5,6], [5,7,6]	,		// top and bottom
							[0,4,2], [4,6,2], [5,3,7], [5,1,3]	,		// angled sides
							[0,1,4], [1,5,4], [2,6,3], [3,6,7]			// trapezoidal ends
							]);
			translate ([0,wall/2,deep+wall-ztolerance])
			cube (size=[nox*(compx+wall)+wall/2,noy*(compy+wall),ztolerance],center=false);
			}

	}
}

if (showlid) {
translate ([0,noy*(compy+wall)+wall+lidoffset,0])
difference () { union () {	// for including coin slot
	if (lidtype==1) { 
		difference () {
		polyhedron ( points = [   
						[0,0,0], 
						[0,noy*(compy+wall)-2*tolerance,0], 
						[nox*(compx+wall)-tolerance+wall/2,0,0], 
						[nox*(compx+wall)-tolerance+wall/2,noy*(compy+wall)-2*tolerance,0],
						[0,wall/2,wall], 
						[0,noy*(compy+wall)-wall/2-2*tolerance,wall], 
						[nox*(compx+wall)-tolerance+wall/2,wall/2,wall], 
						[nox*(compx+wall)-tolerance+wall/2,noy*(compy+wall)-wall/2-2*tolerance,wall]
						],
					triangles = [ 
						[0,2,1], [1,2,3], [4,5,6], [5,7,6]	,		// top and bottom
						[0,4,2], [4,6,2], [5,3,7], [5,1,3]	,		// angled sides
						[0,1,4], [1,5,4], [2,6,3], [3,6,7]			// trapezoidal ends
						]);
		// Thumb hole
		if (includethumbhole==true) {
			intersection () {
			translate ([min(8,nox*(compx+wall)/8),(noy*(compy+wall))/2,thumbrad+wall/2]) sphere (r=thumbrad, center=true, $fn=60);
			translate ([min(8,nox*(compx+wall)/8),0,0]) cube (size=[20,(noy*(compy+wall)),20], center=false);
		}
	}

		}
	} else {

	difference() {
	cube ( size = [nox * (compx + wall) + 3 * wall + 2* tolerance, noy * (compy + wall) + 3 * wall + 2*tolerance, lidheight], center = false);

	translate ([wall,wall,wall])
	cube ( size = [nox * (compx + wall) +wall+tolerance, noy * (compy + wall) + wall + tolerance, lidheight+1], center = false);
	}
} // if lidtype
} // union
if (includecoinslot==true) {
	for ( yslot = [ 0 : noy - 1])
		{
             for( xslot = [ 0 : nox - 1])
			{
			translate([ xslot * ( compx + wall ) + (2-lidtype)*wall + (compx-coinx)/2, yslot * ( compy + wall ) + wall*(2-3*lidtype/2) + (compy-coiny)/2, 0])
			cube ( size = [ coinx, coiny, wall ]);
			}
		}
	}
} //difference
} // if showlid



