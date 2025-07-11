@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Clean Core Index'

@Metadata.ignorePropagatedAnnotations: true

define root view entity zc_cclm_CleanCoreIndex

  as select from zi_cclm_cleancoreindex

{
  key Indexdate            as CCLMDate,
  key Cclmtype             as CCLMType,
  key ObjName              as Object,
  key SubName              as ABAPObject,

      Abappackage          as ABAPPackage,

      case Cclmtype
        when 'MOD' then 10
        when 'FM ' then 1
        when 'UE ' then 8
        when 'REP' then 1
        when 'FM1' then 2
        when 'FM2' then 2
        when 'ATC' then 5
        else 99
        end                as CCLMIndex,

      1                    as ItemCount,
      Applicationcomponent as ABAPApplCompExternalID
}
