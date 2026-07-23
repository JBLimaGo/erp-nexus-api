{

  * Service é onde colocamos casos de uso e regras da aplicação/domínio
  * Regras / caso de uso
  * Valida Regras

}

unit CustomerService;

interface

uses
  System.Generics.Collections,
  Customer,
  CustomerDTO,
  CustomerRepository;

type
  TCustomerService = class
  private
    FRepository: ICustomerRepository;
  public
    constructor Create(
      ARepository: ICustomerRepository
    );

    function ListCustomers:
      TObjectList<TCustomer>;

    function FindCustomerById(
      AId: Integer
    ): TCustomer;

    function CreateCustomer(
      ADTO: TCreateCustomerDTO
    ): TCustomer;
  end;

implementation

uses
  System.SysUtils;

constructor TCustomerService.Create(
  ARepository: ICustomerRepository
);
begin
  inherited Create;

  FRepository := ARepository;
end;

function TCustomerService.ListCustomers:
  TObjectList<TCustomer>;
begin
  Result := FRepository.FindAll;
end;

function TCustomerService.FindCustomerById(
  AId: Integer
): TCustomer;
begin
  Result := FRepository.FindById(AId);
end;

function TCustomerService.CreateCustomer(
  ADTO: TCreateCustomerDTO
): TCustomer;
begin
  if Trim(ADTO.Name) = '' then
    raise Exception.Create(
      'O nome do campo e obrigatorio.'
    );

  if Trim(ADTO.Document) = '' then
    raise Exception.Create(
      'O nome do documento e obrigatorio.'
    );

  Result := TCustomer.Create;

  Result.Name := Trim(ADTO.Name);
  Result.Document := Trim(ADTO.Document);
  Result.Email := Trim(ADTO.Email);
  Result.Active := ADTO.Active;

  try
    FRepository.Add(Result);
  except
    Result.Free;
    raise;
  end;
end;

end.
