# `GAP` package `QDistRnd`
The `GAP` package for calculating the distance of a $q$-ary quantum
stabilizer code

[![DOI](https://joss.theoj.org/papers/10.21105/joss.04120/status.svg)](https://doi.org/10.21105/joss.04120)

## Overview
The `GAP` package `QDistRnd` implements a probabilistic algorithm for
finding the distance of a $q$-ary quantum low-density parity-check
code linear over a finite field GF($q$).  An empirical convergence
criterion is provided to estimate the probability that a minimum
weight codeword has actually been found.  Versions of the routines for
CSS and regular stabilizer codes are given.

In addition, a format for storing matrices associated with $q$-ary
quantum codes is introduced and implemented via provided import/export
routines.  The format is based on the well established MaTrix market
eXchange (MTX) Coordinate format developed at NIST, and is designed
for full backward compatibility with this format.  Thus, the files are
readable by any software package which supports MTX.

## Requirements 
The package `QDistRnd` requires the `Guava` package to run; `GAPDoc`
and `AutoDoc` are required to generate the documentation (see the file
`PackageInfo.g` for versions required).  All of these packages are
included with `GAP` version 4.11; this or later version of `GAP` is
strongly recommended.

## Installation
Starting with GAP 4.13.0, the `QDistRnd` package is distributed with a standard installation of `GAP`. 

To install the package permanently, download the latest released version from 
[releases](https://github.com/QEC-pages/QDistRnd/releases/) 
and unpack it in the `pkg` directory of one of your `GAP` root
directories.  After installation, the package can be loaded at the
`GAP` prompt by typing

    gap> LoadPackage("QDistRnd");

Alternatively, if you just want to try it, you can unpack the package
anywhere and type at the `GAP` prompt 

    gap> SetPackagePath("QDistRnd","absolute_path_to_the_package_QDistRnd" );

After that you can load the package as you would do normally.

## Testing

After installation, basic tests of the package (most of the examples
listed in the package manual) can by performed by running

    gap> TestPackage("qdistrnd");

at the GAP command prompt.  Note that the package name must be in
lowercase. 


The same tests are run as a part of documentation processing script
which is also executed as a GitHub Action every time changes are
commited.

## Documentation
Documentation for the package can be found in the `doc` subdirectory in
HTML form as `chap0.html` and PDF form as `manual.pdf`. Documentation
can also be accessed on the [package
website](https://qec-pages.github.io/QDistRnd/) and through the
standard `GAP` help system. Documentation can be recompiled by running

    gap makedoc.g

in the package directory.

## Plans for the future

1. The package only deals with Galois-qubit `q`-ary codes.  It would
   be nice to develop and implement similar methods for quantum codes
   over a finite ring, e.g., `Z(q)` with `q` not necessarily a power
   of a prime.  This could be done with the help of Smith normal form
   decomposition.  The required complexity may be higher, however.
   
2. Write sample read/write routines for `MTXE` files in `Mathematica`
   and/or `C`.

3. If there is need (or interest), add routines for the alternate
   integer format to represent elements from extension fields, where
   polynomials over a prime field `GF(p)` will be encoded as `p`-ary
   integers.  The only apparent advantage would be a unification with
   the currently used format for prime field elements using the
   equivalence with `Z(p)`.  On the other hand, it would not improve
   readability: the corresponding decimal integers would be as
   difficult to interpret as the currently used integer powers of a
   primitive field element.
