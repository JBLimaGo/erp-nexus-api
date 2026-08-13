unit JwtService;

interface

type
  IJwtService = interface
    ['{F43D7C0D-4E7F-48F7-9E39-6E6E7E5F4D9C}']

    function GenerateToken(
      AUserId: Integer;
      const ALogin: string
    ): string;

    function ValidateToken(
      const AToken: string
    ): Boolean;

  end;

  TJwtService = class(TInterfacedObject, IJwtService)
  public

    function GenerateToken(
      AUserId: Integer;
      const ALogin: string
    ): string;

    function ValidateToken(
      const AToken: string
    ): Boolean;

  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  JOSE.Core.JWT,
  JOSE.Core.JWS,
  JOSE.Core.JWK,
  JOSE.Core.JWA;

{ TJwtService }

function TJwtService.GenerateToken(
  AUserId: Integer;
  const ALogin: string
): string;
var
  LToken : TJWT;
  LJWS   : TJWS;
  LKey   : TJWK;
begin
  LToken := TJWT.Create;
  try

    LToken.Claims.Subject    := AUserId.ToString;
    LToken.Claims.Issuer     := 'ERP Nexus API';
    LToken.Claims.IssuedAt   := Now;
    LToken.Claims.Expiration := IncHour(Now, 1);

    LToken.Claims.SetClaimOfType<string>(
      'login',
      ALogin
    );

    LJWS := TJWS.Create(LToken);
    LKey := TJWK.Create('ERP-NEXUS-2026');

    try
      LJWS.SkipKeyValidation := True;

      LJWS.Sign(
        LKey,
        TJOSEAlgorithmId.HS256
      );

      Result := LJWS.CompactToken;

    finally
      LKey.Free;
      LJWS.Free;
    end;

  finally
    LToken.Free;
  end;
end;

function TJwtService.ValidateToken(const AToken: string): Boolean;
begin

end;

end.
