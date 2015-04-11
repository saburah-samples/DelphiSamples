unit PersonModule;

interface

uses
  SysUtils;

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

  TPerson = class
  private
    FName: string;
    FAddress: TAddress;
    procedure SetAddress(const Value: TAddress);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Name: string read FName write FName;
    property Address: TAddress read FAddress write SetAddress;
  end;

implementation

uses
  Mapping;

{ TPerson }

constructor TPerson.Create;
begin
  FAddress := TAddress.Create;
end;

destructor TPerson.Destroy;
begin
  FreeAndNil(FAddress);
  inherited;
end;

procedure TPerson.SetAddress(const Value: TAddress);
begin
  MapperManager.Map(Value, FAddress);
end;

end.
