@AbapCatalog.sqlViewName: 'ZSQL_CARRIERVH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zajm_I_CarrierVH'
define view Zajm_I_CarrierVH
  as select from /dmo/carrier
{
      @UI.lineItem: [{position: 10 }]
  key carrier_id as CarrierId,
      @UI.lineItem: [{position: 20 }]
      name       as Name
}


