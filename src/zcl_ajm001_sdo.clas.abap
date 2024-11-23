CLASS zcl_ajm001_sdo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS ex1
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_ajm001_sdo IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "ex1( out ).

**********************************************************************
**********************************************************************


    TYPES: BEGIN OF st_connection,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.

    TYPES: BEGIN OF st_connection_nested,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             message         TYPE symsg,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection_nested.

    DATA connection TYPE st_connection.
    DATA connection_nested TYPE st_Connection_nested.

* Example 1: Access to structure components
**********************************************************************

    connection-airport_from_id = 'ABC'.
    connection-airport_to_id   = 'XYZ'.
    connection-carrier_name    = 'My Airline'.

    "Access to sub-components of nested structure
    connection_nested-message-msgty = 'E'.
    connection_nested-message-msgid = 'ABC'.
    connection_nested-message-msgno = '123'.

* Example 2: Filling a structure with VALUE #(    ).
**********************************************************************

    CLEAR connection.

    connection = VALUE #( airport_from_id = 'ABC'
                          airport_to_id   = 'XYZ'
                          carrier_name    = 'My Airline'
                        ).

    " Nested VALUE to fill nested structure
    connection_nested = VALUE #( airport_from_id = 'ABC'
                                 airport_to_id   = 'XYZ'
                                 message         = VALUE #( msgty = 'E'
                                                            msgid = 'ABC'
                                                            msgno = '123' )
                                 carrier_name    = 'My Airline'
                         ).

* Example 3: Wrong result after direct assignment
**********************************************************************

    connection_nested = connection.

    out->write(  `-------------------------------------------------------------` ).
    out->write(  `Example 3: Wrong Result after direct assignment` ).

    out->write( data = connection
                name = `Source Structure:`).

    out->write( |Component connection_nested-message-msgid: { connection_nested-message-msgid }| ).
    out->write( |Component connection_nested-carrier_name : { connection_nested-carrier_name  }| ).

* Example 4: Assigning Structures using CORRESPONDING #( )
**********************************************************************
    CLEAR connection_nested.
    connection_nested = CORRESPONDING #(  connection ).  "

    out->write(  `-------------------------------------------------------------` ).
    out->write(  `Example 4: Correct Result after assignment with CORRESPONDING` ).

    out->write( data = connection
                name = `Source Structure:`).

    out->write( |Component connection_nested-message-msgid: { connection_nested-message-msgid }| ).
    out->write( |Component connection_nested-carrier_name : { connection_nested-carrier_name  }| ).


  ENDMETHOD.

  METHOD ex1.


* Example 1 : Motivation for Structured Variables
**********************************************************************

    DATA connection_full TYPE /DMO/I_Connection.

    SELECT SINGLE
     FROM /dmo/I_Connection
   FIELDS AirlineID, ConnectionID, DepartureAirport, DestinationAirport,
          DepartureTime, ArrivalTime, Distance, DistanceUnit
    WHERE AirlineId    = 'LH'
      AND ConnectionId = '0400'
     INTO @connection_full.

    out->write(  `--------------------------------------` ).
    out->write(  `Example 1: CDS View as Structured Type` ).
    out->write( connection_full ).

* Example 2: Global Structured Type
**********************************************************************

    DATA message TYPE symsg.

    out->write(  `---------------------------------` ).
    out->write(  `Example 2: Global Structured Type` ).
    out->write( message ).

* Example 3 : Local Structured Type
**********************************************************************

    TYPES: BEGIN OF st_connection,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.

    DATA connection TYPE st_connection.

    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name
     WHERE AirlineID = 'LH'
       AND ConnectionID = '0400'
      INTO @connection.

    out->write(  `---------------------------------------` ).
    out->write(  `Example 3: Global Local Structured Type` ).
    out->write( connection ).

* Example 4 : Nested Structured Type
**********************************************************************

    TYPES: BEGIN OF st_nested,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             message         TYPE symsg,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_nested.

    DATA connection_nested TYPE st_nested.

    out->write(  `---------------------------------` ).
    out->write(  `Example 4: Nested Structured Type` ).
    out->write( connection_nested ).
  ENDMETHOD.

ENDCLASS.
