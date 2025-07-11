@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'List of Custom ABAP FunctionModules'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zi_cclm_functionmodules
  as select from    tfdir as Function

    left outer join tftit as Text
      on  Function.funcname = Text.funcname
      and Text.spras        = $session.system_language

  association [1..1] to ZI_cclm_CustomReports as _Report on _Report.ABAPObject = $projection.ABAPObjectMainReport

{
      @ObjectModel.text.element: [ 'FunctionModuleText' ]
  key Function.funcname as ABAPFunctionModule,

      Function.pname    as ABAPObject,

      case
        when Function.pname_main is not initial then Function.pname_main
        else Function.pname
        end             as ABAPObjectMainReport,

      @Semantics.text: true
      Text.stext        as FunctionModuleText,

      _Report
}
