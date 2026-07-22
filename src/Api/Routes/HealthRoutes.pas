unit HealthRoutes;

interface

procedure RegisterHealthRoutes;

implementation

uses
  System.JSON,
  Horse,
  AppConfig;

procedure RegisterHealthRoutes;
begin
  THorse.Get('/health',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LJSON: TJSONObject;
    begin
      LJSON := TJSONObject.Create;
      try
        LJSON.AddPair('status', 'online');
        LJSON.AddPair('service', TAppConfig.APP_NAME);
        LJSON.AddPair('version', TAppConfig.APP_VERSION);

        Res
          .Status(200)
          .ContentType('application/json')
          .Send(LJSON.ToJSON);
      finally
        LJSON.Free;
      end;
    end
  );
end;

end.
