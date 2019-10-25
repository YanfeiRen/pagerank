#results-allalgs-tables.jl
include("results.jl")
##
using Printf
##
allparams = getindex.(results,2)
display(allparams)
allparams
## Look at the threaded results for livejournal on nilpotent
subset = [3,4,5] # chosen manually...
results[subset]
nthreads = [1,32]
@show allparams[subset]
Ts = getindex.(results[subset], 1)
##
function make_threads_table(r, nthreads)
  methods = ["power_simple" "power_multi_8" "power_multi_16"
             "gs_fast_zero" "gs_multi_zero_8" "gs_multi_zero_16"
             "push_cyclic" "push_cyclic_multi_8" "push_cyclic_multi_8"
             "push_simple" "push_multi_8" "push_multi_16"]
  names = ["Power", "Gauss-Seidel", "Cyclic Push", "Queue Push"]
  #= design 1
  for i=1:size(methods,1)
    for t = 1:length(r) # once for each number of threads
      if t == 1
        @printf("%20s ", methods[i])
      else
        @printf("%20s ", "")
      end
      for j=1:size(methods,2)
        @printf("& %4i", r[t][methods[i,j]])
      end
      println("")
    end
  end
  =#
  for i=1:size(methods,1)
    @printf("%20s ", names[i])
    for j=1:size(methods,2)
      print(" & ")
      for t = 1:length(r)
        @printf("& %4i", r[t][methods[i,j]])
      end
    end
    println(" \\\\")
  end
end
make_threads_table(Ts, nthreads)
##
push!(Ts, Ts[2])
make_threads_table(Ts, nthreads)
