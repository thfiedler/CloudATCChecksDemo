CLASS meta_data DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_ci_atc_check_meta_data.
ENDCLASS.

CLASS meta_data IMPLEMENTATION.

  METHOD if_ci_atc_check_meta_data~get_checked_object_types.
    types = VALUE #( ( 'CLAS' ) ( 'FUGR' ) ( 'PROG' ) ).
  ENDMETHOD.

  METHOD if_ci_atc_check_meta_data~get_description.
    description = 'CodePal4Cloud'.
  ENDMETHOD.

  METHOD if_ci_atc_check_meta_data~get_finding_code_infos.
    finding_code_infos = VALUE #(
      ( code = zcl_create_object_not_allowed=>finding_codes-create_object severity =  if_ci_atc_check=>finding_severities-note text = 'Static CREATE OBJECT statement are obsolete. Use NEW instead.' )
    ).
  ENDMETHOD.

  METHOD if_ci_atc_check_meta_data~get_quickfix_code_infos.
    quickfix_code_infos = VALUE #(
      ( code = zcl_create_object_not_allowed=>quickfix_codes-create_to_new short_text = 'Replace static CREATE OBJECT by NEW')
    ).
  ENDMETHOD.

  METHOD if_ci_atc_check_meta_data~is_remote_enabled.
    is_remote_enabled = abap_true.
  ENDMETHOD.

  METHOD if_ci_atc_check_meta_data~uses_checksums.
    uses_checksums = abap_true.
  ENDMETHOD.

ENDCLASS.
