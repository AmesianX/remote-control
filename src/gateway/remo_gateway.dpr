program remo_gateway;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {Form3},
  ServerUnit in 'ServerUnit.pas',
  Config in '..\..\lib\Config.pas',
  Global in '..\..\lib\Global.pas',
  Protocols in '..\..\lib\Protocols.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.