program ERPNexusAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  AppConfig in 'Config\AppConfig.pas',
  AppRoutes in 'Api\Routes\AppRoutes.pas',
  HealthRoutes in 'Api\Routes\HealthRoutes.pas',
  CustomerRoutes in 'Api\Routes\CustomerRoutes.pas',
  CustomerController in 'Api\Controllers\CustomerController.pas',
  Customer in 'Domain\Models\Customer.pas',
  CustomerDTO in 'Api\DTOs\CustomerDTO.pas',
  CustomerService in 'Domain\Services\CustomerService.pas',
  CustomerRepository in 'Domain\Repositories\CustomerRepository.pas',
  MemoryCustomerRepository in 'Infrastructure\Repositories\MemoryCustomerRepository.pas',
  AppContainer in 'Config\AppContainer.pas';

begin
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
