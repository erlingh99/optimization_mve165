# Sets
n = 10
Components = 1:n # 10 components

# Parameters
# T = 50    #number of timesteps

I = [(s, t) for s=0:T for t=s+1:T+1]

d = ones(1,T)*20      #cost of a maintenance occasion



c__ = ones(1, T+1)
c__[end] = 0

c_ = [34 25 14 21 16  3 10  5  7 10]'*c__     #costs of new components at timepoints 1..T+1

U = [42 18 90 94 49 49 34 90 37 11]     #lives of new components

c = ones(n, T+1, T+1)*(T*(maximum(d) + n*maximum(c_)) + 1)


for i in Components
    for (s,t) in I
        if t-s <= U[i]
            c[i, s+1, t] = c_[i, t]
        end
    end
end