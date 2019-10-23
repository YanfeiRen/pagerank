results = []

## Collected by Yanfei Ren, 10:40am EDT 10/22
result = Dict(["fast_power_multi_8" => 5576
"gs_multi_zero_8" => 16496
"push_cyclic_multi_16" => 6080
"power_fast" => 1239
"fast_power_multi_16" => 5760
"push_cyclic_multi_8" => 6856
"power_simple" => 1598
"push_simple" => 1030
"power_multi_16" => 6208
"gs_fast" => 2863
"push_multi_8" => 4360
"power_multi_8" => 7176
"gs_multi_8" => 11136
"push_cyclic" => 2042
"gs_fast_zero" => 3399
"gs_multi_16" => 11648
"push_multi_16" => 4944
"gs_multi_zero_16" => 16720])
params = ["distributed", "procs-192", "graph-livejournal", "order-original", "server-unimodular"]
push!(results, (result, params))

## "threaded", "threads-1", "graph-livejournal", "order-original", "server-nilpotent" 
result = Dict(["fast_power_multi_8" => 64
  "gs_multi_zero_8" => 152
  "push_cyclic_multi_16" => 96
  "power_fast" => 16
  "fast_power_multi_16" => 80
  "push_cyclic_multi_8" => 104
  "power_simple" => 25
  "push_simple" => 12
  "power_multi_16" => 96
  "gs_fast" => 41
  "push_multi_8" => 56
  "power_multi_8" => 88
  "gs_multi_8" => 112
  "push_cyclic" => 41
  "gs_fast_zero" => 46
  "gs_multi_16" => 144
  "push_multi_16" => 64
  "gs_multi_zero_16" => 176])
params = ["threaded", "threads-1", "graph-livejournal", "order-original", "server-nilpotent"]
push!(results, (result, params))
