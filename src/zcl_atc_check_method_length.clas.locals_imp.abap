class meta_data definition final.
  public section.
    interfaces if_ci_atc_check_meta_data.
    data method_threshold type i.
    METHODS constructor
      IMPORTING
        i_method_threshold TYPE i.
endclass.

class meta_data implementation.

  method constructor.
    me->method_threshold = i_method_threshold.
  endmethod.

  method if_ci_atc_check_meta_data~get_attributes ##NEEDED.
   attributes = VALUE #(
      ( name = `MethodThreshold`
        kind = if_ci_atc_check_meta_data=>attribute_kinds-elementary
        value = ref #( method_threshold ) )
    ).
  endmethod.

  method if_ci_atc_check_meta_data~get_checked_object_types.
    types = value #( ( 'CLAS' ) ).
  endmethod.

  method if_ci_atc_check_meta_data~get_description.
    description = 'Check number of code lines of method'.
  endmethod.

  method if_ci_atc_check_meta_data~get_finding_code_infos.
    finding_code_infos = value #(
      ( code = zcl_atc_check_method_length=>finding_codes-code1
        severity = if_ci_atc_check=>finding_severities-error
        text = 'Number of code lines exceeds threshold' )
    ).
  endmethod.

  method if_ci_atc_check_meta_data~uses_checksums.
  endmethod.

  method if_ci_atc_check_meta_data~get_quickfix_code_infos.
  endmethod.

  method if_ci_atc_check_meta_data~is_remote_enabled.
    is_remote_enabled = abap_true.
  endmethod.
endclass.
