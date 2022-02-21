LoadPackage( "AutoDoc" );
AutoDoc( rec( scaffold := true, 
              autodoc := rec(
                              scan_dirs := [".", "doc", "lib"] 
                             ),
              gapdoc := 
              rec(
                   LaTeXOptions := 
                   rec(
                        EarlyExtraPreamble := 
                        """ 
                        \newcommand{\rank}{\mathop{\rm rank}}
                        \newcommand{\wgt}{\mathop{\rm wgt}} 
                        \newcommand{\gf}{\mathop{\rm GF}} 
                        """
                       )
                      ),
              extract_examples := true
            ) );
QUIT;

