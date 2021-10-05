# this is specific for GAP under windows with msys64
GAP = C:/usr/gap-4_11.1/gap.exe
GAPDIR = /C/usr/gap-4_11.1
export PATH = C:\usr\gap-4_11.1\bin\x86_64-pc-cygwin-default64-kv7

ECHO = /usr/bin/echo
SED = /usr/bin/sed 
CD = /usr/bin/cd
RM = /usr/bin/rm
MV = /usr/bin/mv
ZIP = /usr/bin/zip 
PDFLATEX = /c/usr/MiKTeX/miktex/bin/x64/pdflatex
MAKEINDEX = /c/usr/MiKTeX/miktex/bin/x64/makeindex
BIBTEX = /c/usr/MiKTeX/miktex/bin/x64/bibtex

default: html try

all: html pdf try 

html:	
	@${ECHO} "*** Making the documentation ***"
	${GAP} -l ${GAPDIR} -b -A -f makedoc.g

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
	${GAP} -l ${GAPDIR} -b -A -f -e -x 100 tryit.g
	@${ECHO}

gap:
	${GAP} -l ${GAPDIR} -b -A -f -e

zip:
	@${ECHO} "*** Making the zip archive ***"
	${ZIP} -9 ../qdistrnd.zip *.g makefile lib/*.g matrices/*.mtx \
	  doc/body.autodoc doc/*.html doc/*.bib doc/*.pdf tmp/ README.md tst/*.tst 

clean:
	@${ECHO} "*** Cleaning up ***"
	${RM} -f *~ tmp?.tex doc/*.blg doc/*.out doc/*.brf doc/*.idx doc/*.log  doc/*.synctex.gz \
		doc/*.toc doc/*.xml doc/*.css doc/*.lab doc/*.js doc/*.bbl doc/*.pnr doc/*.aux doc/*.six */*~ \
		doc/*.ilg doc/*.ind

veryclean: clean
	${RM} -f tst/*.tst tmp/* doc/*.html doc/*.txt doc/*.tex doc/*.pdf 
	${RM} -f -r doc/auto

