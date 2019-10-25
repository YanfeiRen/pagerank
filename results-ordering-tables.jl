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
=#

allparams = getindex.(results,2)
display(allparams)
allparams
## Look at the threaded results for orkut on nilpotent as order varies
subset = [5,6,7] # chosen manually...
orkut_order = getindex.(results[subset],1)
display(allparams[subset])

##
function make_order_table(orig,order50,order100)
  orders = (orig,order50,order100)
  methods = ["power_multi_8","gs_multi_zero_8","push_cyclic_multi_8","push_multi_8"]
  names = ["Power", "Gauss-Seidel", "Cyclic Push", "Queue Push"]
  for i=1:size(methods,1)
    @printf("%20s ", names[i])
    for j=1:length(orders)
      @printf(" & %4i", orders[j][methods[i]])
    end
    println(" \\\\")
  end
end
make_order_table(orkut_order...)

##
## Look at the threaded results for orkut on nilpotent as order varies
subset = [8,9,10] # chosen manually...
lj_order = getindex.(results[subset],1)
display(allparams[subset])
##
make_order_table(lj_order...)
