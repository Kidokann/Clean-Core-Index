@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'View of all SAPScript output message configuration'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zi_cclm_sapscript_output
  as select from tnapr as Output

  association [0..*] to I_ABAPObjectDirectoryEntry as _DevObject on _DevObject.ABAPObject = $projection.OutputReport

{
  key Output.kschl as ConditionKey,
  key Output.nacha as OutputType,
  key Output.kappl as OutputApplication,

      Output.fonam as SAPScriptForm,
      Output.pgnam as OutputReport,
      Output.ronam as OutputEntryForm,
      
      _DevObject
}
