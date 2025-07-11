"! Behavior handler for CCLM Clean Core Index
CLASS lhc_zi_cclm_cleancoreindex DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    "! check global authorization of user
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CleanCoreIndexHistory RESULT result.

    "! early numbering handler to ensure proper keys
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE cleancoreindexhistory.

ENDCLASS.


CLASS lhc_zi_cclm_cleancoreindex IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(entities_wo_id) = entities.

    SORT entities_wo_id BY indexdate
                           cclmtype
                           objname
                           subname.

    LOOP AT entities_wo_id ASSIGNING FIELD-SYMBOL(<new_entity>).
      " first check the largest ID used so far for given entry

      SELECT MAX( id ) FROM @mapped-cleancoreindexhistory AS existing
        WHERE indexdate = @<new_entity>-indexdate
          AND cclmtype  = @<new_entity>-Cclmtype
          AND ObjName   = @<new_entity>-ObjName
          AND SubName   = @<new_entity>-SubName
        INTO @DATA(max_id).

        <new_entity>-Id = max_id + 1.

      APPEND VALUE #( %cid = <new_entity>-%cid
                      %key = <new_entity>-%key )
             TO mapped-cleancoreindexhistory.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
