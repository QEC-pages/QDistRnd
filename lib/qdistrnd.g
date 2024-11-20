# Functions for finding an upper bound on the distance of a quantum code
# linear over a Galois Field F [for regular qubit code F is GF(2)]
#
# Written by
# Vadim A. Shabashov <vadim.art.shabashov@gmail.com>
# Valerii K. Kozin <kozin.valera@gmail.com>
# Leonid P. Pryadko <leonid.pryadko@gmail.com>



############################
#! @Chapter AllFunctions
#! @Section HelperFunctions



#! @Description Calculate the average of the components of a numerical `vector`
#! @Arguments vector
#DeclareGlobalFunction("QDR_AverageCalc");
BindGlobal("QDR_AverageCalc",
                     function(mult)
                         return 1.0*Sum(mult)/Length(mult);
                     end
                     );





#! @Description Calculate the symplectic weight of a `vector` with
#! an even number of entries from the field `field`.   The elements of
#! the pairs are
#! intercalated: $(a_1, b_1, a_2, b_2,\ldots)$.
#! 
#! **Note: the parity of vector `length` and the format are not verified!!!**
#! @Returns symplectic weight of a vector 
#! @Arguments vector, field
#DeclareGlobalFunction("QDR_SymplVecWeight");        
BindGlobal("QDR_SymplVecWeight",
                     function(vec, F)
                         local wgt, i, len;
    # local variables: wgt - the weight, i - for "for" loop, len - length of vec
                         
                         len := Length(vec);
    #    if (not IsInt(len / 2)) then
    #   Error(" symplectic vector must have even length, = ", len,"\n");
    #    fi;

                         wgt := 0;
                         for i in [1..(len/2)] do
                             if (vec[2*i-1] <> Zero(F) or vec[2*i] <> Zero(F)) then
                                 wgt := wgt + 1;;
                             fi;
                         od;

                         return wgt;
                     end
                     );

#! @Description count the total number of non-zero entries in a matrix.
#! @Arguments matrix
#! @Returns number of non-zero elements
DeclareGlobalFunction("QDR_WeightMat");
InstallGlobalFunction("QDR_WeightMat",
                     function(mat)
                         local NonZeroElem,i,rows;
                         rows:=DimensionsMat(mat)[1];
                         NonZeroElem:=0;
                         for i in [1..rows] do
                             NonZeroElem:=NonZeroElem+WeightVecFFE(mat[i]);
                         od;
                         return NonZeroElem;
                     end
                     );
                      

#! @Description Aux function to print out the relevant probabilities given
#! the list `vector` of multiplicities of the codewords found.  Additional
#! parameters are `n`, the code length, and `num`, the number of
#! repetitions; these are ignored in the present version of the
#! program.  See <Ref Sect="Section_Empirical"/> for 
#! related discussion.
#! @Arguments vector, n, num
#! @Returns nothing
DeclareGlobalFunction("QDR_DoProbOut");
InstallGlobalFunction("QDR_DoProbOut",
                     function(mult,n,num)
                         local s0,s1,s2;
                         Print("<n>=", QDR_AverageCalc(mult));
                         s0:=Length(mult);
                         if s0>1 then
                             s1:=Sum(mult);
                             s2:=Sum(mult, x->x^2);
                             Print(" X^2_",s0-1,"=",Float(s2*s0-s1^2)/s1, "\n");
                         # Here the expression is due to the map to
                         # multinomial distribution (divide by the total) and the quantity is
                         # supposed to be distributed by chi^2 with s0-1 degrees of freedom.
                         else
                             Print("\n");
                         fi;
                     end
                     );

#! @Description Parse a string describing a Galois field
#! Supported formats: `Z(p)`, `GF(q)`, and `GF(q^m)`,
#! where `p` must be a prime, `q` a prime or a power of a prime, and `m` a natural integer.  
#! No spaces are allowed.
#! @Returns the corresponding Galois field
#! @Arguments str
#DeclareGlobalFunction("QDR_ParseFieldStr");
BindGlobal("QDR_ParseFieldStr",
                     function(str)
                         local body, q;                         
                         if EndsWith(str,")") then 
                             if StartsWith(str,"Z(") then 
                                 body := str{[3..Length(str)-1]};
                                 q := Int(body);
                                 if IsInt(q) and IsPrimeInt(q) then
                                     return Z(q);
                                 else
                                     Print("\n Argument of ",str,"should be prime\n");
                                 fi;
                             elif StartsWith(str,"GF(") then 
                                 body := str{[4..Length(str)-1]};
                                 q := Int(body);
                                 if IsInt(q) then 
                                     if IsPrimePowerInt(q) then
                                         return GF(q);
                                     fi;
                                 else 
                                     q := SplitString(body,"^");
                                     if Length(q) = 2 then
                                         if IsInt(Int(q[1])) and 
                                            IsInt(Int(q[2])) and 
                                            IsPrimePowerInt(Int(q[1])^Int(q[2]))
                                         then
                                             return GF(Int(q[1])^Int(q[2]));
                                         fi;
                                     fi;
                                 fi;
                                 Print("\n Argument of ",str,"should be a prime power\n");
                             fi;
                         fi;
                         Error("\n QDR_ParseFieldStr: Invalid argument format str=",str,
                               "\n valid format: 'GF(p)', 'Z(p)', 'GF(p^m)', 'GF(q)'",
                               "\n with 'p' prime, 'm' positive integer, and 'q' a prime power\n");
                     end
                     );

#! @Description Parse string `str` as a polynomial over the field `F`.
#! Only characters in "0123456789*+-^x" are allowed in the string. 
#! In particular, no spaces are allowed.
#! @Returns the corresponding polynomial
#! @Arguments F, str
#DeclareGlobalFunction("QDR_ParsePolyStr");
BindGlobal("QDR_ParsePolyStr", 
          function(F, str)
              local func, new_str;
              # make sure `str` only contains these characters 
              new_str := String(str); # copy
              RemoveCharacters(new_str,"0123456789x*+-^");
              if (Length(new_str) > 0) then 
                  Error("QDR_ParsePolyStr: invalid character(s) [",new_str,"] in polynomial ",str);
              fi;              
              
              func := EvalString(Concatenation("""
                function(F)   
                  local x;       
                  x := Indeterminate(F,"x");
                  return """, str, """;
                end
                """));
              return func(F);
          end);

