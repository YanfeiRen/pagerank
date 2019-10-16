@testset "power method" begin
@testset "simple_pagerank" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  pr = seeded_pagerank(A,0.85,1,1/1e6)
  x = ManyPagerank.simple_pagerank(Pt',0.85,1)
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6
end


@testset "multi_pagerank" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 1:8)...)
  y = ManyPagerank.multi_pagerank(Pt', 0.85, SVector((1 : 8)...))
  X = _unpack(y)
  @test norm(PR./sum(PR,dims=1)-X./sum(X,dims=1),1) <= 1/1e6
end

end
