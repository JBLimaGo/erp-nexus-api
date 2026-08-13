unit LoginDTO;

interface

uses
  System.JSON;

type
  TLoginDTO = class
  private
    FLogin: string;
    FSenha: string;

  public
    property Login: string
      read FLogin
      write FLogin;

    property Senha: string
      read FSenha
      write FSenha;

    class function FromJSON(
      const AJson: string
    ): TLoginDTO;
  end;

implementation

class function TLoginDTO.FromJSON(
  const AJson: string
): TLoginDTO;
var
  LBody: TJSONObject;
begin
  Result := TLoginDTO.Create;

  LBody := TJSONObject.ParseJSONValue(AJson) as TJSONObject;

  try
    if Assigned(LBody) then
    begin
      Result.Login := LBody.GetValue<string>('login', '');
      Result.Senha := LBody.GetValue<string>('senha', '');
    end;
  finally
    LBody.Free;
  end;
end;

end.
