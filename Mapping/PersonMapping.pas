unit PersonMapping;

interface

implementation

uses
  Classes,
  Mapping,
  PersonModule, SysUtils;

const
  CRLF = #13#10;
//
// Object To Object Mappers
//

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

procedure AddressMapperHandler(ASource, ATarget: TAddress);
begin
  ATarget.Region := ASource.Region;
  ATarget.City := ASource.City;
  ATarget.Street := ASource.Street;
end;

procedure ContactMapperHandler(ASource, ATarget: TContact);
begin
  ATarget.Kind := ASource.Kind;
  ATarget.Value := ASource.Value;
end;

procedure PersonMapperHandler(ASource, ATarget: TPerson);
begin
  ATarget.Name := ASource.Name;
  ATarget.Address := ASource.Address;
  ATarget.Contacts := ASource.Contacts;
end;

//
// Object To Stream Mappers
//

procedure StreamListMapperHandler(ASource: TList; ATarget: TStream);
var
  Data: string;
  I: Integer;
  Item: TObject;
begin
  for I := 0 to ASource.Count - 1 do
  begin
    Data := Format('List.Index=%d'+CRLF, [I]);
    ATarget.WriteBuffer(Data[1], Length(Data));
    Item := TObject(ASource.Items[I]);
    MapperManager.Map(Item, ATarget);
  end;
end;

procedure StreamAddressMapperHandler(ASource: TAddress; ATarget: TStream);
var
  Data: string;
begin
  Data := Format('Address.Region=%s'+CRLF, [ASource.Region]);
  ATarget.WriteBuffer(Data[1], Length(Data));
  Data := Format('Address.City=%s'+CRLF, [ASource.City]);
  ATarget.WriteBuffer(Data[1], Length(Data));
  Data := Format('Address.Street='+CRLF, [ASource.Street]);
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure StreamContactMapperHandler(ASource: TContact; ATarget: TStream);
var
  Data: string;
begin
  Data := Format('Contact.Kind=%s'+CRLF, [ContactKindNames[ASource.Kind]]);
  ATarget.WriteBuffer(Data[1], Length(Data));
  Data := Format('Contact.Value=%s'+CRLF, [ASource.Value]);
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure StreamPersonMapperHandler(ASource: TPerson; ATarget: TStream);
var
  Data: string;
begin
  Data := Format('Person.Name=%s'+CRLF, [ASource.Name]);
  ATarget.WriteBuffer(Data[1], Length(Data));
  MapperManager.Map(ASource.Address, ATarget);
  MapperManager.Map(ASource.Contacts, ATarget);
end;

initialization
  MapperManager.RegisterMapper(TList, TList, @ListMapperHandler);
  MapperManager.RegisterMapper(TAddress, TAddress, @AddressMapperHandler);
  MapperManager.RegisterMapper(TContact, TContact, @ContactMapperHandler);
  MapperManager.RegisterMapper(TPerson, TPerson, @PersonMapperHandler);

  MapperManager.RegisterMapper(TList, TStream, @StreamListMapperHandler);
  MapperManager.RegisterMapper(TAddress, TStream, @StreamAddressMapperHandler);
  MapperManager.RegisterMapper(TContact, TStream, @StreamContactMapperHandler);
  MapperManager.RegisterMapper(TPerson, TStream, @StreamPersonMapperHandler);

end.
