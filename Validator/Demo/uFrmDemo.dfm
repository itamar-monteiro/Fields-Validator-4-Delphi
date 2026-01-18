object FrmDemo: TFrmDemo
  Left = 0
  Top = 0
  ActiveControl = edt_Nome
  Caption = 'FrmDemo'
  ClientHeight = 287
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lbl_Nome: TLabel
    Left = 24
    Top = 24
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object lbl_Endereco: TLabel
    Left = 311
    Top = 24
    Width = 49
    Height = 15
    Caption = 'Endere'#231'o'
  end
  object lbl_Cidade: TLabel
    Left = 24
    Top = 77
    Width = 37
    Height = 15
    Caption = 'Cidade'
  end
  object lbl_Telefone: TLabel
    Left = 311
    Top = 77
    Width = 44
    Height = 15
    Caption = 'Telefone'
  end
  object lbl_Email: TLabel
    Left = 438
    Top = 77
    Width = 34
    Height = 15
    Caption = 'E-mail'
  end
  object lbl_LimiteCredito: TLabel
    Left = 24
    Top = 132
    Width = 91
    Height = 15
    Caption = 'Limite de Cr'#233'dito'
  end
  object lbl_CPFCNPJ: TLabel
    Left = 127
    Top = 132
    Width = 53
    Height = 15
    Caption = 'CPF/CNPJ'
  end
  object edt_Nome: TEdit
    Left = 24
    Top = 40
    Width = 281
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object edt_Endereco: TEdit
    Left = 311
    Top = 40
    Width = 386
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 1
  end
  object edt_Cidade: TEdit
    Left = 24
    Top = 93
    Width = 281
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 2
  end
  object edt_Telefone: TEdit
    Left = 311
    Top = 93
    Width = 121
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 3
  end
  object edt_Email: TEdit
    Left = 438
    Top = 93
    Width = 259
    Height = 23
    CharCase = ecLowerCase
    TabOrder = 4
  end
  object btn_Validar: TButton
    Left = 24
    Top = 184
    Width = 177
    Height = 41
    Caption = 'Validar'
    TabOrder = 5
    OnClick = btn_ValidarClick
  end
  object edt_LimiteCredito: TEdit
    Left = 24
    Top = 149
    Width = 97
    Height = 23
    Alignment = taRightJustify
    CharCase = ecUpperCase
    NumbersOnly = True
    TabOrder = 6
  end
  object edt_CPFCNPJ: TEdit
    Left = 127
    Top = 149
    Width = 178
    Height = 23
    MaxLength = 18
    TabOrder = 7
    OnChange = edt_CPFCNPJChange
  end
end
