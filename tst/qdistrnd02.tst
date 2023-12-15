# QDistRnd, chapter 4
#
# DO NOT EDIT THIS FILE - EDIT EXAMPLES IN THE SOURCE INSTEAD!
#
# This file has been generated by AutoDoc. It contains examples extracted from
# the package documentation. Each example is preceded by a comment which gives
# the name of a GAPDoc XML file and a line range from which the example were
# taken. Note that the XML file in turn may have been generated by AutoDoc
# from some other input.
#
gap> START_TEST( "qdistrnd02.tst");

# doc/_Chapter_AllFunctions.xml:19-25
gap> F:=GF(5);;
gap> Hx:=One(F)*[[1,-1,0,0 ],[0,0,1,-1]];;
gap> Hz:=One(F)*[[1, 1,1,1]];;
gap> DistRandCSS(Hz,Hx,100,0,2 : field:=F);
2

# doc/_Chapter_AllFunctions.xml:32-35
gap> DistRandCSS(Hz,Hx,100,2,2 : field:=F);
-2

# doc/_Chapter_AllFunctions.xml:42-49
gap> F:=GF(5);;
gap> H:=One(F)*[[1,0, -1,0,  0,0,  0,0 ], # original Hx in odd positions
>            [0,0,  0,0,  1,0, -1,0 ],
>            [0,1,  0,1,  0,1,  0,1 ]];; # original Hz in even positions
gap> DistRandStab(H,100,0,2 : field:=F);
2

# doc/_Chapter_AllFunctions.xml:73-76
gap> QDR_AverageCalc([2,3,4,5]);
3.5

# doc/_Chapter_AllFunctions.xml:79-90
gap> F:=GF(3);; 
gap> x:=Indeterminate(F,"x");; poly:=One(F)*(1-x);;
gap> n:=5;;
gap> mat:=QDR_DoCirc(poly,n,2*n,F);; # make a circulant matrix with 5 rows 
gap> Display(mat);
 1 2 . . . . . . . .
 . . 1 2 . . . . . .
 . . . . 1 2 . . . .
 . . . . . . 1 2 . .
 . . . . . . . . 1 2

#
gap> STOP_TEST("qdistrnd02.tst", 1 );
