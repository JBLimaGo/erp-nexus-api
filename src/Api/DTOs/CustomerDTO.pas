{

   dados de entrada

}

unit CustomerDTO;

interface

type
  TCreateCustomerDTO = class
  private
    FName: string;
    FDocument: string;
    FEmail: string;
    FActive: Boolean;
  public
    constructor Create;

    property Name: string
      read FName
      write FName;

    property Document: string
      read FDocument
      write FDocument;

    property Email: string
      read FEmail
      write FEmail;

    property Active: Boolean
      read FActive
      write FActive;
  end;

implementation

constructor TCreateCustomerDTO.Create;
begin
  inherited Create;

  FActive := True;
end;

end.
