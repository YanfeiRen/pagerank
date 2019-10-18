
using SparseArrays
function normalize_data(A::SparseMatrixCSC)
    @assert(is_connected((A)))
    AI,AJ,AV = findnz(A)
    fill!(A.nzval, 1.0)
    d = vec(sum(A;dims=2))
    n = size(A,1)
    Pt = sparse(AI,AJ,AV./d[AI],n,n) # form the row-stochastic version of P
    return A, Pt
end
function load_data(filename::AbstractString)
    return normalize_data(MatrixNetworks.readSMAT(filename))
end
