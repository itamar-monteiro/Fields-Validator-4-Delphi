unit Validator.Attributes.MinMaxValue;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.StdCtrls,
  System.Rtti,
  Validator.Consts,
  Validator.Helpers,
  Validator.Attributes.BaseValidator;

type
  MinMaxValue = class(BaseValidator)
  private
    FMinValue: Currency;
    FMaxValue: Currency;
  public
    constructor Create(const AMinValue: Currency); overload;
    constructor Create(const AMinValue, AMaxValue: Currency); overload;
    constructor Create(const AMinValue: Currency; const AMessage: string); overload;
    constructor Create(const AMinValue, AMaxValue: Currency; const AMessage: string); overload;
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

constructor MinMaxValue.Create(const AMinValue: Currency);
begin
  Self.Create(AMinValue, 0, '');
end;

constructor MinMaxValue.Create(const AMinValue, AMaxValue: Currency);
begin
  Self.Create(AMinValue, AMaxValue, '');
end;

constructor MinMaxValue.Create(const AMinValue: Currency; const AMessage: string);
begin
  Self.Create(AMinValue, 0, AMessage);
end;

constructor MinMaxValue.Create(const AMinValue, AMaxValue: Currency; const AMessage: string);
begin
  FMinValue:= AMinValue;
  FMaxValue:= AMaxValue;
  FMessage := AMessage.Trim;
end;

function MinMaxValue.GetFormattedMessage(const ARttiField: TRttiField): string;
var
  LBaseMsg: string;
begin
  if (not FMessage.Trim.IsEmpty) then
    LBaseMsg:= FMessage.Trim
  else if (FMinValue > 0) and (FMaxValue > 0) then
    LBaseMsg:= MSG_DEFAULT_VALUE
  else if (FMinValue > 0) then
    LBaseMsg:= MSG_DEFAULT_VALUE_MIN
  else if (FMaxValue > 0) then
    LBaseMsg:= MSG_DEFAULT_VALUE_MAX;

  LBaseMsg:= LBaseMsg
               .Replace('<min>', FMinValue.ToString, [rfReplaceAll, rfIgnoreCase])
               .Replace('<max>', FMaxValue.ToString, [rfReplaceAll, rfIgnoreCase]);

  Result:= ARttiField.FormatMsg(LBaseMsg);
end;

function MinMaxValue.Validar(const Value: TValue): Boolean;
var
  LValue: Integer;
begin
  LValue:= Value.ToString.Length;
  Result:= (LValue >= FMinValue) and ((FMaxValue <= 0) or (LValue <= FMaxValue));
end;

end.
