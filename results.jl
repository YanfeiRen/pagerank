results = []

## "distributed", "procs-192", "graph-livejournal", "order-original", "server-unimodular"
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

## "distributed", "procs-192", "graph-livejournal", "order-50", "server-unimodular"
result = Dict(["fast_power_multi_8" => 7216
  "gs_multi_zero_8" => 19272
  "push_cyclic_multi_16" => 8224
  "power_fast" => 1956
  "fast_power_multi_16" => 7520
  "push_cyclic_multi_8" => 9448
  "power_simple" => 2281
  "push_simple" => 1009
  "power_multi_16" => 7776
  "gs_fast" => 4461
  "push_multi_8" => 4416
  "power_multi_8" => 8448
  "gs_multi_8" => 13224
  "push_cyclic" => 3721
  "gs_fast_zero" => 5165
  "gs_multi_16" => 14352
  "push_multi_16" => 5104
  "gs_multi_zero_16" => 18832])
params = ["distributed", "procs-192", "graph-livejournal", "order-50", "server-unimodular"]
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

## "threaded", "threads-32", "graph-livejournal", "order-original", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 1440
  "gs_multi_zero_8" => 3128
  "push_cyclic_multi_16" => 1840
  "power_fast" => 316
  "fast_power_multi_16" => 1840
  "push_cyclic_multi_8" => 2240
  "power_simple" => 399
  "push_simple" => 213
  "power_multi_16" => 1584
  "gs_fast" => 582
  "push_multi_8" => 944
  "power_multi_8" => 1984
  "gs_multi_8" => 2504
  "push_cyclic" => 626
  "gs_fast_zero" => 675
  "gs_multi_16" => 2576
  "push_multi_16" => 1232
  "gs_multi_zero_16" => 3248])
params = ["threaded", "threads-32", "graph-livejournal", "order-original", "server-nilpotent"]
push!(results, (result, params))

