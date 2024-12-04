@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_S4D400_AJM_RAP
  provider contract transactional_query
  as projection on ZR_S4D400_AJM_RAP
{
  key Uuid,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_CarrierVH', element: 'CarrierId' } }]
  CarrierId,
  ConnectionId,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_AirportVH', element: 'AirportID' } }]
  AirportFromId,
  CityFrom,
  CountryFrom,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_AirportVH', element: 'AirportID' } }]
  AirportToId,
  CityTo,
  CountryTo,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
