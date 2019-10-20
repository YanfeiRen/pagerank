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
        "graphfile"
            help = "a positional argument"
            required = true
    end

    return parse_args(s)
end

using MatrixNetworks
using StaticArrays
using BenchmarkTools

function threaded_benchmark(graphfile::AbstractString, maxtime::Float64=14.4*60)
    gdata = load_data(graphfile)
    benchmarks = Dict{String,Int}()
    vex = SVector((1:8)...)
    alpha = 0.85

    println("Benchmarking simple_pagerank for power_method")
    benchmarks["power_simple"] = benchmark_method_single(maxtime, setup_call_simple_power, gdata, alpha, 1)
    println(benchmarks["power_simple"])

    println("Benchmarking fast_pagerank_power for power_method")
    benchmarks["power_fast"] = benchmark_method_single(maxtime, setup_call_fast_power, gdata, alpha, 1)
    println(benchmarks["power_fast"])

    println("Benchmarking multi_pagerank for power_method")
    benchmarks["power_multi"] = benchmark_method_multi(maxtime, setup_call_simple_power_multi, gdata, alpha, vex)
    println(benchmarks["power_multi"])

    println("Benchmarking FastGaussSeidel")
    benchmarks["gs_fast"] = benchmark_method_single(maxtime, setup_call_gs_fast, gdata, alpha, 1)
    println(benchmarks["gs_fast"])

    println("Benchmarking FastGaussSeidelFromZero")
    benchmarks["gs_fast_zero"] = benchmark_method_single(maxtime, setup_call_gs_from_zero, gdata, alpha, 1)
    println(benchmarks["gs_fast_zero"])

    println("Benchmarking GaussSeidelMultiPR")
    benchmarks["gs_multi"] = benchmark_method_multi(maxtime, setup_call_gs_multi, gdata, alpha, vex)
    println(benchmarks["gs_multi"])

    println("Benchmarking gs_multi_zero")
    benchmarks["gs_multi_zero"] = benchmark_method_multi(maxtime, setup_call_gs_multi_from_zero, gdata, alpha, vex)
    println(benchmarks["gs_multi_zero"])

    println("Benchmarking simple_push_method")
    benchmarks["push_simple"] = benchmark_method_single(maxtime, setup_call_simple_push_method, gdata, alpha, 1)
    println(benchmarks["push_simple"])

    println("Benchmarking multi_push_method")
    benchmarks["push_multi"] = benchmark_method_multi(maxtime, setup_call_multi_push_method, gdata, alpha, vex)
    println(benchmarks["push_multi"])

    println("Benchmarking cyclic_push_method")
    benchmarks["push_cyclic"] = benchmark_method_single(maxtime, setup_call_cyclic_push_method, gdata, alpha, 1)
    println(benchmarks["push_cyclic"])

    println("Benchmarking cyclic_multi_push_method")
    benchmarks["push_cyclic_multi"] = benchmark_method_multi(maxtime, setup_call_cyclic_multi_push_method, gdata, alpha, vex)
    println(benchmarks["push_cyclic_multi"])

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
    display(threaded_benchmark(parsed_args["graphfile"], 60*parsed_args["maxtime"]))
    println("")

end

if !isinteractive()
    main()
end
