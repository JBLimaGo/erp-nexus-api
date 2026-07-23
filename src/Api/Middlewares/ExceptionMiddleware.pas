unit ExceptionMiddleware;

interface

uses
  Horse;

procedure RegisterExceptionMiddleware;

implementation

uses
  System.SysUtils,
  System.JSON,
  DomainExceptions;

procedure SendError(
  Res: THorseResponse;
  AStatusCode: Integer;
  const AErrorCode: string;
  const AMessage: string
);
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;

  LJSON.AddPair(
    'error',
    AErrorCode
  );

  LJSON.AddPair(
    'message',
    AMessage
  );

  Res
    .Status(AStatusCode)
    .ContentType('application/json')
    .Send(LJSON.ToJSON);

  LJSON.Free;
end;

procedure RegisterExceptionMiddleware;
begin
  THorse.Use(
    procedure(
      Req: THorseRequest;
      Res: THorseResponse;
      Next: TProc
    )
    begin
      try

        Next();

      except

        on E: EValidationException do
        begin
          SendError(
            Res,
            400,
            'VALIDATION_ERROR',
            E.Message
          );
        end;

        on E: ENotFoundException do
        begin
          SendError(
            Res,
            404,
            'NOT_FOUND',
            E.Message
          );
        end;

        on E: EConflictException do
        begin
          SendError(
            Res,
            409,
            'CONFLICT',
            E.Message
          );
        end;

        on E: Exception do
        begin
          Writeln(
            '[ERROR] ',
            E.ClassName,
            ': ',
            E.Message
          );

          SendError(
            Res,
            500,
            'INTERNAL_SERVER_ERROR',
            'Ocorreu um erro interno no servidor'
          );
        end;

      end;
    end
  );
end;

end.
