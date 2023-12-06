###########################################
#### run harmonic oscillator
###########################################



using Plots
using LaTeXStrings



## include external functions
include("input.jl")
include("run_video.jl")
include("analytic_solutions.jl")


## generating oscillator
osc = Inp.Osc();
osc.ζ=0.025
osc.ω = sqrt(osc.k/osc.m); osc.c = 2*osc.m*osc.ω*osc.ζ; osc.ω_d = osc.ω*sqrt(1-osc.ζ*osc.ζ)

## generating excitation
exc = Inp.SinExc()
exc.f_0 = 0.1
exc.ν = 1.0

## generating solution
sol = Inp.Sol(500, 0.3)
sol.timeplot = zeros(sol.n_steps)
for i in 1:sol.n_steps
    sol.timeplot[i] = (i-1)*sol.dt
end
sol.x_sol = zeros(sol.n_steps); sol.x_dot_sol = zeros(sol.n_steps)
#
inhomogeneous_solution(osc, exc, sol, 0.0, 0.0)

## plot solution
#fig = plot(size(700,400), legend=nothing)
#plot!(fig, (sol.timeplot, sol.x_sol), label=nothing, color="blue", linewidth=2.0)
#display(fig)

## play video
vid = Inp.Vid(-2.25, 2.85, -4.5, 1.25)
run_video(sol, vid)



println("... Done ...")