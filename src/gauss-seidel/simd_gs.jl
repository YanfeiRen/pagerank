using SparseArrays
using LinearAlgebra
using StaticArrays
using DataStructures
using MatrixNetworks

function _is_in_svec(x::SVector{N,T},k::T) where {N,T}
    return minimum(abs.(x-k))==0
end

function multi_gauss_seidel_from_zero!(x::Vector{T},
      A, id, d, alpha, v, tol,
      maxiter::Int) where T
  n = size(A,1)
  z = zero(T)
	fill!(x, z)
	ialpha = 1 - alpha
	endsum = 1 - tol
	evs = [ SVector{length(v),Float64}([i == j ? ialpha : 0 for j=1:length(v)]) for i in 1:length(v) ]
	rowid = rowvals(A)
	nzeros = nonzeros(A)
  lastiter = -1
	@inbounds for iter = 1:maxiter
		# delta tracks the sum in the current iterate, which will give the total sum
		delta = z
	  for i = 1:n
		  tmpsum = z
		  for nz in nzrange(A,i)
		    tmpsum += alpha*x[rowid[nz]]
		  end
      if _is_in_svec(v,i)
          for ind = 1:length(v)
              if i == v[ind]
                tmpsum += evs[ind]
                break
              end
          end
      end
		  delta += tmpsum
		  xi = tmpsum*id[i]
		  x[i] = xi
	  end
	  if all(delta .>= endsum)
      lastiter = iter
		  break
	  end
	end
	x .*= d
	#x /= sum(x) # make sure it sums to 1
  is = 1 ./ sum(x) # compute the inverse sum
  map!(x -> x .* is, x, x) # do the inverse
	return x, lastiter
end

multi_gauss_seidel_from_zero(A, alpha, v, tol) = multi_gauss_seidel_from_zero!(
  Vector{SVector{length(v),Float64}}(undef, size(A,1)),
  A,1.0 ./vec(sum(A,dims=2)), vec(sum(A,dims=2)), alpha, v, tol,
  ceil(Int, log(tol)/log(alpha)))

multi_gauss_seidel_from_zero(A, alpha, v) = multi_gauss_seidel_from_zero(A,alpha,v,min((1.0-alpha)/size(A,1), 1.0e-6))

GaussSeidelMultiPR(P, alpha, v, tol) = GaussSeidelMulti!(
    Vector{SVector{length(v),Float64}}(undef, size(P,1)),
    P, alpha, v, tol, ceil(Int, log(tol)/log(alpha)))

GaussSeidelMultiPR(P, alpha, v) = GaussSeidelMultiPR(P,alpha,v,min((1.0-alpha)/size(P,1), 1.0e-6))


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
    evs = [ SVector{length(v),Float64}([i == j ? ialpha : 0 for j=1:length(v)]) for i in 1:length(v) ]
    lastiter = -1
    @inbounds for iter = 1: maxiter
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
        if all(change_scale*delta .< tol)
           lastiter = iter
           break
        end
    end
    if !(x === xinit)
        xinit[:] .= x
    end
    xinit,lastiter
end

GaussSeidelMultiPR(P, alpha, v, tol) = GaussSeidelMulti!(
    Vector{SVector{length(v),Float64}}(undef, size(P,1)),
    P, alpha, v, tol, 2*ceil(Int, log(tol)/log(alpha)))

GaussSeidelMultiPR(P, alpha, v) = GaussSeidelMultiPR(P,alpha,v,min((1.0-alpha)/size(P,1), 1.0e-6))

#@time y = GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))
