### this is specific for GAP under windows with msys64
## GAP = C:/usr/gap-4_11.1/gap.exe -l /C/usr/gap-4_11.1
## export PATH = C:\usr\gap-4_11.1\bin\x86_64-pc-cygwin-default64-kv7
## PDFLATEX = /c/usr/MiKTeX/miktex/bin/x64/pdflatex
## MAKEINDEX = /c/usr/MiKTeX/miktex/bin/x64/makeindex
## BIBTEX = /c/usr/MiKTeX/miktex/bin/x64/bibtex

### this is for unix
GAP = gap.sh
PDFLATEX = pdflatex
MAKEINDEX = makeindex
BIBTEX = bibtex

ECHO = /bin/echo
SED = /bin/sed 
CD = cd
RM = /bin/rm
MV = /bin/mv
ZIP = /usr/bin/zip
TAR = /bin/tar 

default: html try

all: html pdf try 

html:	
	@${ECHO} "*** Making the documentation ***"
	${GAP} -b -A -f makedoc.g

pdf:
	@${ECHO} "*** Postprocessing resulting LaTeX document ***"
	${SED} -e "s/\(Section\|Subsection\|Chapter\){\\\textunderscore}/\1_/g" doc/QDistRnd.tex > doc/manual.tex
	@${ECHO}
	@${ECHO} "*** Making the file manual.pdf ***"
	cd doc && \
	${PDFLATEX} manual && \
	${MAKEINDEX} manual  && \
	${BIBTEX} manual  && \
	${PDFLATEX} manual && \
	${PDFLATEX} manual
	@${ECHO}


try:
	@${ECHO} "*** Trying the examples ***"
	${GAP} -b -A -f -e -x 100 tryit.g
	@${ECHO}

gap:
	${GAP} -b -A -f -e

zip:
	@${ECHO} "*** Making the zip archive ***"
	${ZIP} -9 ../qdistrnd.zip *.g makefile lib/*.g matrices/*.mtx \
	  doc/body.autodoc doc/*.html doc/*.bib doc/*.pdf tmp/ README.md tst/*.tst 

tgz: 	html pdf
	@${ECHO} "*** Making the release archive ***"
	${TAR} -czvf ../qdistrnd.tgz -C .. QDistRnd/init.g QDistRnd/makedoc.g QDistRnd/PackageInfo.g \
		QDistRnd/makefile QDistRnd/makefile.win \
		QDistRnd/README.md QDistRnd/doc/body.autodoc QDistRnd/doc/QDistRnd.bib \
		QDistRnd/lib/examples.g QDistRnd/lib/qdistrnd.g QDistRnd/lib/cyclic.g \
		QDistRnd/matrices QDistRnd/tmp QDistRnd/tst 
		QDistRnd/doc/manual.pdf QDistRnd/doc/manual.six \
		QDistRnd/doc/chap0.html QDistRnd/doc/chap1.html QDistRnd/doc/chap2.html \
		QDistRnd/doc/chap3.html QDistRnd/doc/chap4.html QDistRnd/doc/chapBib.html \
		QDistRnd/doc/chapInd.html QDistRnd/doc/chooser.html 
	@${ECHO} "*** Done making the release archive ***"

clean:
	@${ECHO} "*** Cleaning up (keep the documentation) ***"
	${RM} -f *~ tmp?.tex doc/*.blg doc/*.out doc/*.brf doc/*.idx doc/*.log  doc/*.synctex.gz \
		 doc/*.xml doc/*.css doc/*.js doc/*.bbl doc/*.pnr doc/*.aux  */*~ \
		doc/*.ilg doc/*.ind doc/*_mj.html 

veryclean: clean 
	${RM} -f tst/*.tst tmp/* doc/*.html doc/*.txt doc/*.tex doc/*.pdf doc/*.six doc/*.toc doc/*.lab
	${RM} -f -r doc/auto

