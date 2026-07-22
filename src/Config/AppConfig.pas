unit AppConfig;

interface

type
  TAppConfig = class
  private
    class function GetPort: Integer; static;
  public const
    APP_NAME = 'ERP Nexus API';
    APP_VERSION = '1.0.0';
    DEFAULT_PORT = 9000;
  public
    class property Port: Integer read GetPort;
  end;

implementation

uses
  System.SysUtils;

class function TAppConfig.GetPort: Integer;
var
  LPort: string;
begin
  LPort := GetEnvironmentVariable('ERP_NEXUS_PORT');

  if not TryStrToInt(LPort, Result) then
    Result := DEFAULT_PORT;
end;

end.
