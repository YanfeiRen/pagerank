include("benchmark-common.jl")

using ArgParse

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--maxtime"
            help = "the total time in minutes"
            arg_type = Float64
            default = 14.4
        "--skipwarmup"
            help = "don't precompile the methods"
            action = :store_true
        "--runsubset_gs8"
            help = "only run the gs_multi_zero_8 method"
            action = :store_true
        "--runsubset8"
            help = "only run the 8x SIMD methods"
            action = :store_true
        "graphfile"
            help = "a positional argument"
            required = true
    end

    return parse_args(s)
end

using MatrixNetworks
using StaticArrays
using BenchmarkTools

function threaded_benchmark(graphfile::AbstractString,
    maxtime::Float64=14.4*60, subset8::Bool=false, subset_gs8::Bool=false)
    gdata = load_data(graphfile)
    benchmarks = Dict{String,Int}()
    vex8 = SVector((1:8)...)
    vex16 = SVector((1:16)...)
    alpha = 0.85

    subset = subset8 || subset_gs8

    if subset==false
        println("Benchmarking simple_pagerank for power_method")
        benchmarks["power_simple"] = benchmark_method_single(maxtime, setup_call_simple_power, gdata, alpha, 1)
        println(benchmarks["power_simple"])
    end

    if subset==false
        println("Benchmarking fast_pagerank_power for power_method")
        benchmarks["power_fast"] = benchmark_method_single(maxtime, setup_call_fast_power, gdata, alpha, 1)
        println(benchmarks["power_fast"])
    end

    if !subset || (subset8==true && subset_gs8==false)
        println("Benchmarking multi_pagerank for power_method - 8")
        benchmarks["power_multi_8"] = benchmark_method_multi(maxtime, setup_call_simple_power_multi, gdata, alpha, vex8)
        println(benchmarks["power_multi_8"])
    end

    if subset==false
        println("Benchmarking multi_pagerank for power_method - 16")
        benchmarks["power_multi_16"] = benchmark_method_multi(maxtime, setup_call_simple_power_multi, gdata, alpha, vex16)
        println(benchmarks["power_multi_16"])
    end

    if !subset || (subset8==true && subset_gs8==false)
        println("Benchmarking fast_multi for power_method - 8")
        benchmarks["fast_power_multi_8"] = benchmark_method_multi(maxtime, setup_call_fast_power_multi, gdata, alpha, vex8)
        println(benchmarks["fast_power_multi_8"])
    end

    if subset == false
        println("Benchmarking fast_multi for power_method - 16")
        benchmarks["fast_power_multi_16"] = benchmark_method_multi(maxtime, setup_call_fast_power_multi, gdata, alpha, vex16)
        println(benchmarks["fast_power_multi_16"])
    end

    if subset == false
        println("Benchmarking FastGaussSeidel")
        benchmarks["gs_fast"] = benchmark_method_single(maxtime, setup_call_gs_fast, gdata, alpha, 1)
        println(benchmarks["gs_fast"])
    end

    if subset == false
        println("Benchmarking FastGaussSeidelFromZero")
        benchmarks["gs_fast_zero"] = benchmark_method_single(maxtime, setup_call_gs_from_zero, gdata, alpha, 1)
        println(benchmarks["gs_fast_zero"])
    end

    if !subset || (subset8==true && subset_gs8==false)
        println("Benchmarking GaussSeidelMultiPR-8")
        benchmarks["gs_multi_8"] = benchmark_method_multi(maxtime, setup_call_gs_multi, gdata, alpha, vex8)
        println(benchmarks["gs_multi_8"])
    end

    if subset == false
        println("Benchmarking GaussSeidelMultiPR-16")
        benchmarks["gs_multi_16"] = benchmark_method_multi(maxtime, setup_call_gs_multi, gdata, alpha, vex16)
        println(benchmarks["gs_multi_16"])
    end

    # this one is always run!
    println("Benchmarking gs_multi_zero 8")
    benchmarks["gs_multi_zero_8"] = benchmark_method_multi(maxtime, setup_call_gs_multi_from_zero, gdata, alpha, vex8)
    println(benchmarks["gs_multi_zero_8"])

    if subset == false
        println("Benchmarking gs_multi_zero 16")
        benchmarks["gs_multi_zero_16"] = benchmark_method_multi(maxtime, setup_call_gs_multi_from_zero, gdata, alpha, vex16)
        println(benchmarks["gs_multi_zero_16"])
    end

    if subset == false
        println("Benchmarking simple_push_method")
        benchmarks["push_simple"] = benchmark_method_single(maxtime, setup_call_simple_push_method, gdata, alpha, 1)
        println(benchmarks["push_simple"])
    end

    if !subset || (subset8==true && subset_gs8==false)
        println("Benchmarking multi_push_method - 8")
        benchmarks["push_multi_8"] = benchmark_method_multi(maxtime, setup_call_multi_push_method, gdata, alpha, vex8)
        println(benchmarks["push_multi_8"])
    end

    if subset == false
        println("Benchmarking multi_push_method - 16")
        benchmarks["push_multi_16"] = benchmark_method_multi(maxtime, setup_call_multi_push_method, gdata, alpha, vex16)
        println(benchmarks["push_multi_16"])
    end

    if subset == false
        println("Benchmarking cyclic_push_method")
        benchmarks["push_cyclic"] = benchmark_method_single(maxtime, setup_call_cyclic_push_method, gdata, alpha, 1)
        println(benchmarks["push_cyclic"])
    end

    if !subset || (subset8==true && subset_gs8==false)
        println("Benchmarking cyclic_multi_push_method - 8 ")
        benchmarks["push_cyclic_multi_8"] = benchmark_method_multi(maxtime, setup_call_cyclic_multi_push_method, gdata, alpha, vex8)
        println(benchmarks["push_cyclic_multi_8"])
    end

    if subset == false
        println("Benchmarking cyclic_multi_push_method - 16 ")
        benchmarks["push_cyclic_multi_16"] = benchmark_method_multi(maxtime, setup_call_cyclic_multi_push_method, gdata, alpha, vex16)
        println(benchmarks["push_cyclic_multi_16"])
    end

    return benchmarks
end



function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg,val) in parsed_args
        println("  $arg  =>  $val")
    end

    if parsed_args["skipwarmup"] == false
        println("Warming up methods ... ")
        @time warmup_methods()
    end

    println("Running methods on $(parsed_args["graphfile"]) ")
    display(threaded_benchmark(parsed_args["graphfile"],
        60*parsed_args["maxtime"],
        parsed_args["runsubset8"],
        parsed_args["runsubset_gs8"]))
    println("")
end

if !isinteractive()
    main()
end
