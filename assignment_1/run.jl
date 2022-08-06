using JuMP
using Gurobi

include("mod.jl")
m, B, V = build_biodiesel_model("dat.jl")
# include("dat.jl")
# m = Model()

# # 3 different products [litre biofuel]
# @variable(m, B[I] >= 0)
# # 3 different crops [litre veg.oil]
# @variable(m, V[J] >= 0)

# # total profits
# B5_profit_tot = B5_profit*B[1]
# B30_profit_tot = B30_profit*B[2]
# B100_profit_tot = B100_profit*B[3]


# area_use_ratio = sum(V./oil_per_hectar)/area_max
# petrol_use_ratio = [0.95, 0.7, 0]'*B/petrol_max
# water_use_ratio = sum(V./oil_per_hectar.*water_per_hectar)/water_max

# # z
# @objective(m, Max, B5_profit_tot+B30_profit_tot+B100_profit_tot)
# # @objective(m, Min, area_use_ratio+petrol_use_ratio+water_use_ratio)

# @constraint(m, biodiesel_demand, sum(B) >= biodiesel_min)

# @constraint(m, area_limited, sum(V./oil_per_hectar) <= area_max)

# @constraint(m, water_limited, sum(V./oil_per_hectar.*water_per_hectar) <= water_max)

# @constraint(m, petrol_limited, [0.95, 0.7, 0]'*B <= petrol_max)

# @constraint(m, enough_veg_oil, sum(B.*veg_oil_used) <= sum(V))
  
print(m) # prints the model instance

set_optimizer(m, Gurobi.Optimizer)
set_optimizer_attribute(m, "OutputFlag", 0)
optimize!(m)

println("Optimal profit: z = ", value(objective_function(m)))
println("Optimal biofuel distribution [L]: B = ", value.(B.data))
println("Optimal crop distribution [ha]: V = ", value.(V.data./oil_per_hectar))
println("Optimal water usage per crop [ML]: W = ", value.(V.data./oil_per_hectar.*water_per_hectar)/1e6)
println("Water used: ", sum(value.(V.data./oil_per_hectar).*water_per_hectar)/water_max*100, "%")
println("Petrol used: ", [0.95, 0.7, 0]'*value.(B.data)/petrol_max*100, "%")
println("Area used: ", sum(value.(V.data)./oil_per_hectar)/area_max*100, "%")
println("Oil per water ratio: ", oil_per_water)
println("Oil per hectare: ", oil_per_hectar)

function get_slack(constraint::ConstraintRef)::Float64  # If you dont want you dont have to specify types
    con_func = constraint_object(constraint).func
    interval = MOI.Interval(constraint_object(constraint).set)
    row_val = value(con_func)
    return min(interval.upper - row_val, row_val - interval.lower)
end

println("veg_oil slack =  ", get_slack(enough_veg_oil))
println("area slack =  ", get_slack(area_limited))
println("water slack =  ", get_slack(water_limited))
println("biodiesel surplus =  ", get_slack(biodiesel_demand))
println("petrol slack =  ", get_slack(petrol_limited))


report = lp_sensitivity_report(m)

print(report)

# a_max = 1600
# w_max = 5000e6 # L
# p_max = 150e3

# ds = 0.0001

# print("\n---------------Unfeasible solutions:---------------\n")
# print("Increasing any variable ", ds*100, "% yields a feasable solution. (above 100% not included)\n\n")

# for step = 0.6:ds:1
#     a = a_max*(1-step) 
#     flag = false   
#     for step2 = 0:ds:0
#         w = w_max*(1-step2)
#         for step3 = 0:ds:0
#             p = p_max*(1-step3)
            
#             set_normalized_rhs(area_limited, a)
#             set_normalized_rhs(water_limited, w)
#             set_normalized_rhs(petrol_limited, p)
#             optimize!(m)
#             if termination_status(m) != MOI.OPTIMAL                
#                 print("Area:", round((1-step)*100, digits=2), "%\t")
#                 print("Water:", round((1-step2)*100, digits=2), "%\t")
#                 print("Petrol:", round((1-step3)*100, digits=2), "%\t")
#                 print("\n")
#                 # if step3 == 0 || step2 == 0#Then reducing water cannot still be feasible, because we cannot increase petrol
#                     # flag = true                                                              
#                 # end
#                 break
#             end
#         end
#         if termination_status(m) != MOI.OPTIMAL                        
#             break
#         end
#     end
#     if termination_status(m) != MOI.OPTIMAL                        
#         break
#     end
# end
