{
  * Um componente responsável por fornecer e persistir dados do domínio no banco de dados.

}

unit ClienteRepository;

interface

uses
  System.Generics.Collections,
  Cliente;

type
  IClienteRepository = interface
    ['{C1526807-4A62-4C55-9557-A7C27E97AA01}']

    function FindAll: TObjectList<TCliente>;

    function FindById(
      AId: Integer
    ): TCliente;

    function ExistsByDocument(
      const ADocument: string
    ): Boolean;

    function Add(
      ACliente: TCliente
    ): TCliente;
  end;

implementation

end.
