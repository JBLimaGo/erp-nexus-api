{
   Criacao
   HTTP + JSON

}

unit ClienteController;

interface

uses
  Horse;

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

  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  Cliente,
  ClienteDTO,
  ClienteService,
  System.Generics.Collections,
  AppContainer,
  DomainExceptions;

               // Lista Todos do Array
class procedure TClienteController.List(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LService: TClienteService;
  LClientes: TObjectList<TCliente>;
  LCliente: TCliente;
  LArray: TJSONArray;
  LJSON: TJSONObject;
begin
  LService := nil;
  LClientes := nil;
  LArray := nil;

  try
    LService :=
      TAppContainer.CreateClienteService;

    LClientes :=
      LService.ListClientes;

    LArray := TJSONArray.Create;

    for LCliente in LClientes do
    begin
      LJSON := TJSONObject.Create;

      LJSON.AddPair(
        'id',
        TJSONNumber.Create(LCliente.Id)
      );

      LJSON.AddPair(
        'name',
        LCliente.Name
      );

      LJSON.AddPair(
        'document',
        LCliente.Document
      );

      LJSON.AddPair(
        'email',
        LCliente.Email
      );

      LJSON.AddPair(
        'active',
        TJSONBool.Create(
          LCliente.Active
        )
      );

      LArray.AddElement(LJSON);
    end;

    Res
      .Status(200)
      .ContentType('application/json')
      .Send(LArray.ToJSON);

  finally
    LArray.Free;
    LClientes.Free;
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
  if not TryStrToInt(
    Req.Params['id'],
    LId
  ) then
  begin
    Res
      .Status(400)
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
    LService :=
      TAppContainer.CreateClienteService;

    LCliente :=
      LService.FindClienteById(LId);

    if not Assigned(LCliente) then
    begin
      Res
        .Status(404)
        .ContentType('application/json')
        .Send(
          '{"error":"CLIENTE_NOT_FOUND",' +
          '"message":"Cliente não encontrado"}'
        );

      Exit;
    end;

    LJSON := TJSONObject.Create;

    LJSON.AddPair(
      'id',
      TJSONNumber.Create(LCliente.Id)
    );

    LJSON.AddPair(
      'name',
      LCliente.Name
    );

    LJSON.AddPair(
      'document',
      LCliente.Document
    );

    LJSON.AddPair(
      'email',
      LCliente.Email
    );

    LJSON.AddPair(
      'active',
      TJSONBool.Create(
        LCliente.Active
      )
    );

    Res
      .Status(200)
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
    LBody := TJSONObject.ParseJSONValue(
      Req.Body
    ) as TJSONObject;

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

    LService  := TAppContainer.CreateClienteService;
    LCliente := LService.CreateCliente(LDTO);

    LResponse := TJSONObject.Create;

    LResponse.AddPair('id', TJSONNumber.Create(LCliente.Id));
    LResponse.AddPair('name', LCliente.Name);
    LResponse.AddPair('document', LCliente.Document);
    LResponse.AddPair('email', LCliente.Email);
    LResponse.AddPair('active', TJSONBool.Create(LCliente.Active));

    Res
      .Status(201)
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


end.
