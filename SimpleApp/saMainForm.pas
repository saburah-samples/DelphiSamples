unit saMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Mapping,
  PersonModule;

type
  TMainForm = class(TForm)
    btnTestObjectPersonMapping: TButton;
    btnTestStreamPersonMapping: TButton;
    memStreamPersonMappingResult: TMemo;
    procedure btnTestObjectPersonMappingClick(Sender: TObject);
    procedure btnTestStreamPersonMappingClick(Sender: TObject);
  private
    { Private declarations }
    FPerson: TPerson;
    procedure SetPerson(const Value: TPerson);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property Person: TPerson read FPerson write SetPerson;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.AfterConstruction;
begin
  inherited;
  FPerson := TPerson.Create;
end;

procedure TMainForm.BeforeDestruction;
begin
  inherited;
  FreeAndNil(FPerson);
end;

procedure TMainForm.SetPerson(const Value: TPerson);
begin
  MapperManager.Map(Value, FPerson);
end;

procedure TMainForm.btnTestObjectPersonMappingClick(Sender: TObject);
var
  Address: TAddress;
  Contacts: TList;
  Contact: TContact;
  Person: TPerson;
  I: Integer;
begin
  Person := TPerson.Create;
  try
    Person.Name := 'Denis Vakhrushev';

    Address := TAddress.Create;
    try
      Address.Region := '18';
      Address.City := 'Izhevsk';
      Address.Street := 'Petrova';

      Person.Address := Address;
    finally
      FreeAndNil(Address);
    end;

    Contacts := TList.Create;
    try
      Contact := TContact.Create;
      Contact.Kind := ckPhone;
      Contact.Value := '9090626123';
      Contacts.Add(Contact);
      Contact := TContact.Create;
      Contact.Kind := ckEmail;
      Contact.Value := 'Denis_Vakhrushev@email.com';
      Contacts.Add(Contact);

      Person.Contacts := Contacts;
    finally
      for I := 0 to Contacts.Count-1 do
        TObject(Contacts.Items[I]).Free;

      FreeAndNil(Contacts);
    end;

    Self.Person := Person;
  finally
    Person.Free;
  end;
  MessageDlg('Person Mapping Done', mtInformation, [mbOK], 0);
end;

procedure TMainForm.btnTestStreamPersonMappingClick(Sender: TObject);
var
  Stream: TStream;
begin
  Stream := TMemoryStream.Create;
  try
    MapperManager.Map(Person, Stream);
    Stream.Position := 0;
    memStreamPersonMappingResult.Lines.LoadFromStream(Stream);
  finally
    FreeAndNil(Stream)
  end;
end;

end.
