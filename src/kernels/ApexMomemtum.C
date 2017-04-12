/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#include "ApexMomentum.h"

template<>
InputParameters validParams<ApexMomentum>()
{
  InputParameters params = validParams<Kernel>();

  // Coupled variables
  //params.addRequiredCoupledVar("velocity", "Velocity component");
  params.addRequiredCoupledVar("pressure","Pressure variable to get the gradient");
  params.addRequiredParam<unsigned>("component", "Component that corresponds to the axis");
  params.addRequiredCoupledVar("temperature", "Temperature field");
  return params;
}

ApexMomentum::ApexMomentum(const InputParameters & parameters) :
    Kernel(parameters),

    _component(getParam<unsigned>("component")),

    _grad_p(coupledGradient("pressure")),
    _temp(coupledValue("temperature")),
    // Grab necessary material properties
    _density(getMaterialProperty<Real>("density")),
    _specific_heat(getMaterialProperty<Real>("specific_heat"))
{
}

Real
ApexMomentum::computeQpResidual()
{
  Real _rayleigh = 0; // to be completed
  if (_component == 2)
  {
    return ( _u[_qp] + _grad_p[_qp](_component) - _rayleigh * _temp[_qp]) * _test[_i][_qp];
  }
  else
  {
    return ( _u[_qp] + _grad_p[_qp](_component)) * _test[_i][_qp];
  }
}

Real
ApexMomentum::computeQpJacobian()
{
  Real _rayleigh = 0; // to be completed
  if (_component == 2)
  {
    return ( _phi[_j][_qp] + _grad_p[_qp](_component) - _rayleigh * _temp[_qp]) * _test[_i][_qp];
  }
  else
  {
    return ( _phi[_j][_qp] + _grad_p[_qp](_component)) * _test[_i][_qp];
  }
}
