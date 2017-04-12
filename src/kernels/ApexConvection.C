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

#include "ApexConvection.h"

template<>
InputParameters validParams<ApexConvection>()
{
  InputParameters params = validParams<Kernel>();

  // Coupled variables
  params.addRequiredCoupledVar("u", "x-velocity");
  params.addCoupledVar("v", 0, "y-velocity"); // only required in 2D and 3D
  params.addCoupledVar("w", 0, "z-velocity"); // only required in 3D

  return params;
}

ApexConvection::ApexConvection(const InputParameters & parameters) :
    Kernel(parameters),

    // Couple to the velocity field
    // Coupled variables
    _u_vel(coupledValue("u")),
    _v_vel(coupledValue("v")),
    _w_vel(coupledValue("w")),

    // Grab necessary material properties
    _density(getMaterialProperty<Real>("density")),
    _specific_heat(getMaterialProperty<Real>("specific_heat"))
{
}

Real
ApexConvection::computeQpResidual()
{
  return _specific_heat[_qp] * _density[_qp]*( _u_vel[_qp] * _grad_u[_qp](0) +
   _v_vel[_qp] * _grad_u[_qp](1) + _w_vel[_qp] * _grad_u[_qp](2) ) *
     _test[_i][_qp];
}

Real
ApexConvection::computeQpJacobian()
{
  RealVectorValue U(_u_vel[_qp], _v_vel[_qp], _w_vel[_qp]);

  return _specific_heat[_qp] * _density[_qp]*(U*_grad_phi[_j][_qp]) * _test[_i][_qp];
  //return _specific_heat[_qp] * _density[_qp]*( (U*_grad_phi[_j][_qp]) +
  //      _phi[_j][_qp] * _grad_u[_i][_qp]) * _test[_i][_qp];
}
