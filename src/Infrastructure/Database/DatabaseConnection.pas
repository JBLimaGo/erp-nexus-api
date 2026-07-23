{
  Realiza a Conexão com Banco de Dados
}

unit DatabaseConnection;

interface

uses
  FireDAC.Comp.Client;

type
  TDatabaseConnection = class
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;

    property Connection: TFDConnection
      read FConnection;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef;

constructor TDatabaseConnection.Create;
begin
  inherited Create;

  FConnection := TFDConnection.Create(nil);

  FConnection.LoginPrompt := False;
end;

destructor TDatabaseConnection.Destroy;
begin
  FConnection.Free;

  inherited;
end;

procedure TDatabaseConnection.Connect;
var
  LDatabase: string;
  LUserName: string;
  LPassword: string;
begin
  if FConnection.Connected then
    Exit;

  LDatabase := GetEnvironmentVariable('ERP_NEXUS_DB');

  LUserName := GetEnvironmentVariable('ERP_NEXUS_DB_USER');

  LPassword := GetEnvironmentVariable('ERP_NEXUS_DB_PASSWORD');

  if Trim(LDatabase) = '' then
    raise Exception.Create(
      'Environment variable ERP_NEXUS_DB is not configured'
    );

  if Trim(LUserName) = '' then
    raise Exception.Create(
      'Environment variable ERP_NEXUS_DB_USER is not configured'
    );

  if Trim(LPassword) = '' then
    raise Exception.Create(
      'Environment variable ERP_NEXUS_DB_PASSWORD is not configured'
    );

  if not FileExists(LDatabase) then
    raise Exception.CreateFmt(
      'Firebird database file not found: %s',
      [LDatabase]
    );

  FConnection.Params.Clear;

  FConnection.Params.DriverID := 'FB';
  FConnection.Params.Database := LDatabase;
  FConnection.Params.UserName := LUserName;
  FConnection.Params.Password := LPassword;

  FConnection.Params.Add('CharacterSet=UTF8');

  FConnection.LoginPrompt := False;
  FConnection.Connected   := True;
end;

end.
