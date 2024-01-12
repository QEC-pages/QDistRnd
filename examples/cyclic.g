#! This code searches for one-generator quantum cyclic
#! codes of length 15 over $GF(8)$, with stabilizer generators of weight 6, 
#! by going over 10000 random
#! polynomials of each degree from 4 to 15.  It takes just a couple minutes on a
#! typical notebook.
AUTODOC_CreateDirIfMissing("tmp");;
q:=8;; F:=GF(q);; wei:=6;; x:=Indeterminate(F,"x");; n:=15;;
dmax:=0*[1..n];  # record the max degrees for the reference 
for deg in [wei-1..n-1] do # polynomial degree
    for l in [1..10000] do    # number of attempts at this degree
        poly:=One(F);
        j:=0;              # free term is always 1
        for i in [2..wei-1] do
            c:=PrimitiveElement(F)^Random([1..q-1]);
            j:=Random([j+1..deg-wei+i]);
            poly:=poly+c*x^(2*j+Random([0,1])); # X or Z
        od;
        c:=PrimitiveElement(F)^Random([1..q-1]);
        poly:=poly+c*x^(2*deg+Random([0,1]));;        
        G:=QDR_DoCirc(poly,n,2*n,F);
        H:=QDR_MakeH(G,F);;
        
        if QDR_WeightMat(G*TransposedMat(H))=0 then
       
            k:=n-RankMat(G);
            if  k>0 then
                if dmax[k]>1 then dmin:=dmax[k]; else dmin:=2; fi;                
                d:=DistRandStab(G,10000,dmin,0 : field:=F, maxav:=20/n);
                # cyclic code; this gives exp(-20) probability
                if d>dmax[k] then
                    dmax[k]:=d;
                    Print("l=",l," ",poly,"\n");
                    fname:=Concatenation("tmp/X","w",String(wei),"_n",String(n),"_k",
                                         String(k),"_d",String(d),"_q",String(q),".mtx");                                
                    Print("Writing ","w=",String(wei),
                          " code [[",String(n),",",String(k),",",String(d),"]]_",
                          String(q),"\n");
                    WriteMTXE(fname,3,G,
                              Concatenation("% code [[",
                                            String(n),",",String(k),",",String(d),
                                            "]]_",String(q)),
                              Concatenation("% cyclic w=",String(wei)," ",String(poly))
                                           : field:=F);                      
                fi;
            fi;
        fi;
    od;
od;
Print(dmax);
