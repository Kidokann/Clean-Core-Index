@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'List of Custom ABAP Reports, FM'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_cclm_CustomReports
  as select from reposrc

  association [0..1] to I_ABAPObjectDirectoryEntry as _DevObject on _DevObject.ABAPObject = $projection.ABAPObjectName and ( _DevObject.ABAPObjectType = 'FUGR' or _DevObject.ABAPObjectType = 'PROG' ) 
  association [0..*] to zi_cclm_functionmodules    as _Functions on _Functions.ABAPObjectMainReport = $projection.ABAPObject

{
  key progname    as ABAPObject,
  key r3state     as ABAPObjectState,
    
      case
         when progname like 'SAPL%' then  substring(progname, 5, length(progname))
         else progname
         end      as ABAPObjectName,

      subc        as ObjectType,

      _DevObject,
      _Functions
}

where r3state  =    'A'
  and(subc     =    '1'
    or subc     =    'M'
    or subc     =    'F')
  and(progname like 'Z%'
    or progname like 'Y%'
    or progname like 'SAPLZ%'
    or progname like 'SAPLY%'
    or progname like 'SAPMZ%'
    or progname like 'SAPMY%')
