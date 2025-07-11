@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ATC Findings for CCLM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zc_cclm_atc as select from zi_cclm_atc
{
    key project_id,
    key item_id,
    key ABAPObject,
    key ABAPPackage,
    priority,
    ObjectType,
    /* Associations */
    _DevObject
} 
