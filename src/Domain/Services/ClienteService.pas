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

    function FindClienteById(
      AId: Integer
    ): TCliente;

    function CreateCliente(
      ADTO: TCreateClienteDTO
    ): TCliente;
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

end.
