## 
## this is to run the tests 
##
SetPackagePath( "qdistrnd",".");
# read the actual code.
## SetInfoLevel(InfoPackageLoading,4); # use if loading error
LoadPackage("qdistrnd");
ShowPackageVariables("qdistrnd");

Test("tst/qdistrnd01.tst");
Test("tst/qdistrnd02.tst");
Test("tst/qdistrnd03.tst");
#Test("tst/qdistrnd04.tst");

## additional tests (may take a few actual minutes to run)
## change 'false' to 'true' in the line below to enable 
if true then 
    Read("lib/cyclic.g" );
fi;

## yet more additional tests 
if false then 
    q:=2;; F:=GF(q);; n:=7;;
    x:=Indeterminate(F,"x");
    p1:=One(F)*(1+x)^3*(1+x+x^3)^2;
    p2:=Quotient(One(F)*(1+x^(2*n)),One(F)*(1+x^2));
    Print("p1=",p1,"\n");
    Print("p2=",p2,"\n");
    #One(F)*(1+x^2+x^4+x^6+x^8);
    mat:=Concatenation(QDR_DoCirc(p1,2*n,2*n,F),
                       QDR_DoCirc(p2,1,2*n,F));
    k:=n-RankMat(mat);
    Display(mat);
    Print("k=",k,"\n");
    if  k>0 then
        d:=DistRandStab(mat,100,0,15 : field:=F);
    fi;
fi;


