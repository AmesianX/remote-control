unit _fmMain;

interface

uses
  JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, _frDeskScreen,
  Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    btConnect: TButton;
    edCode: TEdit;
    frDeskScreen: TfrDeskScreen;
    plTop: TPanel;
    tmClose: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmCloseTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
  public
  published
    procedure rp_Connected(AJsonData: TJsonData);
    procedure rp_Disconnected(AJsonData: TJsonData);
    procedure rp_ErPeerConnected(AJsonData: TJsonData);
    procedure rp_PeerConnected(AJsonData:TJsonData);
    procedure rp_PeerDisconnected(AJsonData:TJsonData);
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, ClientUnit;

{$R *.dfm}

procedure TfmMain.btConnectClick(Sender: TObject);
begin
  plTop.Visible := false;
  TClientUnit.Obj.sp_SetConnectionID(StrToIntDef(edCode.Text, 0));
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  Action := caNone;
  tmClose.Enabled := true;
  TCore.Obj.Finalize;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TClientUnit.Obj.Connect;

  TCore.Obj.View.Add(Self);
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  TCore.Obj.View.Remove(Self);
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TClientUnit.Obj.sp_KeyDown(Key);
end;

procedure TfmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  TClientUnit.Obj.sp_KeyUp(Key);
end;

procedure TfmMain.rp_Connected(AJsonData: TJsonData);
begin
  Caption := 'Remote control - ���� ���� �Ϸ�';
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.rp_Disconnected(AJsonData: TJsonData);
begin
  MessageDlg('������ ������ �������� ���α׷��� �����մϴ�.', mtWarning, [mbOK], 0);
  Close;
end;

procedure TfmMain.rp_ErPeerConnected(AJsonData: TJsonData);
begin
  MessageDlg('�߸��� ���̵�� ������ �õ��Ͽ����ϴ�.' + #13#10 + '���̵� Ȯ���Ͽ��ֽñ� �ٶ��ϴ�.', mtWarning, [mbOK], 0);
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.rp_PeerConnected(AJsonData: TJsonData);
begin
  Caption := 'Remote control - ���� ���� ��';
end;

procedure TfmMain.rp_PeerDisconnected(AJsonData: TJsonData);
begin
  MessageDlg('������� ������ ���������ϴ�.', mtWarning, [mbOK], 0);
  Caption := 'Remote control - ���� ��� ��';
  plTop.Visible := true;
  edCode.SetFocus;
end;

procedure TfmMain.tmCloseTimer(Sender: TObject);
begin
  Application.Terminate;
end;

end.
