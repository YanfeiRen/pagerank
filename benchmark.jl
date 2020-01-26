include("benchmark-common.jl")

using ArgParse

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--opt1"
            help = "an option with an argument"
        "--opt2", "-o"
            help = "another option with an argument"
            arg_type = Int
            default = 0
        "--flag1"
            help = "an option without argument, i.e. a flag"
            action = :store_true
        "graphfile"
            help = "a positional argument"
            required = true
    end

    return parse_args(s)
end


function run_methods(graphfile::AbstractString)

    A,At,Pt,d,id = load_data(graphfile)
    benchmarks = Dict{String,Any}()

    println("Benchmarking simple_pagerank for power_method")
    benchmarks["power_simple"] = @benchmark ManyPagerank.simple_pagerank($Pt',0.85,1)

    println("Benchmarking fast_pagerank_power for power_method")
    benchmarks["power_fast"] = @benchmark ManyPagerank.fast_pagerank_power($A, 0.85, 1)

    println("Benchmarking multi_pagerank for power_method")
    benchmarks["power_multi"] = @benchmark ManyPagerank.multi_pagerank($Pt', 0.85, SVector((1 : 8)...))

    println("Benchmarking FastGaussSeidel")
    benchmarks["gs_fast"] = @benchmark ManyPagerank.FastGaussSeidel($A, $id, $d, 0.85, 1)

    println("Benchmarking FastGaussSeidelFromZero")
    benchmarks["gs_fast_zero"] = @benchmark ManyPagerank.FastGaussSeidelFromZero($A, $id, $d, 0.85, 1)

    println("Benchmarking GaussSeidelMultiPR")
    benchmarks["gs_multi"] = @benchmark ManyPagerank.GaussSeidelMultiPR($Pt, 0.85, SVector((1 : 8)...))

    println("Benchmarking fast_gauss")
    benchmarks["gs_multi_zero"] = @benchmark ManyPagerank.multi_gauss_seidel_from_zero($A, 0.85, SVector((1 : 8)...))


    println("Benchmarking simple_push_method")
    benchmarks["push_simple"] = @benchmark ManyPagerank.simple_push_method($At, 0.85, 1)

    println("Benchmarking multi_push_method")
    benchmarks["push_multi"] =  @benchmark ManyPagerank.multi_push_method($At, 0.85, SVector((1 : 8)...))

    println("Benchmarking cyclic_push_method")
    benchmarks["push_cyclic"] = @benchmark ManyPagerank.cyclic_push_method($At, 0.85, 1)

    println("Benchmarking cyclic_multi_push_method")
    benchmarks["push_cyclic_multi"] = @benchmark ManyPagerank.cyclic_multi_push_method($At, 0.85, SVector((1 : 8)...))

    println("Benchmarking sor_from_zero")
    bechmarks["sor_from_zero"] = @benchmark ManyPagerank.sor_from_zero($A, 0.85, SVector((1 : 8)...))

    println("Benchmarking sor_from_zero2")
    bechmarks["sor_from_zero2"] = @benchmark ManyPagerank.sor_from_zero2($A, 0.85, SVector((1 : 8)...))

    # Todo: format the benchmarking output info
    return benchmarks

end

function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg,val) in parsed_args
        println("  $arg  =>  $val")
    end

    println("Warming up methods ... ")
    @time warmup_methods()

    println("Running methods on $(parsed_args["graphfile"]) ")
    display(run_methods(parsed_args["graphfile"]))
    println("")

end

if !isinteractive()
    main()
end
