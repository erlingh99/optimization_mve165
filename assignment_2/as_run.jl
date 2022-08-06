using JuMP
#using Cbc
using Gurobi
using SparseArrays
using CSV
using DataFrames
using DelimitedFiles


# rvals = Vector{Int8}()
# obj = Vector{Float32}()

include("as_dat_small.jl")
include("as_mod.jl")
m, x, z = build_model(true, true)
set_optimizer(m, Gurobi.Optimizer)
# set_optimizer_attributes(m, "MIPGap" => 2e-2, "TimeLimit" => 3600)
"""
Some useful parameters for the Gurobi solver:
    SolutionLimit = k : the search is terminated after k feasible solutions has been found
    MIPGap = r : the search is terminated when  | best node - best integer | < r * | best node |
    MIPGapAbs = r : the search is terminated when  | best node - best integer | < r
    TimeLimit = t : limits the total time expended to t seconds
    DisplayInterval = t : log lines are printed every t seconds
See http://www.gurobi.com/documentation/8.1/refman/parameters.html for a
complete list of valid parameters
"""
add_cut_to_small!(m)
optimize!(m)
# unset_binary.(x)
# unset_binary.(z)
# optimize!(m)
"""
Some useful output & functions
"""
# obj_ip = objective_value(m)
# unset_binary.(x)
# unset_binary.(z)
# optimize!(m)
# obj_lp = objective_value(m)
# println("obj_ip = $obj_ip, obj_lp = $obj_lp, gap = $(obj_ip-obj_lp) "


println("solve time: $(solve_time(m))")

x_val = value.(x.data)
z_val = value.(z)


println("Objective = $(objective_value(m))")
println("x  = ")
println(sparse(x_val))
println("z = ")
println(sparse(z_val))


