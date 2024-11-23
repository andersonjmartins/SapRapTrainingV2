CLASS zcl_ajm001_tables DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ajm001_tables IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*
*    TYPES: BEGIN OF st_connection,
*             carrier_id      TYPE /dmo/carrier_id,
*             connection_id   TYPE /dmo/connection_id,
*             airport_from_id TYPE /dmo/airport_from_id,
*             airport_to_id   TYPE /dmo/airport_to_id,
*             carrier_name    TYPE /dmo/carrier_name,
*           END OF st_connection.
*
*
** Example 1 : Simple and Complex Internal Table
***********************************************************************
*
*    " simple table (scalar row type)
*    DATA numbers TYPE TABLE OF i.
*    " complex table (structured row type)
*    DATA connections TYPE TABLE OF st_connection.
*
*    out->write(  `--------------------------------------------` ).
*    out->write(  `Example 1: Simple and Complex Internal Table` ).
*    out->write( data = numbers
*                name = `Simple Table NUMBERS:`).
*    out->write( data = connections
*                name = `Complex Table CONNECTIONS:`).
*
** Example 2 : Complex Internal Tables
***********************************************************************
*
*    " standard table with non-unique standard key (short form)
*    DATA connections_1 TYPE TABLE OF st_connection.
*
*    " standard table with non-unique standard key (explicit form)
*    DATA connections_2 TYPE STANDARD TABLE OF st_connection
*                            WITH NON-UNIQUE DEFAULT KEY.
*
*    " sorted table with non-unique explicit key
*    DATA connections_3  TYPE SORTED TABLE OF st_connection
*                             WITH NON-UNIQUE KEY airport_from_id
*                                                 airport_to_id.
*
*    " sorted hashed with unique explicit key
*    DATA connections_4  TYPE HASHED TABLE OF st_connection
*                             WITH UNIQUE KEY carrier_id
*                                             connection_id.
*
** Example 3 : Local Table Type
***********************************************************************
*
*    TYPES tt_connections TYPE SORTED TABLE OF st_connection
*                              WITH UNIQUE KEY carrier_id
*                                              connection_id.
*
*    DATA connections_5 TYPE tt_connections.
*
** Example 4 : Global Table Type
***********************************************************************
*
*    DATA flights  TYPE /dmo/t_flight.
*
*    out->write(  `------------------------------------------` ).
*    out->write(  `Example 4: Global Table TYpe /DMO/T_FLIGHT` ).
*    out->write(  data = flights
*                 name = `Internal Table FLIGHTS:` ).
*
*
*
**    TYPES: BEGIN OF st_connection,
**             carrier_id      TYPE /dmo/carrier_id,
**             connection_id   TYPE /dmo/connection_id,
**             airport_from_id TYPE /dmo/airport_from_id,
**             airport_to_id   TYPE /dmo/airport_to_id,
**             carrier_name    TYPE /dmo/carrier_name,
**           END OF st_connection.
*
**    TYPES tt_connections TYPE STANDARD TABLE OF   st_connection
**                              WITH NON-UNIQUE KEY carrier_id
**                                                  connection_id.
*
**    DATA connections TYPE tt_connections.
*
*    TYPES: BEGIN OF st_carrier,
*             carrier_id    TYPE /dmo/carrier_id,
*             carrier_name  TYPE /dmo/carrier_name,
*             currency_code TYPE /dmo/currency_code,
*           END OF st_carrier.
*
*    TYPES tt_carriers TYPE STANDARD TABLE OF st_carrier
*                          WITH NON-UNIQUE KEY carrier_id.
*
*    DATA carriers TYPE tt_carriers.
*
** Example 1: APPEND with structured data object (work area)
***********************************************************************
*
**    DATA connection  TYPE st_connection.
*    " Declare the work area with LIKE LINE OF
*    DATA connection LIKE LINE OF connections.
*
*
**    connection-carrier_id       = 'NN'.
**    connection-connection_id    = '1234'.
**    connection-airport_from_id  = 'ABC'.
**    connection-airport_to_id    = 'XYZ'.
**    connection-carrier_name     = 'My Airline'.
*
*    " Use VALUE #( ) instead assignment to individual components
*    connection = VALUE #( carrier_id       = 'NN'
*                          connection_id    = '1234'
*                          airport_from_id  = 'ABC'
*                          airport_to_id    = 'XYZ'
*                          carrier_name     = 'My Airline' ).
*
*    APPEND connection TO connections.
*
*    out->write(  `--------------------------------` ).
*    out->write(  `Example 1: APPEND with Work Area` ).
*    out->write(  connections ).
*
** Example 2: APPEND with VALUE #( ) expression
***********************************************************************
*
*    APPEND VALUE #( carrier_id       = 'NN'
*                    connection_id    = '1234'
*                    airport_from_id  = 'ABC'
*                    airport_to_id    = 'XYZ'
*                    carrier_name     = 'My Airline'
*                  )
*       TO connections.
*
*    out->write(  `----------------------------` ).
*    out->write(  `Example 2: Append with VALUE` ).
*    out->write(  connections ).
*
** Example 3: Filling an Internal Table with Several Rows
***********************************************************************
*
*    carriers = VALUE #(  (  carrier_id = 'AA' carrier_name = 'American Airlines' )
*                         (  carrier_id = 'JL' carrier_name = 'Japan Airlines'    )
*                         (  carrier_id = 'SQ' carrier_name = 'Singapore Airlines')
*                      ).
*
*    out->write(  `-----------------------------------------` ).
*    out->write(  `Example 3: Fill Internal Table with VALUE` ).
*    out->write(  carriers ).
*
** Example 4: Filling one Internal Table from Another
***********************************************************************
*
*    connections = CORRESPONDING #( carriers ).
*
*    out->write(  `--------------------------------------------` ).
*    out->write(  `Example 4: CORRESPONDING for Internal Tables` ).
*    out->write(  data = carriers
*                 name = `Source Table CARRIERS:`).
*    out->write(  data = connections
*                 name = `Target Table CONNECTIONS:`).


