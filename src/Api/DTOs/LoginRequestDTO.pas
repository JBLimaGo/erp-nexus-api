unit LoginRequestDTO;

interface

type
  TLoginRequestDTO = class
  private
    FLogin: string;
    FSenha: string;
  public
    property Login: string read FLogin write FLogin;
    property Senha: string read FSenha write FSenha;
  end;

implementation

end.




