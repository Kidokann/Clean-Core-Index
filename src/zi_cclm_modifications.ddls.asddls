@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'View modifications done by customer'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zi_cclm_modifications
  as select from smodilog

{
  key obj_type as ObjectType,
  key obj_name as ObjectName,
  key sub_type as SubObjectType,
  key sub_name as SubObjectName,

      prot_only
}

where inactive = ''
  and (   operation = 'ALL'
       or operation = 'MOD'
       or operation = 'NEW'
       or operation = 'PRE'
       or operation = 'POST'
       or operation = '')
  and int_type <> 'APPD'

group by obj_type,
         obj_name,
         sub_type,
         sub_name,
         prot_only
