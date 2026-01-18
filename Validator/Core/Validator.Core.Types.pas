unit Validator.Core.Types;

interface

uses
  System.Classes;

type
  TValidationMode = (vmOneByOne, vmAll);
  TOnErrorDisplay = procedure(const AErrorMessage: string) of object;

implementation

end.
