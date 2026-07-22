unit AppRoutes;

interface

procedure RegisterRoutes;

implementation

uses
  Horse,
  AppConfig,
  HealthRoutes;

procedure RegisterRoutes;
begin
  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(TAppConfig.APP_NAME);
    end
  );

  RegisterHealthRoutes;
end;

end.
