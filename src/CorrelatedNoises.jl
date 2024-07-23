module CorrelatedNoises
using Statistics
using Base.Threads
using LinearAlgebra

using FFTW
using DataFrames, GLM
using LaTeXStrings
using Plots

include("noise_gen.jl")

include("data_proc/data_processing.jl")

include("fourier/fourier_analysis.jl")

include("matrix_utils/eigen_analysis.jl")
include("matrix_utils/matrix_ops.jl")

include("plots/plot_eigenspectrum.jl")
include("plots/plot_psd.jl")
include("plots/plot_trazes.jl")

export correlated_noise_generator, movingaverage #noise_gen exports
export create_ts_matrix, compute_average_eigvals, compute_eigvals #matrix utils exports
export plot_eigen_spectrum, plot_psd, plot_traze #plot utils exports

end #end of module