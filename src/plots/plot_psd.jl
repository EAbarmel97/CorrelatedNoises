"""
    function plot_psd(x::Vector{Float64}, 
            destination_dir::String, 
            A::Float64, 
            beta::Float64)

Plots the psd associated with a complex array of numbers in log-log scale, highlighting the linear fit in black
"""
function plot_psd(x::Vector{Float64}, destination_dir::String, beta::Float64)
  rfft_arr = rfft(x)
  f = sampling_freq_arr(length(x))

  psd = compute_psd(rfft_arr)
  deleteat!(psd, 1)

  params = intercept_and_exponent(log10.(f), log10.(psd))

  full_file_path = joinpath(destination_dir, "psd_logscale_beta_$(replace(string(round(beta,digits=2)),"." => "_")).pdf")
  if !isfile(full_file_path)
    #plot styling
    plt = plot(f, psd, label=L"PSD \ \left( f \right)", xscale=:log10, yscale=:log10, alpha=0.2) #plot reference
    #linear fit
    plot!((u) -> exp10(params[1] + params[2] * log10(u)), label="linear fit", minimum(f), maximum(f), xscale=:log10, yscale=:log10, lc=:red)

    title!("PSD for ts with beta = $beta")
    xlabel!(L"f")
    ylabel!("power density spectra")

    #file saving
    savefig(plt, full_file_path)
  end
end

"""
    plot_beta_beta_fit(from_beta::Float64, to_beta::Float64, delta::Float64, dest_dir::String; 
                       num_samples::Int64=20, ts_length::Int64=10000)

Plots the relationship between a range of beta values and their corresponding beta fits. 

# Arguments
- `from_beta::Float64`: The starting beta value.
- `to_beta::Float64`: The ending beta value.
- `delta::Float64`: Step size between consecutive beta values.
- `dest_dir::String`: The directory where the plot will be saved.
- `num_samples::Int64`: Number of samples used to compute the mean beta fit (default: 20).
- `ts_length::Int64`: Length of the time series for each sample (default: 10,000).

# Details
The function calculates the mean and standard deviation of the beta fits for each beta value in the specified range. 
It then generates a plot of these values with error bars, along with an identity function for reference. 
The plot is saved in `dest_dir` if it doesn't already exist.
"""
function plot_beta_beta_fit(from_beta::Float64, to_beta::Float64, delta::Float64, dest_dir::String; num_samples::Int64=20, ts_length::Int64=10000)
  if to_beta - from_beta < 0
    @error "impossible to plot. $(to_beta) less than $(from_beta)"
  end

  betas::Vector{Float64} = collect(Float64, from_beta:delta:to_beta)

  mean_beta_fits = Float64[]
  std_dev_beta_fits = Float64[]

  beta_beta_fit_dict = Dict{Float64,Vector{Float64}}()
  for beta in betas
    beta_fits = Float64[]
    Threads.@threads for _ in 1:num_samples
      time_series = correlated_noise_generator(ts_length, 1.0, beta)
      rfft_ts = rfft(time_series)
      psd = compute_psd(rfft_ts)
      linear_fit_log_psd(psd, length(time_series))
      push!(beta_fits, -1 * linear_fit_log_psd(psd, length(time_series))[2])
    end

    beta_beta_fit_dict[beta] = beta_fits
    push!(mean_beta_fits, mean(beta_fits))
    push!(std_dev_beta_fits, std(beta_fits))
  end

  full_file_path = joinpath(dest_dir,
    "from_$(replace(string(round(from_beta,digits=3)),"." => "_"))_to_$(replace(string(round(to_beta,digits=3)),"." => "_"))_beta_vs_beta_fit_plot.pdf")

  if !isfile(full_file_path)
    #plot styling
    plt = plot(betas, mean_beta_fits, yerror=std_dev_beta_fits, label=L"PSD \ \left( f \right)", lc=:blue) #plot reference
    #linear fit
    plot!((u) -> u, label="identity func", betas[1], betas[end], alpha=0.5, lc=:red)

    title!("PSD for ts from beta = $(from_beta) to beta = $(to_beta)"; titlefontsize=12)
    xlabel!("beta")
    ylabel!("beta_fit")

    #file saving
    savefig(plt, full_file_path)
  end
end
