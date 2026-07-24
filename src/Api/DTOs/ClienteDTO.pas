{

   dados de entrada

}

unit ClienteDTO;

interface

type
  TCreateClienteDTO = class
  private
    FName: string;
    FDocument: string;
    FEmail: string;
    FActive: Boolean;
  public
    constructor Create;

    property Name: string
      read FName
      write FName;

    property Document: string
      read FDocument
      write FDocument;

    property Email: string
      read FEmail
      write FEmail;

    property Active: Boolean
      read FActive
      write FActive;
  end;

  TUpdateClienteDTO = class
  private
    FName: string;
    FDocument: string;
    FEmail: string;
    FActive: Boolean;
  public
    property Name: string
      read FName
      write FName;

    property Document: string
      read FDocument
      write FDocument;

    property Email: string
      read FEmail
      write FEmail;

    property Active: Boolean
      read FActive
      write FActive;

    class function FromJSON(
      const AJSON: string
    ): TUpdateClienteDTO;
  end;

implementation

  uses
    System.SysUtils,
    System.JSON;

constructor TCreateClienteDTO.Create;
begin
  inherited Create;

  FActive := True;
end;

class function TUpdateClienteDTO.FromJSON(
  const AJSON: string
): TUpdateClienteDTO;
var
  LJSONValue: TJSONValue;
  LJSONObject: TJSONObject;
begin
  Result     := TUpdateClienteDTO.Create;

  LJSONValue := TJSONObject.ParseJSONValue(AJSON);

  try
    try
      if not Assigned(LJSONValue) then
        raise Exception.Create(
          'JSON inválido'
        );

      if not (LJSONValue is TJSONObject) then
        raise Exception.Create(
          'O corpo da requisição deve ser um objeto JSON'
        );

      LJSONObject :=
        LJSONValue as TJSONObject;

      LJSONObject.TryGetValue<string>(
        'name',
        Result.FName
      );

      LJSONObject.TryGetValue<string>(
        'document',
        Result.FDocument
      );

      LJSONObject.TryGetValue<string>(
        'email',
        Result.FEmail
      );

      LJSONObject.TryGetValue<Boolean>(
        'active',
        Result.FActive
      );

    except
      Result.Free;
      raise;
    end;

  finally
    LJSONValue.Free;
  end;
end;

end.
