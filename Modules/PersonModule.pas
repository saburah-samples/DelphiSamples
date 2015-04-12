unit PersonModule;

interface

uses
  SysUtils,
  Classes;

type
  TAddress = class
  private
    FRegion: string;
    FCity: string;
    FStreet: string;
  public
    property Region: string read FRegion write FRegion;
    property City: string read FCity write FCity;
    property Street: string read FStreet write FStreet;
  end;

  TContactKind = (ckPhone, ckEmail);
  TContact = class
  private
    FKind: TContactKind;
    FValue: string;
  public
    property Kind: TContactKind read FKind write FKind;
    property Value: string read FValue write FValue;
  end;

  TPerson = class
  private
    FName: string;
    FAddress: TAddress;
    FContacts: TList;
    procedure SetAddress(const Value: TAddress);
    procedure SetContacts(const Value: TList);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Name: string read FName write FName;
    property Address: TAddress read FAddress write SetAddress;
    property Contacts: TList read FContacts write SetContacts;
  end;

const
  ContactKindNames: array [TContactKind] of string = (
    'Phone', 'Email'
  );

implementation

uses
  Mapping;

{ TPerson }

constructor TPerson.Create;
begin
  FAddress := TAddress.Create;
  FContacts := TList.Create;
end;

destructor TPerson.Destroy;
begin
  FreeAndNil(FContacts);
  FreeAndNil(FAddress);
  inherited;
end;

procedure TPerson.SetAddress(const Value: TAddress);
begin
  MapperManager.Map(Value, FAddress);
end;

procedure TPerson.SetContacts(const Value: TList);
begin
  MapperManager.Map(Value, FContacts);
end;

end.