#! @Description Create a header string describing the field `F`
#! for use in the function `WriteMTXE`.
#! If `F` is a prime Galois field, just specify it: 
#! @BeginCode
#! % Field: GF(p)
#! @EndCode
#! For an extension field $\mathop{\rm GF}(p^m)$ with $p$ prime and $m>1$, also give 
#! the primitive polynomial **which should not contain any spaces**.  For example,  
#! @BeginCode
#! % Field: GF(7^4) PrimitiveP(x): x^4-2*x^2-3*x+3
#! @EndCode
#! See Chapter <Ref Chap="Chapter_FileFormat"/> for details.
#! @Returns the created header string 
#! @Arguments F
#DeclareGlobalFunction("QDR_FieldHeaderStr");
BindGlobal("QDR_FieldHeaderStr",
                     function(F) # field F
                         local p,m, poly,lis,i,j, b, str, out;
                         if not IsField(F) then 
                             Error("\n Argument must be a Galois Field! F=",F,"\n");
                         fi;                         
                         p:=Characteristic(F);    
                         # for some reason DegreeOverPrimeField does
                         # not work
                         m:=DegreeFFE(PrimitiveElement(F));  # field GF(p^m);          
                         str:="";
                         out:=OutputTextString(str,false);; 
                         PrintTo(out,"% Field: ", F);  # this is it for a prime field
                         if not IsPrimeField(F) then   
                             poly:=DefiningPolynomial(F);                         
                             lis:=CoefficientsOfUnivariatePolynomial(poly);
                             PrintTo(out," PrimitiveP(x): ");                             
                             for i in [0..m] do 
                                 j:=m-i;    # degree     
                                 b:=IntFFESymm(lis[j+1]);
                                 if b<>0 then 
                                     if AbsInt(b)<>1 then 
                                         if b>0 then PrintTo(out,"+",b); else PrintTo(out,b); fi;
                                         if j>1 then PrintTo(out,"*x^",j); 
                                         elif j=1 then PrintTo(out,"*x");
                                         fi;
                                     else 
                                         if b>0 then 
                                             if j<m then PrintTo(out,"+"); fi;
                                         else PrintTo(out,"-"); fi;            
                                         if j>1 then PrintTo(out,"x^",j); 
                                         elif j=1 then PrintTo(out,"x");
                                         else PrintTo(out,"1"); # j=0 abd abs(b)=1
                                         fi;
                                     fi;
                                 fi;    
                             od;
                             
                             CloseStream(out);
                         fi;
                         
                         return str;
                     end                     
                     );

#! @Description Process the field header (second line in the MTXE file
#! format), including the field, PrimitiveP record, and anything else.
#! Supported format options:
#! @BeginCode FieldHeaderA
#! Field: `field` PrimitiveP(x): `polynomial` Format: `format`
#! @EndCode
#! @InsertCode FieldHeaderA
#! 
#! Here the records should be separated by one or more spaces;
#! while `field`, `polynomial`, and `format` **should not contain any spaces.**
#! Any additional records in this line will be silently ignored.
#! 
#! The `field` option should specify a valid field, $\mathop{\rm GF}(q)$ or
#! $\mathop{\rm GF}(p^m)$, where $q>1$ should be a power of the prime $p$. 
#! 
#! The `polynomial` should be a valid expanded monic
#! polynomial with integer coefficients, with a single independent
#! variable `x`; it should contain no spaces.  An error will be
#! signaled if `polynomial` is not a valid primitive polynomial of the `field`.
#! This argument is optional;  by default, Conway polynomial will be used.
#!
#! The optional `format` string (**not implemented**) should be "AdditiveInt" (the default
#! for prime fields), "PowerInt" (the default for extension fields
#! with $m>1$) or "VectorInt".  
#! 
#! `AdditiveInt` indicates that values listed
#! are expected to be in the corresponding prime field and should be
#! interpreted as integers mod $p$.  
#! `PowerInt` indicates that field elements are
#! represented as integers powers of the primitive element, root of
#! the primitive polynomial, or $-1$ for the zero field element.  
#! `VectorInt` corresponds to encoding coefficients of a degree-$(m-1)$ $p$-ary
#! polynomial representing field elements into a $p$-ary integer.  In
#! this notation, any negative value will be taken mod $p$, thus $-1$
#! will be interpreted as $p-1$, the additive inverse of the field $1$.
#! 
#! On input, `recs` should contain a list of tokens obtained by
#! splitting the field record line;
#! `optF` should be assigned to `ValueOption("field")` or `fail`.
#! 
#! @Arguments recs, optF
#! @Returns the list [Field, ConversionDegree, FormatIndex] (plus anything else we
#! may need in the future); the list is to be used as the second
#! parameter in `QDR_ProcEntry()`  
#DeclareGlobalFunction("QDR_ProcessFieldHeader");
BindGlobal("QDR_ProcessFieldHeader",
                     function(recs,optF)
                         local m,F,Fp,poly,x,ic,is,a;
    
                         if (Length(recs)>2 and recs[1][1]='%' and recs[2]="Field:") then
                             F:=QDR_ParseFieldStr(recs[3]);
                             if not IsField(F) then
                                 Error("invalid input file field '",recs[3],"' given\n");
                             fi;
                         fi;
                         
                         # compare with the field option
                         if optF <> fail then
                             if not IsField(optF) then
                                 Error("invalid option 'field'=",optF,"\n");
                             else # default field is specified
                                 if IsBound(F) then
                                     if F<>optF then
                                         Error("field mismatch: file='",F,
                                               "' given='",optF,"'\n");
                                     fi;
                                 else
                                     F:=optF;
                                 fi;
                             fi;
                         elif not IsBound(F) then
                             F:=GF(2);                            
                         fi;
                         
                         # check if a PrimitiveP is specified (only if the field is prime).
                         if IsPrimeField(F) then
                             return [F,1,0]; # field, degree=1, format="AdditiveInt"
                         fi;    
                         ic:=1; is:=1; # set default conversion degree        
                         if Length(recs)>3 then # analyze primitive polynomial
                             if StartsWith(recs[4],"PrimitiveP(x)") then 
                                 # process primitive polynomial here 
                                 if Length(recs)=4 then 
                                     Error("Polynomial must be separated by space(s) ",recs[4],"\n");
                                 fi;
                                 if not EndsWith(recs[4],"):") then 
                                     Error("Invalid entry ",recs[4],"\n");
                                 fi;                                 
                                 
                                 poly:=QDR_ParsePolyStr(recs[5]);
                                 
                                 if not IsUnivariatePolynomial(poly) then
                                     Error("Univariate polynomial expected ",recs[5],"\n");
                                 fi;
                                 Fp:=PrimeField(F);                
                                 poly:=poly*One(Fp);
                                 if not IsPrimitivePolynomial(Fp,poly) then 
                                     Error("Polynomial ",recs[5], " must be primitive in ",Fp,"\n");
                                 fi;
                                 m:=DegreeFFE(PrimitiveElement(F));            
                                 if not DegreeOfLaurentPolynomial(poly)=m then 
                                     Error("Polynomial degree ",recs[5], " should be ",m,"\n");
                                 fi;
                                 a:=PrimitiveRoot(F); 
                                 for ic in [1..Size(F)-2] do
                                     if Value(poly,a^ic) = Zero(Fp) then 
                                         break; # will terminate here for sure
                                     fi;        # since `poly` is primitive.
                                 od; 
                                 is:= 1/ic mod (Size(F)-1);
                                 Unbind(poly);
                                 
                             fi;
                         fi;
    
                         # todo: process `format` here 
                         
                         return [F,is,2]; # field, degree, format="PowerInt"
                     end
                     );

