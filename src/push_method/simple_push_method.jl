using SparseArrays
using LinearAlgebra
using StaticArrays
using MatrixNetworks
using DataStructures
import KahanSummation

################# Need to improve #######################
function simple_push_method!(x::Vector{T}, r, Q, A, alpha::T, v::Int, tol::T) where T
    empty!(Q)
    n = size(A,1)
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
    rowid = rowvals(A)
    push!(Q, v)
    while !(isempty(Q))
        i = front(Q)
        popfirst!(Q)
        ri = r[i]
        x[i] += ri
        delta += ri
        dist = (endtol-delta)
        if delta >= endtol
          break
        end
        r[i] = 0.0
        rows = nzrange(A,i)
        deg = size(rows,1)
        pushval = alpha*ri/deg
        queue_thresh = tol/(n/(1-alpha))
        for nz in rows
          w = rowid[nz]
          pre = r[w]
            newval = pre+pushval
            r[w] += pushval
            if pre < queue_thresh && newval >= queue_thresh
              push!(Q,w)  # then we must include this
            end
        end

    end
    xinit # always return xinit
end
simple_push_method(A, alpha, v::Int, tol) = simple_push_method!(
    Vector{Float64}(undef, size(A,1)),
    Vector{Float64}(undef, size(A,1)),
    CircularDeque{Int}(size(A,1)), A, alpha, v, tol)
simple_push_method(A, alpha, v::Int) = simple_push_method(A, alpha, v, min((1.0)/size(A,1), 1.0e-6))



#@time x = simple_pushmethod3(A, 0.85, 1)
