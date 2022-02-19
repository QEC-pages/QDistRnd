# QDistRnd, chapter 2
#
# DO NOT EDIT THIS FILE - EDIT EXAMPLES IN THE SOURCE INSTEAD!
#
# This file has been generated by AutoDoc. It contains examples extracted from
# the package documentation. Each example is preceded by a comment which gives
# the name of a GAPDoc XML file and a line range from which the example were
# taken. Note that the XML file in turn may have been generated by AutoDoc
# from some other input.
#
gap> START_TEST( "qdistrnd01.tst");

# doc/_Chapter_Examples.xml:20-38
gap> q:=3;; F:=GF(q);; 
gap> x:=Indeterminate(F,"x");; poly:=One(F)*(1+x^3-x^5-x^6);;
gap> n:=5;;
gap> mat:=QDR_DoCirc(poly,n-1,2*n,F);; #construct circulant matrix with 4 rows 
gap> Display(mat);
 1 . . 1 . 2 2 . . .
 . . 1 . . 1 . 2 2 .
 2 . . . 1 . . 1 . 2
 . 2 2 . . . 1 . . 1
gap> d:=DistRandStab(mat,100,1,0 : field:=F,maxav:=20/n);
3
gap> AUTODOC_CreateDirIfMissing("tmp");;
gap> WriteMTXE("tmp/n5_q3_complex.mtx",3,mat,
>         "% The 5-qubit code [[5,1,3]]_3",
>         "% Generated from h(x)=1+x^3-x^5-x^6",
>         "% Example from the QDistRnd GAP package"   : field:=F);
File tmp/n5_q3_complex.mtx was created

# doc/_Chapter_Examples.xml:79-90
gap> lis:=ReadMTXE("tmp/n5_q3_complex.mtx");;  
gap> lis[1]; # the field 
GF(3)
gap> lis[2]; # converted to `mode=1`
1
gap> Display(lis[3]);
 1 . . 1 . 2 2 . . .
 . . 1 . . 1 . 2 2 .
 2 . . . 1 . . 1 . 2
 . 2 2 . . . 1 . . 1

# doc/_Chapter_Examples.xml:113-120
gap> lisX:=ReadMTXE(Filename(DirectoriesPackageLibrary("QDistRnd","matrices"),"QX80.mtx",0);;
gap> GX:=lisX[3];;
gap> lisZ:=ReadMTXE(Filename(DirectoriesPackageLibrary("QDistRnd","matrices"),"QZ80.mtx",0);;
gap> GZ:=lisZ[3];;
gap> DistRandCSS(GX,GZ,100,1,2:field:=GF(2));
5

#
gap> STOP_TEST("qdistrnd01.tst", 1 );
