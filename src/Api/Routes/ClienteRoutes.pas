{

  conhece endpoint/verbo

}

unit ClienteRoutes;

interface

procedure RegisterClienteRoutes;

implementation

uses
  Horse,
  ClienteController;

procedure RegisterClienteRoutes;
begin
  THorse.Get(
    '/api/v1/clientes',
    procedure(
      Req: THorseRequest;
      Res: THorseResponse
    )
    begin
      TClienteController.List(Req, Res);
    end
  );

   THorse.Get(
    '/api/v1/clientes/:id',
    procedure(
      Req: THorseRequest;
      Res: THorseResponse
    )
    begin
      TClienteController.FindById(Req, Res);
    end
  );

  THorse.Post(
    '/api/v1/clientes',
    procedure(
      Req: THorseRequest;
      Res: THorseResponse
    )
    begin
      TClienteController.CreateCliente(
        Req,
        Res
      );
    end
  );

end;

end.
