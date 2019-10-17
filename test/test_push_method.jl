@testset "push method" begin
@testset "simple_push" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  pr = seeded_pagerank(A,0.85,1,1/1e6)
  x = ManyPagerank.simple_push_method(copy(A'),0.85,1)
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6
end

end
