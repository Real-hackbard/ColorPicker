{
  uScreenCapture

  Captures the desktop.
}
unit uScreenCapture;

interface

uses Windows, Graphics;

  // Main procedure, captures a part of the desktop
  function CaptScreen(var Bitmap: TBitmap; const Src: TRect; const AddLayered: boolean): boolean;

implementation

var
  DesktopDC: HDC; // Desktop Handle

// Main procedure, captures a part of the desktop
//  - Bitmap:       Bitmap used to return the capture
//  - Src:          Clipping rectangle
//  - AddLayered:   Captures Layered Windows
//
// Remark
//  BitBlt can use NOTSRCCOPY as a RasterOperation to invert the screen,
//  but this one is not working with the layered Windows, those are simply
//  dissappearing from the capture
//
function CaptScreen(var Bitmap: TBitmap; const Src: TRect; const AddLayered: boolean): boolean;
const
  // Missing RasterOperation
  //  Gives the ablility to capture Layered Windows as well
	CAPTUREBLT = $40000000;
var
	RasterOp: Cardinal;
  dcComp: HDC;
begin
  // Initializes the result
  Result := false;

  // Initializes RasterOp with provided options
  if AddLayered then
    RasterOp := SRCCOPY or CAPTUREBLT
  else
    RasterOp := SRCCOPY;

  // Creates in memory DC
  dcComp := CreateCompatibleDC(DesktopDC);

  // Checks if the function succeeded
  if (dcComp <> 0) then
  begin
    // Puts the bitmap in the memory DC
    Bitmap.Handle := CreateCompatibleBitmap(DesktopDC, Src.Right - Src.Left, Src.Bottom - Src.Top);

    // Checks if the bitmap handle is valid
    if (Bitmap.Handle <> 0) then
    begin
      // Puts the bitmap into the memory DC
      SelectObject(dcComp, Bitmap.Handle);

      // Copies the specified part of the screen to the bitmap
      BitBlt(dcComp, 0, 0, Bitmap.Width, Bitmap.Height, DesktopDC, Src.Left, Src.Top, RasterOp);

      // The capture is done
      Result := true;
    end;
  end;
  // Frees resources
  DeleteDC(dcComp);
end;

initialization
  // Gets the actual desktop handle
  DesktopDC := GetDcEx(GetDesktopWindow(), 0, 0);

finalization
  // Frees the handle
  ReleaseDc(GetDesktopWindow(), DesktopDC);
end.
