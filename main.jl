include("src/CorrelatedNoises.jl")
using .CorrelatedNoises: correlated_noise_generator, plot_traze, plot_psd

const PATH_TO_SAVE = "plots"

function main(ARGS)
    args = parse.(Float64, ARGS[1:3])

    for i in eachindex(args)
        time_series = CorrelatedNoises.correlated_noise_generator(10000, 1.0, args[i])
        if !isfile(PATH_TO_SAVE)
            CorrelatedNoises.plot_traze(PATH_TO_SAVE, time_series, 1.0, args[i])
            CorrelatedNoises.plot_psd(time_series, PATH_TO_SAVE, 1.0, args[i])
        end

    end
end

main(ARGS)