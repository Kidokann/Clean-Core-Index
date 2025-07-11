@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'List of Custom ABAP FunctionModules'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zc_cclm_functionmodules
  as select from zi_cclm_functionmodules

{
  key ABAPFunctionModule,

      ABAPObject,
      ABAPObjectMainReport,
      FunctionModuleText,
      _Report._DevObject.ABAPPackage,

      _Report
}

where ABAPFunctionModule not like 'TABLE%'
and ABAPFunctionModule not like 'VIEW%'
and _Report._DevObject.ABAPObjectType = 'FUGR'
