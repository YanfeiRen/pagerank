@testset "power method" begin
@testset "simple_pagerank" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  pr = seeded_pagerank(A,0.85,1,1/1e6)
  x,lastiter = ManyPagerank.simple_pagerank(Pt',0.85,1)
  @test lastiter != -1
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6

  x,lastiter = ManyPagerank.fast_pagerank_power(A,0.85,1)
  @test lastiter != -1
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6

  pr = seeded_pagerank(A,0.85,size(A,1)-1,1/1e6)
  x,lastiter = ManyPagerank.simple_pagerank(Pt',0.85,size(A,1)-1)
  @test lastiter != -1
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6

  x,lastiter = ManyPagerank.fast_pagerank_power(A,0.85,size(A,1)-1)
  @test lastiter != -1
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6
end


@testset "multi_pagerank" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 1:8)...)
  y,lastiter = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))
  @test lastiter != -1
  X = _unpack(y)
  PR = PR./sum(PR,dims=1)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))


  y,lastiter = ManyPagerank.fast_multi_pagerank_power(A, 0.85, SVector((1 : 8)...))
  @test lastiter != -1
  X = _unpack(y)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))

  PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 9:16)...)
  y,lastiter = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((9 : 16)...))
  @test lastiter != -1
  X = _unpack(y)
  PR = PR./sum(PR,dims=1)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))


  y,lastiter = ManyPagerank.fast_multi_pagerank_power(A, 0.85, SVector((9 : 16)...))
  @test lastiter != -1
  X = _unpack(y)
  X = X./sum(X,dims=1)
  @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))
end


end
