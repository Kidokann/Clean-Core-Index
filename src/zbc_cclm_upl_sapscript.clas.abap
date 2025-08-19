"! <p class="shorttext synchronized" lang="de">Class to extract usage of SAPScript forms</p>
"! This class is part of clean core strategy. It helps to collect all actively used
"! SAPScript forms. With this class, the results can be stored in table <your own table>
CLASS zbc_cclm_upl_sapscript DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      "! data type for usage statistic
      BEGIN OF
        ty_usage,

        sapscriptform TYPE swncentryid,
        report        TYPE progname,
        lastcreatedat TYPE date,
        lastcreatedby TYPE syuname,
        totalusage    TYPE int4,
      END OF ty_usage.

    "! Table type for usage statistics aggregated by user, date and SAPScript form
    TYPES tyt_usage TYPE STANDARD TABLE OF ty_usage WITH KEY sapscriptform.

    "! <p class="shorttext synchronized" lang="de">get SAPscript usage by date</p>
    "! This method reads all existing TemSe objects to collect all used SAPScript
    "! forms during the diven time period.
    "! This method can't be used to query historical data stored in <your own table>. Instead
    "! it can be used to read actual data
    "! @parameter usage_from | <p class="shorttext synchronized" lang="de">spool created from date</p>
    "! @parameter usage_to   | <p class="shorttext synchronized" lang="de">spool created to date</p>
    "! @parameter usage      | <p class="shorttext synchronized" lang="de">table containing aggregated data</p>
    METHODS get_actual_usage_by_date IMPORTING usage_from   TYPE sydate
                                               usage_to     TYPE sydate
                                     RETURNING VALUE(usage) TYPE tyt_usage.

    "! <p class="shorttext synchronized" lang="de">Persist usage statistics to database</p>
    "! This method can be used to store usage statistics to database. It stores actual usage statistics to
    "! table <your own table>. If record already exists, it gets aggregated (update), otehrwise it creates new records
    "! @parameter usage_list | <p class="shorttext synchronized" lang="de">List with actual usage data to store</p>
    METHODS write_usage_to_db IMPORTING usage_list TYPE tyt_usage.

  PRIVATE SECTION.
    TYPES:
      "! data type for single spool entry, no aggregated data
      BEGIN OF ty_non_aggregated_usage,
        spool         TYPE zi_cclm_upl_sapscript,
        sapscriptform TYPE tdname,
      END OF ty_non_aggregated_usage.

    "! Table type for spool entries, no aggregation
    TYPES tyt_non_aggreageted_usage TYPE STANDARD TABLE OF ty_non_aggregated_usage.

    "! <p class="shorttext synchronized" lang="de">Get SAPScript form name by content</p>
    "! This method can be used to determine SAPScript form name based on spool content
    "! (content of TemSe object)
    "! @parameter content   | <p class="shorttext synchronized" lang="de">content of TemSe object</p>
    "! @parameter form_name | <p class="shorttext synchronized" lang="de">Name of SAPScript form</p>
    METHODS get_sapscript_name IMPORTING content          TYPE string
                               RETURNING VALUE(form_name) TYPE tdform.

    "! <p class="shorttext synchronized" lang="de">Aggregate usage statistic</p>
    "! This method aggregates (sum) actual usage data to one row for each date, user and SAPScript
    "! @parameter spool | <p class="shorttext synchronized" lang="de">list of non aggregated usage data</p>
    "! @parameter usage | <p class="shorttext synchronized" lang="de">aggregated usage data</p>
    METHODS aggregate_usage IMPORTING !spool       TYPE tyt_non_aggreageted_usage
                            RETURNING VALUE(usage) TYPE tyt_usage.

ENDCLASS.


CLASS zbc_cclm_upl_sapscript IMPLEMENTATION.
  METHOD get_actual_usage_by_date.
    DATA spool TYPE tyt_non_aggreageted_usage.

    SELECT * FROM zi_cclm_upl_sapscript
      WHERE createdat BETWEEN @usage_from AND @usage_to
      INTO TABLE @DATA(sapscript_list).

    LOOP AT sapscript_list ASSIGNING FIELD-SYMBOL(<single_form>).

      IF <single_form>-datalength <= 0.
        CONTINUE.
      ENDIF.

      DATA(encoded_content) = ||.

      " prepare conversion RAW to STRING
      DATA(encoded_object) = cl_abap_conv_in_ce=>create( encoding = '4103'
                                                         input    = <single_form>-content ).

      " convert RAW to string
      encoded_object->read( IMPORTING data = encoded_content ).

      DATA(formname) = get_sapscript_name( substring( val = encoded_content
                                                      len = 1000 ) ).

      spool = VALUE #( BASE spool
                       ( spool         = <single_form>
                         sapscriptform = formname )  ).

      CLEAR formname.
    ENDLOOP.

    usage = aggregate_usage( spool  ).
  ENDMETHOD.

  METHOD get_sapscript_name.
    " SAPScript
    FIND 'IN01' IN content MATCH OFFSET DATA(pos).
    IF pos > 0.
    ELSE.
      " SmartForm
      FIND 'IN04' IN content MATCH OFFSET pos.
    ENDIF.

    IF pos > 0.
      pos += 5.
      form_name = substring( val = content
                             off = pos
                             len = 16 ).
    ENDIF.
  ENDMETHOD.

  METHOD aggregate_usage.
    LOOP AT spool ASSIGNING FIELD-SYMBOL(<spool>).

      " try to get last usage of a given form, user and date
      ASSIGN usage[ sapscriptform = <spool>-sapscriptform
                    lastcreatedby = <spool>-spool-createdby
                    lastcreatedat = <spool>-spool-createdat ] TO FIELD-SYMBOL(<usage>).

      " record already found, aggregate
      IF sy-subrc = 0 AND <usage> IS ASSIGNED.
        <usage>-totalusage += 1.
        <usage>-report      = <spool>-spool-report.
      ELSE.
        " new record, add to list
        usage = VALUE #( BASE usage
                         ( sapscriptform = <spool>-sapscriptform
                           report        = <spool>-spool-report
                           lastcreatedat = <spool>-spool-createdat
                           lastcreatedby = <spool>-spool-createdby
                           totalusage    = 1 ) ).
      ENDIF.

      UNASSIGN <usage>.
    ENDLOOP.
  ENDMETHOD.

  METHOD write_usage_to_db.
  " < to persist the data, add your own logic here >
  ENDMETHOD.
ENDCLASS.
