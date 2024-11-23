CLASS zcl_ajm001_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ajm001_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA update_tab TYPE TABLE FOR UPDATE /DMO/R_AgencyTP.
    DATA input_keys TYPE TABLE FOR READ IMPORT /DMO/R_AgencyTP.
    DATA result_tab TYPE TABLE FOR READ RESULT /DMO/R_AgencyTP.

    update_tab = VALUE #( ( AgencyID = '070002' Name = 'Modified Name Agency' ) ).
    input_keys = VALUE #( ( AgencyID = '070002' ) ).

    READ ENTITIES OF /DMO/R_AgencyTP
    ENTITY /DMO/Agency
    ALL FIELDS
    WITH input_keys
    RESULT DATA(result).
*    RESULT result_tab.
    result_tab = result.

    MODIFY ENTITIES OF /DMO/R_AgencyTP
    ENTITY /DMO/Agency
    UPDATE FIELDS ( name )
    WITH update_tab.

    COMMIT ENTITIES.

  ENDMETHOD.
ENDCLASS.
