#### CONVECTION-DIFFUSION | BIG TRANSIENT |  - SIMPLE GEOMODEL ####
[GlobalParams]
  gravity = '0 0 9.8'
  rho = 1
  mu = 1
  thermal_conductivity = '1' #from the reference doc
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  #nz = 24
  #block_id = '0 1 2 3 4 5 6 7 8 9 10 11 12'
  #block_name = 'Basement Cattamarra_Coal_Measures DefaultCover Eneabba_Fm Kockatea_Shale Late_Permian Lesueur_Ss Neocomian_Unc Topo_and_bathy Woodada_Fm Yarragadee_Fm Yigarn out'
  xmax = 90 # 9 km
  ymax = 60 # 5 km
  #zmax = 80 # 3 km
  second_order = true
  #elem_type = QUAD9
[]

[Variables]
  [./pore_pressure]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temperature]
    order = FIRST
    family = LAGRANGE
  [../]

[]


[Materials]
# note: all thermal conductivity values with water satured at 30ºC
  [./basement]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3.2 980 2700 1.2e-18 0.01 0.89' # K: (W/m*K), J/Kg-K, kg/m3, m2, N*s/m^2
  [../]
[]


[BCs]
  #active='basin_bottom_temp2D basin_top_temp2D x_no_slip y_no_slip'
  [./basin_bottom_temp]
    type = NeumannBC
    variable = temperature
    boundary = back
    value = 0.03
  [../]
  [./basin_top_temp]
    type = DirichletBC
    variable = temperature
    boundary = front
    value= 308
  [../]
[]

#[Problem]
#  type = FEProblem
#[]
[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

#  [Executioner]
#    type = Transient

#    num_steps = 100
#    dt = 86400
#    dtmin = 3600
#    petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -sub_pc_factor_levels'
#    petsc_options_value = 'asm      2               ilu          4'
#    line_search = 'none'
#    nl_rel_tol = 1e-12
#    nl_abs_tol = 1e-13
#    nl_max_its = 6
#    l_tol = 1e-6
#    l_max_its = 500
#  []

[Executioner]
  type = Transient
  scheme = crank-nicolson
  num_steps = 300 # simulate for 300 days
  solve_type =  PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm lu'
  dt = 86400 # 24h in seconds
[]

[Outputs]
  exodus = true
[]
