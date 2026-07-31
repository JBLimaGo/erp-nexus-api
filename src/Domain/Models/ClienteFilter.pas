unit ClienteFilter;

interface

type
  TClienteFilter = class
  private
    FPage: Integer;
    FPageSize: Integer;
    FName: string;
    FDocument: string;
    FActive: string;

  public
    constructor Create;

    property Page: Integer
      read FPage
      write FPage;

    property PageSize: Integer
      read FPageSize
      write FPageSize;

    property Name: string
      read FName
      write FName;

    property Document: string
      read FDocument
      write FDocument;

    property Active: string
      read FActive
      write FActive;
  end;

implementation

constructor TClienteFilter.Create;
begin
  inherited Create;

  FPage := 1;
  FPageSize := 20;

  FName := '';
  FDocument := '';
  FActive := '';
end;

end.
