"""
    imexp(x::Array{Float64,1})::Array{ComplexF64,1}
    
Returns an array of unitary norm complex numbers. Obtained from Euler's polar form
"""
function imexp(x::Vector{Float64})::Vector{ComplexF64}
    unitary_norm_complex_arr = ComplexF64[]
    for i in eachindex(x)
        unitary_norm_complex = cos(x[i]) + sin(x[i])*im
        push!(unitary_norm_complex_arr,unitary_norm_complex)
    end

    return unitary_norm_complex_arr
end

"""
    correlated_noise_generator(N::Int64,beta0::Float64,beta1::Float64)::Array{Float64,1} 

Outputs a time series obtained by inverse-fourier transforming correlated noise given exponenet and intercept from a linear fit 
"""
function correlated_noise_generator(N::Int64, A::Float64, beta::Float64)::Vector{Float64}
    index_arr = collect(1:N)
    log10_psd = map(index_arr) do u
        return log10(A) - beta*log10(u)
    end

    psd = exp10.(log10_psd)
    norm_array = sqrt.(psd) 
    phase_arr = 2*pi*rand(N) 
    z_array = norm_array .* imexp(phase_arr) #correlated noise

    return real(ifft(z_array))
end


"""
    intercept_and_exponent(x::Vector{Float64}, y::Vector{Float64})::Vector{Float64}

Compute the intercept and exponent for a linear fit between `x` and `y`.

# Arguments
- `x::Vector{Float64}`: Vector of independent variable values.
- `y::Vector{Float64}`: Vector of dependent variable values.

# Returns
- `params::Vector{Float64}`: Vector containing the intercept and exponent.

# Example
```julia
x_values = [1.0, 2.0, 3.0]
y_values = [0.1, 0.2, 0.3]
intercept_and_exponent(x_values, y_values)```
"""
function intercept_and_exponent(x::Vector{Float64},y::Vector{Float64})::Vector{Float64}
   data = DataFrame(X=x,Y=y)
   return GLM.coef(GLM.lm(@formula(Y ~ X), data))
end
