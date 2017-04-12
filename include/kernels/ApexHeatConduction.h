/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef ApexHeatConduction_H
#define ApexHeatConduction_H

#include "Diffusion.h"
#include "Material.h"

//Forward Declarations
class ApexHeatConduction;

template<>
InputParameters validParams<ApexHeatConduction>();

class ApexHeatConduction : public Diffusion
{
public:

  ApexHeatConduction(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();

  virtual Real computeQpJacobian();

private:
 Real _diffusion_coefficient;
};

#endif //ApexHeatConduction_H
