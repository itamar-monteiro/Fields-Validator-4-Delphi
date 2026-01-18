unit Validator.Attributes.Email;

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
  Email = class(BaseValidator)
  public
    constructor Create(const AMessage: string='');
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

constructor Email.Create(const AMessage: string='');
begin
  FMessage:= AMessage.Trim;

  if FMessage.IsEmpty then
    FMessage:= MSG_DEFAULT_EMAIL;
end;

function Email.GetFormattedMessage(const ARttiField: TRttiField): string;
begin
  Result:= ARttiField.FormatMsg(FMessage);
end;

function Email.Validar(const Value: TValue): Boolean;
var
  LValue: string;
  LRegexEmail: string;
begin
  LValue     := Value.ToString.Trim;
  LRegexEmail:= '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  Result     := TRegEx.IsMatch(LValue, LRegexEmail);
end;

end.
