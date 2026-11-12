
"""
    vet_eq_spc(n) -> Array{Vector{Float64}}

    Gera e retorna um vetor de n vetores unitários igualmente espaçados em um círculo
"""

function vet_eq_spc(n::Int)
  #TODO: generalizar para mais dimensoes

  if n < 1
    error("n must be ::Int and > 1, got n=$n") 
  end

  angle = 2*pi/n

  #matriz de rotação
  m_rot = [cos(angle) -sin(angle);
           sin(angle) cos(angle)]
  
  vet_array = Array{Vector{Float64}}(undef, n)
  
  # por padrão iniciasse com um vetor unitário na direção do eixo y, e vai rotacionando ele  
  vet_array[1] = [0, 1]

  for i in range(2, n)
      vet_array[i] = m_rot*vet_array[i-1] 
  end
  return vet_array

end
