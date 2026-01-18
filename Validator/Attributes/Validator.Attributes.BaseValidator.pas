unit Validator.Attributes.BaseValidator;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.StdCtrls,
  System.Rtti,
  Validator.Consts,
  Validator.Helpers;

type
  BaseValidator = class(TCustomAttribute)
  protected
    FMessage: string;
  public
    function Validar(const Value: TValue): Boolean; virtual; abstract;
    function GetFormattedMessage(const ARttiField: TRttiField): string; virtual; abstract;
  end;

implementation

end.
