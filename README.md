# LyapunovStability.jl

[![CI](https://github.com/Nicholas-Wallace/LyapunovStability.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Nicholas-Wallace/LyapunovStability.jl/actions/workflows/CI.yml?query=branch%3Amain)

Lyapunov Stability analysis toolbox for Julia  

`LyapunovStability.jl` provides tools to verify stability using Lyapunov functions. Using the set-invariance-based approach the type of sets that we use in this library are Hyperpolyhedral ones. 


## Installation

To install LyapunovStability.jl, use Julia Package Manager:

```julia
julia> ]
pkg> add LyapunovStability
```
## Basic Usage

This example demonstrates how to define a system using its state-space matrices, specify state and input constraints, and investigate the invariance of a polyhedral set.

### Julia implementation

```julia
using LyapunovStability

# defining state-space matrices
A = [
    1.0  1.0;
    0.0  1.0
]

B = [2.0; 1.0;;]

C = [1.0  0.0]


sys = SLIT(A, B, C, SSF) # defining the system


# state and input constraints
X = [0.8 0;
          0  1;
         -1  0;
          0  -1]
    
U = [1.2;
    -1.5;;]


ip = is_pinvariant(sys, X; U=U) # verify the invariance of X

```

## Documentation
Documentation is available through the package docstrings, for example `?is_pinvariant` in the Julia REPL.

## Relationship with Other Packages

`LyapunovStability.jl` relies on [JuMP](https://jump.dev/) for optimization modeling, [NEOSServer.jl](https://github.com/odow/NEOSServer.jl) to access the NEOS Server (Knitro), and [Polyhedra.jl](https://github.com/JuliaPolyhedra/Polyhedra.jl) with [CDDLib.jl](https://github.com/JuliaPolyhedra/CDDLib.jl) for polyhedral representation and computation; [Plots.jl](https://docs.juliaplots.org/) is used for visualization. In the future, we aim to integrate the package with other control toolboxes, such as ControlSystems.jl, to support model import/export and interoperability with established control-design workflows.

## Contributing

Contributions, bug reports, and suggestions are welcome. Feel free to open an issue or submit a pull request.