#! @Description Convert a string entry which should represent an integer
#! to the Galois Field element as specified in the `fmt`.
#! * `str` is the string representing an integer.
#! * `fmt` is a list  [Field, ConversionDegree, FormatIndex]
#!   - `Field` is the Galois field $\mathop{\rm GF}(p^m)$ of the code
#!   - `ConversionDegree` $c$ : every element $x$ read is replaces with
#!     $x^c$.  This may be needed if a non-standard primitive
#!     polynomial is used to define the field. 
#!   - `FormatIndex` in {0,1,2}. `0` indicates no conversion (just a
#!     modular integer).  `1` indicates that the integer represents
#!     a power of the primitive element, or $-1$ for 0.  `2`
#!     indicates that the integer encodes coordinates of a length $m$
#!     vector as the digits of a $p$-ary integer (**not yet implemented**).
#! * `FileName`, `LineNo` are the line number and the name of the
#!   input file; these are used to signal an error.
#!
#! @Returns the converted field element 
#! @Arguments str, fmt, FileName, LineNo
#DeclareGlobalFunction("QDR_ProcEntry");
BindGlobal("QDR_ProcEntry",
                     function(str,fmt,FileName,LineNo)
                         local ival, fval;
                         ival:=Int(str);
                         if ival=fail then 
                             Error("\n",FileName,":",LineNo,"Invalid entry '",str,
                                   "', expected an integer\n");
                         fi;
                         if fmt[3]=0 then 
                             fval:=ival*One(fmt[1]);
                         elif fmt[3]=1 then 
                             if ival=-1 then 
                                 fval:=Zero(fmt[1]);
                             else
                                 fval:=PrimitiveElement(fmt[1])^ival;
                             fi;
                         else
                             Error("FormatIndex=",fmt[3]," value not supported\n");
                         fi;
                         return fval^fmt[2];    
                     end
                     );


#! @Subsection Examples

#! @Section IOFunctions 


