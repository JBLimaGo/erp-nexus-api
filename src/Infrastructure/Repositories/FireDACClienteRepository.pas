{

Processo é chamado frequentemente de mapeamento objeto-relacional,
embora aqui estejamos fazendo o mapeamento manualmente, sem ORM.

}
unit FireDACClienteRepository;

interface

uses
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Cliente,
  ClienteRepository,
  DatabaseConnection,
  ClienteFilter;

type
  TFireDACClienteRepository = class(
    TInterfacedObject,
    IClienteRepository
  )
  private
    FDatabase: TDatabaseConnection;

    function CreateQuery: TFDQuery;

    function LoadClienteFromQuery(
      AQuery: TFDQuery
    ): TCliente;

    function BuildSelectSql(
      AFilter: TClienteFilter
    ): string;

    procedure BindSelectParams(
      AQuery: TFDQuery;
      AFilter: TClienteFilter;
      AStartRow: Integer;
      AEndRow: Integer
    );

  public
    constructor Create;
    destructor Destroy; override;

    function FindAll: TObjectList<TCliente>;

    function FindAllPaged(
      AFilter: TClienteFilter
    ): TObjectList<TCliente>;

    function Count(
      AFilter: TClienteFilter
    ): Integer;

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

function TFireDACClienteRepository.CreateQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDatabase.Connection;
end;

function TFireDACClienteRepository.LoadClienteFromQuery(
  AQuery: TFDQuery
): TCliente;
begin
  Result := TCliente.Create;

  Result.Id       := AQuery.FieldByName('ID').AsInteger;
  Result.Name     := AQuery.FieldByName('NAME').AsString;
  Result.Document := AQuery.FieldByName('DOCUMENT').AsString;
  Result.Email    := AQuery.FieldByName('EMAIL').AsString;
  Result.Active   := AQuery.FieldByName('ACTIVE').AsBoolean;
end;

function TFireDACClienteRepository.BuildSelectSql(
  AFilter: TClienteFilter
): string;
begin

  Result :=
      'SELECT '+
      ' ID, '+
      ' NAME, '+
      ' DOCUMENT, '+
      ' EMAIL, '+
      ' ACTIVE '+
      'FROM CLIENTE '+
      'WHERE 1 = 1 ';

  if Trim(AFilter.Name) <> '' then
    Result := Result + 'AND NAME CONTAINING :NAME ';

  if Trim(AFilter.Document) <> '' then
    Result := Result + 'AND DOCUMENT = :DOCUMENT ';

  if Trim(AFilter.Active) <> '' then
    Result := Result + 'AND ACTIVE = :ACTIVE ';

  Result := Result + 'ORDER BY ID '+'ROWS :START_ROW TO :END_ROW';

end;
                                    // GET
function TFireDACClienteRepository.FindAll: TObjectList<TCliente>;
var
  LQuery: TFDQuery;
begin
  Result := TObjectList<TCliente>.Create(True);

  LQuery := CreateQuery;

  try

    try

      LQuery.SQL.Text :=
        'SELECT '+
        ' ID, '+
        ' NAME, '+
        ' DOCUMENT, '+
        ' EMAIL, '+
        ' ACTIVE '+
        'FROM CLIENTE '+
        'ORDER BY ID';

      LQuery.Open;

      while not LQuery.Eof do
        begin

          Result.Add(LoadClienteFromQuery(LQuery));

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

function TFireDACClienteRepository.FindAllPaged(
  AFilter: TClienteFilter
): TObjectList<TCliente>;
var
  LQuery: TFDQuery;
  LStartRow: Integer;
  LEndRow: Integer;
begin
  // Cria a caixa onde serão colocados os clientes encontrados.
  Result := TObjectList<TCliente>.Create(True);

  // Cria uma consulta já conectada ao banco.
  LQuery := CreateQuery;

  try
    try
      // Calcula a primeira e a última linha da página solicitada.
      LStartRow := ((AFilter.Page - 1) * AFilter.PageSize) + 1;
      LEndRow   := LStartRow + AFilter.PageSize - 1;

      // Monta o SQL conforme os filtros informados.
      LQuery.SQL.Text := BuildSelectSql(AFilter);

      // Preenche os parâmetros da consulta.
      BindSelectParams(
        LQuery,
        AFilter,
        LStartRow,
        LEndRow
      );

      // Executa a consulta.
      LQuery.Open;

      // Enquanto existir registro...
      while not LQuery.Eof do
        begin
          // Converte a linha do banco em um objeto Cliente
          // e adiciona na lista de retorno.
          Result.Add(
            LoadClienteFromQuery(LQuery)
          );

          // Vai para o próximo registro.
          LQuery.Next;
        end;

    except
      Result.Free;
      raise;
    End;
  finally
    LQuery.Free;
  end;

end;

procedure TFireDACClienteRepository.BindSelectParams(
  AQuery: TFDQuery;
  AFilter: TClienteFilter;
  AStartRow: Integer;
  AEndRow: Integer
);
begin

  AQuery.ParamByName('START_ROW').AsInteger := AStartRow;
  AQuery.ParamByName('END_ROW').AsInteger   := AEndRow;

  if Trim(AFilter.Name) <> '' then
    AQuery.ParamByName('NAME').AsString     := Trim(AFilter.Name);

  if Trim(AFilter.Document) <> '' then
    AQuery.ParamByName('DOCUMENT').AsString := Trim(AFilter.Document);

  if Trim(AFilter.Active) <> '' then
    AQuery.ParamByName('ACTIVE').AsBoolean  := SameText(Trim(AFilter.Active),'true');

end;

function TFireDACClienteRepository.Count(
  AFilter: TClienteFilter
): Integer;
var
  LQuery: TFDQuery;
begin
  Result := 0;

  LQuery := TFDQuery.Create(nil);

  try

    LQuery.Connection := FDatabase.Connection;

    LQuery.SQL.Text :=
      'SELECT COUNT(*) TOTAL ' +
      'FROM CLIENTE';

    LQuery.Open;

    Result := LQuery.FieldByName('TOTAL').AsInteger;

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
