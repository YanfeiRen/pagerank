

using MatrixNetworks
using StaticArrays
using BenchmarkTools
using SparseArrays

function load_data(graphfile)
    A,Pt = ManyPagerank.load_data(graphfile)
    At = copy(A')
    d = vec(sum(A,dims=2))
    id = 1.0 ./d

    println("Loaded $graphfile")
    println("  $(size(A,1)) vertices")
    println("  $(nnz(A)) non-zeros")
    println("")

    return A, At, Pt, d, id
end

function warmup_methods()
    A = load_matrix_network("airports")
    fill!(A.nzval, 1.0)
    A,Pt = ManyPagerank.normalize_data(A)
    At = copy(A')
    pr = seeded_pagerank(A, 0.85, 1, 1/1e6)

    kmax = 16

    println("Run simple_pagerank for power_method")
    x = ManyPagerank.simple_pagerank(Pt', 0.85, 1)
    @time ManyPagerank.simple_pagerank(Pt', 0.85, 1)

    println("Run fast_pagerank_power for power_method")
    x = ManyPagerank.fast_pagerank_power(A, 0.85, 1)
    @time ManyPagerank.fast_pagerank_power(A, 0.85, 1)

    println("Run multi_pagerank for power_method")
    for k=1:kmax
        x = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : k)...))
    end
    @time ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))

    d = vec(sum(A,dims=2))
    id = 1.0 ./d

    println("Run FastGaussSeidel")
    x = ManyPagerank.FastGaussSeidel(A, id, d, 0.85, 1)
    @time ManyPagerank.FastGaussSeidel(A, id, d, 0.85, 1)

    println("Run FastGaussSeidelFromZero")
    x = ManyPagerank.FastGaussSeidelFromZero(A, id, d, 0.85, 1)
    @time ManyPagerank.FastGaussSeidelFromZero(A, id, d, 0.85, 1)

    println("Run GaussSeidelMultiPR")
    for k=1:kmax
        y = ManyPagerank.GaussSeidelMultiPR(Pt, 0.85, SVector((1 : k)...))
    end
    @time ManyPagerank.GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))

    println("Run fast_gauss")
    for k=1:kmax
        x = ManyPagerank.multi_gauss_seidel_from_zero(A, 0.85, SVector((1 : k)...))
    end
    @time ManyPagerank.multi_gauss_seidel_from_zero(A, 0.85, SVector((1 : 8)...))

    println("Run simple_push_method")
    x = ManyPagerank.simple_push_method(At, 0.85, 1)
    @time ManyPagerank.simple_push_method(At, 0.85, 1)

    println("Run multi_push_method")
    for k=1:kmax
        x = ManyPagerank.multi_push_method(At, 0.85, SVector((1 : k)...))
    end
    @time ManyPagerank.multi_push_method(At, 0.85, SVector((1 : 8)...))


    println("Run cyclic_push_method")
    x = ManyPagerank.cyclic_push_method(At, 0.85, 1)
    @time ManyPagerank.cyclic_push_method(At, 0.85, 1)

    println("Run cyclic_multi_push_method")
    for k=1:kmax
        x = ManyPagerank.cyclic_multi_push_method(At, 0.85, SVector((1 : k)...))
    end
    @time ManyPagerank.cyclic_multi_push_method(At, 0.85, SVector((1 : 8)...))
end

##
function tol_and_maxiter(n::Int, alpha)
  tol = min((1.0-alpha)/n, 1.0e-6)
  maxiter = 2*ceil(Int, log(tol)/log(alpha))
  return (tol,maxiter)
end

