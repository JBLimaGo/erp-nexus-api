{
  modelo do domínio
}

unit Customer;

interface

type
  TCustomer = class
  private
    FId: Integer;
    FName: string;
    FDocument: string;
    FEmail: string;
    FActive: Boolean;
  public
    property Id: Integer
      read FId
      write FId;

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

end.
