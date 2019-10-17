function multi_push_method!(x::Vector{T}, r::Vector{T},
    Q, A, alpha, v, tol) where T
    @assert(length(T) == length(v)) # make sure we are the right size
    empty!(Q)

    n = size(A,1)
    xinit = x
    z = zero(T)
    fill!(x, z)
    fill!(r, z)

    delta = zero(T)
    endtol = 1-tol # we stop when sum(x) >= endtol
    dist = endtol .- delta # this is the distance to stopping

    ialpha = 1-alpha
    invalpha = 1/(1-alpha)

    # compute r[v] += (1-alpha)
    for i in v
      r[i] += SVector{length(v),Float64}((i == j ? ialpha : 0 for j=1:length(v))...)
      push!(Q, i)
    end

    rowid = rowvals(A)
    while !(isempty(Q))
      i = front(Q)
      popfirst!(Q)
      ri = r[i]
      x[i] += ri
      delta += ri
      dist = (endtol.-delta)
      if all(delta .>= endtol)
        break
      end
      r[i] = z
      rows = nzrange(A,i)
      deg = size(rows,1)
      pushval = alpha.*ri./deg
      queue_thresh = tol/(n/ialpha)
      for nz in rows
        w = rowid[nz]
        pre = r[w]
        newval = pre+pushval
        r[w] += pushval
        if all(pre .< queue_thresh) && any(newval .>= queue_thresh)
          push!(Q,w)  # then we must include this
        end
      end
    end
    xinit # always return xinit
end
multi_push_method(A, alpha, v, tol) = multi_push_method!(
    Vector{SVector{length(v),Float64}}(undef, size(A,1)),
    Vector{SVector{length(v),Float64}}(undef, size(A,1)),
    CircularDeque{Int}(size(A,1)), A, alpha, v, tol)
multi_push_method(A, alpha, v) = multi_push_method(A, alpha, v, min((1.0)/size(A,1), 1.0e-6))
