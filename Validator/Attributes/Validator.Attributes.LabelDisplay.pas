unit Validator.Attributes.LabelDisplay;

interface

uses
  System.SysUtils,
  System.Classes;

type
  LabelDisplay = class(TCustomAttribute)
  private
    FDisplayLabel: string;
  public
    constructor Create(const ADisplayLabel: string);
    property DisplayLabel: string read FDisplayLabel;
  end;

implementation

constructor LabelDisplay.Create(const ADisplayLabel: string);
begin
  FDisplayLabel:= ADisplayLabel;
end;

end.
