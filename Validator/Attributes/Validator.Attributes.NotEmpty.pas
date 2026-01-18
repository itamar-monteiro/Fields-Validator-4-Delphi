unit Validator.Attributes.NotEmpty;

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
  NotEmpty = class(BaseValidator)
  private
  public
    constructor Create(const AMessage: string='');
    function Validar(const Value: TValue): Boolean; override;
    function GetFormattedMessage(const ARttiField: TRttiField): string; override;
  end;

implementation

constructor NotEmpty.Create(const AMessage: string);
begin
  FMessage:= AMessage.Trim;
  if FMessage.IsEmpty then
    FMessage:= MSG_DEFAULT_NOT_EMPTY;
end;

function NotEmpty.GetFormattedMessage(const ARttiField: TRttiField): string;
begin
  Result:= ARttiField.FormatMsg(FMessage);
end;

function NotEmpty.Validar(const Value: TValue): Boolean;
begin
  Result:= not Value.ToString.Trim.IsEmpty;
end;

end.
