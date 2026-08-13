unit AppRoutes;

interface

procedure RegisterRoutes;

implementation

uses
  Horse,
  AppConfig,
  HealthRoutes,
  ClienteRoutes,
  OpenApiRoutes;

procedure RegisterRoutes;
begin
  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(TAppConfig.APP_NAME);
    end
  );

  RegisterHealthRoutes;
  RegisterClienteRoutes;
  RegisterOpenApiRoutes;
end;

end.
