#!/bin/bash
$JULIA -e 'using Pkg; Pkg.activate("."); Pkg.test()'
