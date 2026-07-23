{
  * Local onde montamos as dependências
}
unit AppContainer;

interface

uses
  CustomerService;

type
  TAppContainer = class
  public
    class function CreateCustomerService:
      TCustomerService;
  end;

implementation

uses
  CustomerRepository,
  MemoryCustomerRepository;

class function TAppContainer.CreateCustomerService:
  TCustomerService;
var
  LRepository: ICustomerRepository;
begin
  LRepository :=
    TMemoryCustomerRepository.Create;

  Result :=
    TCustomerService.Create(
      LRepository
    );
end;

end.
