@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for Z_R_AJM_CONN'
define root view entity Z_C_AJM_CONN
  provider contract transactional_query
  as projection on Z_R_AJM_CONN
{
  key UUID, 
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_CarrierVH', element: 'CarrierId' } }]
  CarrierID,
  ConnectionID,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_AirportVH', element: 'AirportID' } }]
  AirportFromID,
  CityFrom,
  CountryFrom,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_AirportVH', element: 'AirportID' } }]
  AirportToID,
  CityTo,
  CountryTo,
  LocalLastChangedAt
  
}
