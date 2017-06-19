#### CONVECTION-DIFFUSION STEADY TEMPLATE - PERTH BASIN SECTION ####

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 28
  ny = 80
  nz = 28
  #block_id = '0 1 2 3 4 5 6 7 8 9 10 11 12'
  #block_name = 'Basement Cattamarra_Coal_Measures DefaultCover Eneabba_Fm Kockatea_Shale Late_Permian Lesueur_Ss Neocomian_Unc Topo_and_bathy Woodada_Fm Yarragadee_Fm Yigarn out'
  xmax = 9000 # 9 km
  ymax = 5000 # 5 km
  zmax = 3000 # 3 km
[]

[MeshModifiers]
	[./perth_section]
  		type = AssignElementSubdomainID
  		subdomain_ids = [magic_key]
  	[../]
[]

[Variables]
  active = 'temperature pressure'
  [./pressure]
  [../]
  [./temperature]
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

[Functions]
  # A ParsedFunction allows us to supply analytic expressions
  # directly in the input file
  [./bc_func]
    type = ParsedFunction
    value = 298.15+grad*y
    vars = 'grad'
    #vals = 1e-3
    vals=1.4449275362e-5 # corresponds to 10 degrees difference over the whole distance in y direction i.e 10/690km
  [../]
[]

[Kernels]
  active = 'heat_convection gravity darcy_pressure heat_conduction'
  [./darcy_pressure]
    type = DarcyPressure
    variable = pressure
  [../]
  [./heat_conduction]
    type = HeatConduction
    variable = temperature
  [../]
  [./gravity]
    type = BodyForce
    variable = temperature
    value = -9.81
  [../]
  [./heat_convection]
    type = DarcyConvection
    variable = temperature
    darcy_pressure = pressure
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
  [./cattamarra_Coal_Measures]
    type = GenericConstantMaterial
    block = 1
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3.73 1000 2360 1.2e-17 0.1 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  [../]
  [./defaultCover]
    type = GenericConstantMaterial
    block = 2
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3.73 1000 2360 1.2e-12 0.1 0.89' # K: (W/m*K), J/Kg-K, kg/m3, m2, N*s/m^2 # CHECK THESE VALUES
  [../]
  [./eneabba_Fm]
    type = GenericConstantMaterial
    block = 3
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '2.62 775 2520 1.2e-13 0.06 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  [../]
  [./kockatea_Shale]
    type = GenericConstantMaterial
    block = 4
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '2.09 900 2650 1.5e-15 0.12 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  [../]
  [./late_Permian]
    type = GenericConstantMaterial
    block = 5
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3 900 2650 1.2e-14 0.05 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  [../]
  [./lesueur_Ss]
    type = GenericConstantMaterial
    block = 6
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3.56 775 2650 2e-15 0.09 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  [../]
  #[./neocomian_Unc]
  #  type = GenericConstantMaterial
  #  block = 7
  #  prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
  #  prop_values = '3.73 1000 2360 1.2e-12 0.1 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2   CHECK THESE VALUES
  #[../]
  #[./topo_and_bathy]
  #  type = GenericConstantMaterial
  #  block = 8
  #  prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
  #  prop_values = '3.73 1000 2360 1.2e-12 0.1 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2    CHECK THESE VALUES
  #[../]
  [./woodada_Fm ]
    type = GenericConstantMaterial
    block = 9
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '2.79 850 2620 1.3e-16 0.04 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  [../]
  [./yarragadee_Fm]
    type = GenericConstantMaterial
    block = 10
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '3.54 775 2180 1.2e-13 0.2 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2 NOTE: AQUIFER VALUES
  [../]
  #[./yigarn]
  #  type = GenericConstantMaterial
  #  block = 11
  #  prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
  #  prop_values = '3.2 980 2700 1.2e-18 0.01 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2
  #[../]
  [./out]
    type = GenericConstantMaterial
    block = 12
    prop_names = 'thermal_conductivity specific_heat density permeability porosity viscosity'
    prop_values = '12 980 2700 1.2e-12 0.01 0.89' # W/m*K, J/kg-K, kg/m^3, m2, N*s/m^2     CHECK THESE VALUES
  [../]
[]


[BCs]
  active='basin_top_fixed_temp basin_bottom_temp'
  [./basin_top_fixed_temp]
    type = DirichletBC
    variable = temperature
    boundary = front
    value= 300 #K
  [../]
  [./basin_top_pressure]
    type = DirichletBC
    variable = pressure
    boundary = front
    value = 1e5 # Pa approximate atmospheric pressure
  [../]
  [./basin_bottom_temp]
    type = NeumannBC
    variable = temperature
    boundary = back
    value = 0.03 #W/m2
  [../]
  [./basin_top_temp]
    type = FunctionDirichletBC
    variable = temperature
    boundary = front
    function = bc_func
  [../]
[]

#[Problem]
#  type = FEProblem
#[]

[Executioner]

  #active='newton_solver'
  #[./newton_solver]
    type = Steady
    solve_type = NEWTON
  #[../]

  #[./pjfnk_solver]
    #type = Steady
    #solve_type =  PJFNK
    #petsc_options_iname = '-pc_type -sub_pc_type'
    #petsc_options_value = 'asm lu'
  #[../]
[]

[Outputs]
  exodus = true
[]
