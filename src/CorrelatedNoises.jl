module CorrelatedNoises
using Statistics
using Base.Threads
using LinearAlgebra

using FFTW
using DataFrames, GLM
using LaTeXStrings
using Plots

include("io/io_ops.jl")

include("fourier/fourier_analysis.jl")

include("matrix_utils/eigen_analysis.jl")
include("matrix_utils/matrix_ops.jl")
include("matrix_utils/data_matrices.jl")

include("plots/plot_eigenspectrum.jl")
include("plots/plot_psd.jl")
include("plots/plot_trazes.jl")

include("noise_gen.jl")

export correlated_noise_generator, movingaverage #noise_gen.jl exports
export create_ts_matrix, compute_average_eigvals, compute_eigvals #matrix_utils/eigen_analysis.jl exports
export plot_eigen_spectrum, plot_psd, plot_traze, plot_beta_beta_fit #plot/plot_psd.jl exports

end #end of module