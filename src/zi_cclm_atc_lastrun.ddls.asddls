@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last ATC job for CCLM'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_cclm_atc_lastrun as select from satc_ac_resulth
{
    
    key max( scheduled_on_ts ) as LastRunCompleteDate
}

  where is_complete = 'X'
    and is_central_run = 'X'
    and run_series_name = 'CCLM'
    and kind = 'C'
