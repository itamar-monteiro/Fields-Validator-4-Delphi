unit Validator.Utils;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  Vcl.StdCtrls,
  Vcl.DBCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Forms;

type
  TRttiUtils = class
  private
    class procedure SetFocusComponent(const AWinControl: TWinControl);
  public
    class function GetTextFromComponent(const AComponent: TComponent): string;
    class procedure SetFocus(const AForm: TForm; const AComponentName: string);
  end;

implementation

class function TRttiUtils.GetTextFromComponent(const AComponent: TComponent): string;
begin
  Result:= '';
  if AComponent is TEdit then
     Result:= Trim(TEdit(AComponent).Text)
  else if AComponent is TComboBox then
     Result:= Trim(TComboBox(AComponent).Text)
  else if AComponent is TDBEdit then
     Result:= Trim(TDBEdit(AComponent).Text)
  else if AComponent is TMaskEdit then
     Result:= Trim(TMaskEdit(AComponent).Text)
  else if AComponent is TLabel then
     Result:= Trim(TLabel(AComponent).Caption)
  else if(AComponent is TRadioGroup)then
    begin
      if(TRadioGroup(AComponent).ItemIndex >= 0)then
        Result:= TRadioGroup(AComponent).Items[TRadioGroup(AComponent).ItemIndex];
      Exit;
    end
  else if(AComponent is TDateTimePicker)then
     Result:= DateToStr(TDateTimePicker(AComponent).Date)
  else if(AComponent is TDBMemo)then
     Result:= TDBMemo(AComponent).Field.AsString
  else if(AComponent is TMemo)then
     Result:= TMemo(AComponent).Text
  else if(AComponent is TDBComboBox)then
     Exit(TDBComboBox(AComponent).Field.AsString)
  else if(AComponent is TDBRadioGroup)then
    if(TDBRadioGroup(AComponent).ItemIndex >= 0)then
      begin
        Result:= TDBRadioGroup(AComponent).Items[TDBRadioGroup(AComponent).ItemIndex]
      end
    else
  raise Exception.Create('Componente não suportado pelo Validator. ' + Format('%s', [AComponent.Name]));
end;

class procedure TRttiUtils.SetFocus(const AForm: TForm; const AComponentName: string);
var
  LComponent: TComponent;
begin
  LComponent:= AForm.FindComponent(AComponentName);

  if (LComponent is TWinControl) then
     SetFocusComponent(TWinControl(LComponent));
end;

class procedure TRttiUtils.SetFocusComponent(const AWinControl: TWinControl);
var
  LParent: TComponent;
begin
  LParent:= TWinControl(AWinControl).Parent;

  while (LParent.ClassParent <> TForm) do
  begin
    if (LParent is TTabSheet) then
      if (not TTabSheet(LParent).Showing) then TTabSheet(LParent).Show;

    LParent:= TWinControl(LParent).Parent;
  end;

  try
    if(TWinControl(AWinControl).CanFocus)then
       TWinControl(AWinControl).SetFocus;
  except
  end;
end;

end.
