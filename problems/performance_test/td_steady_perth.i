#### STEADY TEMPLATE - PERTH BASIN SECTION ####
#### Perfomance test input file ####
[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = [nx]
  ny = [ny]
  nz = [nz]
  xmin=0
  ymin=0
  zmin=0
  xmax = 156000 # 100 km
  ymax = 690000 # 50 km
  zmax = 80000 # 8 km
[]

[Variables]
  [./temperature]
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
  [./heat_conduction]
    type = HeatConduction
    variable = temperature
  [../]
[]


[Materials]
  #active = 'basement'
# note: all thermal conductivity values with water satured at 30ºC
  [./basement]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.2 980 2700' # K: (W/m*K), J/Kg-K, kg/m3
  [../]
  [./cattamarra_Coal_Measures]
    type = GenericConstantMaterial
    block = 1
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.73 1000 2360' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./defaultCover]
    type = GenericConstantMaterial
    block = 2
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.73 1000 2360' # K: (W/m*K), J/Kg-K, kg/m3 # CHECK THESE VALUES
  [../]
  [./eneabba_Fm]
    type = GenericConstantMaterial
    block = 3
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '2.62 775 2520' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./kockatea_Shale]
    type = GenericConstantMaterial
    block = 4
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '2.09 900 2650' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./late_Permian]
    type = GenericConstantMaterial
    block = 5
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3 900 2650' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./lesueur_Ss]
    type = GenericConstantMaterial
    block = 6
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.56 775 2650' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./neocomian_Unc]
    type = GenericConstantMaterial
    block = 7
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.73 1000 2360' # W/m*K, J/kg-K, kg/m^3   CHECK THESE VALUES
  [../]
  [./topo_and_bathy]
    type = GenericConstantMaterial
    block = 8
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.73 1000 2360' # W/m*K, J/kg-K, kg/m^3    CHECK THESE VALUES
  [../]
  [./woodada_Fm ]
    type = GenericConstantMaterial
    block = 9
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '2.79 850 2620' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./yarragadee_Fm]
    type = GenericConstantMaterial
    block = 10
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.54 775 2180' # W/m*K, J/kg-K, kg/m^3 NOTE: AQUIFER VALUES
  [../]
  [./yigarn]
    type = GenericConstantMaterial
    block = 11
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.2 980 2700' # W/m*K, J/kg-K, kg/m^3
  [../]
  [./out]
    type = GenericConstantMaterial
    block = 12
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '3.2 980 2700' # W/m*K, J/kg-K, kg/m^3     CHECK THESE VALUES
  [../]
[]

[BCs]
  [./basin_bottom_temp]
    type = NeumannBC
    variable = temperature
    boundary = back
    value = 0.003
    #value = 2.787068e-13
  [../]
  [./basin_top_temp]
    type = FunctionDirichletBC
    variable = temperature
    boundary = front
    function = bc_func
  [../]
[]

[Executioner]
    type = Steady
    solve_type = NEWTON
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  #print_perf_log = true
  #file_base = d_steady_full_perth_out
[]

[MeshModifiers]
	[./perth_section]
  		type = AssignElementSubdomainID
  		subdomain_ids = [magic_key]
  	[../]
[]
