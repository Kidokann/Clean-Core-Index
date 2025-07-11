@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View of all active user exits w. incudes'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zc_cclm_userexits as select from zi_cclm_userexits

{
    key Project,
    key UserExitName,
    key FMName,
    FMType,
    Report,
    IncludeNo,
    MainReport,
    Namespace,
    Include,
    _DevObject.ABAPObject,
    _DevObject.ABAPPackage,
    /* Associations */
    _DevObject
}
