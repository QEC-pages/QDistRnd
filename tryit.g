SetPackagePath( "qdistrnd","c:/home/leonid/text/progs/gap/distance/qdistrnd");
#SetPackagePath( "qdistrnd","/home/cats/gap-4.11.0/pkg/qdistrnd");
ShowPackageVariables("qdistrnd");
LoadPackage("qdistrnd");

#fname:="../Xw6_n15_k1_d5_q5.mtx";
#
#ReadMTXE(fname);
#lis:=ReadMTXE(fname);
#GG:=lis[3];
#
#Print(lis[4],"\n");
#
#Display(GG);
#
#Print("\n");

#Print("\n");

#Print("\n");
Test("tst/qdistrnd01.tst");
Test("tst/qdistrnd02.tst");

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

# Read("examples/cyclic.g" );

