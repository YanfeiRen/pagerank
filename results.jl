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

## "threaded", "threads-64", "graph-livejournal", "order-original", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 2440
  "gs_multi_zero_8" => 5320
  "push_cyclic_multi_16" => 3040
  "power_fast" => 576
  "fast_power_multi_16" => 2784
  "push_cyclic_multi_8" => 3192
  "power_simple" => 731
  "push_simple" => 323
  "power_multi_16" => 2784
  "gs_fast" => 917
  "push_multi_8" => 1504
  "power_multi_8" => 2752
  "gs_multi_8" => 4480
  "push_cyclic" => 849
  "gs_fast_zero" => 1324
  "gs_multi_16" => 4512
  "push_multi_16" => 2048
  "gs_multi_zero_16" => 5680])
params = ["threaded", "threads-64", "graph-livejournal", "order-original", "server-nilpotent"]
push!(results, (result, params))

## "threaded", "threads-64", "graph-orkut", "order-original", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 512
  "gs_multi_zero_8" => 1744
  "push_cyclic_multi_16" => 272
  "power_fast" => 128
  "fast_power_multi_16" => 816
  "push_cyclic_multi_8" => 696
  "power_simple" => 186
  "push_simple" => 127
  "power_multi_16" => 816
  "gs_fast" => 294
  "push_multi_8" => 512
  "power_multi_8" => 904
  "gs_multi_8" => 1376
  "push_cyclic" => 210
  "gs_fast_zero" => 366
  "gs_multi_16" => 1120
  "push_multi_16" => 0
  "gs_multi_zero_16" => 1680])
params = ["threaded", "threads-64", "graph-orkut", "order-original", "server-nilpotent"]
push!(results, (result, params))

## "threaded", "threads-64", "graph-orkut", "order-50", "server-nilpotent" 
result = Dict(["fast_power_multi_8" => 928
  "gs_multi_zero_8" => 1920
  "push_cyclic_multi_16" => 1008
  "power_fast" => 182
  "fast_power_multi_16" => 992
  "push_cyclic_multi_8" => 1104
  "power_simple" => 256
  "push_simple" => 127
  "power_multi_16" => 960
  "gs_fast" => 421
  "push_multi_8" => 424
  "power_multi_8" => 896
  "gs_multi_8" => 1440
  "push_cyclic" => 391
  "gs_fast_zero" => 520
  "gs_multi_16" => 1600
  "push_multi_16" => 0
  "gs_multi_zero_16" => 1952])
params = ["threaded", "threads-64", "graph-orkut", "order-50", "server-nilpotent"]
push!(results, (result, params))

## "threaded", "threads-64", "graph-orkut", "order-100", "server-nilpotent" 
result = Dict(["fast_power_multi_8" => 968
  "gs_multi_zero_8" => 2120
  "push_cyclic_multi_16" => 976
  "power_fast" => 195
  "fast_power_multi_16" => 864
  "push_cyclic_multi_8" => 1176
  "power_simple" => 252
  "push_simple" => 128
  "power_multi_16" => 992
  "gs_fast" => 441
  "push_multi_8" => 512
  "power_multi_8" => 944
  "gs_multi_8" => 1448
  "push_cyclic" => 415
  "gs_fast_zero" => 561
  "gs_multi_16" => 1680
  "push_multi_16" => 0
  "gs_multi_zero_16" => 1936
])
params = ["threaded", "threads-64", "graph-orkut", "order-100", "server-nilpotent"]
push!(results, (result, params))

## liveJournal-50 - 1 procs Unimodular Distributed Tests (Only need 8x methods results)
## "distributed", "procs-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 240
  "push_multi_8" => 128
  "power_multi_8" => 256
  "gs_multi_8" => 320
  "push_cyclic_multi_8" => 328
  "gs_multi_zero_8" => 536])
params = ["distributed", "procs-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))
