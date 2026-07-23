unit DomainExceptions;

interface

uses
  System.SysUtils;

type
  EValidationException = class(Exception);

  ENotFoundException = class(Exception);

  EConflictException = class(Exception);

implementation

end.
