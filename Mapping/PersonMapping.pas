unit PersonMapping;

interface

implementation

uses
  Classes,
  Mapping,
  PersonModule;

procedure AddressMapperHandler(ASource, ATarget: TAddress);
begin
  ATarget.Region := ASource.Region;
  ATarget.City := ASource.City;
  ATarget.Street := ASource.Street;
end;

procedure PersonMapperHandler(ASource, ATarget: TPerson);
begin
  ATarget.Name := ASource.Name;
  ATarget.Address := ASource.Address;
  ATarget.Contacts := ASource.Contacts;
end;

procedure ContactMapperHandler(ASource, ATarget: TContact);
begin
  ATarget.Kind := ASource.Kind;
  ATarget.Value := ASource.Value;
end;

procedure ListMapperHandler(ASource, ATarget: TList);
var
  I: Integer;
  Item: TObject;
begin
  ATarget.Clear;
  for I := 0 to ASource.Count - 1 do
  begin
    Item := TObject(ASource.Items[I]);
    ATarget.Add(MapperManager.Map(Item, Item.ClassType));
  end;
end;

initialization
  MapperManager.RegisterMapper(TAddress, TAddress, @AddressMapperHandler);
  MapperManager.RegisterMapper(TPerson, TPerson, @PersonMapperHandler);
  MapperManager.RegisterMapper(TContact, TContact, @ContactMapperHandler);
  MapperManager.RegisterMapper(TList, TList, @ListMapperHandler);

end.
