#!/bin/bash
$JULIA -e 'using Pkg; Pkg.activate("."); include("src/ManyPagerank.jl"); include("benchmark.jl");' $@
