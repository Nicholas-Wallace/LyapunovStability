# Examples

This page will contain complete examples.

## Verifying invariance of a polyhedral set

```julia
# Example code will be added here.
```

## Finding an invariant polyhedron

```julia
# Example code will be added here.
```

## Animating two coupled tanks

`animate_tanks` receives a `2 × N` matrix where the first row is the level of
tank 1 and the second row is the level of tank 2. Each column is one time step.
The animation is saved as a GIF.

```julia
using LyapunovStability

levels = [
     10.0   5.0   0.0  -5.0 -10.0;
    -10.0  -5.0   0.0   5.0  10.0
]

animate_tanks(levels; filename = "tanks.gif", fps = 5)
```

When the levels come from a simulated state `[h1; h2]`, the trajectory matrix can
be passed directly:

```julia
traj = trajectory(sys, [10.0; -10.0], 100)
animate_tanks(traj; filename = "tanks.gif", fps = 15)
```

## Animating a state-space trajectory

`animate_trajectory` receives a `2 × N` matrix where each column is a state
`[x1; x2]`. The GIF shows a growing path and a moving marker at the current
state.

```julia
traj = trajectory(sys, [1.0; 1.0], 100)

animate_trajectory(traj; filename = "trajectory.gif", fps = 15)
```

An invariant polyhedron can be drawn in the background:

```julia
animate_trajectory(traj; filename = "trajectory_poly.gif", fps = 15, ip = ip)
```

## Animating tanks and state space together

`animate_tanks_trajectory` creates a single GIF with the tanks on the left and
the state-space trajectory on the right. The same `2 × N` matrix drives both
panels, so they remain synchronized frame by frame.

```julia
traj = trajectory(sys, [10.0; -10.0], 100)

animate_tanks_trajectory(
    traj;
    filename = "tanks_trajectory.gif",
    fps = 15,
    ip = ip,
)
```
