unit Unit1;

interface

uses
  Windows, Classes, Forms, Controls, StdCtrls, ExtCtrls, ComCtrls, Dialogs,
  Messages, SysUtils, Graphics, ShellAPI, Menus, IniFiles, uSnapShots, uLang,
  uUtils, uScreenCapture, uFilters, uColorUtil, XPMan, Clipbrd, Buttons,
  uOptions;

type
  TForm1 = class(TForm)
    timerMain: TTimer;
    popupTray: TPopupMenu;
    popupOptions: TPopupMenu;
    mnuRestore: TMenuItem;
    mnuQuit: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N7: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPause: TMenuItem;
    mnuColor: TMenuItem;
    mnuEffect: TMenuItem;
    mnuCustCol0: TMenuItem;
    mnuCustCol1: TMenuItem;
    mnuCustCol2: TMenuItem;
    mnuCustCol3: TMenuItem;
    mnuCustCol4: TMenuItem;
    mnuFX0: TMenuItem;
    mnuFX1: TMenuItem;
    mnuFX2: TMenuItem;
    mnuFX3: TMenuItem;
    mnuFX4: TMenuItem;
    mnuSnap: TMenuItem;
    mnuHotspot: TMenuItem;
    mnuAddLayered: TMenuItem;
    mnuSysTray: TMenuItem;
    mnuGrab: TMenuItem;
    mnuTaskBar: TMenuItem;
    mnuOnTop: TMenuItem;
    pcMain: TPageControl;
    tabMain: TTabSheet;
    tabSnaps: TTabSheet;
    tabOptions: TTabSheet;
    lstSnaps: TListBox;
    btnDelSnap: TButton;
    btnSaveSnap: TButton;
    lblCustomColor: TLabel;
    cbCustom: TComboBox;
    chkSysTray: TCheckBox;
    lblLng: TLabel;
    cbLngs: TComboBox;
    chkHotSpot: TCheckBox;
    lblFX: TLabel;
    cbFX: TComboBox;
    pnlCapture: TPanel;
    shpEdit: TShape;
    imgEdit: TImage;
    imgFold: TImage;
    chkAddLayered: TCheckBox;
    chkLayered: TCheckBox;
    trkLayered: TTrackBar;
    trkZoom: TTrackBar;
    imgZoom: TImage;
    lblFactor: TLabel;
    imgMousePos: TImage;
    lblCursor: TLabel;
    boxGrabbed: TGroupBox;
    imgCol1: TImage;
    imgCol2: TImage;
    imgCol3: TImage;
    imgCol4: TImage;
    imgCol5: TImage;
    imgCol6: TImage;
    imgCol7: TImage;
    imgCol8: TImage;
    imgCol9: TImage;
    imgCol10: TImage;
    imgCol11: TImage;
    imgCol12: TImage;
    imgCol13: TImage;
    imgCol14: TImage;
    imgCol15: TImage;
    imgCol16: TImage;
    imgCol17: TImage;
    imgCol18: TImage;
    imgCol19: TImage;
    imgCol20: TImage;
    imgCol21: TImage;
    imgCol22: TImage;
    imgCol23: TImage;
    imgCol24: TImage;
    imgCol25: TImage;
    imgCol26: TImage;
    imgCol27: TImage;
    imgCol28: TImage;
    cbSpace: TComboBox;
    lblColorSpace: TLabel;
    imgCol: TImage;
    imgWebsafe: TImage;
    eRGBR: TEdit;
    eRGBG: TEdit;
    eRGBB: TEdit;
    eSpace1: TEdit;
    eSpace2: TEdit;
    eSpace3: TEdit;
    lblRGB: TLabel;
    lblSpace: TLabel;
    eCustom: TEdit;
    lblCustom: TLabel;
    btnCopy: TBitBtn;
    chkOnTop: TCheckBox;
    chkTaskBar: TCheckBox;
    N8: TMenuItem;
    TabSheet1: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    imgCol35: TImage;
    imgCol34: TImage;
    imgCol33: TImage;
    imgCol32: TImage;
    imgCol31: TImage;
    imgCol30: TImage;
    imgCol29: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    Image1: TImage;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mnuCustCol0Click(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuFX0Click(Sender: TObject);
    procedure mnuTaskBarClick(Sender: TObject);
    procedure chkTaskBarClick(Sender: TObject);
    procedure mnuOnTopClick(Sender: TObject);
    procedure chkOnTopClick(Sender: TObject);
    procedure chkSysTrayClick(Sender: TObject);
    procedure chkAddLayeredClick(Sender: TObject);
    procedure mnuSysTrayClick(Sender: TObject);
    procedure mnuAddLayeredClick(Sender: TObject);
    procedure mnuPauseClick(Sender: TObject);
    procedure cbSpaceChange(Sender: TObject);
    procedure chkHotSpotClick(Sender: TObject);
    procedure cbFXChange(Sender: TObject);
    procedure cbCustomChange(Sender: TObject);
    procedure mnuHotspotClick(Sender: TObject);
    procedure imgCol18Click(Sender: TObject);
    procedure imgCol18MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuGrabClick(Sender: TObject);
    procedure imgColClick(Sender: TObject);
    procedure timerMainTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trkZoomChange(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure mnuSnapClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure lstSnapsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstSnapsClick(Sender: TObject);
    procedure imgEditMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnDelSnapClick(Sender: TObject);
    procedure btnSaveSnapClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuRestoreClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure cbLngsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgFoldClick(Sender: TObject);
    procedure chkLayeredClick(Sender: TObject);
    procedure trkLayeredChange(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgWebsafeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Clear1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
   private
    rScreen: TRect;
    OldTimer: boolean;
    IconData: TNotifyIconDataEx;
    AttendButtonUp: Boolean;
    bmpSpectrum: TBitmap;
    bmpWebSafe, bmpNotWebSafe: TBitmap;
    Options: TOptions;
    procedure WMTrayIconMessage(var Msg: TMessage); message WM_TRAYNOTIFY;
    procedure OnMinimized(Sender: TObject);
    procedure DrawSpectrum;
    procedure DrawSeparationBar;
    procedure DrawGrabbedColors;
    procedure ColorChanged(Sender: TObject);
  public
    Snapshots: TSnapshots;
    Languages: TLanguages;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R RESRC.RES}

uses uColorDialog, Unit2;

const
  _Ratios: array[1..12] of byte = (2, 4, 8, 12, 16, 20, 24, 28, 32, 40, 48, 64);
  _crDropper = 1;

procedure TForm1.WMTrayIconMessage(var Msg: TMessage);
var
  P: TPoint;
begin
  case Msg.LParam of
    WM_LBUTTONDBLCLK:
      AttendButtonUp := True;
    WM_LBUTTONUP:
      if AttendButtonUp then
      begin
        AttendButtonUp := False;
        mnuRestore.OnClick(Self);
        PopupMenu := nil;
      end;
    WM_RBUTTONUP:
      begin
        GetCursorPos(P);
        SetForegroundWindow(Handle);
        popupTray.Popup(P.x, P.y);
      end;
  end;
end;

procedure TForm1.DrawSpectrum;
var x, y, vY: integer; Row: PRGBTripleArray;
begin
  bmpSpectrum.Width := RGBMAX + 1;
  bmpSpectrum.Height := RGBMAX + 1;
  bmpSpectrum.PixelFormat := pf24bit;
  for y := 0 to RGBMAX do begin
    Row := bmpSpectrum.ScanLine[y];
    vY := RGBMAX - y;
    for x := 0 to RGBMAX do Row[x] := HSLInRGBMAXToRGB(x, RGBMAX, vY);
  end;
end;

procedure TForm1.DrawSeparationBar;
var bmp: TBitmap; bmpBrush: TBitmap; rgb1, rgb2, rgb3: TRGBTriple;
begin
	bmpBrush := TBitmap.Create;
  bmpBrush.Width := 8;
  bmpBrush.Height := 8;
  with bmpBrush.Canvas do
  begin
  	Brush.Color := clLime;
    FillRect(ClipRect);
    Pixels[3,2] := clBtnShadow;
    Pixels[2,3] := clBtnShadow;
    Pixels[5,4] := clBtnHighlight;
    Pixels[4,5] := clBtnHighlight;
    rgb1 := ColorToRGBTriple(Pixels[3,2]);
    rgb2 := ColorToRGBTriple(Pixels[5,4]);
    rgb3.rgbtRed := (2 * rgb1.rgbtRed + rgb2.rgbtRed) div 3;
    rgb3.rgbtGreen := (2 * rgb1.rgbtGreen + rgb2.rgbtGreen) div 3;
    rgb3.rgbtBlue := (2 * rgb1.rgbtBlue + rgb2.rgbtBlue) div 3;
    Pixels[4,2] := RGBTripleToColor(rgb3);
    Pixels[3,3] := RGBTripleToColor(rgb3);
    Pixels[2,4] := RGBTripleToColor(rgb3);
    rgb3.rgbtRed := (rgb1.rgbtRed + rgb2.rgbtRed) div 2;
    rgb3.rgbtGreen := (rgb1.rgbtGreen + rgb2.rgbtGreen) div 2;
    rgb3.rgbtBlue := (rgb1.rgbtBlue + rgb2.rgbtBlue) div 2;
    Pixels[4,3] := RGBTripleToColor(rgb3);
    Pixels[3,4] := RGBTripleToColor(rgb3);
    rgb3.rgbtRed := (2 * rgb2.rgbtRed + rgb1.rgbtRed) div 3;
    rgb3.rgbtGreen := (2 * rgb2.rgbtGreen + rgb1.rgbtGreen) div 3;
    rgb3.rgbtBlue := (2 * rgb2.rgbtBlue + rgb1.rgbtBlue) div 3;
    Pixels[5,3] := RGBTripleToColor(rgb3);
    Pixels[4,4] := RGBTripleToColor(rgb3);
    Pixels[3,5] := RGBTripleToColor(rgb3);
  end;
  bmp := TBitmap.Create;
  bmp.Width := imgFold.Width;
  bmp.Height := imgFold.Height;
  bmp.Canvas.Brush.Bitmap := bmpBrush;
	bmp.Canvas.FillRect(bmp.canvas.ClipRect);
  imgFold.Canvas.Draw(0, 0, bmp);
  imgFold.Transparent := true;
  bmpBrush.Free;
  bmp.Free;
end;

procedure TForm1.DrawGrabbedColors;
var  i: integer; bmp: TBitmap; imgColor: TImage;
  RGB: TRGBTriple; HSL: THSLTriple; HSV: THSVTriple;  sHint: string;
begin
  if Options.Colors.Count > 0 then
  begin
    bmp := TBitmap.Create;
    bmp.Width := imgCol1.Width;
    bmp.Height := imgCol1.Height;
    bmp.PixelFormat := pf24bit;
    bmp.Canvas.Pen.Color := clBlack;
    for i := 0 to Options.Colors.Count - 1 do
    begin
      imgColor := TImage(Form1.FindComponent('imgCol'+ IntToStr(i+1)));
      bmp.Canvas.Brush.Color := StringToColor(Options.Colors[i]);
      bmp.Canvas.Rectangle(0, 0, bmp.Width, bmp.Height);
      imgColor.Canvas.Draw(0, 0, bmp);
      RGB := ColorToRGBTriple(StringToColor(Options.Colors[i]));
      HSL := RGBToHSL(RGB);
      HSV := RGBToHSV(RGB);
      sHint :=  Format(
                  'RGB: %d %d %d',
                  [RGB.rgbtRed, RGB.rgbtGreen, RGB.rgbtBlue]) +
                Chr(13) + Chr(10) +
                Format(
                  'HSL: %d° %d %d',
                  [HSL.hsltHue, HSL.hsltSaturation, HSL.hsltLuminance]) +
                Chr(13) + Char(10) +
                Format(
                  'HSV: %d° %d %d',
                  [HSV.hsvtHue, HSV.hsvtSaturation, HSV.hsvtValue]) +
                Chr(13) + Chr(10);
      sHint := sHint + cbCustom.Text + ': ';
      case cbCustom.ItemIndex of
        0: sHint := sHint + RGBToCppHEX(RGB);
        1: sHint := sHint + RGBToCSharp(RGB);
        2: sHint := sHint + RGBToDelphiHEX(RGB);
        3: sHint := sHint + RGBToHTML(RGB);
        else
          sHint := sHint + RGBToVBHEX(RGB);
      end;
      imgColor.Hint := sHint;
      imgColor.Visible := true;
    end;
    bmp.Free;
  end;
end;

procedure TForm1.Clear1Click(Sender: TObject);
var
  strlst: TStringList;
  i, c: integer;
  Img : TImage;
begin
  strlst := TStringList.Create;
  try
    strlst.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Data\Grabbed\Grabbed.ini');
    for i := strlst.Count - 1 downto 0 do
      if Pos('1=$',strlst[i]) > 0 then
        strlst.Delete(i);
    strlst.SaveToFile(ExtractFilePath(Application.ExeName) + 'Data\Grabbed\Grabbed.ini');
  finally
    strlst.Free;

    for c := 0 to 35 -1 do
    begin
      Img := TImage(Form1.FindComponent('imgCol'+ IntToStr(c+1)));
      Img.Picture.Graphic := nil;
    end;

    Options := TOptions.Create(self);
    Options.OnCurrentColorChange := ColorChanged;
    cbFX.ItemIndex := integer(Options.Filter);
  end;
end;

procedure TForm1.ColorChanged(Sender: TObject);
var
  RGB: TRGBTriple;
  HSL: THSLTriple;
  HSV: THSVTriple;
  Bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.Width := imgCol.Width;
  bmp.Height := imgCol.Height;
  with bmp.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := Options.CurrentColor;
    Rectangle(0, 0, bmp.Width, bmp.Height);
  end;

  imgCol.Canvas.Draw(0, 0, bmp);
  bmp.Free;
  RGB := ColorToRGBTriple(Options.CurrentColor);

  if RGBIsWebSafe(RGB) then
  begin
    if imgWebSafe.Tag <> 1 then
    begin
      imgWebSafe.Picture.Bitmap := bmpWebSafe;
      imgWebSafe.Tag := 1;
    end;
  end
  else if imgWebSafe.Tag <> 0 then
  begin
    imgWebSafe.Picture.Bitmap := bmpNotWebSafe;
    imgWebSafe.Tag := 0;
  end;

  eRGBR.Text := IntToStr(RGB.rgbtRed);
  eRGBG.Text := IntToStr(RGB.rgbtGreen);
  eRGBB.Text := IntToStr(RGB.rgbtBlue);

  if (cbSpace.ItemIndex = 0) then
  begin
      lblSpace.Caption := 'HSL:';
      HSL := RGBToHSL(RGB);
      eSpace1.Text := IntToStr(HSL.hsltHue);
      eSpace2.Text := IntToStr(HSL.hsltSaturation);
      eSpace3.Text := IntToStr(HSL.hsltLuminance);
  end else begin
      lblSpace.Caption := 'HSV:';
      HSV := RGBToHSV(RGB);
      eSpace1.Text := IntToStr(HSV.hsvtHue);
      eSpace2.Text := IntToStr(HSV.hsvtSaturation);
      eSpace3.Text := IntToStr(HSV.hsvtValue);
  end;

  lblCustom.Caption := cbCustom.Text + ':';

  case cbCustom.ItemIndex of
      0: eCustom.Text := RGBToCppHEX(RGB);
      1: eCustom.Text := RGBToCSharp(RGB);
      2: eCustom.Text := RGBToDelphiHEX(RGB);
      3: eCustom.Text := RGBToHTML(RGB);
      else
        eCustom.Text := RGBToVBHEX(RGB);
  end;
end;

procedure TForm1.OnMinimized(Sender: TObject);
begin
  if chkSysTray.Checked then
  begin
    Hide;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var  i: integer;
begin
  //Application.OnMinimize := OnMinimized;
  Screen.Cursors[_crDropper] := LoadCursor(hInstance, 'CR_DROPPER');
  ImgEdit.Cursor := _crDropper;
  imgMousePos.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMP_POS');
  imgZoom.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMP_ZOOM');
  btnCopy.Glyph.LoadFromResourceName(hInstance, 'BMP_COPY');
  bmpWebSafe := TBitmap.Create;
  bmpNotWebSafe := TBitmap.Create;
  bmpWebSafe.LoadFromResourceName(hInstance, 'BMP_WEBSAFE');
  bmpNotWebSafe.LoadFromResourceName(hInstance, 'BMP_NOTWEBSAFE');
  bmpSpectrum := TBitmap.Create;
  DrawSpectrum;
  DrawSeparationBar;
  Languages := TLanguages.Create;

  if Languages.GetLanguages then
  begin
    for i := 0 to Languages.Files.Count - 1 do
      cbLngs.Items.Add(Languages.Files.Names[i]);
    cbLngs.Enabled := true;
  end;

  cbLngs.ItemIndex := 0;
  Languages.GetDefault(Form1);
  Languages.DefaultStr.Add('btnPause=&Pause');
  Languages.DefaultStr.Add('btnResume=&Resume');
  Languages.DefaultStr.Add('DeleteSnapshot=Delete snapshot ''%s''?');
  Languages.DefaultStr.Add('Snapshots=Snapshots');
  Languages.DefaultStr.Add('Byte=B');
  Languages.DefaultStr.Add('AddedSnapshot=Snapshot ''%s'' added.');
  Snapshots := TSnapshots.Create;
  Snapshots.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Data\Snaps\Snaps.dat');

  if Snapshots.Count > 0 then
  begin
    for i := 0 to Snapshots.Count - 1 do
      lstSnaps.Items.Add(Snapshots.Item[i].Name);
    lstSnaps.Enabled := true;
  end;

  LoadWindowsHand;
  trkZoom.Min := Low(_Ratios);
  trkZoom.Max := High(_Ratios);
  Options := TOptions.Create(self);
  Options.OnCurrentColorChange := ColorChanged;
  cbFX.ItemIndex := integer(Options.Filter);

  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data\Options\Options.ini') do
    begin
      cbSpace.ItemIndex := ReadInteger('GENERAL', 'ColorSpace', 0);
      cbCustom.ItemIndex := ReadInteger('GENERAL', 'CustomColor', 0);
      trkZoom.Position := ReadInteger('GENERAL', 'Zoom', 2);
      if not ReadBool('GENERAL', 'FullSize', true) then
        imgFold.OnClick(Self);
      chkHotspot.Checked := ReadBool('GENERAL', 'Hotspot', true);
      chkAddLayered.Checked := ReadBool('GENERAL', 'AddLayered', true);
      chkSysTray.Checked := ReadBool('GENERAL', 'SysTray', false);
      chkOnTop.Checked := ReadBool('GENERAL', 'OnTop', true);
      chkTaskBar.Checked := ReadBool('GENERAL', 'TaskBar', true);
      cbLngs.ItemIndex := ReadInteger('GENERAL', 'Language', 0);
      Free;
    end;

  with IconData do
  begin
    cbSize := SizeOf(IconData);
    Wnd := Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
    uCallBackMessage := WM_TRAYNOTIFY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;

  Shell_NotifyIcon(NIM_ADD, @IconData);
  cbSpace.OnChange(Self);
  cbCustom.OnChange(Self);
  cbFX.OnChange(Self);
  pnlCapture.DoubleBuffered := true;

  KeyPreview := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Data\Options\Options.ini') do
    begin
        WriteInteger('GENERAL', 'ColorSpace', cbSpace.ItemIndex);
        WriteInteger('GENERAL', 'CustomColor', cbCustom.ItemIndex);
        WriteInteger('GENERAL', 'Zoom', trkZoom.Position);
        WriteInteger('GENERAL', 'FX', cbFX.ItemIndex);
        WriteBool('GENERAL', 'FullSize', pnlCapture.Visible);
        WriteBool('GENERAL', 'Hotspot', mnuHotspot.Checked);
        WriteBool('GENERAL', 'AddLayered', chkAddLayered.Checked);
        WriteBool('GENERAL', 'SysTray', chkSysTray.Checked);
        WriteBool('GENERAL', 'OnTop', chkOnTop.Checked);
        WriteBool('GENERAL', 'TaskBar', chkTaskBar.Checked);
        WriteInteger('GENERAL', 'Language', cbLngs.ItemIndex);
        Free;
    end;
    Snapshots.SaveToFile(ExtractFilePath(Application.ExeName) + 'Data\Snaps\Snaps.dat');
    IconData.uID := 1;
    Shell_NotifyIcon(NIM_DELETE, @IconData);
    Options.Free;
    Snapshots.Free;
    Languages.Free;
    bmpSpectrum.Free;
    bmpWebSafe.Free;
    bmpNotWebSafe.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then begin
    TimerMain.Enabled := false;
    Label1.Caption := '" F2 "  Start';
  end;

  if Key = VK_F2 then begin
    TimerMain.Enabled := true;
    Label1.Caption := '" F1 "  Stop';
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  cbLngs.OnChange(Self);
  trkZoom.OnChange(Self);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    form2 := TForm2.Create(nil);
    form2.ShowModal;
    finally
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if chkSysTray.Checked then
  begin
    OldTimer := timerMain.Enabled;
    timerMain.Enabled := false;
    mnuRestore.Enabled := true;
    Action := caNone;
    PopupMenu := popupTray;
    Application.Minimize;
  end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Options.PushColor(Options.CurrentColor)) then // colorCurrent)) then
    DrawGrabbedColors;
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
    if pcMain.ActivePage = tabMain then
      if (trkZoom.Position < trkZoom.Max) and
        not trkZoom.Focused and
        trkZoom.Enabled then
      begin
        trkZoom.Position := trkZoom.Position + 1;
        Handled := true;
      end;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
    if pcMain.ActivePage = tabMain then
      if (trkZoom.Position > trkZoom.Min) and
        not trkZoom.Focused and
        trkZoom.Enabled then
      begin
        trkZoom.Position := trkZoom.Position - 1;
        Handled := true;
      end;
end;

procedure TForm1.trkZoomChange(Sender: TObject);
var
    iZoom: integer;
    iWidth: integer;
    iHeight: integer;
begin
    iZoom := _Ratios[trkZoom.Position] div 2;
    if imgEdit.Width mod iZoom > 0 then iWidth := imgEdit.Width div iZoom + 1
    else iWidth := imgEdit.Width div iZoom;
    if imgEdit.Height mod iZoom > 0 then iHeight := imgEdit.Height div iZoom + 1
    else
        iHeight := imgEdit.Height div iZoom;
    lblFactor.Caption := Format('%dx (%dx%d)', [iZoom, iWidth, iHeight]);
end;

procedure TForm1.timerMainTimer(Sender: TObject);
var
  pCursor: TPoint;
  rInvalid: TRect;
  bmpDesk: TBitmap;
begin
  GetCursorPos(pCursor);
  lblCursor.Caption := Format('(%d,%d)',[pCursor.X, pCursor.Y]);
  rInvalid := Rect(
                shpEdit.ClientToScreen(Point(0,0)),
                shpEdit.ClientToScreen(Point(shpEdit.Width, shpEdit.Height)));
  if not pnlCapture.Visible then
  begin
    bmpDesk := TBitmap.Create;
    rScreen.Left := pCursor.X - 2;
    rScreen.Top := pCursor.y - 2;
    rScreen.Right := pCursor.X + 2;
    rScreen.Bottom := pCursor.Y + 2;
    CaptScreen(bmpDesk, rScreen, chkAddLayered.Checked);
    Options.ApplyFilter(bmpDesk);
    Options.CurrentColor := bmpDesk.Canvas.Pixels[1, 1];
    bmpDesk.Free;
  end
  else if not PtInRect(rInvalid, pCursor) then
  begin
    mnuSnap.Enabled := true;
    rScreen.Left := pCursor.X - imgEdit.Width div _Ratios[trkZoom.Position];
    rScreen.Top := pCursor.Y - imgEdit.Height div _Ratios[trkZoom.Position];
    if imgEdit.Width mod _Ratios[trkZoom.Position] > 0 then
      rScreen.Right := pCursor.X + imgEdit.Width div _Ratios[trkZoom.Position] + 1
    else
      rScreen.Right := pCursor.X + imgEdit.Width div _Ratios[trkZoom.Position];
    if imgEdit.Height mod _Ratios[trkZoom.Position] > 0 then
      rScreen.Bottom := pCursor.Y + imgEdit.Height div _Ratios[trkZoom.Position] + 1
    else
      rScreen.Bottom := pCursor.Y + imgEdit.Height div _Ratios[trkZoom.Position];
    if rScreen.Left < 0 then
      OffsetRect(rScreen, -rScreen.Left, 0);
    If rScreen.Top < 0 then
      OffsetRect(rScreen, 0, -rScreen.Top);
    If rScreen.Right > Screen.DesktopWidth then
      OffsetRect(rScreen, -(rScreen.Right - Screen.DesktopWidth), 0);
    If rScreen.Bottom > Screen.DesktopHeight then
      OffsetRect(rScreen, 0, -(rScreen.Bottom - Screen.DesktopHeight));
    bmpDesk := TBitmap.Create;
    CaptScreen(bmpDesk, rScreen, chkAddLayered.Checked);
    pCursor.X := pCursor.X - rScreen.Left;
    pCursor.Y := pCursor.Y - rScreen.Top;
    if mnuHotspot.Checked then
    with bmpDesk.Canvas do
    begin
      Pen.Mode := pmNot;
      MoveTo(pCursor.X - 1, pCursor.Y - 1);
      LineTo(pCursor.X + 1, pCursor.Y - 1);
      LineTo(pCursor.X + 1, pCursor.Y + 1);
      LineTo(pCursor.X - 1, pCursor.Y + 1);
      LineTo(pCursor.X - 1, pCursor.Y - 1);
      if trkZoom.Position = 1 then
      begin
        MoveTo(pCursor.X - 2, pCursor.Y - 2);
        LineTo(pCursor.X + 2, pCursor.Y - 2);
        LineTo(pCursor.X + 2, pCursor.Y + 2);
        LineTo(pCursor.X - 2, pCursor.Y + 2);
        LineTo(pCursor.X - 2, pCursor.Y - 2);
      end;
    end;
    Options.ApplyFilter(bmpDesk);
    Options.CurrentColor := bmpDesk.Canvas.Pixels[pCursor.X, pCursor.Y];
    imgEdit.Canvas.CopyRect(
                    imgEdit.Canvas.ClipRect,
                    bmpDesk.Canvas,
                    bmpDesk.Canvas.ClipRect);
    bmpDesk.Free;  end  else  begin
    bmpDesk := TBitmap.Create;
    bmpDesk.Assign(bmpSpectrum);
    Options.ApplyFilter(bmpDesk);
    imgEdit.Canvas.CopyRect(
                    imgEdit.Canvas.ClipRect,
                    bmpDesk.Canvas,
                    bmpDesk.Canvas.ClipRect);
    pCursor := imgEdit.ScreenToClient(pCursor);
    Options.CurrentColor := bmpDesk.Canvas.Pixels[pCursor.X, pCursor.Y];
    bmpDesk.Free;
    mnuSnap.Enabled := false
    end;
end;

procedure TForm1.imgFoldClick(Sender: TObject);
begin
  if pnlCapture.Visible then
    Form1.Width := Form1.Width - pnlCapture.Width
  else
    Form1.Width := Form1.Width + pnlCapture.Width;
  pnlCapture.Visible := not pnlCapture.Visible;
  timerMain.Enabled := ( (pcMain.ActivePage = tabMain) or
                          ((pcMain.ActivePage = tabOptions) and
                          pnlCapture.Visible)) and
                          (mnuPause.Tag = 0);
  mnuSnap.Enabled := timerMain.Enabled;
end;

procedure TForm1.imgWebsafeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fColor.Show;
end;

procedure TForm1.pcMainChange(Sender: TObject);
begin
  { Activate Timer
  timerMain.Enabled := ( (pcMain.ActivePage = tabMain) or
                          ((pcMain.ActivePage = tabOptions) and
                          pnlCapture.Visible)) and
                          (mnuPause.Tag = 0);
  }
  mnuSnap.Enabled := timerMain.Enabled;
  if (pcMain.ActivePage = tabSnaps) then
  begin
    if (lstSnaps.Items.Count = 0) then
      imgEdit.Picture.Bitmap.Assign(bmpSpectrum) else begin
      if lstSnaps.ItemIndex = -1 then
        lstSnaps.ItemIndex := 0;
      lstSnaps.OnClick(Self);
    end;
  end;
end;

procedure TForm1.lstSnapsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var r: TRect; i, indent: integer; rgb1, rgb2, rgb3: TRGBTriple;
begin
  with lstSnaps.Canvas do
  begin
    if (odFocused in State) and (odSelected in State) then
    begin
      rgb1 := ColorToRGBTriple(TColor(ColorToRGB(clHighlight)));
      rgb2 := ColorToRGBTriple(TColor(ColorToRGB(lstSnaps.Color)));
      rgb3.rgbtRed := (rgb1.rgbtRed + 2 * rgb2.rgbtRed) div 3;
      rgb3.rgbtGreen := (rgb1.rgbtGreen + 2 * rgb2.rgbtGreen) div 3;
      rgb3.rgbtBlue := (rgb1.rgbtBlue + 2 * rgb2.rgbtBlue) div 3;
      Brush.Color := RGBTripleToColor(rgb3);
      Pen.Color := clHighLight;
    end
    else if (odSelected in State) then
    begin
      Brush.Color := clBtnFace;
      Pen.Color := clBtnShadow;
    end else begin
      Brush.Color := lstSnaps.Color; Pen.Color := lstSnaps.Color;
    end;
    RoundRect( Rect.Left + 1, Rect.Top + 1, Rect.Right - 1, Rect.Bottom - 1, 6, 6);
    r.Top := Rect.Top + (Rect.Bottom - Rect.Top - 32) div 2;
    r.Bottom := r.Top + 32;
    r.Left := Rect.Left + (Rect.Bottom - Rect.Top - 32) div 2;
    r.Right := r.Left + 32;
    StretchDraw(r, Snapshots[Index].Bitmap);
    if odSelected in State then
      Font.Style := [fsBold]
    else
      Font.Style := [];
    i := TextHeight('°_');
    Font.Size := lstSnaps.Font.Size - 1;
    Font.Style := [];
    indent := (Rect.Bottom - Rect.Top - (i + 1) * 2) div 3;
    Font.Color := clGray;
    Font.Style := [];
    TextOut(
      r.Right + 16,
      Rect.Top + 1 + i + indent * 2,
      IntToStr(Snapshots[Index].Bitmap.Width) + 'x' +
        IntToStr(Snapshots[Index].Bitmap.Height) + '  ' +
        BytesToStr(Snapshots[Index].Size,
          Languages.GetResStrValue('Byte'), 1000));
    Font.Color := clBlack;
    Font.Size := lstSnaps.Font.Size;
    if odSelected in State then
      Font.Style := [fsBold]
    else
      Font.Style := [];
    TextOut(r.Right + 8, Rect.Top + 1 + indent, lstSnaps.Items[Index]);
    if (odFocused in State) then
      DrawFocusRect(Rect);
  end;
end;

procedure TForm1.lstSnapsClick(Sender: TObject);
begin
  if lstSnaps.ItemIndex > -1 then
  begin
    imgEdit.Canvas.CopyRect(
      imgEdit.Canvas.ClipRect,
      Snapshots[lstSnaps.ItemIndex].Bitmap.Canvas,
      Snapshots[lstSnaps.ItemIndex].Bitmap.Canvas.ClipRect);
  end
  else
    imgEdit.Picture.Bitmap.Assign(bmpSpectrum);
end;

procedure TForm1.imgEditMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if not trkZoom.Enabled then
    Options.CurrentColor := imgEdit.Canvas.Pixels[X, Y];
end;

procedure TForm1.btnDelSnapClick(Sender: TObject);
begin
  if (lstSnaps.ItemIndex > -1) and
      (MessageBox(
        Application.Handle,
        PChar(Format(Languages.GetResStrValue('DeleteSnapshot'), [SnapShots[lstSnaps.ItemIndex].Name])),
        PChar(Languages.GetResStrValue('Snapshots')),
        MB_YESNO or MB_ICONQUESTION) = mrYes) then
  begin
    Snapshots.Delete(lstSnaps.ItemIndex);
    lstSnaps.Items.Delete(lstSnaps.ItemIndex);
    if lstSnaps.Items.Count = 0 then
    begin
      imgEdit.Picture.Bitmap.Assign(bmpSpectrum);
      lstSnaps.Enabled := false;
    end
    else
    begin
      lstSnaps.ItemIndex := 0;
      lstSnaps.OnClick(Self);
    end;
  end;
end;

procedure TForm1.btnSaveSnapClick(Sender: TObject);
var  Filename: string;
begin
  if (lstSnaps.ItemIndex > -1) then
  begin
    Filename := SnapShots[lstSnaps.ItemIndex].Name + '.bmp';
    if PromptForFilename(
        Filename, 'Bitmap (*.bmp)|*.bmp',
        '.bmp', '', '', true) then
    SnapShots[lstSnaps.ItemIndex].Bitmap.SaveToFile(Filename);
  end;
end;

procedure TForm1.imgColClick(Sender: TObject);
var
  FormColor: TfColor;
begin
  if (not timerMain.Enabled) then
  begin
    FormColor := TfColor.Create(Self);
    FormColor.OldColor := Options.CurrentColor;
    if (FormColor.ShowModal = mrOK) then
      Options.CurrentColor := RGBTripleToColor(FormColor.CurrentColor.RGB);
    FormColor.Release;
  end;
end;

procedure TForm1.imgCol18MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if timerMain.Enabled then
    (Sender as TImage).Cursor := crDefault
  else
    (Sender as TImage).Cursor := crHandPoint;
end;

procedure TForm1.imgCol18Click(Sender: TObject);
begin
  if not timerMain.Enabled then
    Options.CurrentColor := StringToColor(Options.Colors[(Sender as TImage).Tag - 1]);
end;

procedure TForm1.cbLngsChange(Sender: TObject);
begin
  Languages.LoadLanguage(Languages.Files.Values[cbLngs.Text]);
  if mnuPause.Tag = 1 then
    mnuPause.Caption := Languages.GetResStrValue('btnResume');
  trkZoom.OnChange(self);
end;

procedure TForm1.mnuQuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.mnuRestoreClick(Sender: TObject);
begin
  Show;
  timerMain.Enabled := OldTimer;
  mnuRestore.Enabled := false;
end;

procedure TForm1.mnuGrabClick(Sender: TObject);
begin
  if (Options.PushColor(Options.CurrentColor)) then // colorCurrent)) then
    DrawGrabbedColors;
end;

procedure TForm1.mnuSnapClick(Sender: TObject);
var
  bmp: TBitmap;
  Snap: TSnapshot;
  pCursor: TPoint;
begin
  try
    bmp := TBitmap.Create;
    CaptScreen(bmp, rScreen, chkAddLayered.Checked);
    Options.ApplyFilter(bmp);
    GetCursorPos(pCursor);
    Snap := TSnapshot.Create('Snapshot' + IntToStr(Snapshots.Increment + 1),
              bmp,
              pCursor);
    Snapshots.Add(Snap);
    lstSnaps.ItemIndex := lstSnaps.Items.Add(Snap.Name);
    lstSnaps.Enabled := true;
  finally
    bmp.Free;
  end;

  with IconData do
  begin
    uFlags := uFlags or _NIF_INFO;
    StrPCopy(szInfo, '');
  end;

  Shell_NotifyIcon(NIM_MODIFY, @IconData);

  with IconData do
  begin
    uFlags := uFlags or _NIF_INFO;
    StrPCopy(szInfo, Format(Languages.GetResStrValue('AddedSnapshot'), [Snap.Name]));
    StrPCopy(szInfoTitle, Languages.GetResStrValue('Snapshots'));
    uTimeout := 10000;
    dwInfoFlags := _NIIF_INFO;
  end;

  Shell_NotifyIcon(NIM_MODIFY, @IconData);
  IconData.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
end;

procedure TForm1.mnuPauseClick(Sender: TObject);
begin
    if mnuPause.Tag = 0 then
    begin
        mnuPause.Caption := Languages.GetResStrValue('btnResume');
        mnuPause.Tag := 1;
    end else begin
        mnuPause.Caption := Languages.GetResStrValue('btnPause');
        mnuPause.Tag := 0;
    end;
    trkZoom.Enabled := mnuPause.Tag = 0;
    lblFactor.Enabled := trkZoom.Enabled;
    lblCursor.Caption := '';
    timerMain.Enabled := (  (pcMain.ActivePage = tabMain) or
                            (pcMain.ActivePage = tabOptions) ) and
                            (mnuPause.Tag = 0);
    mnuSnap.Enabled := timerMain.Enabled;
end;

procedure TForm1.mnuCopyClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(eCustom.Text));
end;

