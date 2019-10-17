@testset "push method" begin

  @testset "cyclic_multi_push" begin
    A = load_matrix_network("airports")
    fill!(A.nzval, 1.0)
    A,Pt = ManyPagerank.normalize_data(A)
    PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 1:8)...)
    y = ManyPagerank.cyclic_multi_push_method(copy(A'), 0.85, SVector((1 : 8)...))
    X = _unpack(y)
    PR = PR./sum(PR,dims=1)
    X = X./sum(X,dims=1)
    @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))
  end


  @testset "cyclic_push" begin
    A = load_matrix_network("airports")
    fill!(A.nzval, 1.0)
    A,Pt = ManyPagerank.normalize_data(A)
    pr = seeded_pagerank(A,0.85,1,1/1e6)
    x = ManyPagerank.cyclic_push_method(copy(A'),0.85,1)
    @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6
  end


  @testset "multi_push" begin
    A = load_matrix_network("airports")
    fill!(A.nzval, 1.0)
    A,Pt = ManyPagerank.normalize_data(A)
    PR = hcat(map(i->seeded_pagerank(A,0.85,i,1/1e6), 1:8)...)
    y = ManyPagerank.multi_push_method(copy(A'), 0.85, SVector((1 : 8)...))
    X = _unpack(y)
    PR = PR./sum(PR,dims=1)
    X = X./sum(X,dims=1)
    @test all(map(i->norm(PR[:,i] - X[:,i],1) <= 1/1e6, 1:8))
  end

@testset "simple_push" begin
  A = load_matrix_network("airports")
  fill!(A.nzval, 1.0)
  A,Pt = ManyPagerank.normalize_data(A)
  pr = seeded_pagerank(A,0.85,1,1/1e6)
  x = ManyPagerank.simple_push_method(copy(A'),0.85,1)
  @test norm(pr./sum(pr)-x./sum(x),1) <= 1/1e6
end




end
