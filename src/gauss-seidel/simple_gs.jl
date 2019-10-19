using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks
import KahanSummation

function FastGaussSeidel!(x::Vector{T}, A, id, d, alpha::T, v, tol::T, maxiter::Int) where T
	n = size(A,1)
	fill!(x, 0.0)
	x[v] += 1 # start at v
	xinit = x
	ialpha = 1 - alpha
	change_scale = alpha/(1-alpha) # this is the scale of the change to get error
	rowid = rowvals(A)
	lastiter = -1
	@inbounds for iter = 1: maxiter
	   delta = 0.0
	   for i = 1:n
		   tmpsum = 0.0
		   recordx_i = x[i]*d[i]
		   Pii = zero(T)
		   for nz in nzrange(A,i)
			   tmpsum += alpha*x[rowid[nz]]
		   end
		   if i == v
		   	tmpsum += ialpha
		   end
		   xi = tmpsum*id[i]
		   x[i] = xi
		   delta += abs(recordx_i - tmpsum)
	   end
	   if change_scale*delta < tol
		   lastiter = iter
		   break
	   end
	end
	x .*= d
	x ./= sum(x) # make sure it sums to 1
	if !(x === xinit)
	   xinit[:] .= x
	end
	xinit, lastiter
end
FastGaussSeidel(A, id, d, alpha, v::Int, tol) = FastGaussSeidel!(
   Vector{Float64}(undef, size(A,1)),
   A, id, d, alpha, v, tol, 2*ceil(Int, log(tol)/log(alpha)))
FastGaussSeidel(A, id, d, alpha, v::Int) = FastGaussSeidel(A, id, d,alpha,v,min((1.0-alpha)/size(A,1), 1.0e-6))

function FastGaussSeidelFromZero!(x::Vector{T}, A, id, d, alpha::T, v, tol::T, maxiter::Int) where T
	n = size(A,1)
	fill!(x, 0.0)
	ialpha = 1 - alpha
	endtol = 1 - tol
	rowid = rowvals(A)
	lastiter = -1
	@inbounds for iter = 1: maxiter
		delta = 0.0
	   for i = 1:n
		   tmpsum = 0.0
		   for nz in nzrange(A,i)
			   tmpsum += alpha*x[rowid[nz]]
		   end
		   if i == v
		   	tmpsum += ialpha
		   end
			 delta += tmpsum
		   xi = tmpsum*id[i]
		   x[i] = xi
	   end
	   if delta >= endtol
		   lastiter = iter
		   break
	   end
	end
	x .*= d
	x ./= sum(x) # make sure it sums to 1
	return x, lastiter
end
FastGaussSeidelFromZero(A, id, d, alpha, v::Int, tol) = FastGaussSeidelFromZero!(
   Vector{Float64}(undef, size(A,1)),
   A, id, d, alpha, v, tol, 2*ceil(Int, log(tol)/log(alpha)))
FastGaussSeidelFromZero(A, id, d, alpha, v::Int) = FastGaussSeidelFromZero(A, id, d,alpha,v,min((1.0-alpha)/size(A,1), 1.0e-6))

#d = vec(sum(A,dims=2))
#id = 1.0 ./d
#@time x = FastGaussSeidel(A, id, d, 0.85, 1)
