unit Validator.Consts;

interface

const
  TAG_MIN = '<min>';
  TAG_MAX = '<max>';
  TAG_FIELD_DISPLAY = '<FieldDisplay>';

  MSG_DEFAULT_NOT_EMPTY  = 'Campo obrigatório não preenchido';
  MSG_DEFAULT_TEXTLEN    = 'O campo deve ter entre ' + TAG_MIN + ' e ' + TAG_MAX + ' caracteres';
  MSG_DEFAULT_TEXTLEN_MIN= 'O campo deve ter ao menos ' + TAG_MIN + ' caracteres';
  MSG_DEFAULT_TEXTLEN_MAX= 'O campo deve ter no máximo ' + TAG_MAX + ' caracteres';
  MSG_DEFAULT_VALUE      = 'O campo deve ter um valor entre ' + TAG_MIN + ' e ' + TAG_MAX + '';
  MSG_DEFAULT_VALUE_MIN  = 'O campo deve ter um valor mínimo de ' + TAG_MIN + '';
  MSG_DEFAULT_VALUE_MAX  = 'O campo deve ter um valor máximo de ' + TAG_MAX + '';
  MSG_DEFAULT_EMAIL      = 'O e-mail digitado é inválido';
  MSG_DEFAULT_TELEFONE   = 'Telefone está fora do padrão aceito. Padrão: (99) 99999-9999';
  MSG_DEFAULT_CPF        = 'CPF inválido';
  MSG_DEFAULT_CNPJ       = 'CNPJ inválido';
  MSG_DEFAULT_CPFCNPJ    = 'CPF ou CNPJ inválido';

implementation

end.
