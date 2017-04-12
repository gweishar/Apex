/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#include "ApexHeatConduction.h"
#include "MooseMesh.h"

template<>
InputParameters validParams<ApexHeatConduction>()
{
  InputParameters params = validParams<Diffusion>();
  params.addClassDescription("Computes residual/Jacobian contribution for $(k \\nabla T, \\nabla \\psi)$ term.");
  params.addRequiredParam<Real>("thermal_conductivity","Thermal Conductivity");

  //params.set<bool>("use_displaced_mesh") = true;
  return params;
}

ApexHeatConduction::ApexHeatConduction(const InputParameters & parameters) :
    Diffusion(parameters),
    _diffusion_coefficient(getParam<Real>("thermal_conductivity"))
{
}

Real
ApexHeatConduction::computeQpResidual()
{
  return _diffusion_coefficient * Diffusion::computeQpResidual();
}

Real
ApexHeatConduction::computeQpJacobian()
{
  return _diffusion_coefficient * Diffusion::computeQpJacobian();
}
