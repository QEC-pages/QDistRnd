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

Quantum computation is hard, primarily, because of the fragility of
multi-particle quantum correlations; these correlations can be
destroyed rapidly in the presence of errors (noise, environment, or
just random control errors) [@Nielsen-book].  Quantum error correction
(QEC) gives a unique way of dealing with such a fragility and enables, at least theoretically, 
an arbitrarily long quantum computation when
error probability $p$ is below certain threshold, $p_c>0$.

QEC requires the use of specially designed quantum error-correcting
codes (QECCs).  One of the most important parameters of a QECC is the
code distance, the minimum weight of a non-trivial logical operator in
the code.  While for some code families the distance is known or can
be related to that of a classical linear error-correcting code, e.g.,
in the case of hypergraph-product and related codes
[@Tillich-Zemor-2009; @Zeng-Pryadko-2018; @Zeng-Pryadko-hprod-2020], in
most cases the distance has to be computed numerically.

So far, there has been very little available software for computing
the distance of quantum codes, and none at all for non-binary codes.   

# The contribution 

The routines in the package are derived from the code originally written
by one of the authors (LPP).  A related Covering Set algorithm has a
provable performance for generic (non-LDPC) quantum codes based on
random matrices <Cite Key="Dumer-Kovalev-Pryadko-IEEE-2017"/>.
Implemented version is a variant of the random **information set**
(IS) algorithm based on random column permutations and Gauss'
elimination [@Leon-1988; @Kruk-1989; Coffey-Goodman-1990].

The &GAP; computer algebra system was chosen because of its excellent
support for linear algebra over finite fields.  Here we give a
reference implementation of the algorithm, with a focus on matrix
formats and generality, as opposed to performance.  Nevertheless, the
routines are sufficiently fast when dealing with codes of practically
important block lengths $n\lesssim 10^3$.

# Acknowledgements

We are grateful to I. Dumer for multiple helpful discussions on the subject.  LPP was supported in part by 
the NSF Division of Physics via
grant No. 1820939.

# References
