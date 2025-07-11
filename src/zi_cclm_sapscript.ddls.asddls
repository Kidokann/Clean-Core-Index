@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View of all SAPScript forms'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_cclm_sapscript as select from stxh
{

key tdname as SAPScriptForm

}
where tdobject = 'FORM' and tdid = 'TXT' and ( tdname like 'Z%'
or tdname like 'Y%' )
group by tdname
