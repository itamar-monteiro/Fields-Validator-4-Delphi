unit Validator.Attributes.CNPJ;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  Validator.Consts,
  Validator.Helpers,
  Validator.Attributes.BaseValidator;

type
  ValidateCNPJ = class(BaseValidator)
  private
    function OnlyNumbers(const ACNPJ: string): string;
    function ValidarDigitos(const ACNPJ: string): Boolean;
  public
    constructor Create(const AMessage: string='');
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

{ ValidateCPF }

constructor ValidateCNPJ.Create(const AMessage: string);
begin
  FMessage:= AMessage.Trim;
  if (FMessage.IsEmpty) then
     FMessage:= MSG_DEFAULT_CNPJ;
end;

function ValidateCNPJ.GetFormattedMessage(const ARttiField: TRttiField): string;
begin
  Result:= ARttiField.FormatMsg(FMessage);
end;

function ValidateCNPJ.OnlyNumbers(const ACNPJ: string): string;
var
  I: Integer;
begin
  Result:= '';
  for I := 1 to Length(ACNPJ) do
  begin
    if CharInSet(ACNPJ[I], ['0'..'9']) then
      Result:= Result + ACNPJ[I];
  end;
end;

function ValidateCNPJ.Validar(const Value: TValue): Boolean;
var
  LCNPJ: string;
begin
  LCNPJ:= Value.ToString.Trim;

  if LCNPJ.IsEmpty then
     Exit(True);

  Result:= ValidarDigitos(LCNPJ);
end;

function ValidateCNPJ.ValidarDigitos(const ACNPJ: string): Boolean;
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

end.

