@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@Analytics.dataCategory: #CUBE

@EndUserText.label: 'Clean Core Index Cube'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity zc_cclm_CleanCoreIndex_Cube
  as select from zc_cclm_CleanCoreIndex

{
      @EndUserText.label: 'Datum'
  key CCLMDate,

      @EndUserText.label: 'Art'
  key CCLMType,

  key Object,
  key ABAPObject,

      ABAPPackage,

      @EndUserText.label: 'Paket beginnt mit'
      case
      when substring(ABAPPackage, 1, 1) = 'Z' then substring(ABAPPackage, 2, 1) else substring(ABAPPackage, 1, 1) end as PackageGroup,

      @EndUserText.label: 'Objekt beginnt mit'
      case
      when substring(ABAPObject, 1, 1) = 'Z' then substring(ABAPObject, 2, 1) else substring(ABAPObject, 1, 1) end    as ObjectGroup,

      ABAPApplCompExternalID,

      @EndUserText.label: 'Modul'
      case when instr(ABAPApplCompExternalID, '-') > 0 then substring(ABAPApplCompExternalID, 1, instr(ABAPApplCompExternalID, '-') - 1)
      else ABAPApplCompExternalID end                                                                                 as Application,

      @DefaultAggregation: #SUM
      @EndUserText.label: 'CleanCore Index'
      CCLMIndex,

      @DefaultAggregation: #SUM
      @EndUserText.label: 'Anzahl Elemente'
      ItemCount
}
