LoadPackage( "AutoDoc" );
AutoDoc( rec( scaffold := true, 
              autodoc := rec(
                             scan_dirs := [".", "doc", "lib", "examples"] 
                             ),
              gapdoc := 
              rec(
                   LaTeXOptions := 
                   rec(
                        EarlyExtraPreamble := 
                        """ 
                        \newcommand{\rank}{\mathop{\rm rank}}
                        \newcommand{\wgt}{\mathop{\rm wgt}} 
                        %\parindent=0pt                
                        %\parskip\bigskipamount
                        """
                       )
                      ),
              extract_examples := true
##    ,          gap_root_relative_path := true
            ) );
QUIT;

