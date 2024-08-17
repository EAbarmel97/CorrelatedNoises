using DataFrames, CSV

function write_to_csv(file_to_write::String, value::Any)
    if !isfile(file_to_write)
       @error "file $file_to_write does not exist"
    end 

    CSV.write(file_to_write, DataFrame(col1 = [value]); append = true, delim = ',')
    return
end

function write_to_csv(file_to_write::String, value::Vector{<:Any})
    if !isfile(file_to_write)
       @error "file $file_to_write does not exist"
    end 

    CSV.write(file_to_write, DataFrame(col1 = value); append = true, delim = ',')
    return
end