#!/bin/bash
$JULIA -O3 -e 'using Pkg; Pkg.activate("."); include("src/ManyPagerank.jl"); include("benchmark-gsMultiZero8-threads.jl");' $@
