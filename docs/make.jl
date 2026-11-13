using Documenter
using LyapunovStability

DocMeta.setdocmeta!(
    LyapunovStability,
    :DocTestSetup,
    :(using LyapunovStability);
    recursive = true,
)

makedocs(
    sitename = "LyapunovStability.jl",
    modules = [LyapunovStability],
    repo = "https://github.com/Nicholas-Wallace/LyapunovStability.jl/blob/{commit}{path}#{line}",
    pages = [
        "Home" => "index.md",
        "Guide" => [
            "Systems" => "guide/systems.md",
            "Invariance" => "guide/invariance.md",
            "Trajectories" => "guide/trajectories.md",
            "Plotting" => "guide/plotting.md",
        ],
        "Examples" => "examples.md",
        "API Reference" => "api.md",
    ],
    checkdocs = :none,
    warnonly = true,
)

# Deployment will be configured once the repository rename and
# DOCUMENTER_KEY setup are complete.
# deploydocs(
#     repo = "github.com/Nicholas-Wallace/LyapunovStability.jl.git",
#     devbranch = "main",
# )
