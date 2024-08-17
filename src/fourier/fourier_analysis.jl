function compute_psd(arr::Vector{T})::Vector{Float64} where T <: Complex 
    squared_norms = Array{Float64}[]
    squared_norms = abs2.(arr)
    return squared_norms
end

function sampling_freq_arr(N::Int64)
    freq_arr = rfftfreq(N)
    freq_arr = convert.(Float64,freq_arr) 

    deleteat!(freq_arr,1)

    return freq_arr
end

""""
    mean_psd(psd_array::Array{Array{Float64,1},1})::Array{Float64,1}

returns the average psd when array of psd at different runs is given
"""
function mean_psd(psd_array::Vector{Vector{Float64}})::Vector{Float64}
    sum = zeros(length(first(psd_array)))
    for i in eachindex(psd_array)
        psd = psd_array[i]
        sum += psd    
    end

    return sum/length(psd_array)
end

function linear_fit_log_psd(psd::Vector{Float64}, ts_length::Int64)::Vector{Float64}
   f = rfftfreq(ts_length)[2:end]
   return intercept_and_exponent(log10.(f), log10.(psd[2:end]))
end