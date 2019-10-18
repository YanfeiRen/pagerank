@testset "gauss seidel" begin
@testset "simple gs" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)

  A,Pt = ManyPagerank.normalize_data(A)
  d = vec(sum(A,dims=2))
  id = 1.0 ./d

  x,lastiter = ManyPagerank.FastGaussSeidel(A, id, d, 0.85, 1)
  pr = seeded_pagerank(A,0.85,1,1/1e6)
  @test lastiter != -1
  @test norm(pr./sum(pr)-x/sum(x),1) <= 1/1e6

  x,lastiter = ManyPagerank.FastGaussSeidelFromZero(A, id, d, 0.85, 1)
  @test lastiter != -1
  @test norm(pr./sum(pr)-x/sum(x),1) <= 1/1e6
end

@testset "multi gs" begin
  A = load_matrix_network("airports")

  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  d = vec(sum(A,dims=2))
  id = 1.0 ./d

  y,lastiter = ManyPagerank.GaussSeidelMultiPR(Pt, 0.85, SVector((1 : 8)...))
  @test lastiter != -1

  X = _unpack(y)
  PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 1:8)...)
  PR = PR./sum(PR,dims=1)
  X = X./sum(X,dims=1)

  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))

  y,lastiter = ManyPagerank.multi_gauss_seidel_from_zero(A, 0.85, SVector((1 : 8)...))
  @test lastiter != -1
  X = _unpack(y)
  PR = PR./sum(PR,dims=1)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))
end

end
