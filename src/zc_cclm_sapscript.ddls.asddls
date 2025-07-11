@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'View of all SAPScript forms'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zc_cclm_sapscript
  as select from    zi_cclm_sapscript as Form

    left outer join ttxfp             as Reports on Reports.tdform = Form.SAPScriptForm

  association [0..*] to zi_cclm_sapscript_output as _Output
    on  _Output.SAPScriptForm = $projection.SAPScriptForm
    and _Output.OutputReport  = $projection.ReportName

{
  key Form.SAPScriptForm,

      Reports.print_name  as ReportName,
      _Output
}
