unit AuthService;

interface

uses
  Usuario,
  LoginDTO,
  UsuarioRepository,
  LoginResponseDTO,
  JwtService;

type
  TAuthService = class
  private
    FRepository: IUsuarioRepository;
    FJwtService: IJwtService;

  public
    constructor Create(
      ARepository: IUsuarioRepository
    );

    function Authenticate(
      ADTO: TLoginDTO
    ): TUsuario;

    function Login(
      const ALogin: string;
      const ASenha: string
    ): TLoginResponseDTO;

  end;

implementation

uses
  System.SysUtils,
  DomainExceptions;

constructor TAuthService.Create(
  ARepository: IUsuarioRepository
);
begin
  inherited Create;

  FRepository := ARepository;
end;

function TAuthService.Login(const ALogin, ASenha: string): TLoginResponseDTO;
var
  LUsuario: TUsuario;
begin

  LUsuario := FRepository.FindByLogin(ALogin);

  if not Assigned(LUsuario) then
    raise EUnauthorizedException.Create(
      'Usuário ou senha inválidos.'
    );

  if LUsuario.Senha <> ASenha then
    raise EUnauthorizedException.Create(
      'Usuário ou senha inválidos.'
    );

  if not LUsuario.Ativo then
    raise EUnauthorizedException.Create(
      'Usuário inativo.'
    );

  Result := TLoginResponseDTO.Create;

  Result.AccessToken := FJwtService.GenerateToken(
                        LUsuario.Id,
                        LUsuario.Login
                        );

  Result.TokenType := 'Bearer';

  Result.ExpiresIn := 3600;

end;

function TAuthService.Authenticate(
  ADTO: TLoginDTO
): TUsuario;
begin
  if not Assigned(ADTO) then
    raise EValidationException.Create(
      'Dados de login não informados.'
    );

  if Trim(ADTO.Login) = '' then
    raise EValidationException.Create(
      'Login é obrigatório.'
    );

  if Trim(ADTO.Senha) = '' then
    raise EValidationException.Create(
      'Senha é obrigatória.'
    );

  Result := FRepository.FindByLogin(
    Trim(ADTO.Login)
  );

  if not Assigned(Result) then
    raise Exception.Create(
      'Usuário ou senha inválidos.'
    );

  if Result.Senha <> ADTO.Senha then
  begin
    Result.Free;

    raise Exception.Create(
      'Usuário ou senha inválidos.'
    );
  end;

  if not Result.Ativo then
  begin
    Result.Free;

    raise Exception.Create(
      'Usuário inativo.'
    );
  end;
end;

end.
