unit Validator.Attributes.FieldDisplay;

interface

uses
  System.SysUtils,
  System.Rtti;

type
  FieldDisplay = class(TCustomAttribute)
  private
    FDisplayName: string;
  public
    constructor Create(const ADisplayName: string);
    property DisplayName: string read FDisplayName;
  end;

implementation

{ FieldDisplay }

constructor FieldDisplay.Create(const ADisplayName: string);
begin
  FDisplayName:= ADisplayName;
end;

end.
