{
  uFilters

  Graphic filters
}
unit uFilters;

interface

uses Windows, Graphics, uColorUtil, Math;

  // Converts the colors of a bitmap to their closest Websafe colors
  procedure WebSafeBitmap(var Dest: TBitmap);

  // Inverts the colors of a Bitmap
  procedure InvertBitmap(var Dest: TBitmap);

  // Converts the colors of a bitmap to shades of gray
  procedure GrayscaleBitmap(var Dest: TBitmap);

  // Removes the saturation from the colors of a bitmap
  procedure DesaturateBitmap(var Dest: TBitmap);
  procedure DesaturateBitmap2(var Dest: TBitmap);

implementation

// Converts the colors of a bitmap to their closest Websafe colors
procedure WebSafeBitmap(var Dest: TBitmap);
var
  x, y: integer;
  Row: PRGBTripleArray;
begin
  // Makes sure the bitmap can be processed
  Dest.PixelFormat := pf24bit;

  for y := 0 to Dest.Height - 1 do
  begin
    Row := Dest.ScanLine[y];
    for x := 0 to Dest.Width - 1 do
      Row[x] := RGBToWebSafe(Row[x]);
  end;
end;

// Inverts the colors of a bitmap
procedure InvertBitmap(var Dest: TBitmap);
begin
  // Simple call to InvertRect (Windows API)
  InvertRect(Dest.Canvas.Handle, Dest.Canvas.ClipRect);
end;

// Converts the colors of a bitmap to shades of gray
procedure GrayscaleBitmap(var Dest: TBitmap);
var
  Row: PRGBTripleArray;
  x, y: integer;
begin
  // Makes sure the bitmap can be processed
	Dest.PixelFormat := pf24bit;

  for y := 0 to Dest.Height - 1 do
  begin
    Row := Dest.Scanline[y];
    for x := 0 to Dest.Width - 1 do
    begin
      // PAL conversion
      // Gray := 0.299 * Red + 0.587 * Green + 0.114 * Blue;
      //  -> With a test of 10 loops, r, g, b from 0 to RGB each -> 5400 Ticks
      //Row[x].rgbtRed := Round(Row[x].rgbtRed * 0.299 + Row[x].rgbtGreen * 0.587 + Row[x].rgbtBlue * 0.114);
      // Gray := HiByte(77 * Red + 150 * Green + 29 * Blue);
      //  -> Same test as before -> 90 Ticks ^_^
      Row[x].rgbtRed :=  HiByte(Row[x].rgbtRed * 77 + Row[x].rgbtGreen * 150 + Row[x].rgbtBlue * 29);
      Row[x].rgbtGreen := Row[x].rgbtRed;
      Row[x].rgbtBlue := Row[x].rgbtRed;
    end;
  end;
end;

// Removes the saturation from the colors of a bitmap
procedure DesaturateBitmap(var Dest: TBitmap);
var
  Row: PRGBTripleArray;
  x,y: Integer;
begin
  // Makes sure the bitmap can be processed
  Dest.PixelFormat := pf24bit;

  for y := 0 to Dest.Height-1 do
  begin
    Row := Dest.scanline[y];
    for x := 0 to Dest.Width-1 do
    begin
      // Gets the value for the shade of gray
      // Equivalent to RGB->HSL then HSL->RGB with HSaturation = 0
      Row[x].rgbtRed := ( Max(Max(Row[x].rgbtRed, Row[x].rgbtGreen), Row[x].rgbtBlue) +
                          Min(Min(Row[x].rgbtRed, Row[x].rgbtGreen), Row[x].rgbtBlue) ) div 2;
      Row[x].rgbtGreen := Row[x].rgbtRed;
      Row[x].rgbtBlue := Row[x].rgbtRed;
    end;
  end;
end;

// Removes the saturation from the colors of a bitmap
procedure DesaturateBitmap2(var Dest: TBitmap);
var
  Row: PRGBTripleArray;
  x,y: Integer;
  red, green: byte;
begin
  // Makes sure the bitmap can be processed
  Dest.PixelFormat := pf24bit;

  for y := 0 to Dest.Height-1 do
  begin
    Row := Dest.scanline[y];
    for x := 0 to Dest.Width-1 do
    begin
      // Gets the value for the shade of gray
      // Equivalent to RGB->HSV then HSV->RGB with Saturation = 0
      red := Max(Max(Row[x].rgbtRed, Row[x].rgbtGreen), Row[x].rgbtBlue);
      Row[x].rgbtRed := red;
      Row[x].rgbtGreen := Row[x].rgbtRed;
      Row[x].rgbtBlue := Row[x].rgbtGreen;
    end;
  end;
end;

end.
