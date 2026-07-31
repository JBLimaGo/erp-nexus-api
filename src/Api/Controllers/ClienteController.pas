{
   Criacao
   HTTP + JSON

   CRUD CLIENTES

CREATE
POST /clientes                 ✅

READ
GET /clientes                  ✅
GET /clientes/:id              ✅

UPDATE
PUT /clientes/:id              ✅

DELETE / SOFT DELETE
DELETE /clientes/:id           ✅

}

unit ClienteController;

interface

uses
  Horse,
  Cliente,
  ClienteFilter,
  System.JSON;

type
  TClienteController = class
  public
    class procedure List(              // GET Lista Todos
      Req: THorseRequest;
      Res: THorseResponse
    );

    class procedure FindById(          // GET Lista um ID Especifico
      Req: THorseRequest;
      Res: THorseResponse
    );

    class procedure CreateCliente(    // POST novo registro
      Req: THorseRequest;
      Res: THorseResponse
    );

    class procedure Update(           // PUT em Registro no Banco de Dados
      Req: THorseRequest;
      Res: THorseResponse
    );

    class procedure Deactivate(       // DELETE um registro, mais ira inativar pois futuramente
      Req: THorseRequest;             // esse cliente pode ter vendas, notas, pedidos, relacionados a esse cliente
      Res: THorseResponse             // com isso não podemos perder o historico desse cliente.
    );

    class function ClienteToJSON(
      ACliente: TCliente
    ): TJSONObject;

    class function CreateFilter(
      Req: THorseRequest
    ): TClienteFilter;

    class function ReadInteger(
      const AValue: string;
      const ADefault: Integer;
      const AErrorMessage: string
    ): Integer;

  end;

implementation

uses
  System.SysUtils,
  ClienteDTO,
  ClienteService,
  System.Generics.Collections,
  AppContainer,
  DomainExceptions;

const
  DEFAULT_PAGE = 1;
  DEFAULT_PAGE_SIZE = 20;
  MAX_PAGE_SIZE = 100;

  MSG_INVALID_PAGE =
    'O parâmetro page deve ser um número inteiro.';

  MSG_INVALID_PAGE_SIZE =
    'O parâmetro pageSize deve ser um número inteiro.';

class function TClienteController.ClienteToJSON(
  ACliente: TCliente): TJSONObject;
begin
  Result := TJSONObject.Create;

  Result.AddPair('id', TJSONNumber.Create(ACliente.Id));
  Result.AddPair('name', ACliente.Name);
  Result.AddPair('document', ACliente.Document);
  Result.AddPair('email', ACliente.Email);
  Result.AddPair('active', TJSONBool.Create(ACliente.Active));
end;

               // Lista Todos do Array
