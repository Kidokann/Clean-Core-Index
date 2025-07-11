"! <p class="shorttext synchronized" lang="de">Class to build clean core index history</p>
CLASS zbc_cclm_cleancore_index DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="de"></p>
    "!
    METHODS create_history.

  PRIVATE SECTION.
    "! <p class="shorttext synchronized" lang="de"></p>
    "!
    "! @parameter deleteDate | <p class="shorttext synchronized" lang="de"></p>
    METHODS delete_history IMPORTING deleteDate TYPE datum.
ENDCLASS.


CLASS zbc_cclm_cleancore_index IMPLEMENTATION.
  METHOD create_history.
    " first wipe old data of same day, if available
    delete_history( sy-datum ).

    SELECT @sy-datum                                                                               AS indexdate,
           'MOD'                                                                                   AS CCLMType,
           SubObjectName                                                                           AS Object,
           ObjectName                                                                              AS ABAPObject,

           ABAPPackage,
           modifications~\_DevObject\_ABAPPackage\_ABAPApplicationComponent-ABAPApplCompExternalID
      FROM zc_cclm_modifications AS modifications

    UNION ALL
    SELECT @sy-datum                                                                                         AS indexdate,
           'FM '                                                                                             AS CCLMType,
           ABAPFunctionModule                                                                                AS Object,
           ABAPObject,

           ABAPPackage,
           functionmodules~\_Report\_DevObject\_ABAPPackage\_ABAPApplicationComponent-ABAPApplCompExternalID
      FROM zc_cclm_functionmodules AS functionmodules

    UNION ALL
    SELECT @sy-datum                                                                           AS indexdate,
           'UE '                                                                               AS CCLMType,
           UserExitName                                                                        AS Object,
           ABAPObject,

           ABAPPackage,
           userexits~\_DevObject\_ABAPPackage\_ABAPApplicationComponent-ABAPApplCompExternalID
      FROM zc_cclm_userexits AS userexits
      WHERE ABAPObject <> ''

    UNION ALL
    SELECT @sy-datum                                                                         AS indexdate,
           'REP'                                                                             AS CCLMType,
           ABAPObjectName                                                                    AS Object,
           ABAPObject,

           reports~\_DevObject-ABAPPackage,
           reports~\_DevObject\_ABAPPackage\_ABAPApplicationComponent-ABAPApplCompExternalID
      FROM ZI_cclm_CustomReports AS reports
    UNION ALL
    SELECT @sy-datum                        AS indexdate,
           'FM1'                            AS CCLMType,
           CAST( SAPScriptForm AS CHAR )    AS Object,
           ' '                              AS ABAPObject,

           'NONE                          ' AS ABAPPackage,
           ' '                              AS ABAPApplCompExternalID
      FROM zi_cclm_sapscript
    UNION ALL
    SELECT @sy-datum                                                                     AS indexdate,
           'ATC'                                                                         AS CCLMType,
           ObjectType                                                                    AS Object,
           ABAPObject,
           CAST( ABAPPackage AS CHAR( 30 ) )                                             AS ABAPPackage,
           atc~\_DevObject\_ABAPPackage\_ABAPApplicationComponent-ABAPApplCompExternalID
      FROM zc_cclm_atc AS atc
      WHERE
  ( ABAPPackage LIKE 'Z%'
    OR ABAPPackage LIKE 'Y%' )
 
  AND  priority    =    1

    UNION ALL
    SELECT @sy-datum                                                             AS indexdate,
           'FM2'                                                                 AS CCLMType,
           SmartForm                                                             AS Object,
           ' '                                                                   AS ABAPObject,
           ABAPPackage,
           smartforms~\_Package\_ABAPApplicationComponent-ABAPApplCompExternalID
      FROM zi_cclm_smartforms AS smartforms

    INTO TABLE @DATA(cleancoreindex).

    MODIFY ENTITIES OF zi_cclm_cleancoreindex
           ENTITY CleanCoreIndexHistory
           CREATE AUTO FILL CID WITH VALUE #(
               FOR index IN cleancoreindex
               ( Applicationcomponent = index-ABAPApplCompExternalID
                 ABAPPackage          = index-ABAPPackage
                 Cclmtype             = index-cclmtype
                 Indexdate            = index-indexdate
                 ObjName              = index-abapobject
                 SubName              = index-object
                 %control             = VALUE #(                " Must be filled when using FROM
                                                 Applicationcomponent = if_abap_behv=>mk-on
                                                 Abappackage          = if_abap_behv=>mk-on
                                                 Cclmtype             = if_abap_behv=>mk-on
                                                 Indexdate            = if_abap_behv=>mk-on
                                                 ObjName              = if_abap_behv=>mk-on
                                                 SubName              = if_abap_behv=>mk-on ) ) )
                                   " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED DATA(mapped_data)
           FAILED DATA(failed_records)
           REPORTED DATA(reported_records).

    IF failed_records IS INITIAL AND reported_records IS INITIAL.
      COMMIT ENTITIES RESPONSES
         " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED DATA(failed_commit)
   " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED DATA(reported_commit).
      IF sy-subrc <> 0.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD delete_history.
    DELETE FROM zbc_cclmidx
    WHERE indexdate = @deletedate.

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
