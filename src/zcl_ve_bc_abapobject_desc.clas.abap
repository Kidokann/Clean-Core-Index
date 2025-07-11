"! <p class="shorttext synchronized" lang="de">VirtualElement: get Description of ABAP Dev Object</p>
"! Virtual Element to fetch short text (description9 of an ABAP development object.
"! With this VE, the desription of objects like reports, FM, classes, methods etc, can be read
CLASS zcl_ve_bc_abapobject_desc DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.


CLASS zcl_ve_bc_abapobject_desc IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA origin_data TYPE STANDARD TABLE OF zc_cclm_reviewobject WITH DEFAULT KEY.

    origin_data = CORRESPONDING #( it_original_data ).

    LOOP AT origin_data ASSIGNING FIELD-SYMBOL(<data>).

      DATA(obj_tab) = VALUE typ_t_adwp_seu_objtxt( ( encl_obj = <data>-ObjectName
                                                     obj_name = <data>-SubObjectName
                                                     object   = <data>-SubObjectType ) ).
      CALL FUNCTION 'RS_SHORTTEXT_GET'
*      EXPORTING
*               language = SY-LANGU
*               clear_buffer = space
*               fallback_language_1 = 'E'
*               fallback_language_2 = 'D'
        TABLES obj_tab = obj_tab.

      LOOP AT obj_tab ASSIGNING FIELD-SYMBOL(<text>).
        <data>-Description = <text>-stext.
      ENDLOOP.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( origin_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<elements>).
      CASE <elements>.
        WHEN 'DESCRIPTION'.
          APPEND 'OBJECTTYPE' TO et_requested_orig_elements.
          APPEND 'OBJECTNAME' TO et_requested_orig_elements.
          APPEND 'SUBOBJECTTYPE' TO et_requested_orig_elements.
          APPEND 'SUBOBJECTNAME' TO et_requested_orig_elements.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
