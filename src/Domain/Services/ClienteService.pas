{

  * Service é onde colocamos casos de uso e regras da aplicação/domínio
  * Regras / caso de uso
  * Valida Regras

}

unit ClienteService;

interface

uses
  System.Generics.Collections,
  Cliente,
  ClienteDTO,
  ClienteRepository;

type
  TClienteService = class
  private
    FRepository: IClienteRepository;
  public
    constructor Create(
      ARepository: IClienteRepository
    );

    function ListClientes:
      TObjectList<TCliente>;

    function FindClienteById(      // GET
      AId: Integer
    ): TCliente;

    function CreateCliente(        // POST
      ADTO: TCreateClienteDTO
    ): TCliente;

    function UpdateCliente(        // PUT
      AId: Integer;
      ADTO: TUpdateClienteDTO
    ): TCliente;

    procedure DeactivateCliente(   // DELETE
      AId: Integer
    );

  end;

implementation

uses
  System.SysUtils,
  DomainExceptions;

constructor TClienteService.Create(
  ARepository: IClienteRepository
);
begin
  inherited Create;

  FRepository := ARepository;
end;

function TClienteService.ListClientes:
  TObjectList<TCliente>;
begin
  Result := FRepository.FindAll;
end;

function TClienteService.FindClienteById(
  AId: Integer
): TCliente;
begin
  Result := FRepository.FindById(AId);
end;

                         // POST
function TClienteService.CreateCliente(
  ADTO: TCreateClienteDTO
): TCliente;
begin
  if Trim(ADTO.Name) = '' then
    raise EValidationException.Create(
      'O nome do cliente é obrigatório');

  if Trim(ADTO.Document) = '' then
    raise EValidationException.Create(
      'O documento do cliente é obrigatório');

  if FRepository.ExistsByDocument(
    Trim(ADTO.Document)
  ) then
    raise EConflictException.Create(
      'Já existe um cliente com este documento');

  Result := TCliente.Create;

  try
    Result.Name     := Trim(ADTO.Name);
    Result.Document := Trim(ADTO.Document);
    Result.Email    := Trim(ADTO.Email);
    Result.Active   := ADTO.Active;

    FRepository.Add(Result);

  except
    Result.Free;
    raise;
  end;
end;
                         // PUT
function TClienteService.UpdateCliente(
  AId: Integer;
  ADTO: TUpdateClienteDTO
): TCliente;
var
  LCliente: TCliente;
begin
  { 1. Validar o ID }
  if AId <= 0 then
    raise EValidationException.Create(
      'O ID do cliente deve ser maior que zero'
    );

  { 2. Garantir que recebemos os dados }
  if not Assigned(ADTO) then
    raise EValidationException.Create(
      'Os dados do cliente são obrigatórios'
    );

  { 3. Validar campos obrigatórios }
  if Trim(ADTO.Name) = '' then
    raise EValidationException.Create(
      'O nome do cliente é obrigatório'
    );

  if Trim(ADTO.Document) = '' then
    raise EValidationException.Create(
      'O documento do cliente é obrigatório'
    );

  { 4. Procurar o cliente atual }
  LCliente := FRepository.FindById(AId);

  if not Assigned(LCliente) then
    raise ENotFoundException.Create(
      'Cliente não encontrado'
    );

  try

    { 5. Verificar conflito com OUTRO cliente }
    if FRepository.ExistsByDocumentExceptId(Trim(ADTO.Document),AId) then
      raise EConflictException.Create(
        'Já existe outro cliente com este documento'
      );

    { 6. Atualizar o objeto existente }
    LCliente.Name     := Trim(ADTO.Name);
    LCliente.Document := Trim(ADTO.Document);
    LCliente.Email    := Trim(ADTO.Email);
    LCliente.Active   := ADTO.Active;

    { 7. Persistir }
    Result := FRepository.Update(LCliente);

  except

    LCliente.Free;

    raise;

  end;
end;
                          // DELETE
procedure TClienteService.DeactivateCliente(
  AId: Integer
);
var
  LCliente: TCliente;
begin
  { 1. Validar o ID }
  if AId <= 0 then
    raise EValidationException.Create(
      'O ID do cliente deve ser maior que zero'
    );

  { 2. Procurar o cliente }
  LCliente := FRepository.FindById(AId);

  if not Assigned(LCliente) then
    raise ENotFoundException.Create(
      'Cliente não encontrado'
    );

  try

    { 3. DELETE deve ser idempotente }
    if not LCliente.Active then
      Exit;

    { 4. Realizar a inativação }
    FRepository.Deactivate(AId);

  finally

    LCliente.Free;

  end;
end;


end.
