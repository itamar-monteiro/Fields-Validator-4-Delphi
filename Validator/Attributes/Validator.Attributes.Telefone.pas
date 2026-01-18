unit Validator.Attributes.Telefone;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.StdCtrls,
  System.Rtti,
  System.RegularExpressions,
  Validator.Consts,
  Validator.Helpers,
  Validator.Attributes.BaseValidator;

type
  Telefone = class(BaseValidator)
  public
    constructor Create(const AMessage: string='');
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

constructor Telefone.Create(const AMessage: string='');
begin
  FMessage:= AMessage.Trim;

  if FMessage.Trim.IsEmpty then
     FMessage:= MSG_DEFAULT_TELEFONE;
end;

function Telefone.GetFormattedMessage(const ARttiField: TRttiField): string;
begin
  Result:= ARttiField.FormatMsg(FMessage);
end;

function Telefone.Validar(const Value: TValue): Boolean;
var
  LValue: string;
  LRegexFone: string;
begin
  LValue    := Value.ToString.Trim;
  //LRegexFone:= '^(\(?\d{2}\)?\s?\d{1}?\s?\d{4}-?\d{4})$';
  LRegexFone:= '^\(\d{2}\)\s\d{5}-\d{4}$'; {Formato: (99) 99999-9999}
  Result    := TRegEx.IsMatch(LValue, LRegexFone);
end;

end.
