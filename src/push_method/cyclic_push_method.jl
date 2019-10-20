using SparseArrays
using LinearAlgebra
using StaticArrays
using MatrixNetworks
using DataStructures
import KahanSummation

function cyclic_push_method!(x::Vector{T}, r, At, id::Vector, alpha::T, v::Int, tol::T, maxiter::Int) where T
    n = size(At,1)
    xinit = x
    fill!(x, 0.0) # make sure x is 0
    delta = 0.0
    endtol = 1-tol # we stop when sum(x) >= endtol
    dist = endtol - delta # this is the distance to stopping
    ialpha = 1-alpha
    invalpha = 1/(1-alpha)
    #@show delta, endtol, dist
    fill!(r, 0.0)
    r[v] += (1-alpha)
    rowid = rowvals(At)

    lastiter = -1
    @inbounds for iter=1:maxiter
      for i=1:n
        ri = r[i]
        x[i] += ri
        delta += ri
        r[i] = 0
        @inbounds rows = nzrange(At,i)
        pushval = alpha*ri*id[i]
        @inbounds for nz in rows
          w = rowid[nz]
          r[w] += pushval
        end
      end
      if delta >= endtol
        lastiter = iter
        break
      end
    end
    xinit, lastiter # always return xinit
end
cyclic_push_method(At::SparseMatrixCSC, alpha, v::Int, tol) = cyclic_push_method!(
    Vector{Float64}(undef, size(At,1)),
    Vector{Float64}(undef, size(At,1)),
    At, 1.0 ./vec(sum(At,dims=1)), alpha, v, tol, 2*ceil(Int, log(tol)/log(alpha)))
cyclic_push_method(At::SparseMatrixCSC, alpha, v::Int) = cyclic_push_method(At, alpha, v, min((1.0)/size(At,1), 1.0e-6))

function cyclic_multi_push_method!(x::Vector{T}, r::Vector{T}, At, id::Vector,
          alpha, v, tol, maxiter::Int) where T
    n = size(At,1)
    xinit = x
    z = zero(T)
    fill!(x, z) # make sure x is 0
    fill!(r, z)
    delta = z
    endtol = 1-tol # we stop when sum(x) >= endtol
    ialpha = 1-alpha
    #@show delta, endtol, dist

    #r[v] += (1-alpha)
    for i in 1:length(v)
      r[v[i]] += SVector{length(v),Float64}([i == j ? ialpha : 0 for j=1:length(v)])
    end

    rowid = rowvals(At)
    lastiter = -1
    @inbounds for iter=1:maxiter
      @inbounds for i=1:n
        ri = r[i]
        x[i] += ri
        delta += ri
        r[i] = z
        rows = nzrange(At,i)
        pushval = alpha*ri*id[i]
        @inbounds for nz in rows
          w = rowid[nz]
          r[w] += pushval
        end
      end
      if all(delta .>= endtol)
        lastiter = iter
        break
      end
    end
    xinit,lastiter # always return xinit
end

cyclic_multi_push_method(At::SparseMatrixCSC, alpha, v, tol) = cyclic_multi_push_method!(
    Vector{SVector{length(v),Float64}}(undef, size(At,1)),
    Vector{SVector{length(v),Float64}}(undef, size(At,1)),
    At, 1.0 ./vec(sum(At,dims=1)), alpha, v, tol, 2*ceil(Int, log(tol)/log(alpha)))
cyclic_multi_push_method(At::SparseMatrixCSC, alpha, v) = cyclic_multi_push_method(At, alpha, v, min((1.0)/size(At,1), 1.0e-6))


#@time x = simple_pushmethod3(A, 0.85, 1)
