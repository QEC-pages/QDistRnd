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
                        """
                       )
                      ),
              extract_examples := true
            ) );
QUIT;