procedure TForm1.mnuCustCol0Click(Sender: TObject);
begin
  cbCustom.ItemIndex := (Sender as TMenuItem).Tag;
end;

procedure TForm1.cbCustomChange(Sender: TObject);
begin
  (Form1.FindComponent('mnuCustCol' + IntToStr(cbCustom.ItemIndex)) as TMenuItem).Checked := true;
  DrawGrabbedColors;
end;

procedure TForm1.mnuFX0Click(Sender: TObject);
begin
  cbFX.ItemIndex := (Sender as TMenuItem).Tag;
end;

procedure TForm1.cbFXChange(Sender: TObject);
begin
  (Form1.FindComponent('mnuFX' + IntToStr(cbFX.ItemIndex)) as TMenuItem).Checked := true;
  Options.Filter := TFilter(cbFX.ItemIndex);
end;

procedure TForm1.mnuHotspotClick(Sender: TObject);
begin
  chkHotspot.Checked := mnuHotspot.Checked;
end;

procedure TForm1.chkHotSpotClick(Sender: TObject);
begin
  mnuHotspot.Checked := chkHotspot.Checked;
end;

procedure TForm1.mnuAddLayeredClick(Sender: TObject);
begin
  chkAddLayered.Checked := mnuAddLayered.Checked;
end;

