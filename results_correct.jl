results = []

###################################### All methods - 14.4 mins threaded ###################

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

###################################### All methods - 14.4 mins distributed ###################
## "distributed", "procs-1", "graph-livejournal", "order-original", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 64
  "gs_multi_zero_8" => 144
  "push_cyclic_multi_16" => 96
  "power_fast" => 16
  "fast_power_multi_16" => 80
  "push_cyclic_multi_8" => 96
  "power_simple" => 24
  "push_simple" => 9
  "power_multi_16" => 96
  "gs_fast" => 24
  "push_multi_8" => 40
  "power_multi_8" => 88
  "gs_multi_8" => 104
  "push_cyclic" => 27
  "gs_fast_zero" => 28
  "gs_multi_16" => 80
  "push_multi_16" => 48
  "gs_multi_zero_16" => 176])
params = ["distributed", "procs-1", "graph-livejournal", "order-original", "server-nilpotent"]
push!(results, (result, params))

## "distributed", "procs-32", "graph-livejournal", "order-original", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 1368
  "gs_multi_zero_8" => 3064
  "push_cyclic_multi_16" => 1776
  "power_fast" => 308
  "fast_power_multi_16" => 1520
  "push_cyclic_multi_8" => 1992
  "power_simple" => 438
  "push_simple" => 189
  "power_multi_16" => 1696
  "gs_fast" => 576
  "push_multi_8" => 880
  "power_multi_8" => 1800
  "gs_multi_8" => 2536
  "push_cyclic" => 544
  "gs_fast_zero" => 690
  "gs_multi_16" => 2720
  "push_multi_16" => 1296
  "gs_multi_zero_16" => 3616])
params = ["distributed", "procs-32", "graph-livejournal", "order-original", "server-nilpotent"]
push!(results, (result, params))

## "distributed", "procs-64", "graph-livejournal", "order-original", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 2128
  "gs_multi_zero_8" => 5704
  "push_cyclic_multi_16" => 2480
  "power_fast" => 493
  "fast_power_multi_16" => 1968
  "push_cyclic_multi_8" => 2848
  "power_simple" => 697
  "push_simple" => 302
  "power_multi_16" => 2912
  "gs_fast" => 937
  "push_multi_8" => 1536
  "power_multi_8" => 2920
  "gs_multi_8" => 4208
  "push_cyclic" => 723
  "gs_fast_zero" => 965
  "gs_multi_16" => 4288
  "push_multi_16" => 1872
  "gs_multi_zero_16" => 5632])
params = ["distributed", "procs-64", "graph-livejournal", "order-original", "server-nilpotent"]
push!(results, (result, params))

###################################### Ordering Tests - 14.4 mins ############################

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

## "threaded", "threads-64", "graph-livejournal", "order-50", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 2720
  "gs_multi_zero_8" => 7128
  "push_cyclic_multi_16" => 3984
  "power_fast" => 769
  "fast_power_multi_16" => 3104
  "push_cyclic_multi_8" => 4272
  "power_simple" => 1006
  "push_simple" => 357
  "power_multi_16" => 3520
  "gs_fast" => 1397
  "push_multi_8" => 1808
  "power_multi_8" => 3312
  "gs_multi_8" => 5496
  "push_cyclic" => 1482
  "gs_fast_zero" => 1971
  "gs_multi_16" => 5888
  "push_multi_16" => 2048
  "gs_multi_zero_16" => 6640])
params = ["threaded", "threads-64", "graph-livejournal", "order-50", "server-nilpotent"]
push!(results, (result, params))

## "threaded", "threads-64", "graph-livejournal", "order-100", "server-nilpotent"
result = Dict(["fast_power_multi_8" => 2680
  "gs_multi_zero_8" => 6864
  "push_cyclic_multi_16" => 4064
  "power_fast" => 779
  "fast_power_multi_16" => 3280
  "push_cyclic_multi_8" => 4928
  "power_simple" => 998
  "push_simple" => 396
  "power_multi_16" => 3728
  "gs_fast" => 1420
  "push_multi_8" => 1936
  "power_multi_8" => 3544
  "gs_multi_8" => 5840
  "push_cyclic" => 1424
  "gs_fast_zero" => 1910
  "gs_multi_16" => 6032
  "push_multi_16" => 2064
  "gs_multi_zero_16" => 7472])
params = ["threaded", "threads-64", "graph-livejournal", "order-100", "server-nilpotent"]
push!(results, (result, params))

