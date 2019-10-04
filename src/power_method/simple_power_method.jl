using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks
import KahanSummation

function pagerank_power!(x::Vector{T}, y::Vector{T},
    P, alpha::T, v, tol::T,
    maxiter::Int) where T
    ialpha = 1.0/(1.0-alpha)
    xinit = x
    fill!(x, 0.0)
    _applyv!(x,v,0.0,1.0) # iteration number 0
    for iter=1:maxiter
        mul!(y,P,x)
        gamma = 1.0-alpha*KahanSummation.sum_kbn(y)
        delta = 0.0
        _applyv!(y,v,alpha,gamma)
        @simd for i=1:length(x)
            @inbounds delta += abs(y[i] - x[i]) # TODO implement Kahan summation
        end
        x,y = y,x # swap
        if delta*ialpha < tol
                    println("Converged on iteration $iter")
            break
        end
    end
    if !(x === xinit) # x is not xinit, so we need to copy it over
        xinit[:] .= x
    end
    xinit # always return xinit
end

function _applyv!(x::Vector{T}, v::Integer,
                 alpha::T, gamma::T) where T
    @simd for i in 1:length(x)
        @inbounds x[i] *= alpha
    end
    x[v] += gamma
end
simple_pagerank(P, alpha, v::Int, tol) = pagerank_power!(
    Vector{Float64}(undef, size(P,1)), Vector{Float64}(undef, size(P,1)),
    P, alpha, v, tol, ceil(Int, log(tol)/log(alpha)))
simple_pagerank(P, alpha, v::Int) = simple_pagerank(P,alpha,v,min((1.0-alpha)/size(P,1), 1.0e-6))
#A, Pt = load_data()
#@time x = simple_pagerank(Pt', 0.85, 1)
