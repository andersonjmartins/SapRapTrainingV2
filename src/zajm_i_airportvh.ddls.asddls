@AbapCatalog.sqlViewName: 'ZSQL_AIRPORTVH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zajm_I_AirportVH'
define view Zajm_I_AirportVH
  as select from /DMO/I_Airport
{
      @UI.lineItem: [{position: 10 }]
  key AirportID as AirportID,
      @UI.lineItem: [{position: 20 }]
      Name      as Name
}
