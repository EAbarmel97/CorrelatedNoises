
function plot_traze(dir_to_save::String, time_series::Vector{Float64}, A::Float64, beta::Float64)
  avg = mean(time_series)
  x = collect(0:(length(time_series)-1))

  plt = plot(x, time_series, label=L"X_n") #plot reference 
  title!("correlated noise time series generated beta = $beta"; titlefontsize=12)
  hline!(plt, [avg, avg], label=L"\overline{X}_n", linewidth=3)
  #ylims!(-1.0, 1.0)
  xlims!(0, length(time_series))
  xlabel!(L"n")
  ylabel!(L"X_n")

  save_to = joinpath(dir_to_save, "corr_noise_A_$(replace(string(round(A,digits=2)),"." => "_"))_beta_$(replace(string(round(beta,digits=2)),"." => "_")).pdf")
  savefig(plt, save_to) #saving plot reference as a file with pdf extension at a given directory  
end
