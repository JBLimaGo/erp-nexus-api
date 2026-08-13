unit OpenApiRoutes;

interface

procedure RegisterOpenApiRoutes;

implementation

uses
  Horse,
  System.SysUtils,
  System.Classes,
  System.IOUtils;

procedure RegisterOpenApiRoutes;
begin
  THorse.Get(
    '/openapi.json',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LJson: TStringList;
    begin
      LJson := TStringList.Create;
      try
        try
          LJson.LoadFromFile(
            TPath.Combine(
            ExtractFilePath(ParamStr(0)), 'docs\openapi.json'
            )
          );

          Res.ContentType('application/json')
             .Status(200)
             .Send(LJson.Text);

        except
          on E: Exception do
            Res.Status(500).Send(E.Message);
        end;

      finally
        LJson.Free;
      end;
    end
  );
end;

end.
