program ERPNexusAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  AppConfig in 'Config\AppConfig.pas',
  AppRoutes in 'Api\Routes\AppRoutes.pas',
  HealthRoutes in 'Api\Routes\HealthRoutes.pas',
  ClienteRoutes in 'Api\Routes\ClienteRoutes.pas',
  ClienteController in 'Api\Controllers\ClienteController.pas',
  Cliente in 'Domain\Models\Cliente.pas',
  ClienteDTO in 'Api\DTOs\ClienteDTO.pas',
  ClienteService in 'Domain\Services\ClienteService.pas',
  ClienteRepository in 'Domain\Repositories\ClienteRepository.pas',
  MemoryClienteRepository in 'Infrastructure\Repositories\MemoryClienteRepository.pas',
  AppContainer in 'Config\AppContainer.pas',
  DatabaseConnection in 'Infrastructure\Database\DatabaseConnection.pas',
  FireDACClienteRepository in 'Infrastructure\Repositories\FireDACClienteRepository.pas',
  DomainExceptions in 'Domain\Exceptions\DomainExceptions.pas',
  ExceptionMiddleware in 'Api\Middlewares\ExceptionMiddleware.pas';

begin

  RegisterExceptionMiddleware;
  RegisterRoutes;

  Writeln('====================================');
  Writeln('        ', TAppConfig.APP_NAME);
  Writeln('====================================');
  Writeln;
  Writeln('Versao: ', TAppConfig.APP_VERSION);
  Writeln('Porta:  ', TAppConfig.Port);
  Writeln;
  Writeln('API:    http://localhost:', TAppConfig.Port);
  Writeln('Health: http://localhost:', TAppConfig.Port, '/health');
  Writeln;
  Writeln('Pressione CTRL+C para encerrar.');
  Writeln;

  THorse.Listen(TAppConfig.Port);
end.
