unit ViewBase;

interface

uses
  ObserverList, JsonData,
  Classes, SysUtils, Graphics;

type
  TViewBase = class(TComponent)
  private
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
  protected
    FObserverList: TObserverList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// �޽����� ���� �� ��ü�� ����Ѵ�.
    procedure Add(Observer: TObject);

    /// Observer���� �޽��� ������ �ߴ��Ѵ�.
    procedure Remove(Observer: TObject);

    /// ��� �� ��� Observer���� �޽����� �����Ѵ�.
    procedure AsyncBroadcast(AMsg: string);

    /// TCore�� �ʱ�ȭ �ƴ�.
    procedure sp_Initialize;

    /// TCore�� ����ó���� ���۵ƴ�.
    procedure sp_Finalize;

    /// ��� View ��ü���� ���� �Ǿ���.
    procedure sp_ViewIsReady;

    /// �ý��� ���ο��� ��� �޽����� ����ϰ��� �� �� ���δ�.
    procedure sp_SystemMessage(AMsg: string; AColor: TColor = clRed);

    /// ���α׷� ����
    procedure sp_Terminate(AMsg: string);

    /// �α��� ��� �ڽ��� Connection ID�� �˰� �Ǿ���.
    procedure sp_ConnectionID(AID: integer);

    /// DeskZip ȭ�� ������ �Ϸ�Ǿ� ǥ���� �غ� �Ǿ���.
    procedure sp_DeskScreenIsReady;
  published
    /// �޽��� ���� ���� ��?
    property Active: boolean read GetActive write SetActive;
  end;

implementation

{ TViewBase }

procedure TViewBase.Add(Observer: TObject);
begin
  FObserverList.Add(Observer);
end;

procedure TViewBase.AsyncBroadcast(AMsg: string);
begin
  FObserverList.AsyncBroadcast(AMsg);
end;

constructor TViewBase.Create(AOwner: TComponent);
begin
  inherited;

  FObserverList := TObserverList.Create(nil);
end;

destructor TViewBase.Destroy;
begin
  FreeAndNil(FObserverList);

  inherited;
end;

function TViewBase.GetActive: boolean;
begin
  Result := FObserverList.Active;
end;

procedure TViewBase.Remove(Observer: TObject);
begin
  FObserverList.Remove(Observer);
end;

procedure TViewBase.SetActive(const Value: boolean);
begin
  FObserverList.Active := Value;
end;

procedure TViewBase.sp_ConnectionID(AID: integer);
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'ConnectionID';
    Params.Integers['ID'] := AID;
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TViewBase.sp_DeskScreenIsReady;
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'DeskScreenIsReady';

    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TViewBase.sp_Finalize;
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'Finalize';
    FObserverList.Broadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TViewBase.sp_Initialize;
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'Initialize';
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TViewBase.sp_SystemMessage(AMsg: string; AColor: TColor);
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'SystemMessage';
    Params.Values['Msg'] := AMsg;
    Params.Integers['Color'] := AColor;

    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TViewBase.sp_Terminate(AMsg: string);
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'Terminate';
    Params.Values['Msg'] := AMsg;

    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TViewBase.sp_ViewIsReady;
var
  Params: TJsonData;
begin
  Params := TJsonData.Create;
  try
    Params.Values['Code'] := 'ViewIsReady';
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

end.
