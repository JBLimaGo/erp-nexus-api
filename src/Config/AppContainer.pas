{
  * Local onde montamos as dependências
}
unit AppContainer;

interface

uses
  ClienteService;

type
  TAppContainer = class
  public
    class function CreateClienteService:
      TClienteService;
  end;

implementation

uses
  ClienteRepository,
  FireDACClienteRepository;

class function TAppContainer.CreateClienteService: TClienteService;
var
  LRepository: IClienteRepository;
begin
  LRepository := TFireDACClienteRepository.Create;

  Result      := TClienteService.Create(LRepository);
end;

end.
