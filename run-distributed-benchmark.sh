#!/bin/bash
$JULIA -O3 -e 'using Pkg; Pkg.activate("."); include("benchmark-distributed.jl");' $@
