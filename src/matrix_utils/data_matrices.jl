"""
    load_data_matrix(::Type{T}, file_path::String; drop_header=false, centralize::Bool=false)::Matrix{T} where {T <: Any}

Load data from a CSV file into a matrix of a specified type, with optional header removal and centralization.

# Arguments
- `::Type{T}`: The type of the elements in the resulting matrix.
- `file_path::String`: The path to the CSV file to load.
- `drop_header::Bool=false`: If `true`, the header row will be dropped. Default is `false`.
- `centralize::Bool=false`: If `true`, the data will be centralized by subtracting the mean of each column. Default is `false`.

# Returns
- `Matrix{T}`: A matrix containing the data from the CSV file, with the specified type `T`.
"""
function load_data_matrix(::Type{T}, file_path::String; drop_header=false, centralize::Bool=false)::Matrix{T} where {T <: Any}
    df = DataFrames.DataFrame(CSV.File(file_path; header=drop_header, delim=',', types = T))
    data = Matrix{T}(df)

    if centralize
        data .-= mean(data, dims=1)
    end

    return data
end