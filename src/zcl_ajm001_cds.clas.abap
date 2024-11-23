CLASS zcl_ajm001_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ajm001_cds IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    DATA connection TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

* First Instance
**********************************************************************

    TRY.
        connection = NEW #(
                            i_carrier_id    = 'LH'
                            i_connection_id = '0400'
                          ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed constructor1` ).
    ENDTRY.

* Second instance
**********************************************************************

    TRY.
        connection = NEW #(
                            i_carrier_id    = 'AA'
                            i_connection_id = '0017'
                          ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed constructor2` ).
    ENDTRY.

* Third instance
**********************************************************************

    TRY.
        connection = NEW #(
                            i_carrier_id    = 'SQ'
                            i_connection_id = '0001'
                          ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed constructor3` ).
    ENDTRY.

* Output
**********************************************************************

    LOOP AT connections INTO connection.

      out->write( connection->get_output( ) ).

    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
