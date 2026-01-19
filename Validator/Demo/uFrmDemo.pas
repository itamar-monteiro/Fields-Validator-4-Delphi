unit uFrmDemo;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Validator.Core,
  Validator.Attributes,
  Validator.Core.Types;

type
  TFrmDemo = class(TForm)

    [LabelDisplay('Nome do cliente')]
    [Required]
    lbl_Nome: TLabel;

    [LabelDisplay('Endereço do cliente')]
    [Required]
    lbl_Endereco: TLabel;

    lbl_Cidade: TLabel;

    [Required]
    lbl_Telefone: TLabel;

    [FieldDisplay('Nome')]
    [NotEmpty]
    [TextLen(3, 20)]
    edt_Nome: TEdit;

    [NotEmpty]
    edt_Endereco: TEdit;
    edt_Cidade: TEdit;

    [FieldDisplay('Telefone')]
    [NotEmpty('"<FieldDisplay>" é obrigatório')]
    [Telefone]
    edt_Telefone: TEdit;

    [NotEmpty('"E-mail" é obrigatório')]
    [Email]
    edt_Email: TEdit;

    [Required]
    lbl_Email: TLabel;

    [FieldDisplay('Limite de crédito')]
    [NotEmpty('<FieldDisplay> é obrigatório"')]
    [MinMaxValue(0, 10000)]
    edt_LimiteCredito: TEdit;

    [Required]
    lbl_LimiteCredito: TLabel;

    [ValidateCPForCNPJ]
    edt_CPFCNPJ: TEdit;

    lbl_CPFCNPJ: TLabel;
    btn_Validar: TButton;
    procedure btn_ValidarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edt_CPFCNPJChange(Sender: TObject);
  private
    procedure FormatarCPFCNPJ(const Componente: TCustomEdit);
    procedure ShowErrors(const AMessage: string);
  public
    { Public declarations }
  end;

var
  FrmDemo: TFrmDemo;

implementation

{$R *.dfm}

{ TForm5 }

procedure TFrmDemo.btn_ValidarClick(Sender: TObject);
begin
  if TValidator.Validate(Self) then
     ShowMessage('O campos estão todos corretos');
end;

procedure TFrmDemo.edt_CPFCNPJChange(Sender: TObject);
begin
  edt_CPFCNPJ.OnChange:= nil;
  try
    FormatarCPFCNPJ(edt_CPFCNPJ);
  finally
    edt_CPFCNPJ.OnChange:= edt_CPFCNPJChange;
  end;
end;

procedure TFrmDemo.FormatarCPFCNPJ(const Componente: TCustomEdit);
var
  Texto, ApenasNumeros: string;
  I: Integer;
begin
  Texto        := Trim(Componente.Text);
  ApenasNumeros:= '';

  // 1. Extrai apenas os números da string atual
  for I:= 1 to Length(Texto) do
  begin
    if CharInSet(Texto[I], ['0'..'9']) then
      ApenasNumeros:= ApenasNumeros + Texto[I];
  end;

  // 2. Define a máscara baseada na quantidade de dígitos
  // CPF: 000.000.000-00 (11 dígitos)
  // CNPJ: 00.000.000/0000-00 (14 dígitos)

  if Length(ApenasNumeros) <= 11 then
    begin
      // Formatação CPF
      if Length(ApenasNumeros) > 9 then
         Insert('-', ApenasNumeros, 10);
      if Length(ApenasNumeros) > 6 then
         Insert('.', ApenasNumeros, 7);
      if Length(ApenasNumeros) > 3 then
         Insert('.', ApenasNumeros, 4);
    end
  else
    begin
      // Formatação CNPJ (máximo 14 dígitos)
      if Length(ApenasNumeros) > 14 then
        ApenasNumeros:= Copy(ApenasNumeros, 1, 14);

      if Length(ApenasNumeros) > 12 then
         Insert('-', ApenasNumeros, 13);
      if Length(ApenasNumeros) > 8 then
         Insert('/', ApenasNumeros, 9);
      if Length(ApenasNumeros) > 5 then
         Insert('.', ApenasNumeros, 6);
      if Length(ApenasNumeros) > 2 then
         Insert('.', ApenasNumeros, 3);
    end;

  // 3. Atualiza o componente sem perder a posição do cursor
  Componente.Text    := ApenasNumeros;
  Componente.SelStart:= Length(ApenasNumeros);
end;

procedure TFrmDemo.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown:= True;
  TValidator.ValidationMode  := vmOneByOne;
  TValidator.ShowErrorLabel  := True;
  TValidator.ConfigureLabelCaption(Self);
  //TValidator.OnErrors:= ShowErrors;
end;

procedure TFrmDemo.ShowErrors(const AMessage: string);
begin
  Application.MessageBox(Pchar(AMessage), 'Erros encontrados', MB_ICONWARNING + MB_OK);
end;

end.
