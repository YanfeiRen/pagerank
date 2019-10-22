#!/bin/bash
$JULIA -O3 -e 'using Pkg; Pkg.activate("."); include("benchmark-gsMultiZero8-distributed.jl");' $@
