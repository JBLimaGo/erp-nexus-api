unit UsuarioRepository;

interface

uses
  Usuario;

type
  IUsuarioRepository = interface
    ['{C4F12E0D-4A1A-4B3B-A0B8-7A0C28B7A7F5}']

    function FindByLogin(
      const ALogin: string
    ): TUsuario;

  end;

implementation

end.
