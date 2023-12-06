###########################################
#### analytic solutions harmonic oscillator
###########################################







## homogenous solution of the sdof oscillator
function homogeneous_solution(osc, sol, x_0::Float64, x_0_dot::Float64)
    A =x_0; B = (osc.ζ*osc.ω*x_0 + x_0_dot) / osc.ω_d
    for i in 1:length(sol.timeplot)
        t = sol.timeplot[i]
        sol.x_sol[i] = exp(-osc.ζ*osc.ω*t) * ( A*cos(osc.ω_d*t) + B*sin(osc.ω_d*t) )
    end
end

## inhomogeneous solution of the sdof oscillator to sin force function
function inhomogeneous_solution(osc, exc, sol, x_0::Float64, x_0_dot::Float64)
    # particular parameters
    nu_o_om = exc.ν / osc.ω
    nu_o_om_sq = nu_o_om * nu_o_om
    D = (1-nu_o_om_sq)^2 + (2*osc.ζ*nu_o_om)^2
    a = ( exc.f_0/osc.k * (1-nu_o_om_sq) ) / D
    b = ( exc.f_0/osc.k * (-2 * osc.ζ * nu_o_om) ) / D
    # initial parameters
    A = x_0 - b
    B = (x_0_dot + osc.ζ*osc.ω*A - a*exc.ν) / osc.ω_d
    for i in 1:length(sol.timeplot)
        t = sol.timeplot[i]
        sol.x_sol[i] = exp(-osc.ζ*osc.ω*t) * ( A*cos(osc.ω_d*t) + B*sin(osc.ω_d*t) ) + a*sin(exc.ν*t) + b*cos(exc.ν*t)
    end
end