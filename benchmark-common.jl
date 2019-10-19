

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


    simple_push_method(A, alpha, v::Int, tol) = simple_push_method!(
        Vector{Float64}(undef, size(A,1)),
        Vector{Float64}(undef, size(A,1)),
        CircularDeque{Int}(size(A,1)), A, alpha, v, tol)
    simple_push_method(A, alpha, v::Int) = simple_push_method(A, alpha, v, min((1.0)/size(A,1), 1.0e-6))
