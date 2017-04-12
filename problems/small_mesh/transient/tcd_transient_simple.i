#### CONVECTION-DIFFUSION | BIG TRANSIENT | TEMPLATE - SIMPLE GEOMODEL ####
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
  active = 'vel_x vel_y pressure temperature'
  [./vel_x]
    order = SECOND
    family = LAGRANGE
  [../]
  [./vel_y]
    order = SECOND
    family = LAGRANGE
  [../]
  [./vel_z]
    order = SECOND
    family = LAGRANGE
  [../]
  [./pressure]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temperature]
    order = FIRST
    family = LAGRANGE
  [../]

[]

[Functions]
  # A ParsedFunction allows us to supply analytic expressions
  # directly in the input file
  [./bc_func]
    type = ParsedFunction
    value = 298.15+(10/28)*grad*x
    vars = 'grad'
    vals = '1' # in future transform this to [grad_value] with deltax/nx calculated from the pythong script
  [../]
[]

[Kernels]
  #active = 'mass x_momentum_space y_momentum_space
  #         heat_conduction temperature_time'
  [./mass]
    type = INSMass
    variable = pressure
    u = vel_x
    v = vel_y
    p = pressure
  [../]

  # x-momentum, time
  [./x_momentum_time]
    type = INSMomentumTimeDerivative
    variable = vel_x
  [../]

  # x-momentum, space
  [./x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_x
    u = vel_x
    v = vel_y
    p = pressure
    component = 0
  [../]

  # y-momentum, time
  [./y_momentum_time]
    type = INSMomentumTimeDerivative
    variable = vel_y
  [../]

  # y-momentum, space
  [./y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_y
    u = vel_x
    v = vel_y
    p = pressure
    component = 1
  [../]

  # z-momentum, time
  [./z_momentum_time]
    type = INSMomentumTimeDerivative
    variable = vel_z
  [../]

  # z-momentum, space
  [./z_momentum_space]
    type = ApexMomentum
    variable = vel_z
    pressure = pressure
    temperature = temperature
    component = 2
  [../]

 # temperature
 [./temperature_time]
   type = HeatConductionTimeDerivative
   variable = temperature
 [../]

 [./heat_conduction]
   type = ApexHeatConduction
   variable = temperature
   #thermal_conductivity = thermal_conductivity2
 [../]

 [./heat_convection]
   type = ApexConvection
   variable = temperature
   u = vel_x
   v = vel_y
   w = vel_z
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
  active='basin_bottom_temp2D basin_top_temp2D x_no_slip y_no_slip'
  [./basin_top_pressure]
    type = DirichletBC
    variable = pressure
    boundary = front
    value = 1e5 # Pa
  [../]
  [./x_no_slip]
    type = DirichletBC
    variable = vel_x
    boundary = 'right left top bottom'
    value = 0.0
  [../]
  [./y_no_slip]
    type = DirichletBC
    variable = vel_y
    boundary = 'right left top bottom'
    value = 0.0
  [../]
  [./z_no_slip]
    type = DirichletBC
    variable = vel_z
    boundary = 'back right front left top bottom'
    value = 0.0
  [../]
  [./basin_bottom_temp2D]
    type = NeumannBC
    variable = temperature
    boundary = bottom
    value = 0.03
  [../]
  [./basin_top_temp2D]
    type = FunctionDirichletBC
    variable = temperature
    boundary = top
    function = bc_func
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

#[MeshModifiers]
#	[./perth_section]
#  		type = AssignElementSubdomainID
#  		subdomain_ids = [magic_key]
#  	[../]
#[]
