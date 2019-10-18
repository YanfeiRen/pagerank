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

using MatrixNetworks
using StaticArrays
using BenchmarkTools
function warmup_methods()
    A = load_matrix_network("airports")
    fill!(A.nzval, 1.0)
    A,Pt = ManyPagerank.normalize_data(A)
    pr = seeded_pagerank(A, 0.85, 1, 1/1e6)

    println("Run simple_pagerank for power_method")
    x = ManyPagerank.simple_pagerank(Pt', 0.85, 1)

    println("Run fast_pagerank_power for power_method")
    x = ManyPagerank.fast_pagerank_power(A, 0.85, 1)

    println("Run multi_pagerank for power_method")
    x = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))

    d = vec(sum(A,dims=2))
    id = 1.0 ./d

    println("Run FastGaussSeidel")
    x = ManyPagerank.FastGaussSeidel(A, id, d, 0.85, 1)

    println("Run FastGaussSeidelFromZero")
    x = ManyPagerank.FastGaussSeidelFromZero(A, id, d, 0.85, 1)

    println("Run GaussSeidelMultiPR")
    y = ManyPagerank.GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))
    #x = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))

    println("Run simple_push_method")
    x = ManyPagerank.simple_push_method(A, 0.85, 1)

    println("Run multi_push_method")
    x = ManyPagerank.multi_push_method(A, 0.85, SVector((1 : 8)...))

    At = copy(A')

    println("Run cyclic_push_method")
    x = ManyPagerank.cyclic_push_method(At, 0.85, 1)

    println("Run cyclic_multi_push_method")
    x = ManyPagerank.cyclic_multi_push_method(At, 0.85, SVector((1 : 8)...))

end

function run_methods(graphfile::AbstractString)

    A,Pt = ManyPagerank.load_data(graphfile)
    d = vec(sum(A,dims=2))
    id = 1.0 ./d

    println("Benchmarking simple_pagerank for power_method")
    b1 = @benchmark ManyPagerank.simple_pagerank($Pt',0.85,1)

    println("Benchmarking fast_pagerank_power for power_method")
    b2 = @benchmark ManyPagerank.fast_pagerank_power($A, 0.85, 1)

    println("Benchmarking multi_pagerank for power_method")
    b3 = @benchmark ManyPagerank.multi_pagerank($Pt', 0.85, SVector((1 : 8)...))

    println("Benchmarking FastGaussSeidel")
    b4 = @benchmark ManyPagerank.FastGaussSeidel($A, $id, $d, 0.85, 1)

    println("Benchmarking FastGaussSeidelFromZero")
    b5 = @benchmark ManyPagerank.FastGaussSeidelFromZero($A, $id, $d, 0.85, 1)

    println("Benchmarking GaussSeidelMultiPR")
    b6 = @benchmark ManyPagerank.GaussSeidelMultiPR($Pt, 0.85, SVector((1 : 8)...))

    println("Benchmarking simple_push_method")
    b7 = @benchmark ManyPagerank.simple_push_method($A, 0.85, 1)

    println("Benchmarking multi_push_method")
    b8 = @benchmark ManyPagerank.multi_push_method($A, 0.85, SVector((1 : 8)...))

    At = copy(A')

    println("Benchmarking cyclic_push_method")
    b9 = @benchmark ManyPagerank.cyclic_push_method($At, 0.85, 1)

    println("Benchmarking cyclic_multi_push_method")
    b10 = @benchmark ManyPagerank.cyclic_multi_push_method($At, 0.85, SVector((1 : 8)...))

    # Todo: format the benchmarking output info
    return b1, b2, b3, b4, b5, b6, b7, b8, b9, b10

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
    run_methods(parsed_args["graphfile"])


end

if !isinteractive()
    main()
end
