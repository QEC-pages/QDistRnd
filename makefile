GAP = C:/usr/gap-4_11.1/gap.exe
#GAPDIR = /proc/cygdrive/C/usr/gap-4_11.1
GAPDIR = /C/usr/gap-4_11.1
export CYGWIN = nodosfilewarning
export LANG = en_US.UTF-8
export PATH = C:\usr\gap-4_11.1\bin\x86_64-pc-cygwin-default64-kv7;%PATH%

## GAP = /home/cats/gap-4.11.0/gap
## GAPDIR = /home/cats/gap-4.11.0
## export CYGWIN = nodosfilewarning
## export PATH = /home/cats/gap-4.11.0/bin/x86_64-pc-linux-gnu-default64-kv7;%PATH%

default: documentation try

documentation:	
	${GAP} -l ${GAPDIR} -b -A -f makedoc.g

try:
	${GAP} -l ${GAPDIR} -b -A -f -e -x 100 tryit.g

gap:
	${GAP} -l ${GAPDIR} -b -A -f -e

zip:
	/usr/bin/zip -9 ../qdistrnd.zip *.g makefile lib/*.g matrices/* examples/*.g \
	doc/body.autodoc doc/*.html doc/*.bib doc/*.pdf tmp/ README.md tst/*.tst 


