@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clean Core Index'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_cclm_cleancoreindex as select from zbc_cclmidx
{
    key indexdate as Indexdate,
    key id as Id,
    key cclmtype as Cclmtype,
    key subname as SubName,
    key objname as ObjName,
    abappackage as Abappackage,
    applicationcomponent as Applicationcomponent
}
