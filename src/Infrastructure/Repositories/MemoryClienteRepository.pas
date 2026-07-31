unit MemoryClienteRepository;

interface

uses
  System.Generics.Collections,
  Cliente,
  ClienteRepository,
  ClienteFilter;

type
  TMemoryClienteRepository = class(
    TInterfacedObject,
    IClienteRepository
  )
  private
    class var FClientes: TObjectList<TCliente>;
    class var FNextId: Integer;

    class procedure Initialize;
  public
    constructor Create;

    function FindAll:
     TObjectList<TCliente>;

    function FindById(
      AId: Integer
    ): TCliente;

    function FindAllPaged(
      AFilter: TClienteFilter
    ): TObjectList<TCliente>;

     function Count(
      AFilter: TClienteFilter
    ): Integer;

    function ExistsByDocument(
      const ADocument: string
    ): Boolean;

    function ExistsByDocumentExceptId(
      const ADocument: string;
      AId: Integer
    ): Boolean;

    function Add(
      ACliente: TCliente
    ): TCliente;

    function Update(
      ACliente: TCliente
    ): TCliente;

    procedure Deactivate(
      AId: Integer
    );

  end;

implementation

  uses
    System.SysUtils;

constructor TMemoryClienteRepository.Create;
begin
  inherited Create;

  Initialize;
end;

class procedure TMemoryClienteRepository.Initialize;
var
  LCliente: TCliente;
begin
  if Assigned(FClientes) then
    Exit;

  FClientes := TObjectList<TCliente>.Create(True);

  LCliente          := TCliente.Create;
  LCliente.Id       := 1;
  LCliente.Name     := 'Empresa Alpha Ltda';
  LCliente.Document := '12345678000190';
  LCliente.Email    := 'contato@empresaalpha.com.br';
  LCliente.Active   := True;

  FClientes.Add(LCliente);

  LCliente          := TCliente.Create;
  LCliente.Id       := 2;
  LCliente.Name     := 'Comercial Beta Ltda';
  LCliente.Document := '98765432000110';
  LCliente.Email    := 'contato@comercialbeta.com.br';
  LCliente.Active   := True;

  FClientes.Add(LCliente);

  FNextId := 3;
end;

function TMemoryClienteRepository.FindById(
  AId: Integer
): TCliente;
var
  LCliente: TCliente;
begin
  Result := nil;

  for LCliente in FClientes do
    begin
      if LCliente.Id = AId then
        begin
          Result          := TCliente.Create;

          Result.Id       := LCliente.Id;
          Result.Name     := LCliente.Name;
          Result.Document := LCliente.Document;
          Result.Email    := LCliente.Email;
          Result.Active   := LCliente.Active;

          Exit;
        end;
    end;
end;

function TMemoryClienteRepository.Add(
  ACliente: TCliente
): TCliente;
var
  LStoredCliente: TCliente;
begin
  ACliente.Id := FNextId;
  Inc(FNextId);

  LStoredCliente          := TCliente.Create;

  LStoredCliente.Id       := ACliente.Id;
  LStoredCliente.Name     := ACliente.Name;
  LStoredCliente.Document := ACliente.Document;
  LStoredCliente.Email    := ACliente.Email;
  LStoredCliente.Active   := ACliente.Active;

  FClientes.Add(LStoredCliente);

  Result := ACliente;
end;

function TMemoryClienteRepository.ExistsByDocument(
  const ADocument: string
): Boolean;
var
  LCliente: TCliente;
begin
  Result := False;

  for LCliente in FClientes do
    begin
      if SameText(Trim(LCliente.Document),Trim(ADocument)) then
        begin
          Result := True;
          Exit;
        end;
    end;
end;

function TMemoryClienteRepository.ExistsByDocumentExceptId(
  const ADocument: string;
  AId: Integer
): Boolean;
var
  LCliente: TCliente;
begin
  Result := False;

  for LCliente in FClientes do
    begin
      if (LCliente.Id <> AId) and SameText(Trim(LCliente.Document), Trim(ADocument)) then
        begin
          Result := True;
          Exit;
        end;
    end;
end;

function TMemoryClienteRepository.Update(
  ACliente: TCliente
): TCliente;
var
  LCliente: TCliente;
begin
  Result := nil;

  for LCliente in FClientes do
    begin
      if LCliente.Id = ACliente.Id then
        begin

          LCliente.Name     := ACliente.Name;
          LCliente.Document := ACliente.Document;
          LCliente.Email    := ACliente.Email;
          LCliente.Active   := ACliente.Active;

          Result := LCliente;

          Exit;
        end;
    end;
end;

procedure TMemoryClienteRepository.Deactivate(
  AId: Integer
);
var
  LCliente: TCliente;
begin
  for LCliente in FClientes do
    begin
      if LCliente.Id = AId then
        begin
          LCliente.Active := False;
          Exit;
        end;
    end;
end;

function TMemoryClienteRepository.FindAll: TObjectList<TCliente>;
var
  LCliente: TCliente;
  LCopy: TCliente;
begin
  Result := TObjectList<TCliente>.Create(True);

  for LCliente in FClientes do
  begin
    LCopy := TCliente.Create;

    LCopy.Id       := LCliente.Id;
    LCopy.Name     := LCliente.Name;
    LCopy.Document := LCliente.Document;
    LCopy.Email    := LCliente.Email;
    LCopy.Active   := LCliente.Active;

    Result.Add(LCopy);
  end;
end;

function TMemoryClienteRepository.FindAllPaged(
  AFilter: TClienteFilter
): TObjectList<TCliente>;
begin
  // Temporariamente reutiliza o método existente.
  Result := FindAll;
end;

function TMemoryClienteRepository.Count(
  AFilter: TClienteFilter
): Integer;
begin
  Result := FClientes.Count;
end;

end.
