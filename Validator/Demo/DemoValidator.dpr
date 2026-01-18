program DemoValidator;

uses
  Vcl.Forms,
  uFrmDemo in 'uFrmDemo.pas' {FrmDemo},
  Validator.Attributes.BaseValidator in '..\Attributes\Validator.Attributes.BaseValidator.pas',
  Validator.Attributes.Email in '..\Attributes\Validator.Attributes.Email.pas',
  Validator.Attributes.FieldDisplay in '..\Attributes\Validator.Attributes.FieldDisplay.pas',
  Validator.Attributes.LabelDisplay in '..\Attributes\Validator.Attributes.LabelDisplay.pas',
  Validator.Attributes.MinMaxValue in '..\Attributes\Validator.Attributes.MinMaxValue.pas',
  Validator.Attributes.NotEmpty in '..\Attributes\Validator.Attributes.NotEmpty.pas',
  Validator.Attributes in '..\Attributes\Validator.Attributes.pas',
  Validator.Attributes.Required in '..\Attributes\Validator.Attributes.Required.pas',
  Validator.Attributes.Telefone in '..\Attributes\Validator.Attributes.Telefone.pas',
  Validator.Attributes.TextLen in '..\Attributes\Validator.Attributes.TextLen.pas',
  Validator.Consts in '..\Consts\Validator.Consts.pas',
  Validator.Core in '..\Core\Validator.Core.pas',
  Validator.Core.Types in '..\Core\Validator.Core.Types.pas',
  Validator.Helpers in '..\Helpers\Validator.Helpers.pas',
  Validator.Utils in '..\Utils\Validator.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmDemo, FrmDemo);
  Application.Run;
end.
