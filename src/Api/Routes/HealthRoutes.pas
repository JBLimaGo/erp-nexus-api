unit HealthRoutes;

interface

procedure RegisterHealthRoutes;

implementation

uses
  System.JSON,
  Horse;

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
        LJSON.AddPair('service', 'ERP Nexus API');
        LJSON.AddPair('version', '1.0.0');

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