#! @Returns a list [`field`, `pair`, `Matrix`, `array_of_comment_strings`]
#! @Arguments FilePath [,pair] : field:=GF(2)
#!
#! @Description Read matrix from an MTX file, an extended version of Matrix Market eXchange 
#! coordinate format supporting finite Galois fields and
#! two-block matrices 
#! $ (A|B) $ 
#! with columns 
#! $A=(a_1, a_2, \ldots , a_n)$ 
#! and 
#! $B=(b_1, b_2, \ldots , b_n)$, see Chapter <Ref Chap="Chapter_FileFormat"/>.
#!
#! * `FilePath` name of existing file storing the matrix
#! * `pair` (optional argument): specifies column ordering;
#!          must correlate with the variable `type` in the file
#!      * `pair=0` for regular single-block matrices (e.g., CSS) `type=integer` (if `pair` not
#!            specified, `pair`=0 is set by default for `integer`) 
#!      * `pair=1` intercalated columns with `type=integer`
#!            $ (a_1, b_1, a_2, b_2,\ldots) $ 
#!      * `pair=2` grouped columns with `type=integer`
#!            $ (a_1, a_2, \ldots, a_n\;    b_1, b_2,\ldots, b_n) $ 
#!      * `pair=3` this is the only option for `type=complex` with elements 
#!            specified as "complex" pairs 
#! * `field` (Options stack):  Galois field, default: $\mathop{\rm GF}(2)$.
#! **Must** match that given in the file (if any).
#! __Notice__: with `pair`=1 and `pair`=2, the number of matrix columns
#! specified in the file must be even, twice the block length of the
#! code.  **This version of the format is deprecated and should be avoided.**
#!
#! 1st line of file must read:
#! @BeginCode LineOne
#! %%MatrixMarket matrix coordinate `type` general 
#! @EndCode
#! @InsertCode LineOne
#!  with `type` being either `integer` or `complex`
#!
#! 2nd line (optional) may contain:
#!
#! @BeginCode LineTwoA
#! % Field: `valid_field_name_in_Gap` 
#! @EndCode
#! @InsertCode LineTwoA
#! or
#! @BeginCode LineTwoB
#! % Field: `valid_field_name_in_Gap` PrimitiveP(x): `polynomial` 
#! @EndCode
#! @InsertCode LineTwoB
#! 
#! Any additional entries in the second line are silently ignored.  By
#! default, $\mathop{\rm GF}(2)$ is assumed;
#! the default can be overriden
#! by the optional `field` argument.   If the field is specified both
#! in the file and by the optional argument, the corresponding values
#! must match.  Primitive polynomial (if any) is only checked in the case of 
#! an extension field; it is silently ignored for a prime field.
#!
#! See Chapter <Ref Chap="Chapter_FileFormat"/> for the details of how the elements
#! of the group are represented depending on whether the field is a prime
#! field ($ q $ a prime) or an extension field with $ q=p^m $, $p$ prime, and $m>1$.
#! 
#DeclareGlobalFunction("ReadMTXE");
BindGlobal("ReadMTXE",
                     function(StrPath, opt... ) # supported option: "field"
                         local input, data, fmt, line, pair, F, rowsG, colsG, G, G1, i, infile,
                               iCommentStart,iComment;
                         # local variables:
                         # input - file converted to a string
                         # data - input separated into records (list of lists)
                         # fmt  - array returned by QDR_ProcessFieldHeader
                         # pair - 0,1,2 (integer) or 3 (complex), see input variables
                         #        indicates if we store matrix in the compressed form,
                         #              using complex representation a+i*b
                         #        (normal form if pair=integer and compressed form if pair=complex),
                         # F - Galois field, over which we are working
                         # rowsG - number of rows in G
                         # colsG - number of columns in G
                         # G - matrix read
                         # G1 - aux matrix with permuted columns
                         # i - dummy for "for" loop
                         # iCommentStart, iComment - range of line numbers for comment section
                         
                         infile := InputTextFile(StrPath);
                         input := ReadAll(infile);;                        # read the file in
                         CloseStream(infile);
                         data := SplitString(input, "\n");;         # separate into lines
                         line := SplitString(data[1], " ");;         # separate into records
                         
                         # check the header line
                         if Length(line)<5 or line[1]<>"%%MatrixMarket" or 
                            line[2]<>"matrix" or line[3]<>"coordinate" or
                            (line[4]<>"integer" and line[4]<>"complex") or line[5]<>"general"
                         then
                             Display(data[1]);
                             Error("Invalid header! This software supports MTX files containing", 
                                   "a general matrix\n",
                                   "\twith integer or complex values in coordinate format.\n");
                         fi;
                         
                         # analyze the 2nd (opt) argument
                         if (Length(opt)>1) then
                             Error("Too many arguments!\n");
                         elif (Length(opt)=1) then
                             pair:=Int(opt[1]); # must be an integer
                             if line[4]="complex" and pair<>3 then
                                 Error("complex matrix must have pair=3, not ",pair,"\n");
                             fi;
                             if line[4]="integer" then
                                 if pair<0 or pair>2 then
                                     Error("integer matrix must have 0<=pair<=2, not ",pair,"\n");
                                 fi;
                             fi;
                         else # no opt specified
                             if line[4]="complex" then pair:=3; else pair:=0; fi;
                         fi;
                         
                         # process the field argument in the second line, if any 
                         line := SplitString(data[2], " ");; # separate into records
                         if (Length(line)>2 and line[1][1]='%' and line[2]="Field:") then
                             iCommentStart:=3; # second line is a format line, not needed
                         else
                             iCommentStart:=2; # this was a regular comment 
                         fi;
                         
                         fmt:=QDR_ProcessFieldHeader(line,ValueOption("field"));
                         F:=fmt[1];

                         # search for the end of top comment section (including any empty lines):
                         iComment := iCommentStart;
                         while Length(data[iComment + 1]) = 0 or data[iComment + 1, 1] = '%' do
                             iComment := iComment + 1;
                             if Length(data[iComment]) = 0 then
                                 data[iComment]:="%"; # suppress empty comment lines
                             fi;
                         od;
                         
                         for i in [iComment+1..Length(data)] do
                             data[i] := SplitString(data[i], " ");; # separate into records
                         od;
                         
                         # Parameters (dimensions and number of non-zero elemments) of G
                         rowsG := Int(data[iComment + 1, 1]);;
                         colsG := Int(data[iComment + 1, 2]);;
                         if pair=3 then colsG:=colsG*2; fi; # complex matrix
                         
                         G := NullMat(rowsG, colsG, F);;    # empty matrix
    
                         # Then we fill G with the elements from data (no more empty / comment lines allowed)
                         if (pair <>3 ) then                      
                             for i in [(iComment + 2)..Length(data)] do
                                 G[Int(data[i,1]), Int(data[i,2])] := 
                                     QDR_ProcEntry(data[i,3],fmt,StrPath,i);                                 
                             od;
                         else # pair=3 
                             for i in [(iComment + 2)..Length(data)] do
                                 G[Int(data[i,1]),2*Int(data[i,2])-1]:=
                                     QDR_ProcEntry(data[i,3],fmt,StrPath,i);                                 
                                 G[Int(data[i,1]),2*Int(data[i,2])]:=
                                     QDR_ProcEntry(data[i,4],fmt,StrPath,i);                                 
                             od;
                         fi;
                         
                         if pair=2 then # reorder the columns
                             G1 := TransposedMatMutable(G);
                             G:=[];
                             for i in [1..(colsG/2)] do
                                 Add(G,G1[i]);
                                 Add(G,G1[i+colsG/2]);
                             od;
                             G := TransposedMatMutable(G);;
                             pair:=1;
                         elif pair=3 then
                             pair:=1;
                         fi;
                         return [F,pair,G,data{[iCommentStart..iComment]}];
                     end
                     );

