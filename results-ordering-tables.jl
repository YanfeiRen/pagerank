# results-ordering-tables.jl
include("results.jl")
##
using Printf


# The goal is to make these tables.

#=
Ordering	LiveJournal - 64 Threads
	Native	50	100
Power-8
GS-8
Cyclic Push-8

	Orkut - 64 Threads
	Native	50	100
Power-8
GS-8
Cyclic Push-8

And the distributed tables


	LiveJournal
	1T	1P	96T	96P	192T	192P
Power-8
GS-8
Cyclic Push-8


	Orkut
	1T	1P	96T	96P	192T	192P
Power-8
GS-8
Cyclic Push-8
=#

allparams = getindex.(results,2)
display(allparams)
allparams
## Look at the threaded results for orkut on nilpotent as order varies
subset = [7,8,9] # chosen manually...
orkut_order = getindex.(results[subset],1)
display(allparams[subset])
#=
should show
["threaded", "threads-64", "graph-orkut", "order-original", "server-nilpotent"]
["threaded", "threads-64", "graph-orkut", "order-50", "server-nilpotent"]
["threaded", "threads-64", "graph-orkut", "order-100", "server-nilpotent"]
=#

##
function make_order_table(results)
  methods = ["power_multi_8","gs_multi_zero_8","push_cyclic_multi_8","push_multi_8"]
  names = ["Power", "Gauss-Seidel", "Cyclic Push", "Queue Push"]
  for i=1:size(methods,1)
    @printf("%20s ", names[i])
    for j=1:length(results)
      @printf(" & %4i", results[j][methods[i]])
    end
    println(" \\\\")
  end
end
make_order_table(orkut_order)

##
## Look at the threaded results for orkut on nilpotent as order varies
subset = [10,11,12] # chosen manually...
lj_order = getindex.(results[subset],1)
display(allparams[subset])
#=
Should show
["threaded", "threads-64", "graph-livejournal", "order-original", "server-nilpotent"]
["threaded", "threads-64", "graph-livejournal", "order-50", "server-nilpotent"]
["threaded", "threads-64", "graph-livejournal", "order-100", "server-nilpotent"]
=#
##
make_order_table(lj_order)

## We can use this also for the distributed tables on unimodular
subset = [18,11,19,12,20,13].+2
uni_lj = getindex.(results[subset],1)
display(allparams[subset])
#= should see
["threaded", "threads-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
["distributed", "procs-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
["threaded", "threads-96", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
["distributed", "procs-96", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
["threaded", "threads-192", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
["distributed", "procs-192", "graph-livejournal", "order-50", "server-unimodular"]
=#
make_order_table(uni_lj)


##
subset = [23,17,24,18,25,19]
uni_orkut = getindex.(results[subset],1)
display(allparams[subset])
#= should see
["threaded", "threads-1", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
["distributed", "procs-1", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
["threaded", "threads-96", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
["distributed", "procs-96", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
["threaded", "threads-192", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
["distributed", "procs-192", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
=#
make_order_table(uni_orkut)