setup_call_simple_power(A,At,Pt,d,id,v,alpha) =
  (ManyPagerank.pagerank_power!,
    (Vector{Float64}(undef, size(A,1)),
    Vector{Float64}(undef, size(A,1)),
    Pt', alpha), tol_and_maxiter(size(A,1),alpha))

setup_call_fast_power(A,At,Pt,d,id,v,alpha) =
  (ManyPagerank.fast_pagerank_power!,
    (Vector{Float64}(undef, size(A,1)),
    Vector{Float64}(undef, size(A,1)),
    A, id, alpha), tol_and_maxiter(size(A,1),alpha))

setup_call_simple_power_multi(A,At,Pt,d,id,v,alpha) =
  (ManyPagerank.pagerank_power_multi!,
    (Vector{SVector{length(v),Float64}}(undef, size(A,1)),
     Vector{SVector{length(v),Float64}}(undef, size(A,1)),
    Pt', alpha), tol_and_maxiter(size(A,1),alpha))

setup_call_simple_push_method(A,At,Pt,d,id,v,alpha) =
    (ManyPagerank.pagerank_power!,
      (Vector{Float64}(undef, size(A,1)),
      Vector{Float64}(undef, size(A,1)),
      CircularDeque{Int}(size(A,1)), A, alpha),
      tol_and_maxiter(size(A,1),alpha)[1])

setup_call_gs_from_zero(A,At,Pt,d,id,v,alpha) =
  (ManyPagerank.FastGaussSeidelFromZero!,
    (Vector{Float64}(undef, size(A,1)),
    A, id, d, alpha),
    tol_and_maxiter(size(A,1),alpha))


#=
Sample usage


v = SVector(1:8...)
f,inputs_pre,inputs_post = setup_call_simple_power_multi(gdata...,v,0.85)
f(inputs_pre...,v,inputs_post...)    # run on column 1


rval = setup_call_fast_power(gdata...,1,0.85)
rval[1](rval[2]...,1,rval[3]...)    # run on column 1
=#

function benchmark_function_simple(myfunction::Function, multi::Bool, A, alpha)
    nthreads = Threads.nthreads()
    totalvecs = zeros(Int, nthreads)
    n = size(A, 1)
    nbatches = floor(Int, n/nthreads)
    if multi
        nbatches = floor(Int, nbatches/8)
    end
    stime = time()
    Threads.@threads for i=1:nthreads
        for batch = 1:nbatches
            if multi
                myfunction(A, alpha, SVector(((i-1)*nbatches+(batch-1)*8+1 : (i-1)*nbatches+batch*8)...))
            else
                myfunction(A, alpha, (i-1)*nbatches+batch)
            end
            if time() - stime <= 14.4*60
                if multi
                    totalvecs[i] += 8
                else
                    totalvecs[i] += 1
                end
            else
                break
            end
        end
    end
    return sum(totalvecs)
end

function benchmark_function_with_d(myfunction::Function, A, id, d, alpha)
    nthreads = Threads.nthreads()
    totalvecs = zeros(Int, nthreads)
    n = size(A, 1)
    nbatches = floor(Int, n/nthreads)
    stime = time()
    Threads.@threads for i=1:nthreads
        for batch = 1:nbatches
            myfunction(A, id, d, alpha, (i-1)*nbatches+batch)
            if time() - stime <= 14.4*60
                totalvecs[i] += 1
            else
                break
            end
        end
    end
    return sum(totalvecs)
end

function threaded_benchmark(graphfile::AbstractString)
    A,At,Pt,d,id = load_data(graphfile)
    benchmarks = Dict{String,Any}()

    println("Threaded Benchmarking Starts....")

    println("Benchmarking simple_pagerank for power_method")
    benchmarks["power_simple"] = benchmark_function_simple(ManyPagerank.simple_pagerank, false, Pt', 0.85)

    println("Benchmarking fast_pagerank_power for power_method")
    benchmarks["power_fast"] = benchmark_function_simple(ManyPagerank.fast_pagerank_power, false, A, 0.85)

    println("Benchmarking multi_pagerank for power_method")
    benchmarks["power_multi"] = benchmark_function_simple(ManyPagerank.multi_pagerank, true, Pt', 0.85)

    println("Benchmarking FastGaussSeidel")
    benchmarks["gs_fast"] = benchmark_function_with_d(ManyPagerank.FastGaussSeidel, A, id, d, 0.85)

    println("Benchmarking FastGaussSeidelFromZero")
    benchmarks["gs_fast_zero"] = benchmark_function_with_d(ManyPagerank.FastGaussSeidelFromZero, A, id, d, 0.85)

    println("Benchmarking GaussSeidelMultiPR")
    benchmarks["gs_multi"] = benchmark_function_simple(ManyPagerank.GaussSeidelMultiPR, true, Pt, 0.85)

    println("Benchmarking fast_gauss")
    benchmarks["gs_multi_zero"] = benchmark_function_simple(ManyPagerank.multi_gauss_seidel_from_zero, true, A, 0.85)

    println("Benchmarking simple_push_method")
    benchmarks["push_simple"] = benchmark_function_simple(ManyPagerank.simple_push_method, false, At, 0.85)

    println("Benchmarking multi_push_method")
    benchmarks["push_multi"] = benchmark_function_simple(ManyPagerank.multi_push_method, true, At, 0.85)

    println("Benchmarking cyclic_push_method")
    benchmarks["push_cyclic"] = benchmark_function_simple(ManyPagerank.cyclic_push_method, false, At, 0.85)

    println("Benchmarking cyclic_multi_push_method")
    benchmarks["push_cyclic_multi"] = benchmark_function_simple(ManyPagerank.cyclic_multi_push_method, true, At, 0.85)

    return benchmarks
end
