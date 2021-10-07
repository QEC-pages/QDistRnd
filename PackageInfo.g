#############################################################################
##  
##  PackageInfo.g for the package `QDistRnd'                     Leonid P. Pryadko
##                                                               Vadim A. Shabashov
##                                                               Valerii K. Kozin
##  For the LoadPackage mechanism in GAP >= 4.5 the minimal set of needed
##  entries is .PackageName, .Version, and .AvailabilityTest, and an error
##  will occur if any of them is missing. Other important entries are
##  .PackageDoc and .Dependencies. The other entries are relevant if the
##  package will be distributed for other GAP users, in particular if it
##  will be redistributed via the GAP Website.
##
##  With a new release of the package at least the entries .Version, .Date 
##  and .ArchiveURL must be updated.
SetPackageInfo( 
        rec(
             PackageName := "QDistRnd",             
             Subtitle := "Calculate the distance of a q-ary quantum stabilizer code",
             Version := "0.6.0",
             Date := "07/10/2021",  
             License := "GPL-2.0-or-later",
             PackageWWWHome :=
             Concatenation( "https://gap-packages.github.io/", 
                            LowercaseString( ~.PackageName ) ),
             SourceRepository :=
             rec( Type := "git", # edit as necessary
                  URL := Concatenation( "https://github.com/VadimShabashov/" , ~.PackageName )
                ),
             IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
             README_URL      := Concatenation( ~.PackageWWWHome, "/README" ),
             PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
             ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                               "/releases/download/v", ~.Version,
                                               "/", LowercaseString(~.PackageName), "-", ~.Version ),
             AbstractHTML :=
             Concatenation(
                            "The GAP package <code>QDistRnd</code> \n" ,
                            "implements a probabilistic algorithm for finding the \n" ,
                            "minimum distance of a quantum code linear over a finite\n" ,
                            "field GF(<var>q</var>).\n"
                 ),
             ArchiveFormats:="tar.gz",             
             SupportEmail := "leonid.pryadko@gmail.com",
             PackageDoc := rec(
                                BookName  := ~.PackageName,
                                ArchiveURLSubset := ["doc"],
                                HTMLStart := "doc/chap0.html",
                                PDFFile   := "doc/manual.pdf",
                                SixFile   := "doc/manual.six",
                                # a longer title of the book, this together with the book name should
                                # fit on a single text line (appears with the '?books' command in GAP)
                                LongTitle := ~.Subtitle
                               ),
             
             Persons := [
                          rec( 
                                  LastName      := "Pryadko",
                                  FirstNames    := "Leonid P.",
                                  IsAuthor      := true,
                                  IsMaintainer  := true,
                                  Email         := "leonid.pryadko@gmail.com",
                                  WWWHome       := "http://faculty.ucr.edu/~leonid",
                                  PostalAddress := Concatenation( [
                                                                    "Leonid Pryadko\n",
                                                                    "Department of Physics &amp; Astronomy\n",
                                                                    "University of California\n",
                                                                    "Riverside, CA 92521\n",
                                                                    "USA" ] ),
                                  Place         := "UCR",
                                  Institution   := "University of California, Riverside"
                              ),
                          rec( 
                                  LastName      := "Shabashov",
                                  FirstNames    := "Vadim A.",
                                  IsAuthor      := true,
                                  IsMaintainer  := true,
                                  Email         := "vadim.art.shabashov@gmail.com",
                                  WWWHome       := "https://sites.google.com/view/vadim-shabashov/",
                                  PostalAddress := Concatenation( [
                                                                    "Vadim Shabashov\n",
                                                                    "The Department of Physics &amp; Engineering\n",
                                                                    "ITMO University\n",
                                                                    "St. Petersburg, 197101\n",
                                                                    "Russia" ] ),
                                  Institution   := "ITMO University"
                              ),
                          rec( 
                                  LastName      := "Kozin",
                                  FirstNames    := "Valerii K.",
                                  IsAuthor      := false,
                                  IsMaintainer  := true,
                                  Email         := "kozin.valera@gmail.com",
                                  PostalAddress := Concatenation( [
                                                                    "Valerii Kozin\n",
                                                                    "The Department of Physics &amp; Engineering\n",
                                                                    "ITMO University\n",
                                                                    "St. Petersburg, 197101\n",
                                                                    "Russia" ] ),
                                  Institution   := "ITMO University"
                              )
                          
             ],

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed 
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages 
##    "other"         for all other packages
##
             Status := "other",

             Dependencies := rec(
                                  GAP := "4.10",
                                  NeededOtherPackages := [["GAPDoc", "1.5"], 
                                                          ["AutoDoc", "1.5"],
                                                          ["Guava","3.14"]]
                                 ),

             AvailabilityTest := ReturnTrue,

# BannerString := Concatenation( 
#     "----------------------------------------------------------------\n",
#     "Loading  Example ", ~.Version, "\n",
#     "by ",
#     JoinStringsWithSeparator( List( Filtered( ~.Persons, r -> r.IsAuthor ),
#                                     r -> Concatenation(
#         r.FirstNames, " ", r.LastName, " (", r.WWWHome, ")\n" ) ), "   " ),
#     "For help, type: ?Example package \n",
#     "----------------------------------------------------------------\n" ),

             TestFile := "tst/testall.g",
             Keywords := ["QECC", "quantum code", "stabilizer code", 
                          "quantum error correcting code", "distance"],

             AutoDoc := rec(
                             TitlePage := rec(
                                               Copyright := """
      <Index>License</Index>                                    
      &copyright; 2021 by Leonid P. Pryadko and Vadim A. Shabashov<P/>    
      &QDistRnd; package is free software;  
      you can redistribute it and/or modify it under the terms of the
      <URL Text="GNU General Public License">http://www.fsf.org/licenses/gpl.html</URL>
      as published by the Free Software Foundation; either version 2 of the License,
      or (at your option) any later version.
      """,
                                               Acknowledgements := """
      We appreciate very much all past and future comments, suggestions and 
      contributions to this package and its documentation provided by &GAP;
      users and developers.
            """,  
                                              ),
                            ),

            ));
