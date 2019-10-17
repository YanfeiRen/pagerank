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
function warmup_methods()
    A = load_matrix_network("airports")
    fill!(A.nzval, 1.0)
    A,Pt = ManyPagerank.normalize_data(A)
    pr = seeded_pagerank(A,0.85,1,1/1e6)
    x = ManyPagerank.simple_pagerank(Pt',0.85,1)
    x = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))

    d = vec(sum(A,dims=2))
    id = 1.0 ./d
    x = ManyPagerank.FastGaussSeidel(A, id, d, 0.85, 1)
    y = ManyPagerank.GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))
    #x = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))
end

function run_methods(graphfile::AbstractString)

    A,Pt = ManyPagerank.load_data(graphfile)
    d = vec(sum(A,dims=2))
    id = 1.0 ./d

    @time x = ManyPagerank.simple_pagerank(Pt',0.85,1)
    @time x = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))

    d = vec(sum(A,dims=2))
    id = 1.0 ./d
    @time x = ManyPagerank.FastGaussSeidel(A, id, d, 0.85, 1)
    @time y = ManyPagerank.GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))
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
