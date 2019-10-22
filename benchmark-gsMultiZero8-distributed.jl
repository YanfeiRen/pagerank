using Distributed
using ArgParse

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--numprocs"
            help = "the number of distributed processes"
            arg_type = Int64
            default = 1
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

function distributed_benchmark(graphfile::AbstractString, nprocs, maxtime::Float64=14.4*60)
    gdata = load_data(graphfile)
    benchmarks = Dict{String,Int}()
    vex8 = SVector((1:8)...)
    # vex16 = SVector((1:16)...)
    alpha = 0.85

    println("Benchmarking gs_multi_zero 8")
    benchmarks["gs_multi_zero_8"] = benchmark_method_distributed(nprocs, maxtime, setup_call_gs_multi_from_zero, gdata, alpha, vex8)
    println(benchmarks["gs_multi_zero_8"])

    return benchmarks
end


function main()

    numprocs = nprocs()

    println("Running methods on $(parsed_args["graphfile"]) ")
    display(distributed_benchmark(parsed_args["graphfile"],numprocs,
        60*parsed_args["maxtime"]))
    println("")
end

if !isinteractive()

    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg,val) in parsed_args
        println("  $arg  =>  $val")
    end

    addprocs(parsed_args["numprocs"])

    @everywhere using Pkg;
    @everywhere Pkg.activate(".")
    @everywhere include("src/ManyPagerank.jl")
    @everywhere include("benchmark-common.jl")
    @everywhere @assert(Threads.nthreads() == 1) # make sure we are single threaded

    main()
end

# A = load_matrix_network("airports")
# fill!(A.nzval, 1.0)
# A,Pt = ManyPagerank.normalize_data(A)
# At = copy(A')
# pr = seeded_pagerank(A, 0.85, 1, 1/1e6)
