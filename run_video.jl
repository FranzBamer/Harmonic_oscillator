###########################################
#### video plots
###########################################



## get the polynomial function of the column
function get_pol(shift::Float64, l::Float64, w::Float64)
    n = 21
    p = zeros(n,2)
    dl = l/(n-1)
    x = 0
    for i in 1:n
        #
        p[i,1] = x
        p[i,2] = shift + 3*w/(l*l)*x^2 - 2*w/(l*l*l)*x^3
        x += dl
    end
    return p
end


## plot column
function plot_column(p::Array, fig)
    plot!(fig, (p[:,2], p[:,1]), color="black", linewidth=1.0)
end

## plot beam
function plot_beam(x, y, b, h, fig)
    # define a function that returns a Plots.Shape
    rectangle(length, height, x, y) = Shape([x+0,x+length,x+length,x+0], [y+0,y+0,y+height,y+height])
    plot!(rectangle(b,h,x,y), opacity=1, linewidth=1.0, color="black")
    scatter!(fig, (x,y+h*0.5), markersize=3, color="red",
                         markerstrokecolor="red", markerstrokewidth=0.5)
    #x_coord = [x, x+l, x+l, x, x]
    #y_coord = [y, y, y+d, y+d, y]
    #plot!(fig, (x_coord, y_coord), color="black", linewidth=2.0)
end

function plot_ground(y::Float64, x1::Float64, x2::Float64, fig)
    plot!(fig, ([x1, x2], [y, y]), color="gray", linewidth=1.0)
    #
    n = 20
    dl = (x2-x1)/n
    xa = x1; ya=y
    b = 0.05; h = 0.05
    for i in 1:n+1
        xe = xa - b; ye = ya - h
        plot!(fig, ([xa, xe], [ya, ye]), color="gray", linewidth=1.0)
        xa += dl
    end
end


## frame structure
function plot_frame(w, fig_frame)
    width = 1.0
    height = 1.0
    beam_height = 0.075
    l = 1.0
    p1 = get_pol(0.0, height, w)
    p2 = get_pol(width,height, w)
    plot_column(p1, fig_frame)
    plot_column(p2, fig_frame)
    plot_beam(w, height, width, beam_height, fig_frame)
    plot_ground(0.0, -width*0.1, width*1.1, fig_frame)
end

function plot_time_resp(w_hist::Vector, n, fig, x_shift, y_shift)
    #
    N = length(w_hist)
    # plot axes
    delta_y = 4.0
    delta_x = 1.0
    plot_arrow([x_shift-delta_x, y_shift], [2*delta_x,0], fig)
    plot_arrow([x_shift, y_shift], [0.0,-delta_y], fig)
    # plot functions
    dt = delta_y/N;
    timeplot = zeros(n)
    x_plot = zeros(n)
    for i in 1:n
        timeplot[i] = -dt*(i-1) + y_shift
        x_plot[i] = w_hist[i] + x_shift
    end
    #
    plot!(fig, (x_plot,timeplot), color="blue", linewidth=1.0)
    scatter!(fig, (x_plot[end],timeplot[end]),
                   markersize=3, color="red", markerstrokecolor="red", markerstrokewidth=0.5)
end

## plot an arrow
## custom arrow function plot
function plot_arrow(start_coord::Vector, vector::Vector, fig)
    # length of vector
    len = sqrt(vector[1]^2 + vector[2]^2)
    end_coord = start_coord + vector
    # rotation matrix
    cos_phi = vector[1]/len
    sin_phi = vector[2]/len
    T = [cos_phi -sin_phi
    sin_phi  cos_phi]
    # arrow head
    coord_arrow_head = [ -0.1   0.0   -0.1
                          0.05  0.0   -0.05 ]
    # rotate arrow head
    coord_arrow_head = T*coord_arrow_head
    # translate arrow head
    coord_arrow_head[1,:] = coord_arrow_head[1,:] .+ end_coord[1]
    coord_arrow_head[2,:] = coord_arrow_head[2,:] .+ end_coord[2]
    # plot arrow
    plot!(fig, [start_coord[1],end_coord[1]], [start_coord[2],end_coord[2]], linewidth=1.0, color="black")
    # plot arrow head
    plot!(fig, coord_arrow_head[1,:], coord_arrow_head[2,:], linewidth=1.0, color="black")
end

## run video
function run_video(sol, vid)
    n =length(sol.x_sol)
    anim = @animate for i in 1:n
        w = sol.x_sol[i]
        fig = plot(size=(600,600), legend=nothing, border=:none,
                                   xlims=(vid.xmin, vid.xmax), ylims=(vid.ymin, vid.ymax), aspect_ratio=1)
        plot_frame(w, fig)
        plot_time_resp(sol.x_sol, i, fig, 0.0, -0.5)
        annotate!(0.15, -4.5, Plots.text(L"t", 12, :dark, rotation = -0 ))
        annotate!(1.1, -0.3, Plots.text(L"x(t)", 12, :dark, rotation = -0 ))
        annotate!(0.5, 0.3, Plots.text(L"k,c", 12, :dark, rotation = -0 ))
        annotate!(0.5+w, 1.2, Plots.text(L"m", 12, :dark, rotation = -0 ))
        display(fig)
    end
    gif(anim, "shear_frame.gif", fps = 50)
end