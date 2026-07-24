{

Processo é chamado frequentemente de mapeamento objeto-relacional,
embora aqui estejamos fazendo o mapeamento manualmente, sem ORM.

}
unit FireDACClienteRepository;

interface

uses
  System.Generics.Collections,
  Cliente,
  ClienteRepository,
  DatabaseConnection;

type
  TFireDACClienteRepository = class(
    TInterfacedObject,
    IClienteRepository
  )
  private
    FDatabase: TDatabaseConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function FindAll:
      TObjectList<TCliente>;

    function FindById(
      AId: Integer
    ): TCliente;

    function ExistsByDocument(
      const ADocument: string
    ): Boolean;

    function ExistsByDocumentExceptId(
      const ADocument: string;
      AId: Integer
    ): Boolean;

    function Add(
      ACliente: TCliente
    ): TCliente;

    function Update(
      ACliente: TCliente
    ): TCliente;

    procedure Deactivate(
      AId: Integer
    );

  end;

implementation

uses
  FireDAC.Comp.Client,
  System.SysUtils;

constructor TFireDACClienteRepository.Create;
begin
  inherited Create;

  FDatabase := TDatabaseConnection.Create;
  FDatabase.Connect;
end;

destructor TFireDACClienteRepository.Destroy;
begin
  FDatabase.Free;

  inherited;
end;
                                   // GET
function TFireDACClienteRepository.FindAll:
  TObjectList<TCliente>;
var
  LQuery: TFDQuery;
  LCliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create(True);

  LQuery := TFDQuery.Create(nil);

  try
    try
      LQuery.Connection := FDatabase.Connection;

      LQuery.SQL.Text :=
        'SELECT ' +
        '  ID, ' +
        '  NAME, ' +
        '  DOCUMENT, ' +
        '  EMAIL, ' +
        '  ACTIVE ' +
        'FROM CLIENTE ' +
        'ORDER BY ID';

      LQuery.Open;

      while not LQuery.Eof do
      begin
        LCliente := TCliente.Create;

        LCliente.Id       := LQuery.FieldByName('ID').AsInteger;
        LCliente.Name     := LQuery.FieldByName('NAME').AsString;
        LCliente.Document := LQuery.FieldByName('DOCUMENT').AsString;
        LCliente.Email    := LQuery.FieldByName('EMAIL').AsString;
        LCliente.Active   := LQuery.FieldByName('ACTIVE').AsBoolean;

        Result.Add(LCliente);

        LQuery.Next;
      end;

    except
      Result.Free;
      raise;
    end;

  finally
    LQuery.Free;
  end;
end;

function TFireDACClienteRepository.FindById(
  AId: Integer
): TCliente;
var
  LQuery: TFDQuery;
begin
  Result := nil;

  LQuery := TFDQuery.Create(nil);

  try
    LQuery.Connection := FDatabase.Connection;

    LQuery.SQL.Text :=
      'SELECT ' +
      '  ID, ' +
      '  NAME, ' +
      '  DOCUMENT, ' +
      '  EMAIL, ' +
      '  ACTIVE ' +
      'FROM CLIENTE ' +
      'WHERE ID = :ID';

    LQuery.ParamByName('ID').AsInteger := AId;

    LQuery.Open;

    if LQuery.IsEmpty then
      Exit;

    Result          := TCliente.Create;

    Result.Id       := LQuery.FieldByName('ID').AsInteger;
    Result.Name     := LQuery.FieldByName('NAME').AsString;
    Result.Document := LQuery.FieldByName('DOCUMENT').AsString;
    Result.Email    := LQuery.FieldByName('EMAIL').AsString;
    Result.Active   := LQuery.FieldByName('ACTIVE').AsBoolean;

  finally
    LQuery.Free;
  end;
end;
                                   // POST
