unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Samples.Spin, Math;

type
   TGrid = array[1..100,1..100] of integer;
   TStayRec = record
      Stay : boolean;
      Val  : integer;
   end;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    StatusBar1: TStatusBar;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Edit1: TEdit;
    lblRGB: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Timer2: TTimer;
    ComboBox1: TComboBox;
    Edit4: TEdit;
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
    xs, ys     : integer;
    grid       : TGrid;
    newgrid    : TGrid;
    Stay       : array[1..100, 1..100] of TStayRec;
    Run        : boolean;
    Colors     : array[0..255] of TColor;
    procedure  Iterate;
    procedure  ClearStay;
    procedure  InitColors;
  end;

var
  Form2: TForm2;

type
   TMark = record
      loc, r,g,b : integer;
   end;

implementation

{$R *.dfm}

procedure TForm2.InitColors;
const
   NUM_MARK = 5;
   Marks : array[1..NUM_MARK] of TMark = (
      (loc: 000; r: 000; g: 000; b: 000),
      (loc: 064; r: 000; g: 255; b: 000),
      (loc: 128; r: 255; g: 000; b: 000),
      (loc: 192; r: 000; g: 000; b: 255),
      (loc: 256; r: 255; g: 255; b: 255));
var
   i, j, d : integer;
   r, g, b : integer;
begin
   for i := 1 to NUM_MARK-1 do begin
      d := Marks[i+1].loc - Marks[i].loc;
      for j := 0 to d-1 do begin
         r := Marks[i].r + (Marks[i+1].r - Marks[i].r) * j div d;
         g := Marks[i].g + (Marks[i+1].g - Marks[i].g) * j div d;
         b := Marks[i].b + (Marks[i+1].b - Marks[i].b) * j div d;
         Colors[Marks[i].loc + j] := RGB(r,g,b);
      end;
   end;
end;

procedure TForm2.ClearStay;
var
   i, j : integer;
begin
   for i := 1 to 100 do
      for j := 1 to 100 do
         Stay[i,j].Stay := False;
end;

procedure TForm2.Iterate;
var
   x, y, v : integer;

   procedure UpdateV(var a: integer; i,j: integer);
   begin
      a := a + (grid[i,j] - a) div 8;
   end;

begin
   for x := 1 to xs do
      for y := 1 to ys do begin
         v := grid[x,y];
         if x > 1  then UpdateV(v, x-1, y);
         if x < xs then UpdateV(v, x+1, y);
         if y > 1  then UpdateV(v, x, y-1);
         if y < ys then UpdateV(v, x, y+1);
         if Stay[x,y].Stay then
            newgrid[x,y] := Stay[x,y].Val
         else
            newgrid[x,y] := v;
      end;
   grid := newgrid;
end;

procedure TForm2.Button1Click(Sender: TObject);
  var
   Iter : integer;
begin
  Screen.Cursor := crHourGlass;
   Timer1.Enabled := false;
   Run := True;
   Button1.Enabled := false;
   Button2.Enabled := true;
   Button3.Enabled := false;
   StatusBar1.Panels[2].Text := 'RGB Picker stopped, calculate Gradient..';
   Iter := 0;
   while Run and not (Application.Terminated) do begin
      Iterate;
      PaintBox1Paint(Self);
      Application.ProcessMessages;
      with StatusBar1 do begin
         Iter := Iter + 1;
         Panels[0].Text := IntToStr(Iter);
      end;
   end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Run := False;
  Button1.Enabled := true;
  Button2.Enabled := false;
  Button3.Enabled := true;
  Timer1.Enabled := true;
  StatusBar1.Panels[2].Text := 'Press F1 to stop Picker';
  Screen.Cursor := crDefault;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
   i, j : integer;
begin
  Screen.Cursor := crHourGlass;
  Randomize;
  xs := SpinEdit1.Value;
  ys := SpinEdit2.Value;
  Run := False;
  ClearStay;
  InitColors;

   for i := 1 to xs do
      for j := 1 to ys do
         grid[i,j] := Random(65536);
         PaintBox1Paint(Self);
   Screen.Cursor := crDefault;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Randomize;
  xs := SpinEdit1.Value;
  ys := SpinEdit2.Value;
  Run := False;
  Button3Click(Self);
  ClearStay;
  InitColors;
  KeyPreview := True;
  StatusBar1.Panels[2].Text := 'Press F1 to stop Picker';
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (GetAsyncKeystate(VK_F1))<>0 then
  begin
    StatusBar1.Panels[2].Text := 'Press F2 to start Picker';
    Timer1.Enabled := false;
  end;

  if (GetAsyncKeystate(VK_F2))<>0 then
  begin
    StatusBar1.Panels[2].Text := 'Press F1 to stop Picker';
    Timer1.Enabled := true;
  end;
