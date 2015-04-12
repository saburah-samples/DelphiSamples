unit Mapping;

interface

uses
  SysUtils,
  Classes;

type
  //
  // MapperManager
  //

  IMapper = interface
    procedure Map(ASource, ATarget: TObject); overload;
    function Map(ASource: TObject; ATarget: TClass): TObject; overload;
  end;

  TCustomMapper = class(TInterfacedObject, IMapper)
  protected
    procedure DoMap(ASource, ATarget: TObject); virtual; abstract;
    function CreateTarget(ATargetClass: TClass): TObject; virtual; abstract;
    function GetSourceClass: TClass; virtual; abstract;
    function GetTargetClass: TClass; virtual; abstract;
  public
    property SourceClass: TClass read GetSourceClass;
    property TargetClass: TClass read GetTargetClass;

    procedure Map(ASource, ATarget: TObject); overload;
    function Map(ASource: TObject; ATargetClass: TClass): TObject; overload;
  end;

  TMapperHandlerProc = procedure (ASource, ATarget: TObject);

  TMapper = class(TCustomMapper)
  private
    FSourceClass: TClass;
    FTargetClass: TClass;
    FHandler: TMapperHandlerProc;
  protected
    procedure DoMap(ASource, ATarget: TObject); override;
    function CreateTarget(ATargetClass: TClass): TObject; override;
    function GetSourceClass: TClass; override;
    function GetTargetClass: TClass; override;
  public
    constructor Create(ASourceClass, ATargetClass: TClass; AHandler: TMapperHandlerProc); virtual;

    property Handler: TMapperHandlerProc read FHandler;
  end;

  TMapperManager = class(TInterfacedObject, IMapper)
  private
    FMappers: TList;
    function GetMapper(Index: Integer): TMapper;
    function GetMapperCount: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure RegisterMapper(ASourceClass, ATargetClass: TClass; AHandler: TMapperHandlerProc);
    function FindMapper(ASourceClass, ATargetClass: TClass): TMapper;

    function Map(ASource: TObject; ATargetClass: TClass): TObject; overload;
    procedure Map(ASource: TObject; ATarget: TObject); overload;

    property MapperCount: Integer read GetMapperCount;
    property Mappers[Index: Integer]: TMapper read GetMapper;
  end;

function MapperManager: TMapperManager;

implementation

uses
  Contnrs;

var
  FMapperManager: TMapperManager = nil;

function MapperManager: TMapperManager;
begin
  if FMapperManager = nil then
    FMapperManager := TMapperManager.Create;

  Result := FMapperManager;
end;

{ TCustomMapper }

procedure TCustomMapper.Map(ASource, ATarget: TObject);
begin
  DoMap(ASource, ATarget);
end;

function TCustomMapper.Map(ASource: TObject; ATargetClass: TClass): TObject;
begin
  Result := CreateTarget(ATargetClass);
  Map(ASource, Result);
end;

{ TMapper }

constructor TMapper.Create(ASourceClass, ATargetClass: TClass; AHandler: TMapperHandlerProc);
begin
  inherited Create;
  FSourceClass := ASourceClass;
  FTargetClass := ATargetClass;
  FHandler := AHandler;
end;

function TMapper.CreateTarget(ATargetClass: TClass): TObject;
begin
  Result := ATargetClass.Create;
end;

procedure TMapper.DoMap(ASource: TObject; ATarget: TObject);
begin
  if Assigned(FHandler) then
    FHandler(ASource, ATarget);
end;

function TMapper.GetSourceClass: TClass;
begin
  Result := FSourceClass;
end;

function TMapper.GetTargetClass: TClass;
begin
  Result := FTargetClass;
end;

{ TMapperManager }

constructor TMapperManager.Create;
begin
  inherited Create;
  FMappers := TObjectList.Create(True);
end;

destructor TMapperManager.Destroy;
begin
  FreeAndNil(FMappers);
  inherited;
end;

procedure TMapperManager.RegisterMapper(ASourceClass, ATargetClass: TClass; AHandler: TMapperHandlerProc);
var
  Mapper: TMapper;
begin
  Mapper := FindMapper(ASourceClass, ATargetClass);
  Assert(Mapper = nil, Format('Mapper [%s, %s] already created.', [ASourceClass.ClassName, ATargetClass.ClassName]));
  Mapper := TMapper.Create(ASourceClass, ATargetClass, AHandler);
  FMappers.Add(Mapper);
end;

function TMapperManager.FindMapper(ASourceClass, ATargetClass: TClass): TMapper;
var
  I: Integer;
  Mapper: TMapper;
begin
  Result := nil;
  for I := 0 to MapperCount - 1 do
  begin
    Mapper := Mappers[I];
    if (Mapper.SourceClass = ASourceClass) and (Mapper.TargetClass = ATargetClass) then
    begin
      Result := Mapper;
      Break;
    end;
  end;
end;

function TMapperManager.Map(ASource: TObject; ATargetClass: TClass): TObject;
var
  SourceClass: TClass;
  Mapper: TMapper;
begin
  Assert(ASource <> nil);
  Assert(ATargetClass <> nil);

  SourceClass := ASource.ClassType;
  Mapper := FindMapper(SourceClass, ATargetClass);
  Assert(Mapper <> nil, Format('Mapper [%s, %s] not found.', [SourceClass.ClassName, ATargetClass.ClassName]));

  Result := Mapper.Map(ASource, ATargetClass);
end;

procedure TMapperManager.Map(ASource, ATarget: TObject);
var
  SourceClass: TClass;
  TargetClass: TClass;
  Mapper: TMapper;
begin
  Assert(ASource <> nil);
  Assert(ATarget <> nil);

  SourceClass := ASource.ClassType;
  TargetClass := ATarget.ClassType;
  Mapper := FindMapper(SourceClass, TargetClass);
  Assert(Mapper <> nil, Format('Mapper [%s, %s] not found.', [SourceClass.ClassName, TargetClass.ClassName]));

  Mapper.Map(ASource, ATarget);
end;

function TMapperManager.GetMapperCount: Integer;
begin
  Result := FMappers.Count;
end;

function TMapperManager.GetMapper(Index: Integer): TMapper;
begin
  Result := TMapper(FMappers[Index]);
end;

initialization
  FMapperManager := nil;
finalization
  FreeAndNil(FMapperManager);
end.
