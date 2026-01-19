unit Validator.Attributes;

interface

uses
  Validator.Attributes.BaseValidator,
  Validator.Attributes.FieldDisplay,
  Validator.Attributes.LabelDisplay,
  Validator.Attributes.TextLen,
  Validator.Attributes.NotEmpty,
  Validator.Attributes.Telefone,
  Validator.Attributes.MinMaxValue,
  Validator.Attributes.Email,
  Validator.Attributes.Required,
  Validator.Attributes.CPF,
  Validator.Attributes.CNPJ,
  Validator.Attributes.CPFCNPJ;

type
  FieldDisplay = Validator.Attributes.FieldDisplay.FieldDisplay;
  LabelDisplay = Validator.Attributes.LabelDisplay.LabelDisplay;
  TextLen      = Validator.Attributes.TextLen.TextLen;
  NotEmpty     = Validator.Attributes.NotEmpty.NotEmpty;
  Telefone     = Validator.Attributes.Telefone.Telefone;
  MinMaxValue  = Validator.Attributes.MinMaxValue.MinMaxValue;
  Email        = Validator.Attributes.Email.Email;
  Required     = Validator.Attributes.Required.Required;
  ValidateCPF  = Validator.Attributes.CPF.ValidateCPF;
  ValidateCNPJ = Validator.Attributes.CNPJ.ValidateCNPJ;
  ValidateCPForCNPJ = Validator.Attributes.CPFCNPJ.ValidateCPForCNPJ;

implementation

end.
