@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'View of all SmartForms'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity zi_cclm_smartforms
  as select from stxfadm

  association [1..1] to I_ABAPPackage as _Package on _Package.ABAPPackage = $projection.ABAPPackage

{
  key formname as SmartForm,

      devclass as ABAPPackage,

      _Package
}

where formtype =    ''
  and( formname like 'Z%'
    or formname =    'Y%' )
