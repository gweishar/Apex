#### CONVECTION-DIFFUSION | SMALL TRANSIENT |  - SIMPLE GEOMODEL ####
[GlobalParams]
  gravity = '0 0 9.8'
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 27
  ny = 18
  nz = 24
  #block_id = '0 1 2'
  #block_name = 'gneiss steel ice'
  xmax = 90 #
  ymax = 70 # 50 km
  zmax = 40 # 8 km
[]

[Variables]
  [./temperature]
  [../]
  [./pressure]
    [./InitialCondition]
      type = ConstantIC
      value = 1e5
    [../]
  [../]
[]

[AuxVariables]
  [./velocity_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./velocity_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./velocity_z]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./darcy_pressure]
    type = DarcyPressure
    variable = pressure
  [../]
  [./heat_conduction]
    type = HeatConduction
    variable = temperature
  [../]
  [./heat_conduction_time_derivative]
    type = HeatConductionTimeDerivative
    variable = temperature
  [../]
  [./heat_convection]
    type = DarcyConvection
    variable = temperature
    darcy_pressure = pressure
  [../]
[]

[AuxKernels]
  [./velocity_x]
    type = DarcyVelocity
    variable = velocity_x
    component = x
    execute_on = timestep_end
    darcy_pressure = pressure
  [../]
  [./velocity_y]
    type = DarcyVelocity
    variable = velocity_y
    component = y
    execute_on = timestep_end
    darcy_pressure = pressure
  [../]
  [./velocity_z]
    type = DarcyVelocity
    variable = velocity_z
    component = z
    execute_on = timestep_end
    darcy_pressure = pressure
  [../]
[]


[Materials]
  active = 'gneiss'
  [./gneiss]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3.2 980 2700 1.2e-18 0.01 0.89' # K: (W/m*K), J/Kg-K, kg/m3, m2, N*s/m^2
  [../]
[]


[BCs]
  [./basin_bottom_temp]
    type = NeumannBC
    variable = temperature
    boundary = back
    value = -0.3
  [../]
  [./basin_top_temp]
    type = DirichletBC
    variable = temperature
    boundary = front
    value = 298.15 # (K) surface temperature at 25 ºC
  [../]
[]

[Executioner]
  type = Transient
  scheme = crank-nicolson
  num_steps = 30
  solve_type =  PJFNK
  ​line_search = basic
  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm lu'
  dt = 1728000 #20 days
  dtmin =  86400 #1 day
[]

[Outputs]
  exodus = true
[]