#! @Arguments StrPath, pair, matrix [,comment[,comment]] : field:=GF(2)
#! @Returns no output
#! @Description 
#! Export a `matrix` in Extended MatrixMarket format, with options
#! specified by the `pair` argument.  
#!
#! * `StrPath` - name of the file to be created;
#! * `pair`: parameter to control the file format details, must match the storage
#!    `type` of the matrix. 
#!   - `pair=0` for regular matrices (e.g., CSS) with `type=integer` 
#!   - `pair=1` for intercalated columns $ (a_1, b_1, a_2, b_2, \ldots) $
#!              with `type=integer` (**deprecated**)
#!   - `pair=2` for grouped columns with `type=integer` **(this is not supported!)**
#!   - `pair=3` for columns specified in pairs with `type=complex`.
#! * Columns of the input `matrix` must be intercalated unless `pair=0`
#! * optional `comment`: one or more strings (or a single list of
#!   strings) to be output after the MTX header line.  
#!
#! The second line specifying the field will be generated
#! automatically **only** if the GAP Option `field` is present.
#! As an option, the line can also be  entered explicitly
#! as the first line of the comments, e.g., `"% Field: GF(256)"`
#!
#! 
#! See Chapter <Ref Chap="Chapter_FileFormat"/> for the details of how the elements
#! of the group are represented depending on whether the field is a prime
#! field ($ q $ a prime) or an extension field with $ q=p^m $, $ m>1 $.
#! 
#DeclareGlobalFunction("WriteMTXE");
BindGlobal("WriteMTXE", # function (StrPath,pair,G,comment...)
          function (StrPath,pair,G,comment...) # supported option: field [default: GF(2)]
              local F, dims, rows, cols, nonzero, i, row, pos, filename;
              # F - field to be used (default: no field specified)
              # dims - dimensions of matrix G
              # rows and cols - number of rows and columns of the matrix G
              # nonzero - number of lines needed to store all nonzero elements of matrix with
              # pair parameter as given
              # i - for "for" loop
              # i, row and pos - temporary variables
              
              # see if the field is specified
              if ValueOption("field")<>fail then
                  if not IsField(ValueOption("field")) then
                      Error("invalid option 'field'=",ValueOption("field"),"\n");
                  else # default field is specified
                      F:=ValueOption("field");
                  fi;
              else
                  F:=GF(2); # default
              fi;
              
              # We check pair parameter
              if (pair <0 ) or (pair>3) or (pair=2) then
                  Error("\n", "Parameter pair=",pair," not supported, must be in {0,1,3}", "\n");
              fi;
              
              # full file name with extension
              if EndsWith(UppercaseString(StrPath),".MTX") then
                  filename:=StrPath;
              else
                  filename := Concatenation(StrPath, ".mtx");
              fi;
              
              if (pair=3) then row:="complex"; else row:="integer"; fi;
              
              # Header of the MatrixMarket
              PrintTo(filename, "%%MatrixMarket matrix coordinate ", row, " general", "\n");
              if ValueOption("field")<>fail then AppendTo(filename,QDR_FieldHeaderStr(F), "\n"); fi;

              for i in [1..Length(comment)] do
                  if comment[i,1]<>'%' then
                      AppendTo(filename, "% ", comment[i], "\n");
                  else
                      AppendTo(filename, comment[i], "\n");
                  fi;
              od;
              if IsPrime(Size(F)) then
                  AppendTo(filename,"% Values Z(",Size(F),") are given\n");
              else
                  AppendTo(filename,"% Powers of GF(",Size(F),") primitive element and -1 for Zero are given\n");
              fi;
              
              # Matrix dimensions
              dims := DimensionsMat(G);;
              rows := dims[1];;
              cols := dims[2];;
              
              # count non-zero elements depending on the 'pair' parameter
              nonzero := 0;
              if (pair = 3) then
                  for i in [1..rows] do
                      nonzero := nonzero + QDR_SymplVecWeight(G[i], F);;
                  od;
              else
                  for i in [1..rows] do
                      nonzero := nonzero + WeightVecFFE(G[i]);;
                  od;
              fi;
              
              if (pair < 3) then
                  # write dimensions of the matrix and number of line containing nonzero elements
                  AppendTo(filename, rows, " ", cols, " ", nonzero, "\n");
                  
                  # Finally, write nonzero elements and their positions according to pair parameter and field F.
                  if IsPrime(Size(F)) then # this includes binary field
                      for i in [1..rows] do
                          row := G[i];;
                          
                          pos := PositionNonZero(row, 0);;
                          while pos <= cols do
                              AppendTo(filename, i, " ", pos, " ", Int(row[pos]), "\n");
                              pos := PositionNonZero(row, pos);;
                          od;
                      od;
                  else # extension field
                      for i in [1..rows] do
                          row := G[i];;
                          
                          pos := PositionNonZero(row, 0);;
                          while pos <= cols do
                              AppendTo(filename, i, " ", pos, " ", 
                                       LogFFE(row[pos], PrimitiveElement(F)), "\n");
                              pos := PositionNonZero(row, pos);;
                          od;
                      od;
                  fi;
              else # pair=3
                  # write dimensions of the matrix and number of line containing nonzero elements
                  AppendTo(filename, rows, " ", cols/2," ", nonzero, "\n");
                  # Finally, write nonzero elements and their positions according to pair parameter and field F.
                  if IsPrime(Size(F)) then
                      for i in [1..rows] do
                          row := G[i];;
                          pos := PositionNonZero(row, 0);;
                          while pos <= cols do
                              # For Ai = 0
                              if IsInt(pos/2) then
                                  AppendTo(filename, i, " ", pos/2, " ", 0, " ", Int(row[pos]), "\n");
                                  pos := PositionNonZero(row, pos);;
                              # For Ai != 0
                              else
                                  AppendTo(filename, i, " ", (pos+1)/2, " ", Int(row[pos]), " ", Int(row[pos + 1]), "\n");
                                  pos := PositionNonZero(row, pos + 1);;
                              fi;
                          od;
                      od;
                  else # extension field
                      for i in [1..rows] do
                          row := G[i];;
                          
                          pos := PositionNonZero(row, 0);;
                          while pos <= cols do
                              # For Ai = 0
                              if IsInt(pos/2) then
                                  AppendTo(filename, i, " ", pos/2, " ", -1, " ", LogFFE(row[pos], PrimitiveElement(F)), "\n");
                                  pos := PositionNonZero(row, pos);;
                              # For Ai != 0
                              else
                                  # Check if Bi = 0
                                  if (row[pos + 1] = Zero(F)) then
                                      AppendTo(filename, i, " ", (pos+1)/2, " ", LogFFE(row[pos], PrimitiveElement(F)), " ", -1, "\n");
                                  else
                                      AppendTo(filename, i, " ", (pos+1)/2, " ", LogFFE(row[pos], PrimitiveElement(F)),
                                               " ", LogFFE(row[pos + 1], PrimitiveElement(F)), "\n");
                                  fi;
                                  
                                  pos := PositionNonZero(row, pos + 1);;
                              fi;
                          od;
                      od;
                  fi;
              fi;
              # Print("File ", filename, " was created\n");
          end
          );


