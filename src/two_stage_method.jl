export two_stage_method

# Step - 1
function cost_function1(b,t0,tpoints,data)
    err = 0
    size_two = size(data)[2]
    for i in 1:length(tpoints)
        w_i = exp((tpoints[i]-t0)^2)
        for j in 1:size_two
            temp_f = b[1,j]-(b[2,j]*(tpoints[i]-t0))
            err += w_i*(temp_f-data[i,j])^2
        end
    end
    return err
end


function two_stage_method(prob::DEProblem,tpoints,data;kwargs...)
    f = prob.f
    b0 = typeof(data)
    b1 = typeof(data)
    for i in 1:length(tpoints)
        t0 = tpoints[i]
        result = optimize(b->cost_function1(b,t0,tpoints,data), [1.0,1.0])
        push!(b0,result.minimizer[1])
        push!(b1,result.minimizer[2])
    end

    
    # Step - 2
    cost_function2 = function (p)
        ff = (t,u,du) -> prob.f(t,u,p,du)
        err = 0
        #du = zeros(length(tpoints))
        for i in 1:length(tpoints)
            err += (ff(tpoints[i],b0[i],b1[i]) - b1[i])^2
        end
        return err
    end
end

# using DifferentialEquations
# using Optim
# tpoints = [0.0,0.5,1.0]
# data  = [1,exp(0.5),exp(1)]

# pf_func = function (t,u,p,du)
#     du = p*u
#  end

# pf = ParameterizedFunction(pf_func,[1])

# u0 = [1.0]
# tspan = (0.0,1.0)
# prob = ODEProblem(pf,u0,tspan)

# cost_function = two_stage_method(prob,tpoints,data)
# result = optimize(cost_function, -20.0, 20.0)
# approximate_estimate = result.minimizer[1]

