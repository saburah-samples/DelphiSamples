unit PersonMapping;

interface

implementation

uses
  Mapping,
  PersonModule;

procedure MapAddressToAddress(ASource, ATarget: TAddress);
begin
  ATarget.Region := ASource.Region;
  ATarget.City := ASource.City;
  ATarget.Street := ASource.Street;
end;

procedure MapPersonToPerson(ASource, ATarget: TPerson);
begin
  ATarget.Name := ASource.Name;
  ATarget.Address := ASource.Address;
end;

initialization
  MapperManager.RegisterMapper(TAddress, TAddress, @MapAddressToAddress);
  MapperManager.RegisterMapper(TAddress, TAddress, @MapPersonToPerson);

end.
