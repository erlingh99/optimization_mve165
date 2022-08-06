# sets
I = 1:3 # 3 different products
J = 1:3 # 3 different crops

# labels
products = ["B5", "B30", "B100"]
crops  = ["Soy", "Sunflower", "Cotton"]

# creating veg.oil
oil_per_hectar = [462.8, 302.4, 389.7] # [L/ha]
water_per_hectar = [5e6, 4.2e6, 1e6] # [L/ha]

# creating biodiesel
methanol_cost = 0.2*1.5/0.9 # per litre biodiesel
veg_oil_used = [0.05, 0.3, 1]./0.9 # per litre biodiesel

# profits after taxes per litre biodiesel
petrol_cost = 1
B5_profit = 1.43*0.8 - 0.95*petrol_cost - 0.05*methanol_cost
B30_profit = 1.29*0.95 - 0.7*petrol_cost - 0.3*methanol_cost
B100_profit = 1.16 - 1*methanol_cost

# constraints
biodiesel_min = 280e3
area_max = 1600
water_max = 5000e6# L
petrol_max = 150e3


# oil_per_water = (oil_per_hectar/area_max)./(water_per_hectar/water_max)  #[92.56, 72, 389.7]*1e-6 # ratio