*  TYPES: BEGIN OF st_connection,
*             carrier_id      TYPE /dmo/carrier_id,
*             connection_id   TYPE /dmo/connection_id,
*             airport_from_id TYPE /dmo/airport_from_id,
*             airport_to_id   TYPE /dmo/airport_to_id,
*             carrier_name    TYPE /dmo/carrier_name,
*           END OF st_connection.
*
*    TYPES tt_connections TYPE SORTED TABLE OF   st_connection
*                              WITH NON-UNIQUE KEY carrier_id
*                                                  connection_id.
*
*    DATA connections TYPE tt_connections.
*    DATA connection  LIKE LINE OF connections.
*
*    TYPES: BEGIN OF st_carrier,
*             carrier_id    TYPE /dmo/carrier_id,
*             currency_code TYPE /dmo/currency_code,
*           END OF st_carrier.
*
*    DATA carriers TYPE STANDARD TABLE OF st_carrier
*                       WITH NON-UNIQUE KEY carrier_id.
*
*    DATA carrier LIKE LINE OF carriers.
*
** Preparation: Fill internal tables with data
***********************************************************************
*    connections = VALUE #(  ( carrier_id      = 'JL'
*                              connection_id   = '0408'
*                              airport_from_id = 'FRA'
*                              airport_to_id   = 'NRT'
*                              carrier_name    = 'Japan Airlines'
*                            )
*                            ( carrier_id      = 'AA'
*                              connection_id   = '0017'
*                              airport_from_id = 'MIA'
*                              airport_to_id   = 'HAV'
*                              carrier_name    = 'American Airlines'
*                            )
*                            ( carrier_id      = 'SQ'
*                              connection_id   = '0001'
*                              airport_from_id = 'SFO'
*                              airport_to_id   = 'SIN'
*                              carrier_name    = 'Singapore Airlines'
*                            )
*                            ( carrier_id      = 'UA'
*                              connection_id   = '0078'
*                              airport_from_id = 'SFO'
*                              airport_to_id   = 'SIN'
*                              carrier_name    = 'United Airlines'
*                            )
*                           ).
*
*    carriers = VALUE #(  (  carrier_id    = 'SQ'
*                            currency_code = ' '
*                         )
*                         (  carrier_id    = 'JL'
*                            currency_code = ' '
*                         )
*                         (  carrier_id    = 'AA'
*                            currency_code = ' '
*                         )
*                         (  carrier_id    = 'UA'
*                            currency_code = ' '
*                         )
*                      ).
*
** Example 1: Table Expression with Key Access
***********************************************************************
*    out->write(  `--------------------------------------------` ).
*    out->write(  `Example 1: Table Expressions with Key Access` ).
*
*    out->write(  data = connections
*                 name = `Internal Table CONNECTIONS: ` ).
*
*    " with key fields
*    connection = connections[ carrier_id    = 'SQ'
*                              connection_id = '0001' ].
*
*    out->write(  data = connection
*                 name = `CARRIER_ID = 'SQ' AND CONNECTION_ID = '001':` ).
*
*    " with non-key fields
*    connection = connections[ airport_from_id = 'SFO'
*                              airport_to_id   = 'SIN' ].
*    out->write(  data = connection
*                 name = `AIRPORT_FROM_ID = 'SFO' AND AIRPORT_TO_ID = 'SIN':` ).
*
** Example 2: LOOP with key access
***********************************************************************
*
*    out->write(  `-------------------------------` ).
*    out->write(  `Example 2: LOOP with Key Access` ).
*
*    LOOP AT connections INTO connection
*                       WHERE airport_from_id <> 'MIA'.
*
*      "do something with the content of connection
*      out->write( data = connection
*                  name = |This is row number { sy-tabix }: | ).
*
*    ENDLOOP.
*
** Example 3: MODIFY TABLE (key access)
***********************************************************************
*    out->write(  `-----------------------------------` ).
*    out->write(  `Example 3: MODIFY TABLE (key access` ).
*
*    out->write(  data = carriers
*                 name = `Table CARRRIERS before MODIFY TABLE:`).
*
*    carrier = carriers[  carrier_id = 'JL' ].
*    carrier-currency_code = 'JPY'.
*    MODIFY TABLE carriers FROM carrier.
*
*    out->write(  data = carriers
*                 name = `Table CARRRIERS after MODIFY TABLE:`).
*
** Example 4: MODIFY (index access)
***********************************************************************
*    out->write(  `--------------------------------` ).
*    out->write(  `Example 4: MODIFY (index access)` ).
*
*    carrier-carrier_id    = 'LH'.
*    carrier-currency_code = 'EUR'.
*    MODIFY carriers FROM carrier INDEX 1.
*
*    out->write(  data = carriers
*                 name = `Table CARRRIERS after MODIFY:`).
*
** Example 5: MODIFY in a LOOP
***********************************************************************
*    out->write(  `----------------------------` ).
*    out->write(  `Example 5: MODIFY  in a LOOP` ).
*
*    LOOP AT carriers INTO carrier
*                    WHERE currency_code IS INITIAL.
*
*      carrier-currency_code = 'USD'.
*      MODIFY carriers FROM carrier.
*
*    ENDLOOP.
*
*    out->write(  data = carriers
*                 name = `Table CARRRIERS after the LOOP:`).


