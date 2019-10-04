using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks
import KahanSummation

function load_data()
    A = MatrixNetworks.readSMAT("/p/mnt/data/graph-db/snap/soc-LiveJournal1-scc.smat")
    AI,AJ,AV = findnz(A)
    d = vec(sum(A;dims=2))
    n = size(A,1)
    Pt = sparse(AI,AJ,AV./d[AI],n,n) # form the row-stochastic version of P
    return A, Pt
end

function FastGaussSeidel!(x::Vector{T}, A, id, d, alpha::T, v, tol::T, maxiter::Int) where T
	n = size(A,1)
	fill!(x, 0.0)
	xinit = x
	ialpha = 1 - alpha
	rowid = rowvals(A)
	nzeros = nonzeros(A)
	for iter = 1: maxiter
	   delta = 0.0
	   for i = 1:n
		   tmpsum = 0.0
		   recordx_i = x[i]*d[i]
		   Pii = zero(T)
		   for nz in nzrange(A,i)
			   tmpsum += alpha*x[rowid[nz]]
			   if rowid[nz] == i
			      Pii += alpha
			   end
		   end
		   if i == v
		   	tmpsum += ialpha
		   end
		   xi = tmpsum*id[i]
		   x[i] = xi
		   delta += abs(recordx_i - tmpsum)
	   end
	   if delta*ialpha < tol
		   println("converged on iter $iter")
		   break
	   end
	end
	x .*= d
	x ./= sum(x) # make sure it sums to 1
	if !(x === xinit) 
	   xinit[:] .= x
	end
	xinit
end
FastGaussSeidel(A, id, d, alpha, v::Int, tol) = FastGaussSeidel!(
   Vector{Float64}(undef, size(A,1)),
   A, id, d, alpha, v, tol, ceil(Int, log(tol)/log(alpha)))
FastGaussSeidel(A, id, d, alpha, v::Int) = FastGaussSeidel(A, id, d,alpha,v,(1.0-alpha)/size(A,1))
d = vec(sum(A,dims=2))
id = 1.0 ./d
@time x = FastGaussSeidel(A, id, d, 0.85, 1)
