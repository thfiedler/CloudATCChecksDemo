CLASS zcl_atc_check_method_length DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ci_atc_check .
    CONSTANTS:
      BEGIN OF finding_codes,
        code1 TYPE if_ci_atc_check=>ty_finding_code VALUE 'CODE_1',
      END OF finding_codes.
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA method_threshold TYPE i.
ENDCLASS.



CLASS ZCL_ATC_CHECK_METHOD_LENGTH IMPLEMENTATION.


  METHOD constructor.
  ENDMETHOD.


  METHOD if_ci_atc_check~get_meta_data.
    meta_data = NEW meta_data( method_threshold ).
  ENDMETHOD.


  METHOD if_ci_atc_check~run.
    DATA finding TYPE if_ci_atc_check=>ty_finding.

    DATA(code_provider) = data_provider->get_code_provider( ).
    DATA(procedures) = code_provider->get_procedures( code_provider->object_to_comp_unit( object ) ).

    LOOP AT procedures->* ASSIGNING FIELD-SYMBOL(<procedure>).
      IF <procedure>-id-kind =  if_ci_atc_source_code_provider=>procedure_kinds-method.
        DATA(no_lines) = lines( <procedure>-statements ).

        IF no_lines > me->method_threshold.
          DATA(location) = code_provider->get_statement_location( <procedure>-statements[ 1 ] ).

          finding-code = me->finding_codes-code1.
          finding-location-object = location-object.
          finding-location-position = location-position.
          APPEND finding TO findings.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_ci_atc_check~set_assistant_factory.
  ENDMETHOD.


  METHOD if_ci_atc_check~set_attributes ##NEEDED.
    DATA(method_threshold) = attributes[ name = `MethodThreshold` ]-value.
    me->method_threshold = method_threshold->*.
  ENDMETHOD.


  METHOD if_ci_atc_check~verify_prerequisites ##NEEDED.
  ENDMETHOD.
ENDCLASS.
