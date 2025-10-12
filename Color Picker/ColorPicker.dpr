program ColorPicker;



uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uSnapshots in 'uSnapshots.pas',
  uUtils in 'uUtils.pas',
  uLang in 'uLang.pas',
  CheckPrevious in 'CheckPrevious.pas',
  uScreenCapture in 'uScreenCapture.pas',
  uFilters in 'uFilters.pas',
  uOptions in 'uOptions.pas',
  uColorUtil in 'uColorUtil.pas',
  uColorDialog in 'uColorDialog.pas' {fColor},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.RES}

begin
  if not CheckPrevious.RestoreIfRunning(Application.Handle, 1) then
  begin
    Application.Initialize;
    Application.Title := 'Color Picker';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfColor, fColor);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
  end;
end.