end;

procedure TForm2.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   px, py : integer;
   v      : string;
begin
   px := x * xs div PaintBox1.Width + 1;
   py := y * ys div PaintBox1.Height + 1;
   v := IntToStr(grid[px,py] div 256);
   v := InputBox('Enter Default Value', 'Default', v);
   Stay[px,py].Val  := StrToInt(v) * 256;
   Stay[px,py].Stay := True;
   Grid[px,py] := Stay[px, py].Val;
   PaintBox1Paint(Self);
end;

procedure TForm2.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   px, py : integer;
begin
   px := x * xs div PaintBox1.Width + 1;
   py := y * ys div PaintBox1.Height + 1;
   StatusBar1.Panels[1].Text := Format('Val at (%d, %d) = %d', [px, py,
   Grid[px,py] div 256]);
end;

procedure TForm2.PaintBox1Paint(Sender: TObject);
var
   i, j     : integer;
   Wid, Hgt : integer;
   x1, y1   : integer;
   x2, y2   : integer;
   v        : integer;
begin
   Wid := PaintBox1.Width;
   Hgt := PaintBox1.Height;
   for i := 1 to xs do
      for j := 1 to ys do begin
         x1 := (i-1) * wid div xs;
         x2 := i * wid div xs;
         y1 := (j-1) * Hgt div ys;
         y2 := j * Hgt div ys;

         v := Grid[i,j];
         PaintBox1.Canvas.Brush.Color := Colors[v div 256];
         PaintBox1.Canvas.Rectangle(x1,y1,x2,y2);
      end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
{
  // This part can be used to paint the screen
  // colors onto an image under the mouse.
function GetZoomRect: TRect;
var
  x: Integer;
  y: Integer;
  w: Integer;
  h: Integer;
begin
  x := Max(Mouse.CursorPos.x - 10, 10);
  y := Max(Mouse.CursorPos.y - 10, 10);
  w := x + 20;
  h := y + 20;
  if (w > Screen.Width)
  then begin
    x := Screen.Width;
    w := Screen.Width;
  end;
  if (h > Screen.Height)
  then begin
    y := Screen.Height;
    h := Screen.Height;
  end;
  Result := Rect(x, y, w, h);
  StatusBar1.Panels[1].Text := IntToStr(x);
  StatusBar1.Panels[3].Text := IntToStr(y);
end;
}
var
  DC: HDC;
  Canvas: TCanvas;
  Couleur: TColor;
  Rouge: Byte;
  Vert: Byte;
  Bleu: Byte;
begin
  Timer1.Enabled := False;
  DC := GetDC(HWND_DESKTOP);
  {
  //    This part can be used to paint the screen
  //    colors onto an image under the mouse.
  //Canvas := TCanvas.Create;
  //Canvas.Handle := DC;
  //ImageZoom.Canvas.CopyRect(ImageZoom.Canvas.ClipRect, Canvas, GetZoomRect);
  //FreeAndNil(Canvas);
  //ImageZoom.Canvas.Pen.Mode := pmNot;
  //ImageZoom.Canvas.Rectangle(50, 50, 50, 50);
  }
  Couleur := GetPixel(DC, Mouse.CursorPos.x, Mouse.CursorPos.y);
  ReleaseDC(HWND_DESKTOP, DC);
  //Shape1.Brush.Color := Couleur;
  Rouge := Couleur and $000000FF;
  Vert := Couleur and $0000FF00 shr 8;
  Bleu := Couleur and $00FF0000 shr 16;
  Edit1.Text := IntToStr(Rouge);
  Edit2.Text := IntToStr(Vert);
  Edit3.Text := IntToStr(Bleu);

  case ComboBox1.ItemIndex of
  0 : Edit4.Text := Format('0x00%.2x%.2x%.2x', [Bleu, Vert, Rouge]);
  1 : Edit4.Text := Format('$00%.2x%.2x%.2x', [Bleu, Vert, Rouge]);
  2 : Edit4.Text := Format('#%.2x%.2x%.2x', [Rouge, Vert, Bleu]);
  end;



  //StatusBar1.Panels[2].Text := 'Picker is Active..';
  Timer1.Enabled := True;
end;

end.
