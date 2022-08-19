class zcl_tf_demo_class definition
  public
  final
  create public .

  public section.
    TYPES ty_c type c length 1.
    class-methods create
      returning
        value(r_result) type ref to zcl_tf_demo_class.
    methods do_it
              IMPORTING
                input_value type ty_c OPTIONAL.
  protected section.
  private section.

endclass.



class zcl_tf_demo_class implementation.

  method create.
    create object r_result.
  endmethod.

  method do_it.
    data tmp_1 type i.
    data tmp_2 type i.
    data tmp_3 type i.
    data tmp_4 type i.
    data tmp_5 type i.
    data tmp_6 type i.
    data tmp_7 type i.
    data tmp_8 type i.
    data tmp_9 type i.

    case input_value.
      when 'A'.
      when 'B'.
      when 'C'.
      when 'D'.
      when 'E'.
      when 'F'.
      when 'G'.
      when 'H'.
      when 'I'.
      when 'J'.
      when 'K'.
    endcase.
  endmethod.
endclass.
