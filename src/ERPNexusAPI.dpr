program ERPNexusAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  HealthRoutes in 'Api\Routes\HealthRoutes.pas';

begin
  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('ERP Nexus API');
    end
  );

  RegisterHealthRoutes;

  Writeln('====================================');
  Writeln('        ERP NEXUS API');
  Writeln('====================================');
  Writeln;
  Writeln('Servidor iniciado na porta 9000');
  Writeln('Acesse: http://localhost:9000');
  Writeln;
  Writeln('Pressione CTRL+C para encerrar.');
  Writeln;

  THorse.Listen(9000);

end.
