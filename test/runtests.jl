using Test
using MatrixNetworks
using LinearAlgebra
using StaticArrays
# directly include the source
include("../src/ManyPagerank.jl")

function invbased_solution(A, α, k)
        I,J,V = findnz(A)
        d = vec(sum(A;dims=2))
        Pt = sparse(I,J,V./d[I],size(A,1),size(A,2)) # form the row-stochastic version of P
        P = Pt'
        X = (1-α)*inv(Matrix(LinearAlgebra.I - α*P))
        extrema(sum(X;dims=1)) # double-check ...

        ## We want to compute the large values of X efficiently!
        ei = zeros(Int,0)
        ej = zeros(Int,0)
        for i=1:size(A,2)
          p = sortperm(X[:,i], rev=true) # find the large values in each column
          @assert p[1] == i
          for j=1:k+1
            if p[j] == i # skip over yourself
              continue
            end
            push!(ej, i)
            push!(ei, p[j])
          end
        end
        L = sparse(ei,ej,1,size(A,1), size(A,2)) # large entries
        return max.(X.*A,L.*X)
end

function _unpack(v::Vector{T}) where T <: SArray
  n = length(T)
  X = zeros(eltype(T),length(v),n)
  for i in 1:length(v)
    X[i,:] .= v[i]
  end
  return X
end

include("test_gauss_seidel.jl")
include("test_power_method.jl")
