##
using Plots
##
function rho(omega,alpha)
  mu = alpha
  opt = 1 + (mu/(1+sqrt(1-mu^2)))^2
  if omega <= opt
    (1/4)*(omega*mu + sqrt(omega^2 *mu^2 - 4*(omega-1)))^2
  else
    omega-1
  end
end
vals = range(0,2, length=100)
plot(collect(vals),rho.(vals,0.99))
