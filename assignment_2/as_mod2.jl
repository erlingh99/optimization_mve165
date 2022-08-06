"""
  Construct and returns the model of this assignment.
"""
function build_model2(relax_x::Bool = false, relax_z::Bool = false)
	#Components - the set of components
	#T - the number of time steps in the model
	#d[1,..,T] - cost of a maintenance occasion
	#c[Components, 0:T, 1:T+1] - cost of service interval
	
	m = Model()

	if relax_x
		@variable(m, x[Components, 1:T+1, 1:T+1] >= 0) #bryr oss kun om t>s delen (øvre triangel)
	else
		@variable(m, x[Components, 1:T+1, 1:T+1], Bin)
	end

	if relax_z
		@variable(m, z[1:T] >= 0)
	else
		@variable(m, z[1:T], Bin)
	end

	cost = @objective(m, Min,
			sum(c[i, s+1, t]*x[i, s+1, t] for i in Components, (s,t) in I) + 
			sum(d[t]*z[t] for t in 1:T))

	ReplaceOnlyAtMaintenance = @constraint(m, [i in Components, t in 1:T],
										sum(x[i, s, t] for s in 1:t) <= z[t])

	StartServiceIntervalWhenPrevEnds = @constraint(m, [i in Components, t in 1:T], 
			sum(x[i, s, t] for s in 1:t) == sum(x[i, t+1, r] for r in t+1:T+1))

	AtleastOneServiceInterval = @constraint(m, [i in Components], sum(x[i, 1, t] for t in 1:T+1) == 1)
	println("model T $T")
	return m, x, z
end