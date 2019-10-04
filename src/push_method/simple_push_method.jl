using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks
using DataStructures
import KahanSummation

function push_method2!(x::Vector{T}, delta, r,
    P, alpha::T, v, tol::T,
    maxiter::Int) where T
    xinit = x
    fill!(x, 0.0)
    fill!(delta, 0.0)
    fill!(r, 0.0)
    _applyv!(r,v,0.0, 1.0-alpha) # iteration number 0
    rowid = rowvals(P)
    nzeros = nonzeros(P)
    for iter=1:maxiter
        for i = 1: length(x)
            x[i] += r[i]
            if r[i] > 0.0
                rows = nzrange(P,i)
                degree = size(rows, 1)
                for nz in rows
                    r[rowid[nz]] += alpha*r[i]/degree
                end
            end
            delta[i] += r[i]
            r[i] = 0.0
            if delta[i] >= tol
                println(delta[i])
                println("Converged on iteration $iter")
                if !(x === xinit) # x is not xinit, so we need to copy it over
                    xinit[:] .= x
                end
                return xinit
            end
        end
    end
    if !(x === xinit) # x is not xinit, so we need to copy it over
        xinit[:] .= x
    end
    xinit # always return xinit
end

simple_pushmethod2(P, alpha, v::Int, tol) = push_method2!(
    Vector{Float64}(undef, size(P,1)), Vector{Float64}(undef, size(P,1)),
    Vector{Float64}(undef, size(P,1)), P, alpha, v, tol, 200)
simple_pushmethod2(P, alpha, v::Int) = simple_pushmethod2(P,alpha,v,1.0-1.0/size(P,1))

#@time x = simple_pushmethod2(Pt, 0.85, 1)

################# Need to improve #######################
function push_method3!(x::Vector{T}, delta, r,
    P, alpha::T, v, tol::T) where T
    xinit = x
    fill!(x, 0.0) # make sure x is 0
    fill!(delta,0.0)
    fill!(r, 0.0)
    _applyv!(r,v,0.0, 1.0-alpha) # iteration number 0
    rowid = rowvals(P)
    nzeros = nonzeros(P)
    a = Deque{Int}()
    push!(a, v)
    print("delta")
    print(sum(delta))
    while !(isempty(a))
        i = front(a)
        popfirst!(a)
        x[i] += r[i]
        rows = nzrange(P,i)
        degree = size(rows, 1)
        for nz in rows
            w = rowid[nz]
            pre = r[w]
            r[w] += alpha*r[i]/degree
            delta[w] += r[w]
            if delta[w] < tol
                push!(a, w)
            else
                if !(x === xinit) # x is not xinit, so we need to copy it over
                    xinit[:] .= x
                end
                return xinit
            end
        end
        r[i] = 0.0
    end
    if !(x === xinit) # x is not xinit, so we need to copy it over
        xinit[:] .= x
    end
    xinit # always return xinit
end
simple_pushmethod3(P, alpha, v::Int, tol) = push_method3!(
    Vector{Float64}(undef, size(P,1)), Vector{Float64}(undef, size(P,1)),
    Vector{Float64}(undef, size(P,1)), P, alpha, v, tol)
simple_pushmethod3(P, alpha, v::Int) = simple_pushmethod3(P, alpha, v, (1.0 - min((1.0)/size(P,1), 1.0e-6)))

#@time x = simple_pushmethod3(Pt, 0.85, 1)
