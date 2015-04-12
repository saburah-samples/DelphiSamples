program SimpleApp;

uses
  Forms,
  saMainForm in 'saMainForm.pas' {MainForm},
  Mapping in '..\Mapping\Mapping.pas',
  PersonMapping in '..\Mapping\PersonMapping.pas',
  PersonModule in '..\Modules\PersonModule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