#! @Section HelperFunctions

#! @Arguments matrix, field
#! @Description Given a two-block `matrix` with intercalated columns 
#! $ (a_1, b_1, a_2, b_2, \ldots) $,  calculate the corresponding check matrix `H` with
#! columns $ (-b_1, a_1, -b_2, a_2, \ldots) $.  
#! 
#! The parity of the number of columns is verified. 
#! @Returns `H` (the check matrix constructed)
#!
#DeclareGlobalFunction("QDR_MakeH");
BindGlobal("QDR_MakeH",
                     function(G, F)
                          
                         local dims, i, H;
                         # local variables: dims - dimensions of G matrix, i - for "for" loop,
                         # H - *** TRANSPOSED *** check matrix
                         
                         dims := DimensionsMat(G);;
                          
                         # Checking that G has even number of columns
                         if (Gcd(dims[2] , 2) = 1) then
                             Error("\n", "Generator Matrix G has odd number of columns!", "\n");
                         fi;
                         
                         # Introducing check matrix
                         H := TransposedMatMutable(G);;
                         for i in [1..(dims[2]/2)] do
                             H[2*i] := (-1) * H[2*i];; #H = (A1,-B1,A2,-B2,...)^T
                             H := Permuted(H, (2*i-1,2*i));; # H = (-B1,A1,-B2,A2,...)^T.
                         od;
                         
                         return TransposedMatMutable(H);
                     end
                     );

#! @Section DistanceFunctions 

#! @Description
#!  Computes an upper bound on the distance $d_Z$ of the
#!  $q$-ary code with stabilizer generator matrices $H_X$, $H_Z$ whose rows
#!  are assumed to be orthogonal (**orthogonality is not verified**).
#!  Details of the input parameters 
#!  * `HX`, `HZ`: the input matrices with elements in the Galois `field` $F$
#!  * `num`: number of information sets to construct (should be large)
#!  * `mindist` - the algorithm stops when distance equal or below `mindist`
#!     is found and returns the result with negative sign.  Set
#!     `mindist` to 0 if you want the actual distance.   
#!  * `debug`: optional integer argument containing debug bitmap (default: `0`)
#!    * 1 (0s  bit set) : print 1st of the vectors found
#!    * 2 (1st bit set) : check orthogonality of matrices and of the final vector
#!    * 4 (2nd bit set) : show occasional progress update
#!    * 8 (3rd bit set) : maintain cw count and estimate the success probability
#!  * `field` (Options stack): Galois field, default: $\mathop{\rm GF}(2)$.   
#!  * `maxav` (Options stack): if set, terminate when $\langle n\rangle$&gt;`maxav`, 
#!    see Section <Ref Sect="Section_Empirical"/>.  Not set by default.
#!  See Section <Ref Sect="Section_SimpleVersion"/> for the
#!  description of the algorithm.  
#! @Arguments HX, HZ, num, mindist[, debug] :field:=GF(2), maxav:=fail
#! @Returns An upper bound on the CSS distance $d_Z$
#DeclareGlobalFunction("DistRandCSS");
BindGlobal("DistRandCSS",
                     function (GX,GZ,num,mindist,opt...) # supported options: field, maxav
                         
                         local DistBound, i, j, dimsWZ, rowsWZ, colsWZ, F, debug, pos, CodeWords, mult,
                               VecCount,  maxav, WZ, WZ1, WZ2, WX,
                               TempVec, FirstVecFound, TempWeight, per; 

                         if ValueOption("field")<>fail then
                             if not IsField(ValueOption("field")) then
                                 Error("invalid option 'field'=",ValueOption("field"),"\n");
                             else # field is specified
                                 F:=ValueOption("field");
                             fi;
                         else
                             F:=GF(2); # default
                         fi;

                         debug := [0,0,0,0];;     # Debug bitmap
                         if (Length(opt) > 0) then
                             debug := debug + CoefficientsQadic(opt[1], 2);;
                         fi;

                         if ValueOption("maxav")<>fail then
                             maxav:=Float(ValueOption("maxav"));
#                             debug[4]:=1;
                         fi;


                         if debug[2]=1 then # check the orthogonality
                             if QDR_WeightMat(GX*TransposedMat(GZ))>0 then
                                 Error("DistRandCSS: input matrices should have orthogonal rows!\n");
                             fi;
                         fi;

                         WZ:=NullspaceMat(TransposedMatMutable(GX)); # generator matrix
                         WX:=NullspaceMat(TransposedMatMutable(GZ)); 
                         dimsWZ:=DimensionsMat(WZ);
                         rowsWZ:=dimsWZ[1]; colsWZ:=dimsWZ[2];
                         DistBound:=colsWZ+1; # +1 to ensure that at least one codeword is recorded
                         for i in [1..num] do
                             per:=Random(SymmetricGroup(colsWZ));
                             WZ1:=PermutedCols(WZ,per);# apply random col permutation
                             WZ2:=TriangulizedMat(WZ1); # reduced row echelon form
                             WZ2:=PermutedCols(WZ2,Inverse(per)); # return cols to orig order
                             for j in [1..rowsWZ] do
                                 TempVec:=WZ2[j]; # this samples low-weight vectors from the code
                                 TempWeight:=WeightVecFFE(TempVec);
                                 if (TempWeight > 0) and (TempWeight <= DistBound) then
                                     if WeightVecFFE(WX*TempVec)>0 then # lin-indep from rows of GX
                                         if debug[2]=1 then # Check that H*c = 0
                                             if (WeightVecFFE(GX * TempVec) > 0) then
                                                 Print("\nError: codeword found is not orthogonal to rows of HX!\n");
                                                 if (colsWZ <= 100) then
                                                     Print("The improper vector is:\n");
                                                     Display(TempVec);
                                                 fi;
                                                 Error("\n");
                                             fi;
                                         fi;
                                         
                                         if TempWeight < DistBound then # new min-weight vector found
                                             DistBound:=TempWeight;
                                             VecCount:=1; # reset the overall count of vectors
                                             if debug[4] = 1  or ValueOption("maxav")<> fail then
                                                 CodeWords := [TempVec];;
                                                 mult := [1];;
                                             fi;                                             
                                             if debug[1] = 1 then
                                                 FirstVecFound := TempVec;;
                                             fi;
                                             
                                         elif TempWeight=DistBound then
                                             VecCount:=VecCount+1;
                                             if debug[4] = 1  or ValueOption("maxav")<> fail then
                                                 pos := Position(CodeWords, TempVec);;
                                                 if ((pos = fail) and (Length(mult) < 100)) then
                                                     Add(CodeWords, TempVec);
                                                     Add(mult, 1);
                                                 elif (pos <> fail) then
                                                     mult[pos] := mult[pos] + 1;;
                                                 fi;
                                             fi;
                                         fi;
                                     fi;
                                 fi;
                                 if DistBound <= mindist then
                                     if debug[1]=1 then
                                         Print("\n", "Distance ",DistBound,"<=",mindist,
                                               " too small, exiting!\n");
                                     fi;
                                     return -DistBound;  # terminate immediately
                                 fi;

                             od ;

                             if ((debug[3] = 1) and (RemInt(i, 200) = 0)) then
                                 Print("Round ", i, " of ", num, "; lowest wgt = ", DistBound, " count=", VecCount, "\n");                                 
                                 if debug[4]=1 then
                                     Print("Average number of times vectors with the lowest weight were found = ",
                                           QDR_AverageCalc(mult), "\n");
                                     Print("Number of different vectors = ",Length(mult), "\n");
                                 fi;
                             fi;

                             if ValueOption("maxav")<>fail then
                                 if QDR_AverageCalc(mult)>maxav then break; fi;
                             fi;
                         od;


                         if (debug[1] = 1) then # print additional information
                             Print(i," rounds of ", num," were made.", "\n");
                             if colsWZ <= 100 then
                                 Print("First vector found with lowest weight:\n");
                                 Display([FirstVecFound]);
                             fi;
                             Print("Minimum weight vector found ", VecCount, " times\n");
                             Print("[[", colsWZ, ",",colsWZ-RankMat(GX)-RankMat(GZ),",",
                                   DistBound, "]];", "  Field: ", F, "\n");
                         fi;
                         
                         if (debug[4] = 1) then
#                             Display(CodeWords);                             
                             QDR_DoProbOut(mult,colsWZ,i);
                         fi;
                         
                         return DistBound;
                         
                     end
                     );


