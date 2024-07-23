"""
    function plot_psd(x::Vector{Float64}, 
            destination_dir::String, 
            A::Float64, 
            beta::Float64)

Plots the psd associated with a complex array of numbers in log-log scale, highlighting the linear fit in black
"""
function plot_psd(x::Vector{Float64}, destination_dir::String, A::Float64, beta::Float64)
    rfft_arr = rfft(x)
    f = sampling_freq_arr(length(x))
    
    psd = compute_psd(rfft_arr)
    deleteat!(psd,1)

    params = intercept_and_exponent(f,psd)
    
    full_file_path = joinpath(destination_dir,"psd_log_A_$(replace(string(round(A,digits=2)),"." => "_"))_beta_$(replace(string(round(beta,digits=2)),"." => "_")).pdf")
    if !isfile(full_file_path)
        #plot styling
        plt = plot(f,psd, label=L"PSD \ \left( f \right)", legend=false, xscale=:log10, yscale=:log10,alpha=0.2) #plot reference 
        #expected linear fit
        plot!((u) -> exp10(log10(A)-beta*log10(u)), minimum(f), maximum(f), xscale=:log10,yscale=:log10,lc=:black)
        
        title!("PSD for ts with A = $A and beta = $beta")
        xlabel!(L"f")
        ylabel!("power density spectra")
        
        #file saving
        savefig(plt, full_file_path)
    end    
end