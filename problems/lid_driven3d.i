[GlobalParams]
  gravity = '0 0 9.8'
  rho = 1
  mu = 1
  cp = 1
  k = .01
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = 1.0
  ymin = 0
  ymax = 1.0
  zmin=0
  zmax = 1
  nx = 5
  ny = 5
  nz = 5
  second_order = true
  #elem_type = HEX8
[]

[MeshModifiers]
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    nodes = '0'
  [../]
[]

[Variables]
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

  [./T]
    order = SECOND
    family = LAGRANGE

    [./InitialCondition]
      type = ConstantIC
      value = 1.0
    [../]
  [../]

  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  #active = 'mass heat_conduction x_momentum_space y_momentum_space z_momentum_space heat_convection heat_conduction_time_derivative'
  [./mass]
    type = INSMass
    variable = p
    u = vel_x
    v = vel_y
    w = vel_z
    p = p
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
    w = vel_z
    p = p
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
    w = vel_z
    p = p
    component = 1
  [../]

  # z-momentum, time
  [./z_momentum_time]
    type = INSMomentumTimeDerivative
    variable = vel_z
  [../]

  # z-momentum, space
  [./z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_z
    u = vel_x
    v = vel_y
    w = vel_z
    p = p
    component = 2
  [../]

 # temperature
 [./temperature_time]
   type = INSTemperatureTimeDerivative
   variable = T
 [../]

 [./temperature_space]
   type = INSTemperature
   variable = T
   u = vel_x
   v = vel_y
   w = vel_z
 [../]
[]

[BCs]
  [./x_no_slip]
    type = DirichletBC
    variable = vel_x
    boundary = 'bottom right left top back'
    value = 0.0
  [../]

  [./lid]
    type = FunctionDirichletBC
    variable = vel_x
    boundary = 'front'
    function = 'lid_function'
  [../]

  [./y_no_slip]
    type = DirichletBC
    variable = vel_y
    boundary = 'bottom right top left front back'
    value = 0.0
  [../]

  [./z_no_slip]
    type = DirichletBC
    variable = vel_z
    boundary = 'bottom right top left front back'
    value = 0.0
  [../]

  [./T_hot]
    type = DirichletBC
    variable = T
    boundary = 'bottom'
    value = 1
  [../]

  [./T_cold]
    type = DirichletBC
    variable = T
    boundary = 'top'
    value = 0
  [../]

  [./p_pin]
    type = DirichletBC
    variable = p
    boundary = 'pinned_node'
    value = 0
  [../]
[]

[Functions]
  [./lid_function]
    # We pick a function that is exactly represented in the velocity
    # space so that the Dirichlet conditions are the same regardless
    # of the mesh spacing.
    type = ParsedFunction
    value = '4*x*(1-x)'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  type = Transient
  # Run for 100+ timesteps to reach steady state.
  num_steps = 5
  dt = .5
  dtmin = .5
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -sub_pc_factor_levels'
  petsc_options_value = 'asm      2               ilu          4'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-13
  nl_max_its = 6
  l_tol = 1e-6
  l_max_its = 500
[]

[Outputs]
  file_base = lid_driven_out
  exodus = true
[]
