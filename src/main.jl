include("CorrelatedNoises.jl")
using .CorrelatedNoises: correlated_noise_generator, plot_traze, plot_psd

const PATH_TO_SAVE = "plots"

function main(ARGS)
    arg1 = Base.parse(Float64,ARGS[1])
    arg2 = Base.parse(Float64,ARGS[2])
    arg3 = Base.parse(Float64,ARGS[3])
    
    time_series1 = CorrelatedNoises.correlated_noise_generator(1000,1.0,arg1)
    if !isfile(PATH_TO_SAVE) 
        CorrelatedNoises.plot_traze(PATH_TO_SAVE,time_series1,1.0,0.0)    
        CorrelatedNoises.plot_psd(time_series1,PATH_TO_SAVE,1.0,arg1)
    end
    
    time_series2 = CorrelatedNoises.correlated_noise_generator(1000,1.0,arg2)
    if !isfile(PATH_TO_SAVE) 
        CorrelatedNoises.plot_traze(PATH_TO_SAVE,time_series2,1.0,1.0)    
        CorrelatedNoises.plot_psd(time_series2,PATH_TO_SAVE,1.0,arg2)
    end

    time_series3 = CorrelatedNoises.correlated_noise_generator(1000,1.0,arg3)
    if !isfile(PATH_TO_SAVE)
        CorrelatedNoises.plot_traze(PATH_TO_SAVE,time_series3,1.0,2.0)
        CorrelatedNoises.plot_psd(time_series3,PATH_TO_SAVE,1.0,arg3)
    end
end

main(ARGS)