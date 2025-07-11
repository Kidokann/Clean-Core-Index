@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'View of all modifications done by customer'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zc_cclm_modifications
  as select from zi_cclm_modifications

  association [1..1] to I_ABAPObjectDirectoryEntry as _DevObject
    on  _DevObject.ABAPObject     = $projection.ObjectName
    and _DevObject.ABAPObjectType = $projection.ObjectType

{
  key ObjectType,
  key ObjectName,
  key SubObjectType,
  key SubObjectName,
  prot_only as WithoutAssistance,

      _DevObject.ABAPPackage,

      _DevObject
}

where _DevObject.ABAPPackage not like '/SAPLOM%'
and _DevObject.ABAPPackage not like 'Z%'
and _DevObject.ABAPPackage not like 'Y%'


