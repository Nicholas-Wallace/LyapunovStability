# utilizar o "!" e alterar a matrix diretamente, sem copia
function elimred(G, ro)
    h = hrep(G, ro)
    p = polyhedron(h, CDDLib.Library())
    removehredundancy!(p)
    h_clean = hrep(p)

    n_h = nhalfspaces(h_clean)
    dim = size(G, 2)

    Gn = Matrix{Float64}(undef, n_h, dim)
    ron = Vector{Float64}(undef, n_h)

    for (i, half_space) in enumerate(halfspaces(h_clean))
        Gn[i, :] = half_space.a
        ron[i] = half_space.β
    end

    return Gn, ron
end

# Cria lista de matrizes F e forma a matriz diagonal extended_F
function extended_F(F, d)
    blocks = [F for _ in 1:(d+1)]
    # Concatena na diagonal (concatena tanto verticalmente quanto horizontalmente)
    # Isso gera a matriz diagonal, os zeros são colocados automaticamente
    return cat(blocks..., dims=(1, 2))
end

function extended_A(A, Ad, d; dm=d)
    n = size(A, 1)
    N = n * (dm + 1)
    id = (d-1) * n + 1 : d * n

    row1 = zeros(n, N-n)
    row1[:, id] = Ad
    row1 = hcat(A, row1)

    identity = Float64.(I(n*dm))
    bottom_zero = zeros(n*dm, n)

    return vcat(row1, hcat(identity, bottom_zero))
end

"""
    admissable_initCond(system::SystemDelayed, ip::InvariantPolyhedron; symetric=false) -> InvariantPolyhedron

Gera o poliedro de condições iniciais admissíveis para o sistema com atraso
fixo `d = system.d`. A dinâmica em malha fechada depende de `system.feedback`:

    SOF -> x[k+1] = system.A*x[k] + system.Ad*system.G*system.C*x[k-d]
    SSF -> x[k+1] = system.A*x[k] + system.Ad*system.G*x[k-d]

onde `system.Ad` é a matriz de entrada atrasada e `system.G` é o ganho.

Assume que `ip` define um poliedro p-invariante:

    ip.F * x <= ip.w

O estado aumentado é `[x[k], x[k-1], ..., x[k-d]]`. Retorna um
`InvariantPolyhedron` com `λ = ip.λ` e o mesmo `system`. Com
`symetric=true`, as restrições também são concatenadas com sua versão negativa;
use `symetric=false` quando `ip` já for simétrico.
"""
function admissable_initCond(system::SystemDelayed, ip::InvariantPolyhedron; symetric::Bool=false)
    system.feedback == OL && error("realimentação OL não possui ganho a otimizar")

    n = size(system.A, 1)
    size(ip.F, 2) == n ||
        throw(DimensionMismatch("ip.F deve ter $n colunas, recebido $(size(ip.F, 2))"))
    length(ip.w) == size(ip.F, 1) ||
        throw(DimensionMismatch("ip.w deve ter $(size(ip.F, 1)) entradas, recebido $(length(ip.w))"))
    system.d >= 1 ||
        throw(ArgumentError("system.d deve ser maior ou igual a 1, recebido $(system.d)"))

    d = system.d
    Ad = system.feedback == SOF ? system.Ad * system.G * system.C :
                                  system.Ad * system.G

    ext_F = extended_F(ip.F, d)
    ext_w = repeat(ip.w, d + 1)

    init_cond_F = ext_F
    init_cond_w = ext_w

    ext_A = extended_A(system.A, Ad, d)
    current_A_pow = ext_F

    for _ in 1:d
        current_A_pow *= ext_A
        init_cond_F = vcat(init_cond_F, current_A_pow)
        init_cond_w = vcat(init_cond_w, ext_w)

        init_cond_F, init_cond_w = elimred(init_cond_F, init_cond_w)
    end

    return InvariantPolyhedron(init_cond_F, init_cond_w, ip.λ, system; symetric=symetric)
end

function calcular_v(F, E, R)
    # Pré-computa a matriz M = F * E
    M = F * E
    
    n_linhas = size(M, 1)
    n_cols_R = size(R, 2)  # dimensão do vetor r
    
    ones_r = ones(size(R, 1))
    
    v = zeros(n_linhas)
    
    # Cria UM único modelo e resolve repetidamente (mais eficiente que criar N modelos)
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    
    @variable(model, r[1:n_cols_R])
    @constraint(model, restricoes, R * r .<= ones_r)
    
    for i in 1:n_linhas
        # Define o objetivo como a i-ésima linha de M
        @objective(model, Max, sum(M[i, j] * r[j] for j in 1:n_cols_R))
        
        optimize!(model)
        
        if termination_status(model) == OPTIMAL
            v[i] = objective_value(model)
        else
            error("LP infeasible or unbounded at row $i")
        end
    end
    
    return v
end
