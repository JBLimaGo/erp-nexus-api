program ERPNexusAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  AppConfig in 'Config\AppConfig.pas',
  AppRoutes in 'Api\Routes\AppRoutes.pas',
  HealthRoutes in 'Api\Routes\HealthRoutes.pas';

begin
  RegisterRoutes;

  Writeln('====================================');
  Writeln('        ', TAppConfig.APP_NAME);
  Writeln('====================================');
  Writeln;
  Writeln('Versao: ', TAppConfig.APP_VERSION);
  Writeln('Porta:  ', TAppConfig.Port);
  Writeln;
  Writeln('API:    http://localhost:', TAppConfig.Port);
  Writeln('Health: http://localhost:', TAppConfig.Port, '/health');
  Writeln;
  Writeln('Pressione CTRL+C para encerrar.');
  Writeln;

  THorse.Listen(TAppConfig.Port);
end.