#! @Description
#!  Computes an upper bound on the distance $d$ of the
#!  $F$-linear stabilizer code with generator matrix $G$ whose rows
#!  are assumed to be symplectic-orthogonal, see Section <Ref
#!  Subsect="Subsection_AlgorithmGeneric"/> (**orthogonality is not verified**). 
#!
#!  Details of the input parameters:
#!  * `G`: the input matrix with elements in the Galois `field` $F$
#!    with $2n$ columns $(a_1,b_1,a_2,b_2,\ldots,a_n,b_n)$.
#!  The remaining options are identical to those in the function
#!  `DistRandCSS` <Ref Sect="Section_DistanceFunctions"/>.
#!  * `num`: number of information sets to construct (should be large)
#!  * `mindist` - the algorithm stops when distance equal or smaller than `mindist`
#!     is found - set it to 0 if you want the actual distance
#!  * `debug`: optional integer argument containing debug bitmap (default: `0`)
#!    * 1 (0s  bit set) : print 1st of the vectors found
#!    * 2 (1st bit set) : check orthogonality of matrices and of the final vector
#!    * 4 (2nd bit set) : show occasional progress update
#!    * 8 (3rd bit set) : maintain cw count and estimate the success probability
#!  * `field` (Options stack): Galois field, default: $\mathop{\rm GF}(2)$.   
#!  * `maxav` (Options stack): if set, terminate when $\langle n\rangle$&gt;`maxav`, 
#!       see Section <Ref Sect="Section_Empirical"/>.  Not set by default.
#! @Arguments G, num, mindist[, debug] :field:=GF(2), maxav:=fail
#! @Returns An upper bound on the code distance $d$
#DeclareGlobalFunction("DistRandStab");
BindGlobal("DistRandStab",
                     function(G,num,mindist,opt...) # supported options: field, maxav
    local F, debug, CodeWords, mult, TempPos, dims, H, i, l, j, W, V, dimsW,
          rows, cols, DistBound, FirstVecFound, VecCount, per, W1, W2, TempVec, TempWeight,maxav,
                     per1, per2;
    # CodeWords - if debug[4] = 1, record the first 100 different CWs with the lowest weight found so far
    # mult - number of times codewords from CodeWords were found
    # TempPos - temporary variable corresponding to the position of TempVec in CodeWords
    # dims - dimensions of matrix G
    # H - check matrix
    # i, l and j - for "for" loop
    # W and V - are vector spaces ortogonal to rows of H and G correspondingly
    # dimsW - dimensions of W (W presented as a matrix, with row being basis vectors)
    # rows and cols are parts of dimW
    # DistBound - upper bound, we are looking for
    # VecCount - number of times vectors with the current lowest weight were found so far.
    # per - is for permutations, which we are using in the code
    # W1, W2, TempVec, TempWeight - temporary variables
    # per1, per2 - auxiliary variables for taking permutation on pairs
    # maxav - a maximal average value of multiplicities of found vectors of the lowest weight

    if ValueOption("field")<>fail then
        if not IsField(ValueOption("field")) then
            Error("invalid option 'field'=",ValueOption("field"),"\n");
        else # field is specified
            F:=ValueOption("field");
        fi;
    else
        F:=GF(2); # default
    fi;

    # Debug parameter
    debug := [0,0,0,0];;
    if (Length(opt) > 0) then
      debug := debug + CoefficientsQadic(opt[1], 2);;
    fi;

    if ValueOption("maxav")<>fail then
      maxav:=Float(ValueOption("maxav"));
#      debug[4]:=1;
    fi;


    # Dimensions of generator matrix
    dims := DimensionsMat(G);

    # Create the check-matrix
    H := QDR_MakeH(G, F);; # this also verifies cols = even

    # optionally check for orthogonality
    if (debug[2] = 1) then
             if QDR_WeightMat(G * TransposedMat(H))>0 then
                Error("\n", "Problem with ortogonality GH^T!", "\n");
             fi;
    fi;

    # Below we are getting vector spaces W and V ortogonal to the columns of H and G correspondingly.
    W := NullspaceMat(TransposedMatMutable(H));;
    V := NullspaceMat(TransposedMatMutable(G));;

    # There we found dimentions of vector space W (how many vectors in a basis and their length).
    dimsW := DimensionsMat(W);;
    rows := dimsW[1];;
    cols := dimsW[2];;

    DistBound := cols + 1;;     # Initial bound on code distance

    # The main part of algorithm.
    for i in [1..num] do
      #Print(i);
        ## We start by creating random permutation for columns in W.
        # per1 := ListPerm(Random(SymmetricGroup(cols/2)), cols/2);;  # random permutation of length cols/2
        # per2 := []; #  We extend the permutation, so it works now on pairs
        # for l in [1..cols/2] do
        #    Append(per2, [2*per1[l]-1, 2*per1[l]]);  # per2 contains the permutation we want as a list
        # od;
        # per := PermList(per2); # this is a permutation of length 2n moving pairs

      per := Random(SymmetricGroup(cols));;

      W1 := PermutedCols(W, per);; # Perform that permutation.
      W2 := TriangulizedMat(W1);; # Reduced row echelon form
      W2 := PermutedCols(W2,Inverse(per));; # Inverse permutation

      for j in [1..rows] do
              # We take one of the sample vectors for this iteration. It supposed to be low-weight.
        TempVec := W2[j];;
        TempWeight := QDR_SymplVecWeight(TempVec, F);;

              # check if this vector is a logical operator).
              # First, rough check:
        if (TempWeight > 0) and (TempWeight <= DistBound) then
          if (WeightVecFFE(V * TempVec) > 0) then # linear independence from rows of G
            if debug[2]=1 then # Check that H*c = 0
              if (WeightVecFFE(H * TempVec) > 0) then
                Print("\nSomething wrong: cw found is not orthogonal to rows of H!\n");
                      if (Length(TempVec) <= 100) then
                        Print("The improper vector is:\n");
                        Display(TempVec);
                      fi;
                      Error("\n");
              fi;
            fi;

            if (TempWeight < DistBound) then

              DistBound := TempWeight;; # min weight found
              VecCount := 1;; # reset the overall count of vectors of such weight

                                # Recording all discovered codewords of minimum weight and their multiplicities
              if debug[4] = 1 or ValueOption("maxav")<>fail then
                  CodeWords := [TempVec];;
                  mult := [1];;
              fi;                 
              if debug[1] = 1 then
                  FirstVecFound := TempVec;;
              fi;

                      # If we already received such a weight (up to now - it is minimal),
            # we want to update number of vectors, corresponding to it
            elif (TempWeight = DistBound) then
              VecCount := VecCount + 1;;

                              # Recording of the first 100 different discovered codewords of
              # minimum weight with their multiplicities
              if debug[4] = 1 or ValueOption("maxav")<>fail then
                  TempPos := Position(CodeWords, TempVec);
                  if ((TempPos = fail) and (Length(mult) < 100)) then
                      Add(CodeWords, TempVec);
                      Add(mult, 1);
                  elif (TempPos <> fail) then
                      mult[TempPos] := mult[TempPos] + 1;;
                  fi;
              fi;

           fi;

                     # Specific terminator, if we don't care for distances below a particular value.
           if (DistBound <= mindist) then # not interesting, exit immediately!
               if debug[1]=1 then
                   Print("\n", "The found distance ",DistBound,"<=",mindist,
                         " too small, exiting!\n");
               fi;               
             return -DistBound;
           fi;
        fi;
      fi;
    od;
    # Optional progress info
    if ((debug[3] = 1) and (RemInt(i, 200) = 0)) then
        Print("Round ", i, " of ", num, "; lowest wgt = ", DistBound, " count=", VecCount, "\n");
        if debug[4]=1 then
            Print("Average number of times vectors with the lowest weight were found = ", QDR_AverageCalc(mult), "\n");
            Print("Number of different vectors = ",Length(mult), "\n");
        fi;
    fi;

    if ValueOption("maxav")<>fail then
        if QDR_AverageCalc(mult)>maxav then break; fi;
    fi;
    od;


    if (debug[1] = 1) then # print additional information
        Print(i," rounds of ", num," were made.", "\n");
        if cols <= 100 then
            Print("First vector found with lowest weight:\n");
            Display([FirstVecFound]);
        fi;        
        Print("Miimum weight vector found ", VecCount, " times\n");
      Print("[[", cols/2, ",",cols/2 - RankMat(G), ",", DistBound, "]];", "  Field: ", F, "\n");
  fi;

  if (debug[4] = 1) then
      QDR_DoProbOut(mult,cols,i);
  fi;
  
  return DistBound;

                     end
                     );


