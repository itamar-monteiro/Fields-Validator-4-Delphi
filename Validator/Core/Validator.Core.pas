unit Validator.Core;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.StdCtrls,
  System.Rtti,
  WinApi.Messages,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.Dialogs,
  Vcl.Forms,
  Validator.Attributes.BaseValidator,
  Validator.Attributes.LabelDisplay,
  Validator.Attributes.Required,
  Validator.Core.Types;

type
  TValidator = class
  private
    class var FErrorList: TList<HWND>;
    class var DefaultWindowProcs: TDictionary<HWND, Pointer>;
    class var FValidationMode: TValidationMode;
    class var FOnErrorDisplay: TOnErrorDisplay;
    class var FShowErrorLabel: Boolean;
    class var FForm: TForm;
    class procedure HookComponent(AControl: TWinControl);
    class procedure ClearErrors;
    class procedure DrawErrorLabel(AControl: TWinControl; AMessage: string; AExibir: Boolean);
  public
    class constructor Create;
    class destructor Destroy;
    class procedure ConfigureLabelCaption(const AForm: TForm);
    class function Validate(AObject: TObject): Boolean;
    class property ValidationMode: TValidationMode read FValidationMode write FValidationMode;
    class property ShowErrorLabel: Boolean read FShowErrorLabel write FShowErrorLabel;
    class property OnErrors: TOnErrorDisplay read FOnErrorDisplay write FOnErrorDisplay;
  end;

  // Função global para o Hook (Windows API standard)
  function ValidatorWindowProc(Handle: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

implementation

class procedure TValidator.ConfigureLabelCaption(const AForm: TForm);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiField: TRttiField;
  LCustomAttribute: TCustomAttribute;
  LLabelAttribute: LabelDisplay;
  LLabelSymbol: TLabel;
  LTargetLabel: TLabel;
begin
  LRttiContext:= TRttiContext.Create;
  try
    LRttiType:= LRttiContext.GetType(AForm.ClassType);

    for LRttiField in LRttiType.GetFields do
    begin
      for LCustomAttribute in LRttiField.GetAttributes do
      begin
        if LCustomAttribute is LabelDisplay then
        begin
          LLabelAttribute:= LabelDisplay(LCustomAttribute);

          if LRttiField.GetValue(AForm).AsObject is TLabel then
          begin
            TLabel(LRttiField.GetValue(AForm).AsObject).Caption:= LLabelAttribute.DisplayLabel;
          end;
        end;

        if LCustomAttribute is Required then
        begin
          if LRttiField.GetValue(AForm).AsObject is TLabel then
          begin
            LTargetLabel:= TLabel(LRttiField.GetValue(AForm).AsObject);
            LLabelSymbol:= AForm.FindComponent('Lbl_Symbol_' + LRttiField.Name) as TLabel;

            if not Assigned(LLabelSymbol) then
            begin
               LLabelSymbol       := TLabel.Create(AForm);
               LLabelSymbol.Name  := 'Lbl_Symbol_' + LRttiField.Name;
               LLabelSymbol.Parent:= LTargetLabel.Parent; // Mesmo Parent do Label

            end;

            LLabelSymbol.Font.Name := 'Segoe UI';
            LLabelSymbol.Font.Color:= $003131EE; //Red-600 -> Tailwind
            LLabelSymbol.Font.Style:= [fsBold];
            LLabelSymbol.Font.Size := 12;
            LLabelSymbol.Caption   := '*';
            LLabelSymbol.Top       := LTargetLabel.Top - 5;
            LLabelSymbol.Left      := LTargetLabel.Left + LTargetLabel.Canvas.TextWidth(LTargetLabel.Caption) + 2;
          end;
        end;
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

class constructor TValidator.Create;
begin
  FErrorList        := TList<HWND>.Create;
  DefaultWindowProcs:= TDictionary<HWND, Pointer>.Create;
  FValidationMode   := vmOneByOne;
  FShowErrorLabel   := True;
end;

class destructor TValidator.Destroy;
begin
  FErrorList.Free;
  DefaultWindowProcs.Free;
  inherited;
end;

class procedure TValidator.DrawErrorLabel(AControl: TWinControl; AMessage: string; AExibir: Boolean);
var
  LNomeLabel, LNomeIcon: string;
  ErrorLabel, ErrorIcon: TLabel;
begin
  LNomeLabel:= 'ErrLabel_' + AControl.Name;
  LNomeIcon := 'ErrIcon_'  + AControl.Name;

  // Tenta localizar os componentes no Parent do controle validado
  ErrorLabel:= AControl.Parent.FindComponent(LNomeLabel) as TLabel;
  ErrorIcon := AControl.Parent.FindComponent(LNomeIcon) as TLabel;

  if not AExibir then
  begin
    if Assigned(ErrorLabel) then ErrorLabel.Free;
    if Assigned(ErrorIcon)  then ErrorIcon.Free;
    Exit;
  end;

  // Criar ou atualizar Ícone
  if not Assigned(ErrorIcon) then
  begin
    ErrorIcon       := TLabel.Create(AControl.Owner);
    ErrorIcon.Name  := LNomeIcon;
    ErrorIcon.Parent:= AControl.Parent;
  end;

  ErrorIcon.Font.Color:= $4444EF;
  ErrorIcon.Font.Name := 'Segoe UI Symbol';
  ErrorIcon.Font.Size := 11;
  ErrorIcon.Font.Style:= [fsBold];
  ErrorIcon.Caption   := #$26A0; // Símbolo de alerta
  ErrorIcon.Left      := AControl.Left;
  ErrorIcon.Top       := AControl.Top + AControl.Height - 2;

  // Criar ou atualizar Label de Mensagem
  if not Assigned(ErrorLabel) then
  begin
    ErrorLabel        := TLabel.Create(AControl.Owner);
    ErrorLabel.Name   := LNomeLabel;
    ErrorLabel.Parent := AControl.Parent;
  end;

  ErrorLabel.Font.Color:= $4444EF;
  ErrorLabel.Font.Name := 'Segoe UI';
  ErrorLabel.Font.Size := 8;
  ErrorLabel.Font.Style:= [fsBold];
  ErrorLabel.Caption   := AMessage;
  ErrorLabel.Left      := ErrorIcon.Left + ErrorIcon.Width + 2;
  ErrorLabel.Top       := ErrorIcon.Top + (ErrorIcon.Height div 2) - (ErrorLabel.Height div 2);
end;

class procedure TValidator.ClearErrors;
var
  LH: HWND;
  LControl: TWinControl;
  TempList: TList<HWND>;
begin
  // Cria uma lista temporária para evitar problemas de iteração
  TempList:= TList<HWND>.Create;
  try
    TempList.AddRange(FErrorList);
    FErrorList.Clear;

    for LH in TempList do
    begin
      LControl:= FindControl(LH);
      if Assigned(LControl) then
        DrawErrorLabel(LControl, '', False);

      // Avisa ao Windows que a moldura (Frame) mudou e deve ser redesenhada sem o retângulo vermelho
      //SetWindowPos(LH, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED or SWP_DRAWFRAME);
      RedrawWindow(LH, nil, 0, RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
    end;
  finally
    TempList.Free;
  end;
end;

class procedure TValidator.HookComponent(AControl: TWinControl);
begin
  if not DefaultWindowProcs.ContainsKey(AControl.Handle) then
  begin
    DefaultWindowProcs.Add(AControl.Handle, Pointer(GetWindowLongPtr(AControl.Handle, GWLP_WNDPROC)));
    SetWindowLongPtr(AControl.Handle, GWLP_WNDPROC, NativeInt(@ValidatorWindowProc));
  end;
end;

function ValidatorWindowProc(Handle: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  Canvas: TCanvas;
  DC: HDC;
  OldProc: Pointer;
  R: TRect;
  ShouldDrawError: Boolean;
begin
  TValidator.DefaultWindowProcs.TryGetValue(Handle, OldProc);

  // Verifica ANTES de chamar o procedimento original
  ShouldDrawError:= (Msg = WM_NCPAINT) and TValidator.FErrorList.Contains(Handle);

  Result:= CallWindowProc(OldProc, Handle, Msg, wParam, lParam);

  //if (Msg = WM_NCPAINT) and TValidator.FErrorList.Contains(Handle) then
  if ShouldDrawError then
  begin
    DC := GetWindowDC(Handle);
    try
      GetWindowRect(Handle, R);
      // Ajusta para coordenadas locais (0, 0)
      OffsetRect(R, -R.Left, -R.Top);

      Canvas:= TCanvas.Create;
      try
        Canvas.Handle   := DC;
        Canvas.Pen.Color:= $4444EF;
        Canvas.Pen.Width:= 2;
        Canvas.Brush.Style:= bsClear;
        Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      finally
        Canvas.Free;
      end;
    finally
      ReleaseDC(Handle, DC);
    end;
  end;

  // SE O COMPONENTE RECEBER O FOCO
//  if (Msg = WM_SETFOCUS) then
//  begin
//    if TValidator.FErrorList.Contains(Handle) then
//    begin
//      TValidator.FErrorList.Remove(Handle);
//      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
//    end;
//  end;
end;

class function TValidator.Validate(AObject: TObject): Boolean;
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiField: TRttiField;
  LCustomAttribute: TCustomAttribute;
  LWinControl: TWinControl;
  LPropText: TRttiProperty;
  AllErrors: TStringList;
  FirstError: TWinControl;
  LValue: TValue;
  LMsg: string;
  LComponent: TComponent;
begin
  ClearErrors;
  AllErrors   := TStringList.Create;
  FirstError  := nil;
  LRttiContext:= TRttiContext.Create;

  try
    LRttiType:= LRttiContext.GetType(AObject.ClassType);

    for LRttiField in LRttiType.GetFields do
    begin
      if(LRttiField.Parent <> LRttiType)then
        Continue;

      LValue:= LRttiField.GetValue(AObject);

      // Se não for objeto ou for nulo, pula.
      if (not LValue.IsObject) or (LValue.AsObject = nil) then
         Continue;

      // Se não for um TWinControl, pula.
      if not (LValue.AsObject is TWinControl) then
         Continue;

      LWinControl:= TWinControl(LValue.AsObject);

      for LCustomAttribute in LRttiField.GetAttributes do
      begin
        if LCustomAttribute is BaseValidator then
        begin
          LPropText:= LRttiContext.GetType(LWinControl.ClassType).GetProperty('Text');

          if not BaseValidator(LCustomAttribute).Validar(LPropText.GetValue(LWinControl)) then
          begin
            HookComponent(LWinControl);

            if not FErrorList.Contains(LWinControl.Handle) then
               FErrorList.Add(LWinControl.Handle);

            if FirstError = nil then
               FirstError:= LWinControl;

            LMsg:= BaseValidator(LCustomAttribute).GetFormattedMessage(LRttiField);

            AllErrors.Add(LMsg);

            if FShowErrorLabel then
               DrawErrorLabel(LWinControl, LMsg, True);

            SetWindowPos(LWinControl.Handle, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED);

            if FValidationMode = vmOneByOne then Break;
          end;
        end;
      end;

      if (FValidationMode = vmOneByOne) and (AllErrors.Count > 0) then
         Break;
    end;

    Result:= AllErrors.Count = 0;

    if not Result then
    begin
      if Assigned(FirstError) then
         FirstError.SetFocus;

      if Assigned(FOnErrorDisplay) then
         FOnErrorDisplay(AllErrors.Text.Trim);

      // Força a pintura das bordas
      for var H in FErrorList do
        RedrawWindow(H, nil, 0, RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
    end;
  finally
    AllErrors.Free;
    LRttiContext.Free;
  end;
end;

end.
