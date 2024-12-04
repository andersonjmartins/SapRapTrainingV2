*"* use this source file for your ABAP unit test classes

CLASS ltcl_ DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_success FOR TESTING RAISING cx_static_check.
    METHODS: test_exception FOR TESTING.
ENDCLASS.


CLASS ltcl_ IMPLEMENTATION.

  METHOD test_success.
*Preparation:
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  ENDMETHOD.

  METHOD test_exception.

  ENDMETHOD.

ENDCLASS.
