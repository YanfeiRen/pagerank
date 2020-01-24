function _optimal_sor_omega(alpha)
	opt = 1 + (alpha/(1+sqrt(1-alpha^2)))^2
end



function sor_from_zero!(x::Vector{T}, A, id, d, alpha, v, omega, tol,
	maxiter::Int) where T

	n = size(A,1)
	z = zero(T)
	fill!(x, z)
	ialpha = 1 - alpha
	iomega = (1-omega)
	endsum = 1 - tol
	evs = [ SVector{length(v),Float64}([i == j ? ialpha : 0 for j=1:length(v)]) for i in 1:length(v) ]
	rowid = rowvals(A)
	# nzeros = nonzeros(A)
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
			# compute SOR
			newx = omega*tmpsum + (iomega*d[i])*(x[i])
			delta += tmpsum

			xi = newx*id[i]
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

sor_from_zero(A, alpha, v, tol) = sor_from_zero!(
	Vector{SVector{length(v),Float64}}(undef, size(A,1)),
	A,1.0 ./vec(sum(A,dims=2)), vec(sum(A,dims=2)), alpha, v,
	_optimal_sor_omega(alpha), tol,
	ceil(Int, log(tol)/log(alpha)))

sor_from_zero(A, alpha, v) = sor_from_zero(A,alpha,v,min((1.0-alpha)/size(A,1), 1.0e-6))


function sor_from_zero2!(x::Vector{T}, A, id, d, alpha, v, omega, tol,
	maxiter::Int) where T

	n = size(A,1)
	z = zero(T)
	fill!(x, z)
	ialpha = 1 - alpha
	change_scale = alpha /(1-alpha)
	iomega = (1-omega)
	evs = [ SVector{length(v),Float64}([i == j ? ialpha : 0 for j=1:length(v)]) for i in 1:length(v) ]
	rowid = rowvals(A)
	lastiter = -1
	@inbounds for iter = 1:maxiter
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
			# compute SOR
			newx = omega*tmpsum + (iomega*d[i])*(x[i])

			xi = newx*id[i]
			delta += abs.(newx - x[i]*d[i])
			x[i] = xi
		end
		if all(change_scale*delta .< tol)
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

sor_from_zero2(A, alpha, v, tol) = sor_from_zero2!(
	Vector{SVector{length(v),Float64}}(undef, size(A,1)),
	A,1.0 ./vec(sum(A,dims=2)), vec(sum(A,dims=2)), alpha, v,
	_optimal_sor_omega(alpha), tol,
	ceil(Int, log(tol)/log(alpha)))

sor_from_zero2(A, alpha, v) = sor_from_zero2(A,alpha,v,min((1.0-alpha)/size(A,1), 1.0e-6))
