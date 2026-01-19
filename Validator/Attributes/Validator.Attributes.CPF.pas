unit Validator.Attributes.CPF;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  Validator.Consts,
  Validator.Helpers,
  Validator.Attributes.BaseValidator;

type
  ValidateCPF = class(BaseValidator)
  private
    function OnlyNumbers(const ACPF: string): string;
    function ValidarDigitos(const ACPF: string): Boolean;
  public
    constructor Create(const AMessage: string='');
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

{ ValidateCPF }

constructor ValidateCPF.Create(const AMessage: string);
begin
  FMessage:= AMessage.Trim;
  if (FMessage.IsEmpty) then
     FMessage:= MSG_DEFAULT_CPF;
end;

function ValidateCPF.GetFormattedMessage(const ARttiField: TRttiField): string;
begin
  Result:= ARttiField.FormatMsg(FMessage);
end;

function ValidateCPF.OnlyNumbers(const ACPF: string): string;
var
  I: Integer;
begin
  Result:= '';
  for I := 1 to Length(ACPF) do
  begin
    if CharInSet(ACPF[I], ['0'..'9']) then
      Result:= Result + ACPF[I];
  end;
end;

function ValidateCPF.Validar(const Value: TValue): Boolean;
var
  LCPF: string;
begin
  LCPF:= Value.ToString.Trim;
  if LCPF.IsEmpty then
     Exit(True);

  Result:= ValidarDigitos(LCPF);
end;

function ValidateCPF.ValidarDigitos(const ACPF: string): Boolean;
var
  I, Soma, Digito1, Digito2: Integer;
  CPFNumeros: string;
begin
  Result    := False;
  CPFNumeros:= OnlyNumbers(ACPF);

  // CPF deve ter exatamente 11 dígitos
  if Length(CPFNumeros) <> 11 then
    Exit;

  // Rejeita sequências inválidas
  if CPFNumeros = StringOfChar(CPFNumeros[1], 11) then
    Exit(False);

  // Verifica se todos os dígitos são iguais (CPF inválido)
//  if (CPFNumeros = '00000000000') or
//     (CPFNumeros = '11111111111') or
//     (CPFNumeros = '22222222222') or
//     (CPFNumeros = '33333333333') or
//     (CPFNumeros = '44444444444') or
//     (CPFNumeros = '55555555555') or
//     (CPFNumeros = '66666666666') or
//     (CPFNumeros = '77777777777') or
//     (CPFNumeros = '88888888888') or
//     (CPFNumeros = '99999999999') then
//    Exit;

  // Calcula o primeiro dígito verificador
  Soma := 0;
  for I:= 1 to 9 do
    Soma:= Soma + StrToInt(CPFNumeros[I]) * (11 - I);

  Digito1:= 11 - (Soma mod 11);

  if Digito1 >= 10 then
     Digito1:= 0;

  // Calcula o segundo dígito verificador
  Soma := 0;
  for I:= 1 to 10 do
    Soma:= Soma + StrToInt(CPFNumeros[I]) * (12 - I);

  Digito2:= 11 - (Soma mod 11);

  if Digito2 >= 10 then
     Digito2 := 0;

  // Verifica se os dígitos calculados conferem com os informados
  Result:= (Digito1 = StrToInt(CPFNumeros[10])) and
           (Digito2 = StrToInt(CPFNumeros[11]));
end;

end.
