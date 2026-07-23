{

   dados de entrada

}

unit ClienteDTO;

interface

type
  TCreateClienteDTO = class
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

constructor TCreateClienteDTO.Create;
begin
  inherited Create;

  FActive := True;
end;

end.
