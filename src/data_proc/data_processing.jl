using DataFrames, CSV

"""
    load_data_matrix(file_path::String; normalize=true::Bool)::Matrix{Float64}

Load data from a CSV file into a matrix and optionally normalize it.

# Arguments
- `file_path::String`: Path to the CSV file.
- `normalize::Bool=true`: Whether to normalize the data by subtracting the mean.

# Returns
- `data::Matrix{Float64}`: Loaded data matrix.

# Example
```julia
file_path = "path/to/data.csv"
load_data_matrix(file_path)
```
"""
function load_data_matrix(file_path::String; drop_header=false,centralize::Bool=true)::Matrix{Float64}
    df = DataFrames.DataFrame(CSV.File(file_path; header=drop_header))
    data = Matrix{Float64}(df)

    if centralize
        data .-= mean(data, dims=1)
    end

    return data
end