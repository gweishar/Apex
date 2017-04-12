#include "ApexApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

// BCs
#include "HeatConductionOutflow.h"

// Kernels
#include "DarcyPressure.h"
#include "ApexConvection.h"
#include "DarcyConvection.h"
#include "ApexHeatConduction.h"
#include "ApexMomentum.h"

//Aux Kernels
#include "DarcyVelocity.h"
#include "EntropyProduction.h"

template<>
InputParameters validParams<ApexApp>()
{
  InputParameters params = validParams<MooseApp>();
  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  return params;
}

ApexApp::ApexApp(InputParameters parameters) :
    MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  ApexApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  ApexApp::associateSyntax(_syntax, _action_factory);
}

ApexApp::~ApexApp()
{
}

// External entry point for dynamic application loading
extern "C" void ApexApp__registerApps() { ApexApp::registerApps(); }
void
ApexApp::registerApps()
{
  registerApp(ApexApp);
}

// External entry point for dynamic object registration
extern "C" void ApexApp__registerObjects(Factory & factory) { ApexApp::registerObjects(factory); }
void
ApexApp::registerObjects(Factory & factory)
{
	registerKernel(DarcyPressure);
  registerKernel(ApexConvection);
  registerKernel(DarcyConvection);
  registerKernel(ApexMomentum);
  registerKernel(ApexHeatConduction);
  registerBoundaryCondition(HeatConductionOutflow);
  registerAux(DarcyVelocity);
  registerAux(EntropyProduction);
}

// External entry point for dynamic syntax association
extern "C" void ApexApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { ApexApp::associateSyntax(syntax, action_factory); }
void
ApexApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