procedure TForm1.chkAddLayeredClick(Sender: TObject);
begin
  mnuAddLayered.Checked := chkAddLayered.Checked;
end;

procedure TForm1.mnuOnTopClick(Sender: TObject);
begin
  chkOnTop.Checked := mnuOnTop.Checked;
end;

procedure TForm1.chkOnTopClick(Sender: TObject);
begin
  mnuOnTop.Checked := chkOnTop.Checked;
  if chkOnTop.Checked then
    Form1.FormStyle := fsStayOnTop
  else
    Form1.FormStyle := fsNormal;
end;

procedure TForm1.mnuTaskBarClick(Sender: TObject);
begin
  chkTaskBar.Checked := mnuTaskBar.Checked;
end;

procedure TForm1.chkTaskBarClick(Sender: TObject);
begin
  mnuTaskBar.Checked := chkTaskBar.Checked;
  if chkTaskBar.Checked then
  begin
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(
      Application.Handle,
      GWL_EXSTYLE,
      GetWindowLong(Application.Handle, GWL_EXSTYLE) xor WS_EX_TOOLWINDOW);
    ShowWindow(Application.Handle, SW_SHOW);
  end
  else
  begin
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(
      Application.Handle,
      GWL_EXSTYLE,
      GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    ShowWindow(Application.Handle, SW_SHOW);
  end;
end;

procedure TForm1.mnuSysTrayClick(Sender: TObject);
begin
  chkSysTray.Checked := mnuSysTray.Checked;
end;

procedure TForm1.chkSysTrayClick(Sender: TObject);
begin
  mnuSysTray.Checked := chkSysTray.Checked;
end;

procedure TForm1.cbSpaceChange(Sender: TObject);
begin
  ColorChanged(Self);
end;

procedure TForm1.chkLayeredClick(Sender: TObject);
begin
  trkLayered.Enabled := chkLayered.Checked;
	Form1.AlphaBlend := chkLayered.Checked;
  Form1.AlphaBlendValue := trkLayered.Position;
end;

procedure TForm1.trkLayeredChange(Sender: TObject);
begin
	Form1.AlphaBlendValue := trkLayered.Position;
end;

procedure TForm1.Button1Click(Sender: TObject);
var  StartTicks, EndTicks: Cardinal;
begin
  StartTicks := GetTickCount();
  EndTicks := GetTickCount();
  MessageBox(
    Application.Handle, PChar('Ticks count = ' + IntToStr(EndTicks - StartTicks)),
    'Result', MB_OK);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  StartTicks, EndTicks: Cardinal;
begin
  Memo1.Lines.Clear;
  StartTicks := GetTickCount();
  EndTicks := GetTickCount();
  MessageBox(
    Application.Handle, PChar('Ticks count = ' + IntToStr(EndTicks - StartTicks)),
    'Result', MB_OK);
end;

end.

