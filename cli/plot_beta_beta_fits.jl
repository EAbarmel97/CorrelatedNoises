include("../src/CorrelatedNoises.jl")
using .CorrelatedNoises: plot_beta_beta_fit

const PATH_TO_SAVE = joinpath("plots", "beta_beta_fit")

function plot(ARGS)
    println("ploting, wait ...\n")
    #from_beta: ARGS[1]
    #to_beta: ARGS[2]
    betas = parse.(Float64, ARGS[1:2])

    #delta: ARGS[3]
    delta = parse(Float64,ARGS[3])
    
    #ts_length = ARGS[4]
    ts_length = parse(Int64,ARGS[4])

    if !isfile(PATH_TO_SAVE)
        CorrelatedNoises.plot_beta_beta_fit(betas[1], betas[2], delta, PATH_TO_SAVE; ts_length = ts_length)
    end
end

plot(ARGS)