## plot scaling results
function _load_data_run(filename)
  lastline = last(readlines(filename))
  return parse(Int, split(lastline, " => ")[2])
end
_load_data_run("results/nilpotent-livejournal-50-1-gs8.txt")
function load_data(machine,graph,nps;dist::Bool=false)
  nvecs = zeros(Int,0)
  for np in nps
    if dist
      push!(nvecs, _load_data_run("results/$(machine)-$(graph)-dist$(np)-gs8.txt"))
    else
      push!(nvecs, _load_data_run("results/$(machine)-$(graph)-$(np)-gs8.txt"))
    end
  end
  return (nps,nvecs)
end
function load_all_data()
  nilpotent_nps = [1,4,8,12,16,24,32,48,64]
  unimodular_nps = [1,12,24,48,64,72,96,120,144,168,192]
  nilpotent_threads = load_data("nilpotent", "livejournal-50", nilpotent_nps)
  nilpotent_dist = load_data("nilpotent", "livejournal-50", nilpotent_nps; dist=true)
  unimodular_threads = load_data("unimodular", "livejournal-50", unimodular_nps)
  unimodular_dist = load_data("unimodular", "livejournal-50", unimodular_nps; dist=true)

  return nilpotent_threads, unimodular_threads, nilpotent_dist, unimodular_dist
end
np_threads,uni_threads,np_dist,uni_dist = load_all_data()
##
using Plots
pyplot()
##
function scaling_plot(data;xtype="threads")
  np,nv = data
  plot(np,nv,markersize=6,markerstrokecolor=:white, marker=:circle,label="actual scaling")
  plot!(np, nv[1]*np,label="linear scaling", color=:lightgrey)
  xlabel!("number of $(xtype)")
  ylabel!("number of solutions in 5 minutes")
  plot!(fg_legend=nothing, legend=:topleft )
  # ugh, vertical annotations are annoying!
  # https://discourse.julialang.org/t/problems-trying-to-rotate-annotations-in-a-plot/23639
  for i in eachindex(np)
    annotate!(np[i],nv[i],
      text(" $(nv[i]), $(round(nv[i]/nv[1]; digits=2))x",
        9, :bottom, color=:grey,rotation=90))
  end

  plot!(size=(300,300))
end
scaling_plot(np_threads)
##
scaling_plot(np_threads)
savefig("results/scaling-nilpotent-threads.pdf")
##
scaling_plot(uni_threads)
savefig("results/scaling-unimodular-threads.pdf")

##
scaling_plot(np_dist;xtype="processes")
savefig("results/scaling-nilpotent-dist.pdf")
##
scaling_plot(uni_dist;xtype="processes")
savefig("results/scaling-unimodular-dist.pdf")
##
plot(np_threads[1],np_threads[2],markersize=4,marker=:circle,label="actual scaling")
plot!(np_threads[1],np_threads[2][1].*np_threads[1],label="linear scaling")
xlabel!("number of threads")
ylabel!("number of solutions in 5 minutes")
plot!(fg_legend=nothing, legend=:topleft )
##
plot!(size=(300,300))
savefig("results/scaling-nilpotent-threads.pdf")
##
plot(uni_threads[1],uni_threads[2],markersize=4,marker=:circle,label="actual scaling")
plot!(uni_threads[1],uni_threads[2][1].*uni_threads[1],label="linear scaling")
xlabel!("number of threads")
ylabel!("number of solutions in 5 minutes")
plot!(fg_legend=nothing, legend=:topleft )
##
plot!(size=(300,300))
savefig("results/scaling-unimodular-threads.pdf")
##
plot(np_dist[1],np_dist[2],markersize=4,marker=:circle,label="actual scaling")
plot!(np_dist[1],np_dist[2][1].*np_dist[1],label="linear scaling")
xlabel!("number of threads")
ylabel!("number of solutions in 5 minutes")
plot!(fg_legend=nothing, legend=:topleft )

##
plot!(size=(300,300))
savefig("results/scaling-unimodular-threads.pdf")
