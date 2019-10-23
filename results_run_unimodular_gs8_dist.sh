#!/bin/bash
THREADS="1 12 24 48 64 72 96 120 144 168 192"
for T in $THREADS; do
  JULIA=/p/mnt/software/julia-1.3/bin/julia \
    JULIA_NUM_THREADS=1 \
    bash run-distributed-benchmark.sh \
      /p/mnt/scratch/dgleich/allpagerank/data/soc-LiveJournal1-scc-50.smat \
       --numprocs=$T --maxtime 5 --runsubset_gs8 | tee results/unimodular-livejournal-50-dist$T-gs8.txt
done
