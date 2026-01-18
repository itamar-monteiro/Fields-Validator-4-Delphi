unit Validator.Attributes.TextLen;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.StdCtrls,
  System.Rtti,
  Validator.Attributes.BaseValidator,
  Validator.Consts,
  Validator.Helpers;

type
  TextLen = class(BaseValidator)
  private
    FMinLength: Integer;
    FMaxLength: Integer;
  public
    constructor Create(const AMinLength: Integer); overload;
    constructor Create(const AMinLength, AMaxLength: Integer); overload;
    constructor Create(const AMinLength: Integer; const AMessage: string); overload;
    constructor Create(const AMinLength, AMaxLength: Integer; const AMessage: string); overload;
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

constructor TextLen.Create(const AMinLength: Integer);
begin
  Self.Create(AMinLength, 0, '');
end;

constructor TextLen.Create(const AMinLength, AMaxLength: Integer);
begin
  Self.Create(AMinLength, AMaxLength, '');
end;

constructor TextLen.Create(const AMinLength: Integer; const AMessage: string);
begin
  Self.Create(AMinLength, 0, AMessage);
end;

constructor TextLen.Create(const AMinLength, AMaxLength: Integer; const AMessage: string);
begin
  FMinLength:= AMinLength;
  FMaxLength:= AMaxLength;
  FMessage  := AMessage.Trim;
end;

function TextLen.GetFormattedMessage(const ARttiField: TRttiField): string;
var
  LBaseMsg: string;
begin
  if (not FMessage.Trim.IsEmpty) then
    LBaseMsg:= FMessage.Trim
  else if (FMinLength > 0) and (FMaxLength > 0) then
    LBaseMsg:= MSG_DEFAULT_TEXTLEN
  else if (FMinLength > 0) then
    LBaseMsg:= MSG_DEFAULT_TEXTLEN_MIN
  else if (FMaxLength > 0) then
    LBaseMsg:= MSG_DEFAULT_TEXTLEN_MAX;

  LBaseMsg:= LBaseMsg
               .Replace(TAG_MIN, FMinLength.ToString, [rfReplaceAll, rfIgnoreCase])
               .Replace(TAG_MAX, FMaxLength.ToString, [rfReplaceAll, rfIgnoreCase]);
  Result:= ARttiField.FormatMsg(LBaseMsg);
end;

function TextLen.Validar(const Value: TValue): Boolean;
var
  LValue: Integer;
begin
  LValue:= Value.ToString.Length;
  Result:= (LValue >= FMinLength) and ((FMaxLength <= 0) or (LValue <= FMaxLength));
end;

end.
