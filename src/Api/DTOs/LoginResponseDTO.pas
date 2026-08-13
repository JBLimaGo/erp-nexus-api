unit LoginResponseDTO;

interface

type
  TLoginResponseDTO = class
  private
    FAccessToken: string;
    FTokenType: string;
    FExpiresIn: Integer;

  public
    constructor Create;

    property AccessToken: string
      read FAccessToken
      write FAccessToken;

    property TokenType: string
      read FTokenType
      write FTokenType;

    property ExpiresIn: Integer
      read FExpiresIn
      write FExpiresIn;
  end;

implementation

constructor TLoginResponseDTO.Create;
begin
  inherited Create;

  FTokenType := 'Bearer';
  FExpiresIn := 3600;
end;

end.
