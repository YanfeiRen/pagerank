@testset "sor" begin
@testset "multi sor" begin
  A = load_matrix_network("airports")
  A = max.(A,A') # designed for undirected graphs

  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  d = vec(sum(A,dims=2))
  id = 1.0 ./d

  PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 1:8)...)
  PR = PR./sum(PR,dims=1)

  y,lastiter = ManyPagerank.sor_from_zero(A, 0.85, SVector((1 : 8)...))
  @test lastiter != -1
  X = _unpack(y)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))

  y,lastiter = ManyPagerank.sor_from_zero2(A, 0.85, SVector((1 : 8)...))
  @test lastiter != -1
  X = _unpack(y)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))

  PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 9:16)...)
  PR = PR./sum(PR,dims=1)

  y,lastiter = ManyPagerank.sor_from_zero(A, 0.85, SVector((9 : 16)...))
  @test lastiter != -1
  X = _unpack(y)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))

  y,lastiter = ManyPagerank.sor_from_zero2(A, 0.85, SVector((9 : 16)...))
  @test lastiter != -1
  X = _unpack(y)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))
end


end
