unit Validator.Attributes.CPFCNPJ;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  Validator.Consts,
  Validator.Helpers,
  Validator.Attributes.BaseValidator;

type
  ValidateCPForCNPJ = class(BaseValidator)
  private
    function OnlyNumbers(const AValue: string): string;
    function ValidarCPF(const ACPF: string): Boolean;
    function ValidarCNPJ(const ACNPJ: string): Boolean;
  public
    constructor Create(const AMessage: string='');
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

{ ValidateCPF }

constructor ValidateCPForCNPJ.Create(const AMessage: string);
begin
  FMessage:= AMessage.Trim;
  if (FMessage.IsEmpty) then
     FMessage:= MSG_DEFAULT_CPFCNPJ;
end;

function ValidateCPForCNPJ.GetFormattedMessage(const ARttiField: TRttiField): string;
begin
  Result:= ARttiField.FormatMsg(FMessage);
end;

function ValidateCPForCNPJ.OnlyNumbers(const AValue: string): string;
var
  I: Integer;
begin
  Result:= '';
  for I := 1 to Length(AValue) do
  begin
    if CharInSet(AValue[I], ['0'..'9']) then
      Result:= Result + AValue[I];
  end;
end;

function ValidateCPForCNPJ.Validar(const Value: TValue): Boolean;
var
  LValor, LValorLimpo: string;
  LTamanho: Integer;
begin
  LValor:= Value.ToString.Trim;

  // Se estiver vazio, não valida (use NotEmpty para obrigatoriedade)
  if LValor.IsEmpty then
    Exit(True);

  LValorLimpo:= OnlyNumbers(LValor);
  LTamanho   := Length(LValorLimpo);

  // Verifica se é CPF (11 dígitos) ou CNPJ (14 dígitos)
  case LTamanho of
    11: Result:= ValidarCPF(LValorLimpo);
    14: Result:= ValidarCNPJ(LValorLimpo);
  else
    Result:= False; // Tamanho inválido (nem CPF nem CNPJ)
  end;
end;

function ValidateCPForCNPJ.ValidarCNPJ(const ACNPJ: string): Boolean;
var
  I, Soma, Digito1, Digito2: Integer;
  Peso: Integer;
  CNPJNumeros: string;
begin
  Result     := False;
  CNPJNumeros:= OnlyNumbers(ACNPJ);

  // CPF deve ter exatamente 11 dígitos
  if Length(CNPJNumeros) <> 14 then
    Exit;

  // Rejeita sequências inválidas
  if CNPJNumeros = StringOfChar(CNPJNumeros[1], 14) then
    Exit(False);

  // Calcula o primeiro dígito verificador
  Soma := 0;
  Peso := 2;

  for I:= 12 downto 1 do
  begin
    Soma:= Soma + StrToInt(CNPJNumeros[I]) * Peso;
    Inc(Peso);
    if Peso > 9 then
       Peso:= 2;
  end;

  Digito1:= 11 - (Soma mod 11);

  if Digito1 >= 10 then
    Digito1:= 0;

  // Calcula o segundo dígito verificador
  Soma := 0;
  Peso := 2;

  for I:= 13 downto 1 do
  begin
    Soma:= Soma + StrToInt(CNPJNumeros[I]) * Peso;
    Inc(Peso);
    if Peso > 9 then
       Peso:= 2;
  end;

  Digito2:= 11 - (Soma mod 11);

  if Digito2 >= 10 then
    Digito2:= 0;

  // Verifica se os dígitos calculados conferem com os informados
  Result:= (Digito1 = StrToInt(CNPJNumeros[13])) and
           (Digito2 = StrToInt(CNPJNumeros[14]));
end;

function ValidateCPForCNPJ.ValidarCPF(const ACPF: string): Boolean;
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
