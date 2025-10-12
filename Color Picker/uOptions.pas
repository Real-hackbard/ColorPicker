{
  uOptions

  Available application's options
}

unit uOptions;

interface

uses Windows, Classes, Forms, SysUtils, IniFiles, Graphics;

type
  // Available color spaces
  TColorSpace = (csHSL, csHSV);

  // Available formatted colors
  TFormattedColor = (fcCpp, fcCSharp, fcDelphi, fcHTML, fcVB, fcCustom);

  // Available filters
  TFilter = (fNormal, fInvert, fWebsafe, fGrayscale, fDesaturate);

  TOptions = class(TObject)
  private
    FCurrentColor: TColor;
    FColorSpace: TColorSpace;
    FFormattedColor: TFormattedColor;
    FFormattedCustom: string;
    FFilter: TFilter;
    FShowHotspot: boolean;
    FCaptureLayered: boolean;
    FCloseToSysTray: boolean;
    FShowInTaskBar: boolean;
    FFullSize: boolean;
    FFilename: TFilename;
    FColorStack: TStringList;
    FParent: TForm;
    FOnCurrentColorChange: TNotifyEvent;
    procedure SetCurrentColor(Value: TColor);
    procedure SetFilter(Value: TFilter);
  public
    constructor Create(Parent: TForm);
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    function PushColor(Color: TColor): boolean;
    procedure ApplyFilter(Dest: TBitmap);
  published
    property Colors: TStringList read FColorStack;
    property CurrentColor: TColor read FCurrentColor write SetCurrentColor;
    property Filter: TFilter read FFilter write SetFilter;
    property OnCurrentColorChange: TNotifyEvent read FOnCurrentColorChange write FOnCurrentColorChange;
  end;

implementation

uses uFilters;

const
  // Maximum number of colors in the stack
  _MaxColors = 28;

constructor TOptions.Create(Parent: TForm);
begin
  inherited Create;

  // Creates the colors list
  FColorStack := TStringList.Create;

  // Saves the parent
  FParent := Parent;

  // File used to store the options
  FFilename := ExtractFilePath(Application.ExeName) + 'Data\Grabbed\Grabbed.ini';

  // Default color
  FCurrentColor := clBlack;

  // Automatically loads the options
  Load;
end;

destructor TOptions.Destroy;
begin
  // Automatically saves the options
  Save;

  // Frees resources
  FColorStack.Free;
  inherited Destroy;
end;

procedure TOptions.SetCurrentColor(Value: TColor);
begin
  if (Value <> FCurrentColor) then
  begin
    FCurrentColor := Value;
    if Assigned(FOnCurrentColorChange) then
      FOnCurrentColorChange(Self);
  end;
end;

procedure TOptions.SetFilter(Value: TFilter);
begin
  if (Value <> FFilter) then
    FFilter := Value;
end;

procedure TOptions.Load;
var
  i: integer;
begin
  with TIniFile.Create(FFilename) do
  begin
    // Main form related options
    FParent.Top := ReadInteger('WINDOW', 'Top', 0);
    FParent.Left := ReadInteger('WINDOW', 'Left', 0);
    FParent.AlphaBlend := ReadBool('WINDOW', 'Layered', false);
    FParent.AlphaBlendValue := Byte(ReadInteger('WINDOW', 'LayeredValue', 255));
    if ReadBool('WINDOW', 'StayOnTop', true) = true then
      FParent.FormStyle := fsStayOnTop
    else
      FParent.FormStyle := fsNormal;
    FCloseToSysTray := ReadBool('WINDOW', 'CloseToSysTray', true);
    FShowInTaskBar := ReadBool('WINDOW', 'ShowInTaskBar', false);
    FFullSize := ReadBool('WINDOW', 'FullSize', true);

    // Informations related options
    FColorSpace := TColorSpace(ReadInteger('GENERAL', 'ColorSpace', 0));
    FFormattedColor := TFormattedColor(ReadInteger('GENERAL', 'FormattedColor', 0));
    FFormattedCustom := ReadString('GENERAL', 'CustomFormat', '');

    // Capture related options
    FFilter := TFilter(ReadInteger('CAPTURE', 'Filter', 0));
    FShowHotSpot := ReadBool('CAPTURE', 'HotSpot', true);
    FCaptureLayered := ReadBool('CAPTURE', 'CaptureLayered', true);

    // Loads the colors
    i := 1;
    while ValueExists('COLORS', IntToStr(i)) and (i <= _MaxColors) do
    begin
      FColorStack.Add(ReadString('COLORS', IntToStr(i), '$00000000'));
      Inc(i);
    end;

    // Frees the ini file
    Free;
  end;
end;

procedure TOptions.Save;
var
  i: integer;
begin
  with TIniFile.Create(FFilename) do
  begin
    // Main form related options
    WriteInteger('WINDOW', 'Top', FParent.Top);
    WriteInteger('WINDOW', 'Left', FParent.Left);
    WriteBool('WINDOW', 'Layered', FParent.AlphaBlend);
    WriteInteger('WINDOW', 'LayeredValue', FParent.AlphaBlendValue);
    WriteBool('WINDOW', 'StayOnTop', FParent.FormStyle = fsStayOnTop);
    WriteBool('WINDOW', 'CloseToSysTray', FCloseToSysTray);
    WriteBool('WINDOW', 'ShowInTaskBar', FShowInTaskBar);
    WriteBool('WINDOW', 'FullSize', FFullSize);

    // Informations related options
    WriteInteger('GENERAL', 'ColorSpace', integer(FColorSpace));
    WriteInteger('GENERAL', 'FormattedColor', integer(FFormattedColor));
    WriteString('GENERAL', 'CustomFormat', FFormattedCustom);

    // Capture related options
    WriteInteger('CAPTURE', 'Filter', integer(FFilter));
    WriteBool('CAPTURE', 'HotSpot', FShowHotSpot);
    WriteBool('CAPTURE', 'CaptureLayered', FCaptureLayered);

    // Saves the colors
    EraseSection('COLORS');
    for i := 1 to FColorStack.Count do
      WriteString('COLORS', IntToStr(i), FColorStack[i - 1]);
    Free;
  end;
end;

function TOptions.PushColor(Color: TColor): boolean;
begin
  if (FColorStack.Count = 0) or (ColorToString(Color) <> FColorStack[0]) then
  begin
    // Inserts the new color
    FColorStack.Insert(0, ColorToString(Color));

    // Removes extra colors
    while (FColorStack.Count > _MaxColors) do
      FColorStack.Delete(FColorStack.Count - 1);

    Result := true;
  end
  else
    Result := false;
end;

// Applies the selected filter on a bitmap
procedure TOptions.ApplyFilter(Dest: TBitmap);
begin
  if FFilter = fInvert then
    InvertBitmap(Dest)
  else if FFilter = fWebsafe then
    WebSafeBitmap(Dest)
  else if FFilter = fGrayscale then
    GrayscaleBitmap(Dest)
  else if FFilter = fDesaturate then
    DesaturateBitmap(Dest);
end;

end.
