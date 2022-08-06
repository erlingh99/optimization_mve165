function build_biodiesel_model(data_file::String)
  include(data_file)
  m = Model()

  # 3 different products [litre biofuel]
  @variable(m, B[I] >= 0)
  # 3 different crops [litre veg.oil]
  @variable(m, V[J] >= 0)

  # total profits
  B5_profit_tot = B5_profit*B[1]
  B30_profit_tot = B30_profit*B[2]
  B100_profit_tot = B100_profit*B[3]

  # z
  @objective(m, Max, B5_profit_tot+B30_profit_tot+B100_profit_tot)

  @constraint(m, biodiesel_demand, sum(B) >= biodiesel_min)

  @constraint(m, area_limited, sum(V./oil_per_hectar) <= area_max)

  @constraint(m, water_limited, sum(V./oil_per_hectar.*water_per_hectar) <= water_max)

  @constraint(m, petrol_limited, [0.95, 0.7, 0]'*B <= petrol_max)

  @constraint(m, enough_veg_oil, sum(B.*veg_oil_used) <= sum(V))

  return m, B, V
end
