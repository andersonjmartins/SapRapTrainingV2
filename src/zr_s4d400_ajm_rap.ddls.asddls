@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_S4D400_AJM_RAP
  as select from zs4d400_ajm_rap as ZConnection
{
  key uuid as Uuid,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'Zajm_I_CarrierVH', element: 'CarrierId' } }]
  carrier_id as CarrierId,
  connection_id as ConnectionId,
  airport_from_id as AirportFromId,
  city_from as CityFrom,
  country_from as CountryFrom,
  airport_to_id as AirportToId,
  city_to as CityTo,
  country_to as CountryTo,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
