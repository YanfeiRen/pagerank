#!/bin/bash
JULIA=/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia JULIA_NUM_THREADS=1 bash run-distributed-benchmark.sh $@
