# Define the directory for the Julia environment
JULIA_DEPOT_PATH := $(shell pwd)/.julenv

DELETE_GRAPHS := rm plots/corr_noise_* && rm plots/psd_logscale_* && rm plots/beta_beta_fit/from_*_to_*  

# Update Project.toml
UPDATE_PROJECT_TOML := cp $(JULIA_DEPOT_PATH)/Project.toml Project.toml

# Custom shell command to add a package from the environment and update Project.toml
ADD_AND_UPDATE := julia --project=$(JULIA_DEPOT_PATH) -e 'using Pkg; Pkg.add("$(ARG)");' && $(UPDATE_PROJECT_TOML)

# Custom shell command to remove a package from the environment and update Project.toml
REMOVE_AND_UPDATE := julia --project=$(JULIA_DEPOT_PATH) -e 'using Pkg; Pkg.rm("$(ARG)");' && $(UPDATE_PROJECT_TOML)

# Target to run Julia commands in the environment
julia_env:
	@julia --project=$(JULIA_DEPOT_PATH) $(ARGS)

# Target to add a package to the environment
add_to_env:
	@$(ADD_AND_UPDATE)

# Target to remove a package from the environment
rm_from_env:
	@$(REMOVE_AND_UPDATE)

# Target to resolve dependencies and instantiate the environment
instantiate:
	@julia --project=$(JULIA_DEPOT_PATH) -e 'using Pkg; Pkg.instantiate()'
	cp Project.toml $(JULIA_DEPOT_PATH)/Project.toml
	@julia --project=$(JULIA_DEPOT_PATH) -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'

# Target to precompile packages in the environment
precompile:
	@julia --project=$(JULIA_DEPOT_PATH) -e 'using Pkg; Pkg.precompile()'

plot_traces_and_psd:                                                         
	@julia --project=$(JULIA_DEPOT_PATH) cli/plot_traces_and_psd.jl $(ARGS)    
                                                                             
plot_beta_beta_fit:                                                          
	@julia --project=$(JULIA_DEPOT_PATH) cli/plot_beta_beta_fits.jl $(ARGS)    
                                                                             # Target to precompile packages in the environment
cleanup:                                                                     
	   $(DELETE_GRAPHS)                                                        

.PHONY: julia_env add_to_env rm_from_env instantiate precompile plot_traces_and_psd plot_beta_beta_fit cleanup
