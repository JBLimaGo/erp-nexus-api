unit MemoryCustomerRepository;

interface

uses
  System.Generics.Collections,
  Customer,
  CustomerRepository;

type
  TMemoryCustomerRepository = class(
    TInterfacedObject,
    ICustomerRepository
  )
  private
    class var FCustomers: TObjectList<TCustomer>;
    class var FNextId: Integer;

    class procedure Initialize;
  public
    constructor Create;

    function FindAll: TObjectList<TCustomer>;

    function FindById(
      AId: Integer
    ): TCustomer;

    function Add(
      ACustomer: TCustomer
    ): TCustomer;
  end;

implementation

constructor TMemoryCustomerRepository.Create;
begin
  inherited Create;

  Initialize;
end;

class procedure TMemoryCustomerRepository.Initialize;
var
  LCustomer: TCustomer;
begin
  if Assigned(FCustomers) then
    Exit;

  FCustomers := TObjectList<TCustomer>.Create(True);

  LCustomer := TCustomer.Create;
  LCustomer.Id := 1;
  LCustomer.Name := 'Empresa Alpha Ltda';
  LCustomer.Document := '12345678000190';
  LCustomer.Email := 'contato@empresaalpha.com.br';
  LCustomer.Active := True;

  FCustomers.Add(LCustomer);

  LCustomer := TCustomer.Create;
  LCustomer.Id := 2;
  LCustomer.Name := 'Comercial Beta Ltda';
  LCustomer.Document := '98765432000110';
  LCustomer.Email := 'contato@comercialbeta.com.br';
  LCustomer.Active := True;

  FCustomers.Add(LCustomer);

  FNextId := 3;
end;

function TMemoryCustomerRepository.FindAll:
  TObjectList<TCustomer>;
var
  LCustomer: TCustomer;
  LCopy: TCustomer;
begin
  Result := TObjectList<TCustomer>.Create(True);

  for LCustomer in FCustomers do
  begin
    LCopy := TCustomer.Create;

    LCopy.Id := LCustomer.Id;
    LCopy.Name := LCustomer.Name;
    LCopy.Document := LCustomer.Document;
    LCopy.Email := LCustomer.Email;
    LCopy.Active := LCustomer.Active;

    Result.Add(LCopy);
  end;
end;

function TMemoryCustomerRepository.FindById(
  AId: Integer
): TCustomer;
var
  LCustomer: TCustomer;
begin
  Result := nil;

  for LCustomer in FCustomers do
  begin
    if LCustomer.Id = AId then
    begin
      Result := TCustomer.Create;

      Result.Id := LCustomer.Id;
      Result.Name := LCustomer.Name;
      Result.Document := LCustomer.Document;
      Result.Email := LCustomer.Email;
      Result.Active := LCustomer.Active;

      Exit;
    end;
  end;
end;

function TMemoryCustomerRepository.Add(
  ACustomer: TCustomer
): TCustomer;
var
  LStoredCustomer: TCustomer;
begin
  ACustomer.Id := FNextId;
  Inc(FNextId);

  LStoredCustomer := TCustomer.Create;

  LStoredCustomer.Id := ACustomer.Id;
  LStoredCustomer.Name := ACustomer.Name;
  LStoredCustomer.Document := ACustomer.Document;
  LStoredCustomer.Email := ACustomer.Email;
  LStoredCustomer.Active := ACustomer.Active;

  FCustomers.Add(LStoredCustomer);

  Result := ACustomer;
end;

end.
