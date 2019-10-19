using StaticArrays
using LinearAlgebra
using SparseArrays
using DataStructures
using MatrixNetworks

function pagerank_power_multi!(x::Vector{T}, y::Vector{T},
    P, alpha, v, tol,
    maxiter::Int) where T
    z = zero(T)
    ialpha = 1.0/(1.0-alpha)
    xinit = x
    fill!(x, zero(T))
    _applyv!(x,v,0.0,ones(T)) # iteration number 0
    lastiter = -1
    evs = [ SVector{length(v),Float64}((i == j ? 1 : 0 for j=1:length(v))...) for i in v ]
    @inbounds for iter=1:maxiter
        mul!(y,P,x,alpha,0.0)
        gamma = 1.0-sum(y)

        for i in 1:length(v)
          y[v[i]] += gamma[i]*evs[i]
        end

        delta = z
        @simd for i=1:length(x)
            @inbounds delta += abs.(y[i] - x[i])
        end
        x,y = y,x # swap
        if all(delta*ialpha .< tol)
            lastiter = iter
            break
        end
    end
    if !(x === xinit) # x is not xinit, so we need to copy it over
        xinit[:] .= x
    end
    xinit, lastiter # always return xinit
end

function _applyv!(x::Vector, v::SArray, alpha::T, gamma) where T
    @simd for i in 1:length(x)
        @inbounds x[i] *= alpha
    end

    for i in 1:length(v)
      ev = SVector{length(v),T}((i == j ? 1 : 0 for j=1:length(v))...)
      x[v[i]] += gamma[i]*ev
    end
end

multi_pagerank(P, alpha, v, tol) = pagerank_power_multi!(
    Vector{SVector{length(v),Float64}}(undef, size(P,1)),
    Vector{SVector{length(v),Float64}}(undef, size(P,1)),
    P, alpha, v, tol, ceil(Int, log(tol)/log(alpha)))

multi_pagerank(P, alpha, v) = multi_pagerank(P,alpha,v,min((1.0-alpha)/size(P,1), 1.0e-6))

function fast_multi_pagerank_power!(x::Vector{T}, y::Vector{T},
    A, id, alpha, v, tol, maxiter) where T

  z = zero(T)
  fill!(x, z)
  xinit = x
  for i in 1:length(v)
    # same as evs below, but scaled differently
    x[v[i]] +=  SVector{length(v),Float64}((i == j ? 1 : 0 for j=1:length(v))...)
  end
  ialpha = 1-alpha
  invialpha = 1/(1-alpha)
  evs = [ SVector{length(v),Float64}((i == j ? ialpha : 0 for j=1:length(v))...) for i in v ]
  rowid = rowvals(A)
  lastiter = -1
  @inbounds for iter=1:maxiter
    fill!(y,z)
    for i = 1:size(A,1)
      tmpval = z
      for nz in nzrange(A,i)
        j = rowid[nz]
        tmpval += x[j]*id[j]
      end
      tmpval *= alpha
      y[i] = tmpval
    end
    for i in 1:length(v)
      y[v[i]] += evs[i]
    end
    # we know there is nothing dangling here... so sum(y) = alpha
    delta = z
    @simd for i=1:length(x)
        @inbounds delta += abs.(y[i] - x[i]) # TODO implement Kahan summation
    end
    x,y = y,x # swap
    if all(delta*invialpha .< tol)
      lastiter = iter
      break
    end
   end
   if !(x === xinit) # x is not xinit, so we need to copy it over
       xinit[:] .= x
   end
   xinit, lastiter # always return xinit
end

fast_multi_pagerank_power(A, alpha, v, tol) = fast_multi_pagerank_power!(
    Vector{SVector{length(v),Float64}}(undef, size(A,1)),
    Vector{SVector{length(v),Float64}}(undef, size(A,1)),
    A, 1.0./vec(sum(A,dims=2)), alpha, v, tol, 2*ceil(Int, log(tol)/log(alpha)))
fast_multi_pagerank_power(A, alpha, v) = fast_multi_pagerank_power(A,alpha,v,min((1.0-alpha)/size(A,1), 1.0e-6))
