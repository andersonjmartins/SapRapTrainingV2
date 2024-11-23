CLASS lhc_connection DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Connection
        RESULT result,
      CheckSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckSemanticKey,
      CheckCerrierID FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckCerrierID,
      CheckOriginDestination FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckOriginDestination,
*      GetCities FOR DETERMINE ON SAVE
*        IMPORTING keys FOR Connection~GetCities,
      GetCities1 FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Connection~GetCities1.
ENDCLASS.

CLASS lhc_connection IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD CheckSemanticKey.

    "Define a validation CheckSemanticKey to check that a particular flight number has not already been used.

    "client data
    "Use the EML READ ENTITIES statement to read the data that the user entered. Ensure that the fields CarrierID,
    "   and ConnectionID are read. Use an inline declaration for the result set.
    READ ENTITIES OF z_r_ajm_conn IN LOCAL MODE
           ENTITY Connection
           FIELDS ( CarrierID ConnectionID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(connections).

*    SELECT FROM zaajm_conn
*           FIELDS uuid
*           FOR ALL ENTRIES IN @connections
*            WHERE carrier_id    = @connections-CarrierID
*              AND connection_id = @connections-ConnectionID
*              AND uuid          <> @connections-uuid
*       INTO TABLE @DATA(check_result).
*    "draft table
*    SELECT FROM zdajm_conn
*         FIELDS uuid
*         FOR ALL ENTRIES IN @connections
*          WHERE carrierid     = @connections-CarrierID
*            AND connectionid  = @connections-ConnectionID
*            AND uuid          <> @connections-uuid
*     APPENDING TABLE @check_result.

    "In a loop over the data that you just read, select the UUIDs of all other data sets with the same combination of airline ID and flight number
    LOOP AT connections INTO DATA(connection).
      "standard table
      SELECT FROM zaajm_conn
             FIELDS uuid
              WHERE carrier_id    = @connection-CarrierID
                AND connection_id = @connection-ConnectionID
                AND uuid          <> @connection-uuid
        UNION
        "draft table
        SELECT FROM zdajm_conn
             FIELDS uuid
              WHERE carrierid     = @connection-CarrierID
                AND connectionid  = @connection-ConnectionID
                AND uuid          <> @connection-uuid

         INTO TABLE @DATA(check_result).
      "INTO TABLE @check_result.

      "key already exists ?
      "If the internal table check_result contains any records create a new message with message classZS4D400,
      "message number 001 and severity ms-error. Pass connection-CarrierID to parameter v1 and connection-ConnectionID to parameter v2
      IF check_result IS NOT INITIAL.
        DATA(message) = me->new_message(
                          id       = 'ZS4D400'
                          number   = '001'
                          severity = ms-error
                          v1       = connection-CarrierID
                          v2       = connection-ConnectionID
                        ).

        "report message to return odata message to screen and to mark the field with error
        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky 				  = connection-%tky.
        reported_record-%msg    			  = message.
        reported_record-%element-CarrierID    = if_abap_behv=>mk-on.
        reported_record-%element-ConnectionID = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.
        	

        "failed record to avoid save incorrect data
        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-connection.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD CheckCerrierID.

    "Use the EML READ ENTITIES statement to read the data that the user entered. Ensure that the field CARRID is read.
    READ ENTITIES OF z_r_ajm_conn IN LOCAL MODE
           ENTITY Connection
           FIELDS ( CarrierID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(connections).

    "In a loop over the data that you just read, check that the airline exists. Use a SELECT statement that returns the
    "   literal abap_true if the airline exists. Use the CDS View /dmo/i_carrier as the data source of the statement.
    LOOP AT connections INTO DATA(connection).

      SELECT SINGLE
        FROM /DMO/I_Carrier
      FIELDS @abap_true
       WHERE airlineid = @connection-CarrierID
       INTO @DATA(exists).
      "If the value of exists is abap_false, create a message object with message ID ZS4D400, number 002, severity ms-error and parameter v1 connection-CarrierID.
      IF exists = abap_false.
        DATA(message) = me->new_message(
                            id       = 'ZS4D400'
                            number   = '002'
                            severity =  ms-error
                            v1       = connection-CarrierID
                          ) .

        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-carrierid = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_Record TO failed-connection.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD CheckOriginDestination.

    "Define a validation CheckOriginDestination to check that the departure and arrival airports of the flight connection are different.
    READ ENTITIES OF z_r_ajm_conn IN LOCAL MODE
           ENTITY Connection
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).
      IF connection-AirportFromID = connection-AirportToID.
        DATA(message) = me->new_message(
                          id       = 'ZS4D400'
                          number   = '003'
                          severity = ms-error
                       ).

        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky =  connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-AirportFromID = if_abap_behv=>mk-on.
        reported_record-%element-AirportToID   = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-connection.

        "CONTINUE.
      ENDIF.

      "IF connection-AirportFromID IS NOT INITIAL.
      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS @abap_true
       WHERE AirportID EQ @connection-AirportFromID
        INTO @DATA(exists).
      IF exists = abap_false.
        message = me->new_message(
                            id       = 'ZS4D400'
                            number   = '004'
                            severity =  ms-error
                            v1       = connection-AirportFromID
                          ) .

        CLEAR reported_record.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-AirportFromID = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        CLEAR failed_record.

        failed_record-%tky = connection-%tky.
        APPEND failed_Record TO failed-connection.

      ENDIF.
      "ENDIF.


      "IF connection-AirportToID IS NOT INITIAL.
      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS @abap_true
       WHERE AirportID = @connection-AirportToID
        INTO @exists.

      IF exists = abap_false.
        message = me->new_message(
                            id       = 'ZS4D400'
                            number   = '004'
                            severity =  ms-error
                            v1       = connection-AirportToID
                          ) .

        CLEAR reported_record.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-AirportToID = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        CLEAR failed_record.

        failed_record-%tky = connection-%tky.
        APPEND failed_Record TO failed-connection.

      ENDIF.
      "ENDIF.
    ENDLOOP.


  ENDMETHOD.

*  METHOD GetCities.
*
*RETURN.
*    "Determine the Cities and Countries
*
*    "Read the user input using an EML READ ENTITIES statement. Read the fields AirportFromID and AirportToID.
*    READ ENTITIES OF z_r_ajm_conn IN LOCAL MODE
*           ENTITY Connection
*           FIELDS ( AirportFromID AirportToID )
*             WITH CORRESPONDING #( keys )
*           RESULT DATA(connections).
*
*    LOOP AT connections INTO DATA(connection).
*
*      CLEAR: connection-CityFrom, connection-CountryFrom.
*      CLEAR: connection-CityTo, connection-CountryTo.
*
*      SELECT SINGLE
*        FROM /DMO/I_Airport
*      FIELDS city, CountryCode
*       WHERE AirportID = @connection-AirportFromID
*        INTO ( @connection-CityFrom, @connection-CountryFrom ).
*
*      SELECT SINGLE
*        FROM /DMO/I_Airport
*      FIELDS city, CountryCode
*       WHERE AirportID = @connection-AirportToID
*        INTO ( @connection-CityTo, @connection-CountryTo ).
*
*      MODIFY connections FROM connection.
*
*    ENDLOOP.
*
*    DATA connections_upd TYPE TABLE FOR UPDATE z_r_ajm_conn.
*
*    connections_upd = CORRESPONDING #( connections ).
*
*
*    MODIFY ENTITIES OF z_r_ajm_conn IN LOCAL MODE
*             ENTITY Connection
*             UPDATE
*             FIELDS ( CityFrom CountryFrom CityTo CountryTo )
*               WITH connections_upd
*           REPORTED DATA(reported_records).
*
*    reported-connection = CORRESPONDING #( reported_records-connection ).
*
*  ENDMETHOD.

**********************************************************************
  METHOD GetCities1.

    "Determine the Cities and Countries

    "Read the user input using an EML READ ENTITIES statement. Read the fields AirportFromID and AirportToID.
    READ ENTITIES OF z_r_ajm_conn IN LOCAL MODE
           ENTITY Connection
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).

      CLEAR: connection-CityFrom, connection-CountryFrom.
      CLEAR: connection-CityTo, connection-CountryTo.

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS city, CountryCode
       WHERE AirportID EQ @connection-AirportFromID
        INTO ( @connection-CityFrom, @connection-CountryFrom ).

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS city, CountryCode
       WHERE AirportID EQ @connection-AirportToID
        INTO ( @connection-CityTo, @connection-CountryTo ).

      MODIFY connections FROM connection.

    ENDLOOP.

    DATA connections_upd TYPE TABLE FOR UPDATE z_r_ajm_conn.

    connections_upd = CORRESPONDING #( connections ).


    MODIFY ENTITIES OF z_r_ajm_conn IN LOCAL MODE
             ENTITY Connection
             UPDATE
             FIELDS ( CityFrom CountryFrom CityTo CountryTo )
               WITH connections_upd
           REPORTED DATA(reported_records).

    reported-connection = CORRESPONDING #( reported_records-connection ).

  ENDMETHOD.

ENDCLASS.
