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
    affiliation: "1, 2"
  - name: Vadim A. Shabashov
    affiliation: 2
  - name: Valerii K. Kozin
    affiliation: "3, 2"
affiliations: 
 - name: Department of Physics & Astronomy, University of California, Riverside, California, 92521 USA
   index: 1
 - name: The Department of Physics & Engineering, ITMO University, St. Petersburg, 197101 Russia
   index: 2
 - name: Department of Physics, University of Basel, Klingelbergstrasse 82, CH-4056 Basel, Switzerland
   index: 3
date: 01 December 2021
bibliography: QDistRnd.bib
---

# Summary

The GAP package `QDistRnd` implements a probabilistic algorithm for
finding the minimum distance of a quantum low-density parity-check code linear over a finite
field $\mathop{\rm GF}(q)$. At each step several codewords are
randomly drawn from a distribution biased toward smaller weights. The
corresponding weights are used to update the upper bound on the
distance, which eventually converges to the minimum distance of the
code. While there is no performance guarantee, an empirical convergence
criterion is given to estimate the probability that a minimum weight
codeword has been found. In addition, a format for storing matrices
associated with $q$-ary quantum codes is introduced and implemented
via the provided import/export functions. The format, MTXE, is based on
the well established MaTrix market eXchange (MTX) Coordinate format
developed at NIST, and is designed for full backward compatibility with
this format. Thus, MTXE files are readable by any software package which
supports MTX.

# Statement of need

Multi-particle quantum correlations can be destroyed rapidly in the
presence of errors due to noise, environment, or just random control
errors [@Nielsen-book]. Quantum error correction (QEC) gives a unique way of controlling
such errors and enables, at least theoretically, an arbitrarily long
quantum computation when error probability $p$ is below certain
threshold, $p_c>0$.

QEC requires the use of specially designed quantum error-correcting
codes (QECCs). One of the most important parameters of a QECC is the
code distance, the minimum weight of a non-trivial logical operator in
the code. While for some code families the distance is known or can be
related to that of a classical linear error-correcting code, as, e.g.,
in the case of hypergraph-product and related codes [@Tillich-Zemor-2009; @Zeng-Pryadko-2018; @Zeng-Pryadko-hprod-2020], in many cases the
distance has to be computed directly [@Kovalev-Pryadko-Hyperbicycle-2013; @Bravyi-Hastings-2013; @Guth-Lubotzky-2014; @Panteleev-Kalachev-2019]. Computing the distance is related
to the problem of minimum-weight syndrome-based decoding; just like for
the classical linear codes [@Evseev-1983], this problem is NP-hard (note that truly
optimal maximum-likelihood decoding for quantum codes requires
degeneracy to be taken into account and is a \#P-complete problem [@Iyer-Poulin-2013]).

To our knowledge, there is no freely available software for computing
the distance of a $q$-ary quantum stabilizer code. A version of the
Zimmermann algorithm for finding the distance of linear codes is
implemented in Magma [@magma-system], and has been adapted in application to quantum
codes, see
<http://magma.maths.usyd.edu.au/magma/handbook/text/1971#22279>. Its
performance, in particular, in application to practically important [@Kovalev-Pryadko-FT-2013]
highly-degenerate quantum codes, also known as quantum LDPC codes, has
not been tested by the authors. Several <span>`C`</span> and
<span>`C++`</span> programs for computing the minimum distance of qubit
(binary) Calderbank-Shor-Steane (CSS) codes in various stages of
development can also be found at the GitHub respository
[QEC-pages](https://github.com/QEC-pages), owned by one of the authors.

The lack of available software has caused researchers in the field of QECC
to either skip the minimum distance calculations altogether [@Panteleev-Kalachev-2019], or develop
their own suboptimal algorithms. In particular, Bravyi and Hastings [@Bravyi-Hastings-2013] used
an exhaustive search over all non-trivial codewords for calculating the
minimum distances.

Note that for some families of QECCs, the distance can be calculated
efficiently. In particular, @Breuckmann-thesis-2017 described an algorithm
attributed to S. Bravyi for computing the distance of a surface code
based on a locally planar graph; for such a code of length $n$ with
$k$ logical qubits, the distance can be computed in
$\mathcal{O}(kn^2\log n)$ steps. Similarly, a version of the
error-impulse method [@Hu-Fossorier-Eleftheriou-2004; @Declercq-Fossorier-2008] based on the belief propagation decoding algorithm
designed for linear LDPC codes can in principle be used for quantum LDPC
codes. We are not aware of any applications of such a technique to
QECCs.

We should mention recent theoretical constructions that prove the
existence of families of quantum LDPC codes with stabilizer generators
of bounded weight and linear (or almost linear) minimum distances 
[@Hastings-Haah-ODonnell-2020; @Panteleev-Kalachev-2020; @Breuckmann-Eberhardt-2020; @Panteleev-Kalachev-2021]. Hardly any of the
codes from the described families have been explicitly constructed, the
reason being that the constructions are expected to produce very long
codes. Thus, there is also a need to develop software for calculating
minimal distances of quantum codes and optimized specifically for long
($n>10^3$) and very long ($n>10^5$) quantum LDPC codes based on
qubits.

# Functionality of the package

The distance-finding routines in the package <span>`QDistRnd`</span> are
derived from the code originally written by one of the authors.
Implemented algorithm is a variant of the random Information Set (IS)
algorithm based on random column permutations and Gauss elimination [@Leon-1988; @Kruk-1989; @Coffey-Goodman-1990]. Its
eventual convergence for quantum stabilizer codes can be proved based on
the existence [@Cuellar-etal-2020] of a permutation matrix $P$ such that the reduced row
echelon form of the matrix $G'=GP$ contains a vector with the weight
equal to the distance of the linear code generated by the rows of $G$.
Further, a related Covering Set (CS) algorithm has a provable
performance [@Dumer-Kovalev-Pryadko-IEEE-2017] for generic (non-LDPC) quantum codes based on random
matrices; the corresponding estimate of the number of iterations needed
to obtain the distance with probability sufficiently close to 1 also
applies for the IS algorithm.

The GAP computer algebra system was chosen because of its excellent
support for linear algebra over finite fields. The package <span>` 
QDistRnd `</span> gives a reference implementation of the algorithm,
with a focus on generality and matrix formats, but not necessarily
performance. Nevertheless, the routines are sufficiently fast when
dealing with codes of practically important block lengths
$n\lesssim 10^3$.

The package also contains functions for importing/exporting matrices
with elements in a given (finite) Galois field, and a description of a
text-based format <span>`MTXE`</span> based on the well-established
MaTrix market eXchange (MTX) Coordinate format developed at NIST [@nist-mm-format]. The
extension is implemented via structured comments, which guarantees full
backward compatibility with the original MTX format. Thus, MTXE files
can be read directly by any software package that supports MTX,
although some additional processing of matrix elements may be required.

#  Acknowledgements

We are grateful to Ilya Dumer for multiple helpful discussions on the
subject. L.P.P. was financially supported in part by the NSF Division of
Physics via grants 1820939 and 2112848, and by the Government of the Russian
Federation through the ITMO Fellowship and Professorship Program. V.K.K. 
acknowledges the support from the Georg H. Endress foundation.

# References