############### Unimodular Distributed Tests (Only need 8x methods results) #########################

## "distributed", "procs-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 120
  "push_multi_8" => 64
  "power_multi_8" => 120
  "gs_multi_8" => 168
  "push_cyclic_multi_8" => 168
  "gs_multi_zero_8" => 272])
params = ["distributed", "procs-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "distributed", "procs-96", "graph-livejournal", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 5528
  "push_multi_8" => 3256
  "power_multi_8" => 5960
  "gs_multi_8" => 8728
  "push_cyclic_multi_8" => 7728
  "gs_multi_zero_8" => 13920])
params = ["distributed", "procs-96", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "distributed", "procs-192", "graph-livejournal", "order-50", "server-unimodular"
result = Dict(["fast_power_multi_8" => 7800
  "push_multi_8" => 4496
  "power_multi_8" => 7768
  "gs_multi_8" => 13120
  "push_cyclic_multi_8" => 9920
  "gs_multi_zero_8" => 19160])
params = ["distributed", "procs-192", "graph-livejournal", "order-50", "server-unimodular"]
push!(results, (result, params))

## "distributed", "procs-192", "graph-livejournal", "order-original", "server-unimodular"
result = Dict(["fast_power_multi_8" => 5352
  "push_multi_8" => 4312
  "power_multi_8" => 6048
  "gs_multi_8" => 11384
  "push_cyclic_multi_8" => 6624
  "gs_multi_zero_8" => 15928])
params = ["distributed", "procs-192", "graph-livejournal", "order-original", "server-unimodular"]
push!(results, (result, params))

## "distributed", "procs-1", "graph-orkut", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 40
  "push_multi_8" => 24
  "power_multi_8" => 40
  "gs_multi_8" => 56
  "push_cyclic_multi_8" => 48
  "gs_multi_zero_8" => 88])
params = ["distributed", "procs-1", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "distributed", "procs-96", "graph-orkut", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 1504
  "push_multi_8" => 872
  "power_multi_8" => 1768
  "gs_multi_8" => 2472
  "push_cyclic_multi_8" => 1864
  "gs_multi_zero_8" => 4184])
params = ["distributed", "procs-96", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "distributed", "procs-192", "graph-orkut", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 1632
  "push_multi_8" => 920
  "power_multi_8" => 888
  "gs_multi_8" => 3560
  "push_cyclic_multi_8" => 2016
  "gs_multi_zero_8" => 5800])
params = ["distributed", "procs-192", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

############################### Unimodular Threaded Tests (Only need 8x methods results) ###############
## "threaded", "threads-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 104
  "push_multi_8" => 64
  "power_multi_8" => 104
  "gs_multi_8" => 160
  "push_cyclic_multi_8" => 160
  "gs_multi_zero_8" => 264])
params = ["threaded", "threads-1", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "threaded", "threads-96", "graph-livejournal", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 2992
  "push_multi_8" => 2752
  "power_multi_8" => 3232
  "gs_multi_8" => 6744
  "push_cyclic_multi_8" => 6432
  "gs_multi_zero_8" => 10248])
params = ["threaded", "threads-96", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "threaded", "threads-192", "graph-livejournal", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 80
  "push_multi_8" => 1808
  "power_multi_8" => 272
  "gs_multi_8" => 2288
  "push_cyclic_multi_8" => 4752
  "gs_multi_zero_8" => 3592])
params = ["threaded", "threads-192", "graph-livejournal", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "threaded", "threads-1", "graph-orkut", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 40
  "push_multi_8" => 24
  "power_multi_8" => 40
  "gs_multi_8" => 56
  "push_cyclic_multi_8" => 48
  "gs_multi_zero_8" => 88])
params = ["threaded", "threads-1", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "threaded", "threads-96", "graph-orkut", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 712
  "push_multi_8" => 680
  "power_multi_8" => 1048
  "gs_multi_8" => 1888
  "push_cyclic_multi_8" => 1584
  "gs_multi_zero_8" => 2384])
params = ["threaded", "threads-96", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))

## "threaded", "threads-192", "graph-orkut", "order-50", "server-unimodular", "subset8x"
result = Dict(["fast_power_multi_8" => 0
 "push_multi_8" => 0
 "power_multi_8" => 0
 "gs_multi_8" => 0
 "push_cyclic_multi_8" => 1040
 "gs_multi_zero_8" => 0])
params = ["threaded", "threads-192", "graph-orkut", "order-50", "server-unimodular", "subset8x"]
push!(results, (result, params))