#! @Chapter AllFunctions
#! @Section HelperFunctions

# Many of the examples are dealing with quantum cyclic codes.  The
# following function is convenient to define the corresponding
# stabilizer generator matrices

#! @Arguments poly, m, n, field
#! @Returns `m` by `2*n` circulant matrix constructed from the polynomial coefficients
#! @Description Given the polynomial `poly` $a_0+b_0 x+a_1x^2+b_1x^3
#! +\ldots$ with coefficients from the field `F`, 
#! constructs the corresponding `m` by 2`n` double circulant matrix
#! obtained by `m` repeated cyclic shifts of the coefficients' vector
#! by $s=2$ positions at a time. 
#DeclareGlobalFunction("QDR_DoCirc");
BindGlobal("QDR_DoCirc",
          function(poly,m,n,F)
              local v,perm,j,deg,mat;
              v:=CoefficientsOfUnivariatePolynomial(poly);
              #    F:=DefaultField(v);
              deg:=Length(v);
              if (n>deg) then
                  v:=Concatenation(v,ListWithIdenticalEntries(n-deg,0*One(F)));
              fi;
              mat:=[v];
              perm:=Concatenation([n],[1..n-1]);
              for j in [2..m] do
                  v:=v{perm};
                  v:=v{perm}; # this creates a quantum code
                  Append(mat,[v]);
              od;
              return mat;
          end);

