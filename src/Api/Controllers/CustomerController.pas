{
   Criação
   HTTP + JSON

}

unit CustomerController;

interface

uses
  Horse;

type
  TCustomerController = class
  public
    class procedure List(              // GET Lista Todos
      Req: THorseRequest;
      Res: THorseResponse
    );

    class procedure FindById(          // GET Lista um ID Especifico
      Req: THorseRequest;
      Res: THorseResponse
    );

    class procedure CreateCustomer(    // POST novo registro
      Req: THorseRequest;
      Res: THorseResponse
    );

  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  Customer,
  CustomerDTO,
  CustomerService,
  System.Generics.Collections,
  AppContainer;

               // Lista Todos do Array
class procedure TCustomerController.List(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LService: TCustomerService;
  LCustomers: TObjectList<TCustomer>;
  LCustomer: TCustomer;
  LArray: TJSONArray;
  LJSON: TJSONObject;
begin
  LService := nil;
  LCustomers := nil;
  LArray := nil;

  try
    LService :=
      TAppContainer.CreateCustomerService;

    LCustomers :=
      LService.ListCustomers;

    LArray := TJSONArray.Create;

    for LCustomer in LCustomers do
    begin
      LJSON := TJSONObject.Create;

      LJSON.AddPair(
        'id',
        TJSONNumber.Create(LCustomer.Id)
      );

      LJSON.AddPair(
        'name',
        LCustomer.Name
      );

      LJSON.AddPair(
        'document',
        LCustomer.Document
      );

      LJSON.AddPair(
        'email',
        LCustomer.Email
      );

      LJSON.AddPair(
        'active',
        TJSONBool.Create(
          LCustomer.Active
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
    LCustomers.Free;
    LService.Free;
  end;
end;

               // Lista Por ID
class procedure TCustomerController.FindById(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LId: Integer;
  LService: TCustomerService;
  LCustomer: TCustomer;
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
        '{"error":"INVALID_CUSTOMER_ID",' +
        '"message":"O ID do cliente deve ser um número inteiro válido."}'
      );

    Exit;
  end;

  LService := nil;
  LCustomer := nil;
  LJSON := nil;

  try
    LService :=
      TAppContainer.CreateCustomerService;

    LCustomer :=
      LService.FindCustomerById(LId);

    if not Assigned(LCustomer) then
    begin
      Res
        .Status(404)
        .ContentType('application/json')
        .Send(
          '{"error":"CUSTOMER_NOT_FOUND",' +
          '"message":"Cliente não encontrado"}'
        );

      Exit;
    end;

    LJSON := TJSONObject.Create;

    LJSON.AddPair(
      'id',
      TJSONNumber.Create(LCustomer.Id)
    );

    LJSON.AddPair(
      'name',
      LCustomer.Name
    );

    LJSON.AddPair(
      'document',
      LCustomer.Document
    );

    LJSON.AddPair(
      'email',
      LCustomer.Email
    );

    LJSON.AddPair(
      'active',
      TJSONBool.Create(
        LCustomer.Active
      )
    );

    Res
      .Status(200)
      .ContentType('application/json')
      .Send(LJSON.ToJSON);

  finally
    LJSON.Free;
    LCustomer.Free;
    LService.Free;
  end;
end;

      // Cria um registro novo
class procedure TCustomerController.CreateCustomer(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LBody: TJSONObject;
  LDTO: TCreateCustomerDTO;
  LCustomer: TCustomer;
  LResponse: TJSONObject;
  LService: TCustomerService;
begin
  LBody := nil;
  LDTO := nil;
  LCustomer := nil;
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

    LDTO := TCreateCustomerDTO.Create;

    LDTO.Name := LBody.GetValue<string>(
      'name',
      ''
    );

    LDTO.Document := LBody.GetValue<string>(
      'document',
      ''
    );

    LDTO.Email := LBody.GetValue<string>(
      'email',
      ''
    );

    LDTO.Active := LBody.GetValue<Boolean>(
      'active',
      True
    );

    try
      LService  := TAppContainer.CreateCustomerService;
      LCustomer := LService.CreateCustomer(LDTO);

    except
      on E: Exception do
      begin
        Res
          .Status(400)
          .ContentType('application/json')
          .Send(
            '{"error":"VALIDATION_ERROR",' +
            '"message":"' +
            E.Message +
            '"}'
          );

        Exit;
      end;
    end;

    LResponse := TJSONObject.Create;

    LResponse.AddPair(
      'id',
      TJSONNumber.Create(
        LCustomer.Id
      )
    );

    LResponse.AddPair(
      'name',
      LCustomer.Name
    );

    LResponse.AddPair(
      'document',
      LCustomer.Document
    );

    LResponse.AddPair(
      'email',
      LCustomer.Email
    );

    LResponse.AddPair(
      'active',
      TJSONBool.Create(
        LCustomer.Active
      )
    );

    Res
      .Status(201)
      .ContentType('application/json')
      .Send(LResponse.ToJSON);

  finally
    LResponse.Free;
    LCustomer.Free;
    LDTO.Free;
    LBody.Free;
    LService.Free;
  end;
end;


end.
