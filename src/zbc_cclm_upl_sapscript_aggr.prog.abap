*&---------------------------------------------------------------------*
*& Report zbc_cclm_upl_sapscript_aggr
*&         Collect and aggregate UPL for SAPScript forms               *
*& RUN AS BACKGROUND JOB
*&---------------------------------------------------------------------*

REPORT zbc_cclm_upl_sapscript_aggr.

PARAMETERS:
  pm_from TYPE dats,
  pm_to   TYPE dats.

START-OF-SELECTION.
  DATA(upl) = NEW zbc_cclm_upl_sapscript( ).

  DATA(usage) = upl->get_actual_usage_by_date( usage_from = pm_from
                                               usage_to   = pm_to ).
  upl->write_usage_to_db( usage_list = usage ).

  LOOP AT usage ASSIGNING FIELD-SYMBOL(<usage>).

    WRITE: / <usage>-lastcreatedat,
    <usage>-lastcreatedby,
    <usage>-sapscriptform,
    <usage>-report,
    <usage>-totalusage.
  ENDLOOP.
