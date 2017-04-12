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

#ifndef ApexMomentum_H
#define ApexMomentum_H

#include "Kernel.h"

// Forward Declaration
class ApexMomentum;

template<>
InputParameters validParams<ApexMomentum>();

/**
 * Kernel which implements the convective term in the transient heat
 * conduction equation, and provides coupling with the Darcy pressure
 * equation.
 */
class ApexMomentum : public Kernel
{
public:
  ApexMomentum(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

  // Variable that will hold the component
  unsigned _component;

  // Coupled variables
  const VariableGradient & _grad_p;
  const VariableValue & _temp;

  /// These references will be set by the initialization list so that
  /// values can be pulled from the Material system.
  const MaterialProperty<Real> & _density;
  const MaterialProperty<Real> & _specific_heat;
};

#endif // ApexMomentum_H
