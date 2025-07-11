@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'ATC Findings for CCLM'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zi_cclm_atc
  as select from satc_Ac_Rstis_Ddlv as results
  join satc_ac_resulth as head on results.display_id = head.display_id
  join zi_cclm_atc_lastrun as _lastRun on head.scheduled_on_ts = _lastRun.LastRunCompleteDate

  association[1..1] to I_ABAPObjectDirectoryEntry as _DevObject on _DevObject.ABAPObject = $projection.ABAPObject and _DevObject.ABAPObjectType = $projection.ObjectType

{
  key results.display_id as project_id,
  key results.item_id,
  key results.obj_name     as ABAPObject,
  key results.package_name as ABAPPackage,

      results.priority,
      results.obj_type     as ObjectType,
    //  note_number as NoteNumber,
    //  note_title as NoteTitle,
      results.check_class as CheckClass,
     //check_message as CheckMessage ,
      
      _DevObject
} where results.exc_approval <> 'A'
