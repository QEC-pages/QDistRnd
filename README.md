# gap-package-qdistrnd
The `GAP` package for calculating the distance of a $q$-ary quantum
stabilizer code.

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
As of February 2022, the `QDistRnd` package is not distributed with a
standard installation of `GAP`. 

To install the package permanently, download the latest released version from 
[releases](https://github.com/QEC-pages/QDistRnd/releases/) 
and unpack it in the `pkg` directory of one of your `GAP` root
directories.  After installation, the package can be loaded at the
`GAP` prompt by typing

gap> `LoadPackage("QDistRnd");`

Alternatively, if you just want to try it, you can unpack the package
anywhere and type at the `GAP` prompt 

gap> `SetPackagePath("QDistRnd","absolute_path_to_the_package_QDistRnd" );`

After that you can load the package as you would do normally.

## Testing

After installation, basic tests of the package (most of the examples
listed in the package manual) can by performed by running

gap> `TestPackage("qdistrnd");`

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

`gap makedoc.g`

in the package directory.
