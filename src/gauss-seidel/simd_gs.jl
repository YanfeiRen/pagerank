using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks

function _is_in_svec(x::SVector{N,T},k::T) where {N,T}
    return minimum(abs.(x-k))==0
end

function GaussSeidelMulti!(x::Vector{T},
    P, alpha, v, tol,
    maxiter::Int) where T
    n = size(P,1)
    fill!(x, zero(T))
    xinit = x
    change_scale = alpha/(1-alpha)
    ialpha = 1 - alpha
    rowid = rowvals(P)
    nzeros = nonzeros(P)
    evs = [ SVector{length(v),Float64}((i == j ? ialpha : 0 for j=1:length(v))...) for i in v ]
    for iter = 1: maxiter
        delta = zero(T)
        for i = 1:n
           tmpsum = 0.0 .* v
           recordx_i = x[i]
           Pii = 0.0
           for nz in nzrange(P,i)
               tmpsum += alpha*nzeros[nz]*x[rowid[nz]]
               if rowid[nz] == i
                   Pii += nzeros[nz]
               end
           end
           tmpsum -= alpha.*Pii.*x[i]
           if _is_in_svec(v,i)
               for ind = 1:length(v)
                   if i == v[ind]
                     tmpsum += evs[ind]
                     break
                   end
               end
           end
           x[i] = tmpsum / (1 - alpha*Pii)
           delta += abs.(recordx_i - x[i])
        end
        if all(change_scale*ialpha .< tol)
           println("converged on iter $iter")
           break
        end
    end
    if !(x === xinit)
        xinit[:] .= x
    end
    xinit
end

GaussSeidelMultiPR(P, alpha, v, tol) = GaussSeidelMulti!(
    Vector{SVector{length(v),Float64}}(undef, size(P,1)),
    P, alpha, v, tol, ceil(Int, log(tol)/log(alpha)))

GaussSeidelMultiPR(P, alpha, v) = GaussSeidelMultiPR(P,alpha,v,min((1.0-alpha)/size(P,1), 1.0e-6))

#@time y = GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))
