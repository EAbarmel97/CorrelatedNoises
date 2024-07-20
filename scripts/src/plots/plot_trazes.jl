
function save_traze(time_series::Vector{Float64}, beta0::Float64, beta1::Float64;dir_to_save::String=".")
    avg = mean(time_series)
    x = collect(0:(length(time_series)-1))
    
    plt = plot(x,time_series, label= L"X_n") #plot reference 
    title!("beta0 = $beta0, beta1 = $beta1")
    hline!(plt, [avg, avg], label=L"\overline{M}_n",linewidth=3)

    xlims!(0, length(time_series))
    xlabel!(L"n")
    ylabel!(L"X_n")
    savefig(plt, dir_to_save) #saving plot reference as a file with pdf extension at a given directory  
end