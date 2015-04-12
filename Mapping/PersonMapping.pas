unit PersonMapping;

interface

implementation

uses
  SysUtils,
  Classes,
  Mapping,
  PersonModule;

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

procedure JsonWriteBeginObject(ATarget: TStream);
var
  Data: string;
begin
  Data := '{';
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure JsonWriteEndObject(ATarget: TStream);
var
  Data: string;
begin
  Data := '}';
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure JsonWriteBeginArray(ATarget: TStream);
var
  Data: string;
begin
  Data := '[';
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure JsonWriteEndArray(ATarget: TStream);
var
  Data: string;
begin
  Data := ']';
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure JsonWriteSeparator(ATarget: TStream);
var
  Data: string;
begin
  Data := ',' + CRLF;
  ATarget.WriteBuffer(Data[1], Length(Data));
end;

procedure JsonWriteProperty(ATarget: TStream; const AName, AValue: string; AHasNext: Boolean); overload;
var
  Data: string;
begin
  Data := Format('"%s": "%s"', [AName, AValue]);
  ATarget.WriteBuffer(Data[1], Length(Data));

  if AHasNext then
    JsonWriteSeparator(ATarget);
end;

procedure JsonWriteProperty(ATarget: TStream; const AName: string; AValue: TObject; AHasNext: Boolean); overload;
var
  Data: string;
begin
  Data := Format('"%s": ', [AName]);
  ATarget.WriteBuffer(Data[1], Length(Data));
  MapperManager.Map(AValue, ATarget);

  if AHasNext then
    JsonWriteSeparator(ATarget);
end;

procedure StreamListMapperHandler(ASource: TList; ATarget: TStream);
var
  I: Integer;
  Item: TObject;
begin
  JsonWriteBeginArray(ATarget);
  for I := 0 to ASource.Count - 1 do
  begin
    Item := TObject(ASource.Items[I]);
    MapperManager.Map(Item, ATarget);
    if I + 1 < ASource.Count then
      JsonWriteSeparator(ATarget);
  end;
  JsonWriteEndArray(ATarget);
end;

procedure StreamAddressMapperHandler(ASource: TAddress; ATarget: TStream);
begin
  JsonWriteBeginObject(ATarget);
  JsonWriteProperty(ATarget, 'Region', ASource.Region, True);
  JsonWriteProperty(ATarget, 'City', ASource.City, True);
  JsonWriteProperty(ATarget, 'Street', ASource.Street, False);
  JsonWriteEndObject(ATarget);
end;

procedure StreamContactMapperHandler(ASource: TContact; ATarget: TStream);
begin
  JsonWriteBeginObject(ATarget);
  JsonWriteProperty(ATarget, 'Kind', ContactKindNames[ASource.Kind], True);
  JsonWriteProperty(ATarget, 'Value', ASource.Value, False);
  JsonWriteEndObject(ATarget);
end;

procedure StreamPersonMapperHandler(ASource: TPerson; ATarget: TStream);
begin
  JsonWriteBeginObject(ATarget);
  JsonWriteProperty(ATarget, 'Name', ASource.Name, True);
  JsonWriteProperty(ATarget, 'Address', ASource.Address, True);
  JsonWriteProperty(ATarget, 'Contacts', ASource.Contacts, False);
  JsonWriteEndObject(ATarget);
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
