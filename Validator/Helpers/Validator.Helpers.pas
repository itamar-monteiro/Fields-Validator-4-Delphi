unit Validator.Helpers;

interface

uses
  System.SysUtils,
  System.RTTI,
  Validator.Consts;

type
  TRttiFieldyHelper = class helper for TRttiField
  public
    function GetFieldDisplay: string;
    function FormatMsg(const AMsg: string): string;
    function GetCustomAttribute<T: TCustomAttribute>: T;
  end;

implementation

uses
  Validator.Attributes.FieldDisplay;

function TRttiFieldyHelper.GetCustomAttribute<T>: T;
var
  LCustomAttribute: TCustomAttribute;
begin
  Result:= nil;

  for LCustomAttribute in GetAttributes do
    if LCustomAttribute is T then
      Exit(T(LCustomAttribute));
end;

function TRttiFieldyHelper.GetFieldDisplay: string;
var
  LFieldDisplay: FieldDisplay;
begin
  //Result:= Self.Name;
  LFieldDisplay:= GetCustomAttribute<FieldDisplay>;

  if (LFieldDisplay <> nil) then
    Result:= LFieldDisplay.DisplayName
  else
    Result:= '';
end;

function TRttiFieldyHelper.FormatMsg(const AMsg: string): string;
var
  LDisplay: string;
begin
  Result  := AMsg;
  LDisplay:= Self.GetFieldDisplay;

  if (not LDisplay.Trim.IsEmpty) and (Pos(LDisplay, AMsg) > 0) then
     LDisplay:= '';

  if (Pos(TAG_FIELD_DISPLAY, AMsg) > 0) then
    Result:= AMsg.Replace(TAG_FIELD_DISPLAY, LDisplay, [rfReplaceAll, rfIgnoreCase])
  else if (not LDisplay.Trim.IsEmpty) then
    Result:= AMsg + Format(' [%s]', [LDisplay]);

//  if (Pos(TAG_FIELD_DISPLAY, AMsg) > 0) then
//    Result:= AMsg.Replace(TAG_FIELD_DISPLAY, LDisplay, [rfReplaceAll, rfIgnoreCase])
//  else if (not LDisplay.Trim.IsEmpty) then
//    Result:= AMsg + Format(' [%s]', [LDisplay]);
end;

end.
