module ManyPagerank

include("graph-io.jl")
include("power_method/simple_power_method.jl")
include("power_method/multi_power_method.jl")
include("gauss-seidel/simd_gs.jl")
include("gauss-seidel/simple_gs.jl")
include("push_method/simple_push_method.jl")
include("push_method/multi_push_method.jl")
include("push_method/cyclic_push_method.jl")

include("sor/sor.jl")
end
