CLASS zcl_create_object_not_allowed DEFINITION
   public
  final
  create public .

  public section.
    interfaces if_ci_atc_check.

    constants:
      begin of finding_codes,
        create_object type if_ci_atc_check=>ty_finding_code value 'CREATE',
      end of finding_codes.
    constants:
      begin of quickfix_codes,
        create_to_new type cl_ci_atc_quickfixes=>ty_quickfix_code value 'CRE_TO_NEW',
      end of quickfix_codes.
  protected section.
  private section.
    methods analyze_procedure
      importing procedure       type if_ci_atc_source_code_provider=>ty_procedure
      returning value(findings) type if_ci_atc_check=>ty_findings.
    methods construct_new_from_create
      importing statement  type if_ci_atc_source_code_provider=>ty_statement
      returning value(new) type if_ci_atc_quickfix=>ty_code.
    methods break_into_lines
      importing code              type string
      returning value(code_lines) type if_ci_atc_quickfix=>ty_code.
    METHODS flatten_tokens
      IMPORTING tokens TYPE if_ci_atc_source_code_provider=>ty_tokens
      RETURNING VALUE(code) TYPE string.

    data assistant_factory type ref to cl_ci_atc_assistant_factory.
    data code type ref to if_ci_atc_source_code_provider.
ENDCLASS.



CLASS ZCL_CREATE_OBJECT_NOT_ALLOWED IMPLEMENTATION.


  method if_ci_atc_check~get_meta_data.
    meta_data = new meta_data( ).
  endmethod.


  method if_ci_atc_check~run.
    code = data_provider->get_code_provider( ).
    data(procedures) = code->get_procedures( code->object_to_comp_unit( object ) ).
    loop at procedures->* assigning field-symbol(<procedure>).
      insert lines of analyze_procedure( <procedure> ) into table findings.
    endloop.
  endmethod.


  method if_ci_atc_check~set_assistant_factory.
    assistant_factory = factory.
  endmethod.


  method if_ci_atc_check~verify_prerequisites.

  endmethod.


  method analyze_procedure.
    loop at procedure-statements assigning field-symbol(<statement>)
        where keyword = 'CREATE' ##PRIMKEY[KEYWORD].
      data(idx) = sy-tabix.
      assign <statement>-tokens[ 2 ] to field-symbol(<second_token>).
      if <second_token>-lexeme = 'OBJECT' and <second_token>-references is initial.
        "This line prevents emitting findings for dynamic CREATE OBJECT statements.
        if not ( value #( <statement>-tokens[ 4 ]-lexeme optional ) = 'TYPE' and <statement>-tokens[ 5 ]-lexeme(1) = '(' ).
          data(create_object_quickfixes) = assistant_factory->create_quickfixes( ).
          create_object_quickfixes->create_quickfix(
            quickfix_code = quickfix_codes-create_to_new )->replace(
            context = assistant_factory->create_quickfix_context( value #( procedure_id = procedure-id statements = value #( from = idx to = idx ) ) )
            code = construct_new_from_create( <statement> )
          ).
          insert value #(
            code = finding_codes-create_object
            location = code->get_statement_location( <statement> )
            checksum = code->get_statement_checksum( <statement> )
            details = assistant_factory->create_finding_details( )->attach_quickfixes( create_object_quickfixes )
          ) into table findings.
        endif.
      endif.
    endloop.
  endmethod.


  method construct_new_from_create.
    data(target) = statement-tokens[ 3 ]-lexeme.
    if lines( statement-tokens ) > 3.
      data(has_type_specified) = xsdbool( statement-tokens[ 4 ]-lexeme = 'TYPE' ).
      if has_type_specified = abap_true.
        data(specified_type) = statement-tokens[ 5 ]-lexeme.
      endif.
      data(argument_tokens) = value if_ci_atc_source_code_provider=>ty_tokens( for <tok> in statement-tokens from cond #(
        when has_type_specified = abap_true
          then 7
          else 5
      ) ( <tok> ) ).
      data(arguments) = flatten_tokens( argument_tokens ).
    endif.
    new = break_into_lines( |{ target } = NEW { cond #( when has_type_specified = abap_true then specified_type else '#' ) }( { arguments } ).| ).
  endmethod.


  method break_into_lines.
    constants allowed_line_length type i value 255.
    data(remaining_chunk) = strlen( code ).
    while remaining_chunk > 0.
      data(already_chopped_chars) = lines( code_lines ) * allowed_line_length.
      data(chars_to_chop) = cond #( when remaining_chunk > allowed_line_length then allowed_line_length else remaining_chunk ).
      insert code+already_chopped_chars(chars_to_chop) into table code_lines.
      remaining_chunk -= chars_to_chop.
    endwhile.
  endmethod.


  METHOD flatten_tokens.
    code = REDUCE #( INIT str = `` FOR tok IN tokens NEXT str = |{ str }{ tok-lexeme } | ).
  ENDMETHOD.
ENDCLASS.
