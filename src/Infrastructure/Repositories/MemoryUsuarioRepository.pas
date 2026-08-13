unit MemoryUsuarioRepository;

interface

uses
  System.Generics.Collections,
  Usuario,
  UsuarioRepository;

type
  TMemoryUsuarioRepository = class(
    TInterfacedObject,
    IUsuarioRepository
  )
  private
    class var FUsuarios: TObjectList<TUsuario>;

    class procedure Initialize;

  public
    constructor Create;

    function FindByLogin(
      const ALogin: string
    ): TUsuario;

  end;

implementation

uses
  System.SysUtils;

constructor TMemoryUsuarioRepository.Create;
begin
  inherited Create;

  Initialize;
end;

class procedure TMemoryUsuarioRepository.Initialize;
var
  LUsuario: TUsuario;
begin
  if Assigned(FUsuarios) then
    Exit;

  FUsuarios := TObjectList<TUsuario>.Create(True);

  LUsuario := TUsuario.Create;

  LUsuario.Id := 1;
  LUsuario.Nome := 'Administrador';
  LUsuario.Login := 'admin';
  LUsuario.Senha := '123456';
  LUsuario.Ativo := True;

  FUsuarios.Add(LUsuario);
end;

function TMemoryUsuarioRepository.FindByLogin(
  const ALogin: string
): TUsuario;
var
  LUsuario: TUsuario;
begin
  Result := nil;

  for LUsuario in FUsuarios do
  begin
    if SameText(
      Trim(LUsuario.Login),
      Trim(ALogin)
    ) then
    begin
      Result := TUsuario.Create;

      Result.Id := LUsuario.Id;
      Result.Nome := LUsuario.Nome;
      Result.Login := LUsuario.Login;
      Result.Senha := LUsuario.Senha;
      Result.Ativo := LUsuario.Ativo;

      Exit;
    end;
  end;
end;

end.
