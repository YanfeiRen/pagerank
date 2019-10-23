#!/bin/bash
THREADS="1 4 8 12 16 24 32 48 64"
for T in $THREADS; do
  JULIA=/p/mnt/software/julia-1.3/bin/julia \
    JULIA_NUM_THREADS=$T \
    bash run-threaded-benchmark.sh \
      /p/mnt/scratch/dgleich/allpagerank/data/soc-LiveJournal1-scc-50.smat \
       --maxtime 5 --runsubset_gs8 | tee results/nilpotent-livejournal-50-$T-gs8.txt
done
