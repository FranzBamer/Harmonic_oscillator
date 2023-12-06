###########################################
#### inputs harmonic oscillator
###########################################



module Inp
    mutable struct Osc
        k::Float64
        m::Float64
        ζ::Float64
        Osc(k=1,m=1,ζ=0.03) = new(k, m, ζ)
        ω::Float64
        ω_d::Float64
        c::Float64
    end
    ##
    mutable struct SinExc
        f_0::Float64
        ν::Float64
        SinExc(f_0=1.0, ν=0.1) = new(f_0, ν)
    end
    ##
    mutable struct Sol
        n_steps::Int64
        dt::Float64
        Sol(n_steps, dt) = new(n_steps, dt)
        timeplot::Vector
        x_sol::Vector
        x_dot_sol::Vector
        x_ddot_sol::Vector
    end
    ##
    mutable struct Vid
        xmin::Float64
        xmax::Float64
        ymin::Float64
        ymax::Float64
        Vid(xmin, xmax, ymin, ymax) = new(xmin, xmax, ymin, ymax)
        w_hist
    end
end