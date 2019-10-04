using StaticArrays
using LinearAlgebra
using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks

function pagerank_power_multi!(x::Vector{T}, y::Vector{T},
    P, alpha, v, tol,
    maxiter::Int) where T
    ialpha = 1.0/(1.0-alpha)
    xinit = x
    fill!(x, zero(T))
    _applyv!(x,v,0.0,ones(T)) # iteration number 0
    for iter=1:maxiter
        mul!(y,P,x,1.0,0.0)
        gamma = 1.0-alpha*sum(y)

        delta = zero(T)
        _applyv!(y,v,alpha,gamma)
        @simd for i=1:length(x)
            @inbounds delta += abs.(y[i] - x[i])
        end
        x,y = y,x # swap
        if all(delta*ialpha .< tol)
            break
        end
    end
    if !(x === xinit) # x is not xinit, so we need to copy it over
        xinit[:] .= x
    end
    xinit # always return xinit
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

#A, Pt = load_data()
#@time y = multi_pagerank(Pt', 0.85, SVector((1 : 8)...))