**********************************************************************
**********************************************************************


TYPES: BEGIN OF st_airport,
             airportid TYPE /dmo/airport_id,
             name      TYPE /dmo/airport_name,
           END OF st_airport.

    TYPES tt_airports TYPE STANDARD TABLE OF st_airport
                          WITH NON-UNIQUE KEY airportid.

    DATA airports TYPE tt_airports.


* Example 1: Structured Variables in SELECT SINGLE ... INTO ...
**********************************************************************

    DATA airport_full TYPE /DMO/I_Airport.

    SELECT SINGLE
      FROM /DMO/I_Airport
    FIELDS AirportID, Name, City, CountryCode
     WHERE City = 'Zurich'
      INTO @airport_full.

    out->write(  `-------------------------------------` ).
    out->write(  `Example 1: SELECT SINGLE ... INTO ...` ).
    out->write(  data = airport_full
                 name = `One of the airports in Zurich (Structure):` ).

* Example 2: Internal Tables in SELECT ... INTO TABLE ...
**********************************************************************

    DATA airports_full TYPE STANDARD TABLE OF /DMO/I_Airport
                            WITH NON-UNIQUE KEY AirportID.

    SELECT
      FROM /DMO/I_Airport
    FIELDS airportid, Name, City, CountryCode
     WHERE City = 'London'
      INTO TABLE @airports_full.

    out->write(  `------------------------------------` ).
    out->write(  `Example 2: SELECT ... INTO TABLE ...` ).
    out->write(  data = airports_full
                 name = `All airports in London (Internal Table):` ).

* Example 3: FIELDS * and INTO CORRESPONDING FIELDS OF TABLE
**********************************************************************

    SELECT
      FROM /DMO/I_Airport
    FIELDS *
     WHERE City = 'London'
      INTO CORRESPONDING FIELDS OF TABLE @airports.

    out->write(  `----------------------------------------------------------` ).
    out->write(  `Example 3: FIELDS * and INTO CORRESPONDING FIELDS OF TABLE` ).
    out->write(  data = airports
                 name = `Internal Table AIRPORTS:` ).

* Example 4: Inline Declaration
**********************************************************************

    SELECT
      FROM /DMO/I_airport
    FIELDS AirportID, Name AS AirportName
     WHERE City = 'London'
     INTO TABLE @DATA(airports_inline).

    out->write(  `----------------------------------------------------------` ).
    out->write(  `Example 4: Inline Declaration after INTO TABLE` ).
    out->write(  data = airports_inline
                 name = `Internal Table AIRPORTS_INLINE:` ).

** Example 4: ORDER BY and DISTINCT
***********************************************************************
*
*    SELECT
*      FROM /DMO/I_Airport
*    FIELDS DISTINCT CountryCode
*     ORDER BY CountryCode
*     INTO TABLE @DATA(countryCodes).
*
*    out->write(  countryCodes ).

* Example 5: UNION (ALL)
**********************************************************************

    SELECT FROM /DMO/I_Carrier
           FIELDS 'Airline' AS type, AirlineID AS Id, Name
           WHERE CurrencyCode = 'GBP'

    UNION ALL

    SELECT FROM /DMO/I_Airport
           FIELDS 'Airport' AS type, AirportID AS Id,  Name
           WHERE City = 'London'
*    ORDER BY type, Id
    INTO TABLE @DATA(names).

    out->write(  `----------------------------------------------` ).
    out->write(  `Example 5: UNION ALL of Airlines and Airports ` ).
    out->write(  data = names
                 name = `ID and Name of Airlines and Airports:` ).


  ENDMETHOD.
ENDCLASS.
