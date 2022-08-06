# Sets
n = 2
Components = 1:n # 2 components

# Parameters
T = 2     #number of timesteps
d = [10 10]      #cost of a maintenance occasion

I = [(s, t) for s=0:T for t=s+1:T+1]

U = [2 1]     #lives of new components

# c_ =  [1 1   2   1 0;
#        1 100 100 1 0]     #costs of new components at timepoints 1..T+1
c_ =  [1 1 0;
       3 3 0]     #costs of new components at timepoints 1..T+1

c = ones(n, T+1, T+1)*(T*(maximum(d) + n*maximum(c_)) + 1)

for i in Components
    for (s,t) in I
        if t-s <= U[i]
            c[i, s+1, t] = c_[i, t]
        end
    end
end