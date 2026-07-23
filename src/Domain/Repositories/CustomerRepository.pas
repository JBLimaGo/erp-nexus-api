{
  * Um componente responsável por fornecer e persistir dados do domínio no banco de dados.

}

unit CustomerRepository;

interface

uses
  System.Generics.Collections,
  Customer;

type
  ICustomerRepository = interface
    ['{C1526807-4A62-4C55-9557-A7C27E97AA01}']

    function FindAll: TObjectList<TCustomer>;

    function FindById(
      AId: Integer
    ): TCustomer;

    function Add(
      ACustomer: TCustomer
    ): TCustomer;
  end;

implementation

end.
