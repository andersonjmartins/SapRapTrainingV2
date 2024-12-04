CLASS zcl_s4d400_ajm_apt_copy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_s4d400_ajm_apt_copy IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    INSERT INTO zs4d400_ajm_rap  VALUES @( VALUE #( client = '100' carrier_id =  '3' uuid = 1 connid = '519'
*                                                airport_from = 'test' city_from = 'Baku'
*                                                country_from = 'Azerbaijan' airport_to = 'test2'
*                                                city_to = 'Berlin' ) ).
*    INSERT INTO zs4d400_ajm_rap VALUES @( VALUE #( client = '100' carrid =  '4' uuid = 2 connid = '520'
*                                                airport_from = 'test' city_from = 'Baku'
*                                                country_from = 'Azerbaijan' airport_to = 'test2'
*                                                city_to = 'Berlin' ) ).
*    INSERT INTO zs4d400_ajm_rap VALUES @( VALUE #( client = '100' carrid =  '5' uuid = 3 connid = '521'
*                                                airport_from = 'test' city_from = 'Baku'
*                                                country_from = 'Azerbaijan' airport_to = 'test2'
*                                                city_to = 'Berlin' ) ).
*    out->write(  sy-dbcnt ).

*  key client      : abap.clnt not null;
*  key uuid        : sysuuid_x16 not null
*  carrier_id      : /dmo/carrier_id;
*  connection_id   : /dmo/connection_id;
*  airport_from_id : /dmo/airport_from_id;
*  city_from       : zajm_city_from;
*  country_from    : land1;
*  airport_to_id   : /dmo/airport_to_id;
*  city_to         : zajm_city_to;
*  country_to      : land1;
    SELECT @sy-mandt AS client,
           AirlineID AS carrier_id,
           ConnectionID AS connection_id,
           DepartureAirport AS airport_from_id,
           DestinationAirport AS airport_to_id,
           DepartureTime,
           ArrivalTime,
           Distance,
           DistanceUnit,
           \_DepartureAirport-city AS city_from,
           \_DepartureAirport-CountryCode AS country_from,
           \_DestinationAirport-city AS city_to,
           \_DestinationAirport-CountryCode AS country_to

    FROM /DMO/I_Connection
    INTO TABLE @DATA(lt_conn)
    UP TO 15 ROWS.

    DELETE from zs4d400_ajm_rap where carrier_id ne 1.

    DATA lt_ajm_conn TYPE STANDARD TABLE OF zs4d400_ajm_rap.
*    DATA ls_ajm_conn TYPE zs4d400_ajm_rap.
*    READ TABLE lt_conn INTO DATA(ls_conn) INDEX 1.
    LOOP AT lt_conn INTO DATA(ls_conn).
      APPEND INITIAL LINE TO lt_ajm_conn ASSIGNING FIELD-SYMBOL(<lfs_conn>).
      MOVE-CORRESPONDING ls_conn TO <lfs_conn>.
      TRY.
          <lfs_conn>-uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lcx_uuid_error).
      ENDTRY.
    ENDLOOP.

*    MODIFY zs4d400_ajm_rap FROM @ls_ajm_conn.
    MODIFY zs4d400_ajm_rap FROM TABLE @lt_ajm_conn.

    COMMIT WORK.
    IF sy-subrc IS INITIAL.
      out->write( 'Sucesso' ).
    ELSE.
      out->write( 'Erro' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
