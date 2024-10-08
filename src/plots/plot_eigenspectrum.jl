"""
    plot_eigen_spectrum(m::Matrix{Float64}, l::Int64, type::String; dir_to_save="."::String)

Plot the eigenvalue spectrum of a matrix `m` with a window size `l` and save the plot to a directory, with an optional type identifier.

# Arguments
- `m::Matrix{Float64}`: Input matrix.
- `l::Int64`: Window size for computing average eigenvalues.
- `type::String`: Type identifier for the plot filename.
- `dir_to_save::String`: Directory path to save the plot. Default is the current directory.

# Example
```julia
plot_eigen_spectrum(matrix, 5, "type_A")```
"""
function plot_eigen_spectrum(m::Matrix{Float64}, l::Int64, beta::Float64; dir_to_save::String = ".")
    rp = row_partition(size(m)[1],l)

    beta_str = round(string(beta),digits=2)
    full_file_path = joinpath(dir_to_save,"eigen_spectra_corrnoise_beta$(beta_str).pdf")

    #compute linear fit 
    average_eig_spectrum = compute_average_eigvals(m,l)
    params = compute_linear_fit_params(average_eig_spectrum)
    
    #persist graph if doesn't exist
    if !isfile(full_file_path)
        # plot styling
        plt = plot(collect(1:length(average_eig_spectrum)), average_eig_spectrum, label=L"ev_n",xscale=:log10, yscale=:log10, lc=:blue, marker=:circle, ms=3)

        # linear fit
        x_vals = collect(1:length(average_eig_spectrum))
        y_vals = exp10.(params[1] .+ params[2] .* log10.(x_vals))
        plot!(x_vals, y_vals, label="Linear Fit: beta = $(round(params[2], digits=3)), A = $(round(exp10(params[1]),digits=3))", lc=:red)
        
        Threads.@threads for i in eachindex(rp)
            if i == 1
                ev = 1/(l -1) .* abs2.(LinearAlgebra.svd(m[1:rp[1],:]).S)
                ev = compute_eigvals(m[1:rp[1],:])
                plot!(collect(1:length(ev)), ev, xscale=:log10, yscale=:log10, alpha=0.2, lc=:grey, label="")
            else
                ev = 1/(l - 1) .* abs2.(LinearAlgebra.svd(m[rp[i-1]+1:rp[i],:]).S)
                plot!(collect(1:length(ev)), ev, xscale=:log10, yscale=:log10, alpha=0.2, lc=:grey, label="")
            end
        end 

        title!("Eigen spectrum plot")
        xlabel!("rank")
        ylabel!("Eigen spectrum")
        
        #file saving
        savefig(plt, full_file_path)
    end
end