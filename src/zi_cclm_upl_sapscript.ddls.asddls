@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'List of actively used SAPScript forms'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_cclm_upl_sapscript
  as select from tst01 as spool
    join         tst03 as data on  spool.dname = data.dname
                               and spool.dpart = data.dpart
{
key spool.dname as SpoolName,
                             key spool.dpart as SpoolPart,
                             key data.drowno as SpoolNo,
                             spool.dtype as SpoolType,
                             spool.dlang as Language,
                             cast( substring( spool.dcretime, 1, 8) as abap.dats ) as CreatedAt,
                             spool.dmodtool as Report,
                             spool.dcreater as CreatedBy,
                            
                             data.ddatalen as DataLength,
                             data.dcontent as Content

  }
where
      spool.dtype like 'OTF%'
  and data.drowno = 1
