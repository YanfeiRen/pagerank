include("benchmark-common.jl")

using ArgParse

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--maxtime"
            help = "the total time in minutes"
            arg_type = Float64
            default = 14.4
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
    vex8 = SVector((1:8)...)
    # vex16 = SVector((1:16)...)
    alpha = 0.85

    println("Benchmarking gs_multi_zero 8")
    benchmarks["gs_multi_zero_8"] = benchmark_method_multi(maxtime, setup_call_gs_multi_from_zero, gdata, alpha, vex8)
    println(benchmarks["gs_multi_zero_8"])

    return benchmarks
end



function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg,val) in parsed_args
        println("  $arg  =>  $val")
    end

    println("Running methods on $(parsed_args["graphfile"]) ")
    display(threaded_benchmark(parsed_args["graphfile"],
        60*parsed_args["maxtime"]))
    println("")
end

if !isinteractive()
    main()
end
