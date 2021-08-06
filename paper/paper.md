---
title: 'QDistRnd: A GAP package for computing the distance of quantum error-correcting codes'
tags:
  - GAP
  - Quantum Error Correction
  - QECC
  - Quantum Error-Correcting Code
  - Qudit code
  - quantum stabilizer code
  - CSS code
authors:
  - name: Leonid P. Pryadko
    orcid: 0000-0002-4990-0259
    affiliation: 1
  - name: Vadim A. Shabashov
    affiliation: 2
  - name: Valerii K. Kozin
    affiliation: "2, 3"
affiliations: 
  - name: Department of Physics & Astronomy, University of California, Riverside, California, 92521 USA
    index: 1
  - name: The Department of Physics & Engineering, ITMO University, St. Petersburg, 197101 Russia
    index: 2
  - name: Science Institute, University of Iceland, Dunhagi-3, IS-107 Reykjavik, Iceland
    index: 3
 date: 6 August 2021
 bibliography: doc/QDistRnd.bib
 ---

# Summary

The GAP package QDistRnd gives a reference implementation of a
probabilistic algorithm for finding the distance of a $q$-ary quantum
low-density parity-check code linear over a finite field $F=GF(q)$.
While there is no guarantee of the performance of the algorithm, an
empirical convergence criterion is given to estimate the probability
that a minimum weight codeword has been found.  In addition, a format
for storing matrices associated with $q$-ary quantum codes is
introduced and implemented.  The format is based on the well
establised MaTrix market eXchange (MTX) Coordinate format developed at
NIST, and is designed for full backward compatibility with this
format.  Thus, the files are readable by any software package which
supports MTX.

# Statement of need

Quantum computation is hard, in particular, because of the fragility
of multi-particle quantum correlations; in the presence of errors
(noise, environment, or just random control errors) they can be
destroyed rapidly.  Quantum error correction (QEC) gives a unique way
of dealing with such a fragility and enables (at least theoretically)
an arbitrarily long quantum computation when error probability $p$ is
below certain threshold, $p_c>0$.  QEC requires the use of specially
designed quantum error-correcting codes, whose development 

Development of quantum error


A significant hurdle to overcome is to build a
sufficient number of non-trivial example codes.  Over the years, the
PI has accumulated a number of such examples, generated with different
techniques.  Some of these codes are now available in the repository
\texttt{Quantum\_LDPC\_Codes} at the group's \texttt{github} page at
\url{http://github.com/QEC-pages}.  The data files are currently
ordered by construction.  As the number of different codes in the
repository grows, additional listings ordering available codes by
generator weight and block length, as, e.g., in David MacKay's
Encyclopedia of Sparse Graph Codes\cite{MacKay-enciclopedia-2017},
will be added.  The intent is to cover quantum codes with block sizes
up to $n =10^3$.  Comparing codes directly will also permit
task-specific optimization of codes.  \begin{problem} Expand the
repository of quantum LDPC codes by new codes constructed.  Invite
contributions by other researchers.  \end{problem} Notice that binary
and $q$-ary codes can be easily stored in Matrix Market
format\cite{nist-mm-format}, possibly with an extension specifying the
base.  When mixed-base codes become available, their storage would
require a special format to be developed (e.g., by listing each block
of columns corresponding to qudits with different dimensions
separately).

Another issue of practical importance is the software for dealing with
quantum codes, e.g., distance verification or syndrome-based decoding.
Writing an efficient program that works with large codes is highly
non-trivial.  For example, recent Intel processors support extended
instruction sets for bitwise logic on binary vectors of up to 512 bits
in length (\texttt{AVX-512}); this speeds up linear algebra over
$\mathbb{F}_2$ by orders of magnitude, compared to what one can get,
e.g., with \href{http://itpp.sourceforge.net/}{\texttt{IT++}} library.

Presently available at the group's \texttt{github} repository are:
\begin{itemize}
\item a program written by Michael Woolls and Weilei Zeng for error
  propagation through a Clifford circuit.  The program was used in
  simulations for
  Ref.~\onlinecite{Zeng-Ashikhmin-Woolls-Pryadko-2019}.
\item two programs written by Weilei Zeng for generating
  higher-dimensional product codes and calculating their parameters;
  it includes a subroutine for calculating the distance of a quantum
  CSS code using random information set
  decoder\cite{Prange-1962,Chua-Yang-1988,Dumer-Kovalev-Pryadko-IEEE-2017}.
  The programs were used for simulations related to
  Refs.~\onlinecite{Zeng-Pryadko-2018,Zeng-Pryadko-hprod-2020}.
\end{itemize}

\begin{problem}
  Publish in an open-source repository the programs implementing
  algorithms designed during this Project.  Maintain already published
  programs by fixing bugs and updating functionality occasionally.
\end{problem}
\noindent In addition, brief descriptions of the software packages
deemed particularly useful to others will be published in {SoftwareX}
(\url{https://www.journals.elsevier.com/softwarex/}) or the {Journal
  of Open Research Software}
(\url{https://openresearchsoftware.metajnl.com/}).


The routines in the package are derived from the code originally written
by one of the authors (LPP).  A related Covering Set algorithm has a
provable performance for generic (non-LDPC) quantum codes based on
random matrices <Cite Key="Dumer-Kovalev-Pryadko-IEEE-2017"/>.
Implemented version is a variant of the random **information set**
(IS) algorithm based on random column permutations and Gauss'
elimination <Cite Key="Leon-1988"/> <Cite Key="Kruk-1989"/> <Cite
Key="Coffey-Goodman-1990"/>.

The &GAP; computer algebra system was chosen because of its excellent
support for linear algebra over finite fields.  Here we give a
reference implementation of the algorithm, with a focus on matrix
formats and generality, as opposed to performance.  Nevertheless, the
routines are sufficiently fast when dealing with codes of practically
important block lengths $n\lesssim 10^3$.

# Statement of need

# 

# Acknowledgements

We are grateful to I. Dumer for multiple helpful discussions on the subject.  LPP was supported in part by 
the NSF Division of Physics via
grant No. 1820939.

# References
