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

#ifndef ApexConvection_H
#define ApexConvection_H

#include "Kernel.h"

// Forward Declaration
class ApexConvection;

template<>
InputParameters validParams<ApexConvection>();

/**
 * Kernel which implements the convective term in the transient heat
 * conduction equation, and provides coupling with the Darcy pressure
 * equation.
 */
class ApexConvection : public Kernel
{
public:
  ApexConvection(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

  // Coupled variables
  const VariableValue & _u_vel;
  const VariableValue & _v_vel;
  const VariableValue & _w_vel;

  /// These references will be set by the initialization list so that
  /// values can be pulled from the Material system.
  const MaterialProperty<Real> & _density;
  const MaterialProperty<Real> & _specific_heat;
};

#endif // ApexConvection_H