class procedure TClienteController.List(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LService: TClienteService;
  LClientes: TObjectList<TCliente>;
  LFilter: TClienteFilter;
  LCliente: TCliente;
  LArray: TJSONArray;
  LJSON: TJSONObject;
begin
  LService := nil;
  LClientes := nil;
  LFilter := nil;
  LArray := nil;

  try
    { Cria o filtro }
    LFilter := CreateFilter(Req);

    { Cria o Service }
    LService := TAppContainer.CreateClienteService;

    { Busca os clientes }
    LClientes := LService.ListClientes(LFilter);

    { Cria o JSON }
    LArray := TJSONArray.Create;

    for LCliente in LClientes do
    begin
      LJSON := ClienteToJSON(LCliente);
      LArray.AddElement(LJSON);
    end;

    Res.Status(200)
       .ContentType('application/json')
       .Send(LArray.ToJSON);

  finally
    LArray.Free;
    LClientes.Free;
    LFilter.Free;
    LService.Free;
  end;
end;

               // Lista Por ID
class procedure TClienteController.FindById(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LId: Integer;
  LService: TClienteService;
  LCliente: TCliente;
  LJSON: TJSONObject;
begin
  if not TryStrToInt(Req.Params['id'],LId) then
  begin
    Res.Status(400)
       .ContentType('application/json')
       .Send(
        '{"error":"INVALID_CLIENTE_ID",' +
        '"message":"O ID do cliente deve ser um número inteiro válido."}'
      );

    Exit;
  end;

  LService := nil;
  LCliente := nil;
  LJSON := nil;

  try
    LService := TAppContainer.CreateClienteService;
    LCliente := LService.FindClienteById(LId);

    if not Assigned(LCliente) then
    begin
      Res.Status(404)
         .ContentType('application/json')
         .Send(
          '{"error":"CLIENTE_NOT_FOUND",' +
          '"message":"Cliente não encontrado"}'
        );

      Exit;
    end;

    LJSON := TJSONObject.Create;

   { LJSON.AddPair('id',TJSONNumber.Create(LCliente.Id));
    LJSON.AddPair('name',LCliente.Name);
    LJSON.AddPair('document',LCliente.Document);
    LJSON.AddPair('email',LCliente.Email);
    LJSON.AddPair('active',TJSONBool.Create(LCliente.Active)
    );   }

    LJSON := ClienteToJSON(LCliente);

    Res.Status(200)
       .ContentType('application/json')
       .Send(LJSON.ToJSON);

  finally
    LJSON.Free;
    LCliente.Free;
    LService.Free;
  end;
end;

      // Cria um registro novo
class procedure TClienteController.CreateCliente(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LBody: TJSONObject;
  LDTO: TCreateClienteDTO;
  LCliente: TCliente;
  LResponse: TJSONObject;
  LService: TClienteService;
begin
  LBody := nil;
  LDTO := nil;
  LCliente := nil;
  LResponse := nil;
  LService  := nil;

  try
    LBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

    if not Assigned(LBody) then
    begin
      Res
        .Status(400)
        .ContentType('application/json')
        .Send(
          '{"error":"INVALID_JSON",' +
          '"message":"O corpo da requisição deve conter um JSON válido."}'
        );

      Exit;
    end;

    LDTO := TCreateClienteDTO.Create;

    LDTO.Name     := LBody.GetValue<string>('name','');
    LDTO.Document := LBody.GetValue<string>('document','');
    LDTO.Email    := LBody.GetValue<string>('email','');
    LDTO.Active   := LBody.GetValue<Boolean>('active',True);

   // LService  := TAppContainer.CreateClienteService;
   // LCliente  := LService.CreateCliente(LDTO);
    LResponse := TJSONObject.Create;

    {

    LResponse.AddPair('id', TJSONNumber.Create(LCliente.Id));
    LResponse.AddPair('name', LCliente.Name);
    LResponse.AddPair('document', LCliente.Document);
    LResponse.AddPair('email', LCliente.Email);
    LResponse.AddPair('active', TJSONBool.Create(LCliente.Active)); }

    LResponse := ClienteToJSON(LCliente);

    Res.Status(201)
       .ContentType('application/json')
       .Send(LResponse.ToJSON);

  finally
    LResponse.Free;
    LCliente.Free;
    LDTO.Free;
    LBody.Free;
    LService.Free;
  end;
end;

class function TClienteController.CreateFilter(
  Req: THorseRequest
): TClienteFilter;
var
  LPage: Integer;
  LPageSize: Integer;
begin
  LPage := ReadInteger(
    Req.Query.Field('page').AsString,
    DEFAULT_PAGE,
    MSG_INVALID_PAGE
  );

  if LPage < DEFAULT_PAGE then
    LPage := DEFAULT_PAGE;

  LPageSize := ReadInteger(
    Req.Query.Field('pageSize').AsString,
    DEFAULT_PAGE_SIZE,
    MSG_INVALID_PAGE_SIZE
  );

  if LPageSize < 1 then
    LPageSize := DEFAULT_PAGE_SIZE;

  if LPageSize > MAX_PAGE_SIZE then
    LPageSize := MAX_PAGE_SIZE;

  Result := TClienteFilter.Create;
  Result.Page := LPage;
  Result.PageSize := LPageSize;
  Result.Name := Req.Query.Field('name').AsString;
  Result.Document := Req.Query.Field('document').AsString;

  if Req.Query.ContainsKey('active') then
    Result.Active := Req.Query.Field('active').AsString;
end;

class function TClienteController.ReadInteger(
  const AValue: string;
  const ADefault: Integer;
  const AErrorMessage: string
): Integer;
begin
  if AValue.IsEmpty then
    Exit(ADefault);

  if not TryStrToInt(AValue, Result) then
    raise EValidationException.Create(AErrorMessage);
end;

// Realiza o PUT no registro update e alteração do registro
class procedure TClienteController.Update(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LId: Integer;
  LDTO: TUpdateClienteDTO;
  LCliente: TCliente;
  LService: TClienteService;
  LResponse: TJSONObject;
begin
  LDTO := nil;
  LCliente := nil;
  LService := nil;
  LResponse := nil;

  if not TryStrToInt(Req.Params['id'], LId) then
    raise EValidationException.Create(
      'ID do cliente inválido'
    );

  LDTO := TUpdateClienteDTO.FromJSON(Req.Body);

  try
    LService := TAppContainer.CreateClienteService;
    LCliente := LService.UpdateCliente(LId, LDTO);
    LResponse := TJSONObject.Create;

   { LResponse.AddPair('id',TJSONNumber.Create(LCliente.Id));
    LResponse.AddPair('name',LCliente.Name);
    LResponse.AddPair('document',LCliente.Document);
    LResponse.AddPair('email',LCliente.Email);
    LResponse.AddPair('active',TJSONBool.Create(LCliente.Active));   }

    LResponse := ClienteToJSON(LCliente);

    Res.Status(200)
       .ContentType('application/json')
       .Send(LResponse.ToJSON);

  finally
    LResponse.Free;
    LCliente.Free;
    LService.Free;
    LDTO.Free;
  end;
end;

       { DELETE - Realiza a desativação do registro cliente pois um cliente pode
                  ter registros relacionados a ele e com isso não podemos perder o
                  historico desse cliente.
       }
class procedure TClienteController.Deactivate(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LId: Integer;
  LService: TClienteService;
begin

  if not TryStrToInt(Req.Params['id'],LId) then
    raise EValidationException.Create(
      'ID do cliente inválido'
    );

  LService := TAppContainer.CreateClienteService;

  try

    LService.DeactivateCliente(LId);

    Res.Status(204);

  finally

    LService.Free;

  end;

end;

end.