function TFireDACClienteRepository.Add(
  ACliente: TCliente
): TCliente;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);

  try
    LQuery.Connection := FDatabase.Connection;

    FDatabase.Connection.StartTransaction;

    try
      LQuery.SQL.Text :=
        'INSERT INTO CLIENTE ( ' +
        '  NAME, ' +
        '  DOCUMENT, ' +
        '  EMAIL, ' +
        '  ACTIVE ' +
        ') VALUES ( ' +
        '  :NAME, ' +
        '  :DOCUMENT, ' +
        '  :EMAIL, ' +
        '  :ACTIVE ' +
        ') ' +
        'RETURNING ID';

      LQuery.ParamByName('NAME').AsString     := ACliente.Name;
      LQuery.ParamByName('DOCUMENT').AsString := ACliente.Document;
      LQuery.ParamByName('EMAIL').AsString    := ACliente.Email;
      LQuery.ParamByName('ACTIVE').AsBoolean  := ACliente.Active;

      LQuery.Open;

      ACliente.Id := LQuery.FieldByName('ID').AsInteger;

      FDatabase.Connection.Commit;

      Result := ACliente;

    except
      if FDatabase.Connection.InTransaction then
        FDatabase.Connection.Rollback;

      raise;
    end;

  finally
    LQuery.Free;
  end;
end;

function TFireDACClienteRepository.ExistsByDocument(
  const ADocument: string
): Boolean;
var
  LQuery: TFDQuery;
begin
  Result := False;

  LQuery := TFDQuery.Create(nil);

  try
    LQuery.Connection := FDatabase.Connection;

    LQuery.SQL.Text :=
      'SELECT FIRST 1 ID ' +
      'FROM CLIENTE ' +
      'WHERE DOCUMENT = :DOCUMENT';

    LQuery.ParamByName('DOCUMENT').AsString := Trim(ADocument);

    LQuery.Open;

    Result := not LQuery.IsEmpty;

  finally
    LQuery.Free;
  end;
end;

function TFireDACClienteRepository.ExistsByDocumentExceptId(
  const ADocument: string;
  AId: Integer
): Boolean;
var
  LQuery: TFDQuery;
begin
  Result := False;

  LQuery := TFDQuery.Create(nil);

  try

    LQuery.Connection := FDatabase.Connection;

    LQuery.SQL.Text :=
      'SELECT FIRST 1 ID ' +
      'FROM CLIENTE ' +
      'WHERE DOCUMENT = :DOCUMENT ' +
      'AND ID <> :ID';

    LQuery.ParamByName('DOCUMENT').AsString := Trim(ADocument);
    LQuery.ParamByName('ID').AsInteger      := AId;
    LQuery.Open;

    Result := not LQuery.IsEmpty;

  finally

    LQuery.Free;

  end;
end;
                                   // PUT
function TFireDACClienteRepository.Update(
  ACliente: TCliente
): TCliente;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);

  try

    LQuery.Connection := FDatabase.Connection;
    FDatabase.Connection.StartTransaction;

    try

      LQuery.SQL.Text :=
        'UPDATE CLIENTE SET ' +
        '  NAME = :NAME, ' +
        '  DOCUMENT = :DOCUMENT, ' +
        '  EMAIL = :EMAIL, ' +
        '  ACTIVE = :ACTIVE ' +
        'WHERE ID = :ID';

      LQuery.ParamByName('NAME').AsString     := ACliente.Name;
      LQuery.ParamByName('DOCUMENT').AsString := ACliente.Document;
      LQuery.ParamByName('EMAIL').AsString    := ACliente.Email;
      LQuery.ParamByName('ACTIVE').AsBoolean  := ACliente.Active;
      LQuery.ParamByName('ID').AsInteger      := ACliente.Id;
      LQuery.ExecSQL;

      FDatabase.Connection.Commit;

      Result := ACliente;

    except

      if FDatabase.Connection.InTransaction then
        FDatabase.Connection.Rollback;

      raise;

    end;

  finally

    LQuery.Free;

  end;
end;
                                     // DELETE
procedure TFireDACClienteRepository.Deactivate(
  AId: Integer
);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);

  try

    LQuery.Connection := FDatabase.Connection;

    FDatabase.Connection.StartTransaction;

    try

      LQuery.SQL.Text :=
        'UPDATE CLIENTE ' +
        'SET ACTIVE = :ACTIVE ' +
        'WHERE ID = :ID';

      LQuery.ParamByName('ACTIVE').AsBoolean := False;
      LQuery.ParamByName('ID').AsInteger     := AId;

      LQuery.ExecSQL;

      FDatabase.Connection.Commit;

    except

      if FDatabase.Connection.InTransaction then
        FDatabase.Connection.Rollback;

      raise;

    end;

  finally

    LQuery.Free;

  end;
end;

end.
