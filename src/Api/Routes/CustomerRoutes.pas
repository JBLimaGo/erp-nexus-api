{

  conhece endpoint/verbo

}

unit CustomerRoutes;

interface

procedure RegisterCustomerRoutes;

implementation

uses
  Horse,
  CustomerController;

procedure RegisterCustomerRoutes;
begin
  THorse.Get(
    '/api/v1/customers',
    procedure(
      Req: THorseRequest;
      Res: THorseResponse
    )
    begin
      TCustomerController.List(Req, Res);
    end
  );

   THorse.Get(
    '/api/v1/customers/:id',
    procedure(
      Req: THorseRequest;
      Res: THorseResponse
    )
    begin
      TCustomerController.FindById(Req, Res);
    end
  );

  THorse.Post(
    '/api/v1/customers',
    procedure(
      Req: THorseRequest;
      Res: THorseResponse
    )
    begin
      TCustomerController.CreateCustomer(
        Req,
        Res
      );
    end
  );

end;

end.
