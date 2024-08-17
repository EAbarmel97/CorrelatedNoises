"""
    embedd_matrix_in_row_space(m::Matrix{Float64}, row_dim::Int64)::Matrix{Float64}

Embed a matrix `m` in a row space of specified dimension.

# Arguments
- `m::Matrix{Float64}`: Input matrix.
- `row_dim::Int64`: Dimension of the row space.

# Returns
- `embedded_matrix::Matrix{Float64}`: Embedded matrix in the row space.

# Example
```julia
matrix = [1.0 2.0; 3.0 4.0]
embedd_matrix_in_row_space(matrix, 3)```
"""
function embedd_matrix_in_row_space(m::Matrix{Float64},row_dim::Int64)::Matrix{Float64}
    if size(m)[1] > row_dim
        @error "the row dimension need to be smaller"
    end

    embedded_matrix = zeros(Float64,row_dim,size(m)[2])
    
    for i in eachindex(eachrow(m))
        embedded_matrix[i,:] .= eachrow(m)[i]
    end

    return embedded_matrix    
end

function centralize_matrix(M::Matrix{Float64})::Matrix{Float64}
    mean_by_row = mean.(eachrow(M)) 
    return M .- mean_by_row
end

function pad_vector(array::Vector{T}, co_dim::Int64)::Vector{T} where {T <: Real}
    return vcat(array,zeros(T,co_dim))
end

"""
    create_ts_matrix(beta::Float64, number_of_observations=10::Int)::Matrix{Float64}

Returns Float64 a matrix by stacking a given number of observations and a linear correlation exponent
"""
function create_ts_matrix(beta::Float64; number_of_realizations=100::Int,number_of_observations=1000::Int)::Matrix{Float64}
    corr_noises_arr  = Float64[]
    corr_noises_arr = Array{Float64,1}[]

    for _ in 1:number_of_realizations
        corr_noise = correlated_noise_generator(number_of_observations,1.0,beta) #times series 
        push!(corr_noises_arr,corr_noise)
    end
    
    return M = hcat(corr_noises_arr...)'
end

"""
    filter_singular_vals_array(m::Matrix{Float64}; atol=eps(Float64)::Float64)::Vector{Float64}

Filter the singular values of a matrix `m` based on a tolerance.

# Arguments
- `m::Matrix{Float64}`: Input matrix.
- `atol::Float64=eps(Float64)`: Absolute tolerance to filter singular values.

# Returns
- `filtered_singular_vals::Vector{Float64}`: Filtered singular values.

# Example
```julia
matrix = [1.0 2.0; 3.0 4.0]
filter_singular_vals_array(matrix)
```
"""
function filter_singular_vals_array(m::Matrix{Float64}; atol=eps(Float64)::Float64)::Vector{Float64}
    singular_vals = LinearAlgebra.svd(m).S  
    return filter(u -> u > atol, singular_vals)
end

"""
    heatmap_plot(cm::Matrix{Float64}; dir_to_save="."::String)

Generate a heatmap plot of a correlation matrix and save it to a directory.

# Arguments
- `cm::Matrix{Float64}`: Correlation matrix.
- `dir_to_save::String`: Directory path to save the plot. Default is the current directory.

# Example
```julia
heatmap_plot(correlation_matrix)```
"""
function heatmap_plot(cm::Matrix{Float64}, type::String; dir_to_save="."::String)
    full_file_path = joinpath(dir_to_save, "heatmap_plot_$type.pdf")
    if !isfile(full_file_path)
        heatmap(
            cm,
            c= :bwr,
            clim=(-1, 1),
            xticks = (1:size(cm, 2), 1:size(cm, 2)),
            xrot = 90,
            size = (500, 500),
            yticks = (1:size(cm, 1), 1:size(cm, 1)),
            yflip = true,
            aspect_ratio = 1
        )
        savefig(full_file_path)
    end
end

