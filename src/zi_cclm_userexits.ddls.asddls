@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View of all active user exits'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_cclm_userexits as select from modattr as projects
inner join modact as active on active.name = projects.name
inner join modsap as FunctionModules on FunctionModules.name = active.member
inner join tfdir as Report on FunctionModules.member = Report.funcname

association[0..*] to I_ABAPObjectDirectoryEntry as _DevObject on $projection.include = _DevObject.ABAPObject and _DevObject.ABAPObjectType = 'PROG'

{

key projects.name as Project,
key active.member as UserExitName,
key FunctionModules.member as FMName,
FunctionModules.typ as FMType,
Report.pname as Report,
Report.include as IncludeNo,
Report.pname_main as MainReport,

substring(Report.pname, 5, length(Report.pname) ) as Namespace,
concat('Z', concat ( substring(Report.pname, 5, length(Report.pname) ), concat('U', Report.include ) )) as Include,

_DevObject




}
where projects.status = 'A' and
 active.member <> ''

