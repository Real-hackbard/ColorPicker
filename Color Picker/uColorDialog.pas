{
  For speed,
    imgMain.Width, imgMain.Height and imgBar.Height = RGBMAX + 1 (256)

  The code needs to be as fast as possible as well as accurate as possible
}
unit uColorDialog;

interface

uses
  Windows, StdCtrls, Controls, ExtCtrls, Graphics, Classes, Forms, SysUtils,
  uColorUtil;

type
  // Set of available color spaces
  TColorSpace = (csRGB, csHSV, csHSL);

  // Defines a field in a color space
  //  The field is directly in relation with the color space
  //  (between 0 and 'Count(ColorSpace.Fields) - 1')
  //    exemple:  ColorSpace  := csRGB
  //              Field       := 1
  //              The field will be 'G'
  TSpaceField = packed record
    ColorSpace: TColorSpace;
    Field: byte;
  end;

  TColorInfos = packed record
    RGB: TRGBTriple;
    HSL: THSLTriple;
    HSV: THSVTriple;
  end;

  TTrackBarInfos = packed record
    Max: integer;       // RGBMAX, HMAX or SLVMAX
    YMax: integer;      // Maximum value for the top of the track image
    YMin: integer;      // Minimum value for the top of the track image
                        //  (= Maximum - RGBMAX)
    Position: integer;  // Position in axis Y
  end;

  TfColor = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    panelDisplay: TPanel;
    imgNewColor: TImage;
    imgOldColor: TImage;
    panelMain: TPanel;
    imgMain: TImage;
    panelBar: TPanel;
    imgBar: TImage;
    imgTrack: TImage;
    radioHSVH: TRadioButton;
    radioHSVS: TRadioButton;
    radioHSVV: TRadioButton;
    radioRed: TRadioButton;
    radioGreen: TRadioButton;
    radioBlue: TRadioButton;
    editHSVH: TEdit;
    editHSVS: TEdit;
    editHSVV: TEdit;
    editRed: TEdit;
    editGreen: TEdit;
    editBlue: TEdit;
    chkWebsafe: TCheckBox;
    editHexa: TEdit;
    lblUnitHSVH: TLabel;
    lblUnitHSVS: TLabel;
    lblUnitHSVV: TLabel;
    lblHexa: TLabel;
    lblUnitHSLH: TLabel;
    lblUnitHSLS: TLabel;
    lblUnitHSLL: TLabel;
    radioHSLH: TRadioButton;
    radioHSLS: TRadioButton;
    radioHSLL: TRadioButton;
    editHSLH: TEdit;
    editHSLS: TEdit;
    editHSLL: TEdit;
    procedure radioBlueClick(Sender: TObject);
    procedure radioGreenClick(Sender: TObject);
    procedure radioRedClick(Sender: TObject);
    procedure radioHSLLClick(Sender: TObject);
    procedure radioHSLSClick(Sender: TObject);
    procedure radioHSLHClick(Sender: TObject);
    procedure radioHSVVClick(Sender: TObject);
    procedure radioHSVSClick(Sender: TObject);
    procedure radioHSVHClick(Sender: TObject);
    procedure editHSVHChange(Sender: TObject);
    procedure imgBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTrackMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgTrackMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTrackMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure chkWebsafeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure editHexaKeyPress(Sender: TObject; var Key: Char);
    procedure editHSVHKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure editHSVSChange(Sender: TObject);
    procedure editRedChange(Sender: TObject);
    procedure editHSVHEnter(Sender: TObject);
    procedure editHexaChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    // Tells if a color selection control is being used
    MouseDown: boolean;
    // Informations used for the 'TrackBar'
    TrackBarInfos: TTrackBarInfos;
    // Cache for the mouse position used by the main display
    MousePos: TPoint;
    // Current field
    CurrentField: TSpaceField;
    // Converts a value in 0..TrackBarInfos.Max to imgHandle.Top
    procedure TrackValueToTop(Value: integer);
    // Changes the position of imgHandle
    procedure TrackValueChanged(Value: integer);
    // Draws the selection on the main bitmap
    procedure DrawSelector(X, Y: integer);
    // Changes the selection on the main bitmap
    procedure MainPositionChanged(X, Y: integer);

    // Refreshes values in TEdits
    procedure RefreshEdits;
    // Refreshes the TEdits in a specific ColorSpace
    procedure RefreshRGBs;
    procedure RefreshHSVs;
    procedure RefreshHSLs;

    // Refreshes the bar image
    procedure RefreshBar(ColorSpace: TColorSpace; Field: byte);
    // Refreshes the main image
    procedure RefreshMain(ColorSpace: TColorSpace; Field: byte);
    // Refreshes the display of the current color
    procedure RefreshDisplay;

    // Draws the main image with two variants fields in a ColorSpace
    procedure DrawHSLMulti(Field: byte);
    procedure DrawRGBMulti(Field: byte);
    procedure DrawHSVMulti(Field: byte);

    // Shared procedure for TEdit.OnChange
    procedure EditChanged(ColorSpace: TColorSpace; Field: byte);
  public
    // Current color
    OldColor: TColor;
    // Informations about the current color
    CurrentColor: TColorInfos;
  end;

var
  fColor: TfColor;

implementation

uses uFilters;

{$R *.dfm}


////////////////////////////////////////////////////////////////////////////////
//
//  Drawing procedures
//

// Draws a HSV field on a Bitmap
//  Bmp: TBitmap used
//  HSV: Values used for H, S and/or V
//  Field: Index of the field being drawn
procedure DrawHSVField(var Bmp: TBitmap; HSV: THSVTriple; Field: byte);
var
  HSV0, HSV1: THSVTriple;
  RGB0, RGB1: TRGBTriple;
  vert: array[0..11] of TTriVertex;
  gRect: array[0..6] of TGradientRect;
begin
  // Shared fixed values
  vert[0].x := 0;
  vert[0].y := 0;
  vert[0].Alpha := 0;
  vert[1].x := Bmp.Width;
  vert[1].Alpha := 0;
  gRect[0].UpperLeft := 0;
  gRect[0].LowerRight := 1;
  HSV0 := HSV;
  HSV1 := HSV;

  if Field <> 0 then
  begin
    // Simple gradient
    vert[1].y := Bmp.Height;
    // Adjusts desired field
    if Field = 1 then
    begin
      HSV0.hsvtSaturation := SLVMAX;
      HSV1.hsvtSaturation := 0;
    end
    else
    begin
      HSV0.hsvtValue := SLVMAX;
      HSV1.hsvtValue := 0;
    end;

    // Gets RGB values
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);

    vert[0].Red := RGB0.rgbtRed shl 8;
    vert[0].Green := RGB0.rgbtGreen shl 8;
    vert[0].Blue := RGB0.rgbtBlue shl 8;

    vert[1].Red := RGB1.rgbtRed shl 8;
    vert[1].Green := RGB1.rgbtGreen shl 8;
    vert[1].Blue := RGB1.rgbtBlue shl 8;

    GradientFill(Bmp.Canvas.Handle, @vert, 2, @gRect, 1, GRADIENT_FILL_RECT_V);
  end
  else
  begin
    // Gradient is divided in 6 parts
    // Fixed values
    vert[1].y := (Bmp.Height + 3) div 6;

    vert[2].x := 0;
    vert[2].y := (Bmp.Height + 3) div 6;
    vert[2].Alpha := 0;
    vert[3].x := Bmp.Width;
    vert[3].y := (2 * Bmp.Height + 3) div 6;
    vert[3].Alpha := 0;

    vert[4].x := 0;
    vert[4].y := (2 * Bmp.Height + 3) div 6;
    vert[4].Alpha := 0;
    vert[5].x := Bmp.Width;
    vert[5].y := (Bmp.Height + 1) div 2;
    vert[5].Alpha := 0;

    vert[6].x := 0;
    vert[6].y := (Bmp.Height + 1) div 2;
    vert[6].Alpha := 0;
    vert[7].x := Bmp.Width;
    vert[7].y := (4 * Bmp.Height + 3) div 6;
    vert[7].Alpha := 0;

    vert[8].x := 0;
    vert[8].y := (4 * Bmp.Height + 3) div 6;
    vert[8].Alpha := 0;
    vert[9].x := Bmp.Width;
    vert[9].y := (5 * Bmp.Height + 3) div 6;
    vert[9].Alpha := 0;

    vert[10].x := 0;
    vert[10].y := (5 * Bmp.Height + 3) div 6;
    vert[10].Alpha := 0;
    vert[11].x := Bmp.Width;
    vert[11].y := Bmp.Height;
    vert[11].Alpha := 0;

    gRect[1].UpperLeft := 2;
    gRect[1].LowerRight := 3;
    gRect[2].UpperLeft := 4;
    gRect[2].LowerRight := 5;
    gRect[3].UpperLeft := 6;
    gRect[3].LowerRight := 7;
    gRect[4].UpperLeft := 8;
    gRect[4].LowerRight := 9;
    gRect[5].UpperLeft := 10;
    gRect[5].LowerRight := 11;

    // Gets the RGB values (HMAX % 6 = 0 => no need to round)
    HSV0.hsvtHue := HMAX;
    HSV1.hsvtHue := 5 * HMAX div 6;
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);
    vert[0].Red := RGB0.rgbtRed shl 8;
    vert[0].Green := RGB0.rgbtGreen shl 8;
    vert[0].Blue := RGB0.rgbtBlue shl 8;
    vert[1].Red := RGB1.rgbtRed shl 8;
    vert[1].Green := RGB1.rgbtGreen shl 8;
    vert[1].Blue := RGB1.rgbtBlue shl 8;

    HSV0.hsvtHue := 5 * HMAX div 6;
    HSV1.hsvtHue := 2 * HMAX div 3;
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);
    vert[2].Red := RGB0.rgbtRed shl 8;
    vert[2].Green := RGB0.rgbtGreen shl 8;
    vert[2].Blue := RGB0.rgbtBlue shl 8;
    vert[3].Red := RGB1.rgbtRed shl 8;
    vert[3].Green := RGB1.rgbtGreen shl 8;
    vert[3].Blue := RGB1.rgbtBlue shl 8;

    HSV0.hsvtHue := 2 * HMAX div 3;
    HSV1.hsvtHue := HMAX div 2;
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);
    vert[4].Red := RGB0.rgbtRed shl 8;
    vert[4].Green := RGB0.rgbtGreen shl 8;
    vert[4].Blue := RGB0.rgbtBlue shl 8;
    vert[5].Red := RGB1.rgbtRed shl 8;
    vert[5].Green := RGB1.rgbtGreen shl 8;
    vert[5].Blue := RGB1.rgbtBlue shl 8;

    HSV0.hsvtHue := HMAX div 2;
    HSV1.hsvtHue := HMAX div 3;
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);
    vert[6].Red := RGB0.rgbtRed shl 8;
    vert[6].Green := RGB0.rgbtGreen shl 8;
    vert[6].Blue := RGB0.rgbtBlue shl 8;
    vert[7].Red := RGB1.rgbtRed shl 8;
    vert[7].Green := RGB1.rgbtGreen shl 8;
    vert[7].Blue := RGB1.rgbtBlue shl 8;

    HSV0.hsvtHue := HMAX div 3;
    HSV1.hsvtHue := HMAX div 6;
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);
    vert[8].Red := RGB0.rgbtRed shl 8;
    vert[8].Green := RGB0.rgbtGreen shl 8;
    vert[8].Blue := RGB0.rgbtBlue shl 8;
    vert[9].Red := RGB1.rgbtRed shl 8;
    vert[9].Green := RGB1.rgbtGreen shl 8;
    vert[9].Blue := RGB1.rgbtBlue shl 8;

    HSV0.hsvtHue := HMAX div 6;
    HSV1.hsvtHue := 0;
    RGB0 := HSVToRGB(HSV0);
    RGB1 := HSVToRGB(HSV1);
    vert[10].Red := RGB0.rgbtRed shl 8;
    vert[10].Green := RGB0.rgbtGreen shl 8;
    vert[10].Blue := RGB0.rgbtBlue shl 8;
    vert[11].Red := RGB1.rgbtRed shl 8;
    vert[11].Green := RGB1.rgbtGreen shl 8;
    vert[11].Blue := RGB1.rgbtBlue shl 8;

    GradientFill(Bmp.Canvas.Handle, @vert, 12, @gRect, 6, GRADIENT_FILL_RECT_V);
  end;
end;

// Draws a HSL field on a Bitmap
//  Bmp: TBitmap used
//  HSL: Values used for H, S and/or L
//  Field: Index of the field being drawn
procedure DrawHSLField(var Bmp: TBitmap; HSL: THSLTriple; Field: byte);
var
  HSL0, HSL1: THSLTriple;
  RGB0, RGB1: TRGBTriple;
  vert: array[0..11] of TTriVertex;
  gRect: array[0..6] of TGradientRect;
begin
  // Shared fixed values
  vert[0].x := 0;
  vert[0].y := 0;
  vert[0].Alpha := 0;
  vert[1].x := Bmp.Width;
  vert[1].Alpha := 0;
  gRect[0].UpperLeft := 0;
  gRect[0].LowerRight := 1;
  HSL0 := HSL;
  HSL1 := HSL;

  if Field = 0 then
  begin
    // Gradient is divided in 6 parts
    // Fixed values
    vert[1].y := (Bmp.Height + 3) div 6;

    vert[2].x := 0;
    vert[2].y := (Bmp.Height + 3) div 6;
    vert[2].Alpha := 0;
    vert[3].x := Bmp.Width;
    vert[3].y := (2 * Bmp.Height + 3) div 6;
    vert[3].Alpha := 0;

    vert[4].x := 0;
    vert[4].y := (2 * Bmp.Height + 3) div 6;
    vert[4].Alpha := 0;
    vert[5].x := Bmp.Width;
    vert[5].y := (Bmp.Height + 1) div 2;
    vert[5].Alpha := 0;

    vert[6].x := 0;
    vert[6].y := (Bmp.Height + 1) div 2;
    vert[6].Alpha := 0;
    vert[7].x := Bmp.Width;
    vert[7].y := (4 * Bmp.Height + 3) div 6;
    vert[7].Alpha := 0;

    vert[8].x := 0;
    vert[8].y := (4 * Bmp.Height + 3) div 6;
    vert[8].Alpha := 0;
    vert[9].x := Bmp.Width;
    vert[9].y := (5 * Bmp.Height + 3) div 6;
    vert[9].Alpha := 0;

    vert[10].x := 0;
    vert[10].y := (5 * Bmp.Height + 3) div 6;
    vert[10].Alpha := 0;
    vert[11].x := Bmp.Width;
    vert[11].y := Bmp.Height;
    vert[11].Alpha := 0;

    gRect[1].UpperLeft := 2;
    gRect[1].LowerRight := 3;
    gRect[2].UpperLeft := 4;
    gRect[2].LowerRight := 5;
    gRect[3].UpperLeft := 6;
    gRect[3].LowerRight := 7;
    gRect[4].UpperLeft := 8;
    gRect[4].LowerRight := 9;
    gRect[5].UpperLeft := 10;
    gRect[5].LowerRight := 11;

    // Gets the RGB values (HMAX % 6 = 0 => no need to round)
    HSL0.hsltHue := HMAX;
    HSL1.hsltHue := 5 * HMAX div 6;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[0].Red := RGB0.rgbtRed shl 8;
    vert[0].Green := RGB0.rgbtGreen shl 8;
    vert[0].Blue := RGB0.rgbtBlue shl 8;
    vert[1].Red := RGB1.rgbtRed shl 8;
    vert[1].Green := RGB1.rgbtGreen shl 8;
    vert[1].Blue := RGB1.rgbtBlue shl 8;

    HSL0.hsltHue := 5 * HMAX div 6;
    HSL1.hsltHue := 2 * HMAX div 3;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[2].Red := RGB0.rgbtRed shl 8;
    vert[2].Green := RGB0.rgbtGreen shl 8;
    vert[2].Blue := RGB0.rgbtBlue shl 8;
    vert[3].Red := RGB1.rgbtRed shl 8;
    vert[3].Green := RGB1.rgbtGreen shl 8;
    vert[3].Blue := RGB1.rgbtBlue shl 8;

    HSL0.hsltHue := 2 * HMAX div 3;
    HSL1.hsltHue := HMAX div 2;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[4].Red := RGB0.rgbtRed shl 8;
    vert[4].Green := RGB0.rgbtGreen shl 8;
    vert[4].Blue := RGB0.rgbtBlue shl 8;
    vert[5].Red := RGB1.rgbtRed shl 8;
    vert[5].Green := RGB1.rgbtGreen shl 8;
    vert[5].Blue := RGB1.rgbtBlue shl 8;

    HSL0.hsltHue := HMAX div 2;
    HSL1.hsltHue := HMAX div 3;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[6].Red := RGB0.rgbtRed shl 8;
    vert[6].Green := RGB0.rgbtGreen shl 8;
    vert[6].Blue := RGB0.rgbtBlue shl 8;
    vert[7].Red := RGB1.rgbtRed shl 8;
    vert[7].Green := RGB1.rgbtGreen shl 8;
    vert[7].Blue := RGB1.rgbtBlue shl 8;

    HSL0.hsltHue := HMAX div 3;
    HSL1.hsltHue := HMAX div 6;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[8].Red := RGB0.rgbtRed shl 8;
    vert[8].Green := RGB0.rgbtGreen shl 8;
    vert[8].Blue := RGB0.rgbtBlue shl 8;
    vert[9].Red := RGB1.rgbtRed shl 8;
    vert[9].Green := RGB1.rgbtGreen shl 8;
    vert[9].Blue := RGB1.rgbtBlue shl 8;

    HSL0.hsltHue := HMAX div 6;
    HSL1.hsltHue := 0;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[10].Red := RGB0.rgbtRed shl 8;
    vert[10].Green := RGB0.rgbtGreen shl 8;
    vert[10].Blue := RGB0.rgbtBlue shl 8;
    vert[11].Red := RGB1.rgbtRed shl 8;
    vert[11].Green := RGB1.rgbtGreen shl 8;
    vert[11].Blue := RGB1.rgbtBlue shl 8;

    GradientFill(Bmp.Canvas.Handle, @vert, 12, @gRect, 6, GRADIENT_FILL_RECT_V);
  end
  else if Field = 1 then
  begin
    // Simple gradient
    vert[1].y := Bmp.Height;

    HSL0.hsltSaturation := SLVMAX;
    HSL1.hsltSaturation := 0;

    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);

    vert[0].Red := RGB0.rgbtRed shl 8;
    vert[0].Green := RGB0.rgbtGreen shl 8;
    vert[0].Blue := RGB0.rgbtBlue shl 8;

    vert[1].Red := RGB1.rgbtRed shl 8;
    vert[1].Green := RGB1.rgbtGreen shl 8;
    vert[1].Blue := RGB1.rgbtBlue shl 8;

    GradientFill(Bmp.Canvas.Handle, @vert, 2, @gRect, 1, GRADIENT_FILL_RECT_V);
  end
  else
  begin
    // Gradient is divided in 2 parts
    vert[1].y := (Bmp.Height + 1) div 2;

    vert[2].x := 0;
    vert[2].y := (Bmp.Height + 1) div 2;
    vert[2].Alpha := 0;
    vert[3].x := Bmp.Width;
    vert[3].y := Bmp.Height;
    vert[3].Alpha := 0;

    gRect[1].UpperLeft := 2;
    gRect[1].LowerRight := 3;

    // Gets the RGB values (SLVMAX % 2 = 0 => no need to round)
    HSL0.hsltLuminance := SLVMAX;
    HSL1.hsltLuminance := SLVMAX div 2;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[0].Red := RGB0.rgbtRed shl 8;
    vert[0].Green := RGB0.rgbtGreen shl 8;
    vert[0].Blue := RGB0.rgbtBlue shl 8;
    vert[1].Red := RGB1.rgbtRed shl 8;
    vert[1].Green := RGB1.rgbtGreen shl 8;
    vert[1].Blue := RGB1.rgbtBlue shl 8;

    HSL0.hsltLuminance := SLVMAX div 2;
    HSL1.hsltLuminance := 0;
    RGB0 := HSLToRGB(HSL0);
    RGB1 := HSLToRGB(HSL1);
    vert[2].Red := RGB0.rgbtRed shl 8;
    vert[2].Green := RGB0.rgbtGreen shl 8;
    vert[2].Blue := RGB0.rgbtBlue shl 8;
    vert[3].Red := RGB1.rgbtRed shl 8;
    vert[3].Green := RGB1.rgbtGreen shl 8;
    vert[3].Blue := RGB1.rgbtBlue shl 8;

    GradientFill(Bmp.Canvas.Handle, @vert, 4, @gRect, 2, GRADIENT_FILL_RECT_V);
  end;
end;

// Draws a RGB field on a Bitmap
//  Bmp: TBitmap used
//  RGB: Values used for R, G and/or B
//  Field: Index of the field being drawn
procedure DrawRGBField(var Bmp: TBitmap; RGB: TRGBTriple; Field: byte);
var
  vert: array[0..1] of TTriVertex;
  gRect: TGradientRect;
begin
  // Simple gradient
  // Fixed values
  vert[0].x := 0;
  vert[0].y := 0;
  vert[0].Alpha := 0;
  vert[1].x := Bmp.Width;
  vert[1].y := Bmp.Height;
  vert[1].Alpha := 0;
  gRect.UpperLeft := 0;
  gRect.LowerRight := 1;

  // Adjusts desired field
  if Field = 0 then
  begin
    vert[0].Red := RGBMAX shl 8;
    vert[0].Green := RGB.rgbtGreen shl 8;
    vert[0].Blue := RGB.rgbtBlue shl 8;
    vert[1].Red := 0;
    vert[1].Green := vert[0].Green;
    vert[1].Blue := vert[0].Blue;
  end
  else if Field = 1 then
  begin
    vert[0].Red := RGB.rgbtRed shl 8;
    vert[0].Green := RGBMAX shl 8;
    vert[0].Blue := RGB.rgbtBlue shl 8;
    vert[1].Red := vert[0].Red;
    vert[1].Green := 0;
    vert[1].Blue := vert[0].Blue;
  end
  else
  begin
    vert[0].Red := RGB.rgbtRed shl 8;
    vert[0].Green := RGB.rgbtGreen shl 8;
    vert[0].Blue := RGBMAX shl 8;
    vert[1].Red := vert[0].Red;
    vert[1].Green := vert[0].Green;
    vert[1].Blue := 0;
  end;

  GradientFill(Bmp.Canvas.Handle, @vert, 2, @gRect, 1, GRADIENT_FILL_RECT_V);
end;


// Draws a HSL multi-gradient
//  Field: Index of the field not being drawn
procedure TfColor.DrawHSLMulti(Field: byte);
var
  Bmp: TBitmap;
  x: integer;
  RGB1, RGB2, RGB3: TRGBTriple;
  iFixed: byte;
  gRect: array[0..1] of TGradientRect;
  vert: array[0..3] of TTriVertex;
begin
  Bmp := TBitmap.Create;
  Bmp.Width := RGBMAX + 1;
  Bmp.Height := RGBMAX + 1;
  Bmp.PixelFormat := pf24bit;

  if (Field = 2) then
  begin
    // Gradient on X and Y
    // Fixed values
    iFixed := CurrentColor.HSL.hsltLuminance * RGBMAX div SLVMAX;
    vert[0].y := 0;
    vert[0].Alpha := 0;
    vert[1].y := RGBMAX + 1;
    vert[1].Alpha := 0;
    gRect[0].UpperLeft := 0;
    gRect[0].LowerRight := 1;

    for x := 0 to RGBMAX do
    begin
      // Width of the rectangle has to be 1
      vert[0].x := x;
      vert[1].x := x + 1;

      RGB1 := HSLInRGBMAXToRGB(x, RGBMAX, iFixed);
      vert[0].Red := RGB1.rgbtRed shl 8;
      vert[0].Green := RGB1.rgbtGreen shl 8;
      vert[0].Blue := RGB1.rgbtBlue shl 8;

      RGB2 := HSLInRGBMAXToRGB(x, 0, iFixed);
      vert[1].Red := RGB2.rgbtRed shl 8;
      vert[1].Green := RGB2.rgbtGreen shl 8;
      vert[1].Blue := RGB2.rgbtBlue shl 8;

      GradientFill(Bmp.Canvas.Handle, @vert, 2, @gRect, 1, GRADIENT_FILL_RECT_V);
    end;
  end
  else
  begin
    // Gradient on axis X with middle color
    // Fixed values
    if (Field = 0) then
      iFixed := CurrentColor.HSL.hsltHue * RGBMAX div HMAX
    else
      iFixed := CurrentColor.HSL.hsltSaturation * RGBMAX div SLVMAX;
    vert[0].y := 0;
    vert[0].Alpha := 0;
    vert[1].y := ((RGBMAX + 1) div 2);
    vert[1].Alpha := 0;
    vert[2].y := ((RGBMAX + 1) div 2);
    vert[2].Alpha := 0;
    vert[3].y := RGBMAX + 1;
    vert[3].Alpha := 0;
    gRect[0].UpperLeft := 0;
    gRect[0].LowerRight := 1;
    gRect[1].UpperLeft := 2;
    gRect[1].LowerRight := 3;
    for x := 0 to RGBMAX do
    begin
      if (Field = 1) then
      begin
        RGB1 := HSLInRGBMAXToRGB(x, iFixed, RGBMAX);
        RGB2 := HSLInRGBMAXToRGB(x, iFixed, RGBMAX div 2);
        RGB3 := HSLInRGBMAXToRGB(x, iFixed, 0);
      end
      else
      begin
        RGB1 := HSLInRGBMAXToRGB(iFixed, x, RGBMAX);
        RGB2 := HSLInRGBMAXToRGB(iFixed, x, RGBMAX div 2);
        RGB3 := HSLInRGBMAXToRGB(iFixed, x, 0);
      end;

      vert[0].x := x;
      vert[0].Red := RGB1.rgbtRed shl 8;
      vert[0].Green := RGB1.rgbtGreen shl 8;
      vert[0].Blue := RGB1.rgbtBlue shl 8;

      vert[1].x := x + 1;
      vert[1].Red := RGB2.rgbtRed shl 8;
      vert[1].Green := RGB2.rgbtGreen shl 8;
      vert[1].Blue := RGB2.rgbtBlue shl 8;

      vert[2].x := x;
      vert[2].Red := RGB2.rgbtRed shl 8;
      vert[2].Green := RGB2.rgbtGreen shl 8;
      vert[2].Blue := RGB2.rgbtBlue shl 8;

      vert[3].x := x + 1;
      vert[3].Red := RGB3.rgbtRed shl 8;
      vert[3].Green := RGB3.rgbtGreen shl 8;
      vert[3].Blue := RGB3.rgbtBlue shl 8;

      GradientFill(Bmp.Canvas.Handle, @vert, 4, @gRect, 2, GRADIENT_FILL_RECT_V);
    end;
  end;

  if chkWebsafe.Checked then
    WebsafeBitmap(Bmp);

  imgMain.Picture.Bitmap := Bmp;
  Bmp.Free;
end;

// Draws a HSV multi-gradient
//  Field: Index of the field not being drawn
procedure TfColor.DrawHSVMulti(Field: byte);
var
  Bmp: TBitmap;
  x: integer;
  RGB1, RGB2: TRGBTriple;
  iFixed: integer;
  gRect: TGradientRect;
  vert: array[0..1] of TTriVertex;
begin
  Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf24bit;
  Bmp.Width := RGBMAX + 1;
  Bmp.Height := RGBMAX + 1;

  // Fixed values
  if Field = 1 then
    iFixed := (RGBMAX * CurrentColor.HSV.hsvtSaturation div SLVMAX)
  else if Field = 2 then
    iFixed := (RGBMAX * CurrentColor.HSV.hsvtValue div SLVMAX)
  else
    iFixed := (RGBMAX * CurrentColor.HSV.hsvtHue div HMAX);
  vert[0].y := 0;
  vert[1].y := RGBMAX + 1;
  vert[0].Alpha := 0;
  vert[1].Alpha := 0;
  gRect.UpperLeft := 0;
  gRect.LowerRight := 1;

  for x := 0 to RGBMAX do
  begin
    // Width of the rectangle has to be 1
    vert[0].x := x;
    vert[1].x := x + 1;

    if (Field = 1) then
    begin
      RGB1 := HSVInRGBMAXToRGB(x, iFixed, RGBMAX);
      RGB2 := HSVInRGBMAXToRGB(x, iFixed, 0);
    end
    else if (Field = 2) then
    begin
      RGB1 := HSVInRGBMAXToRGB(x, RGBMAX, iFixed);
      RGB2 := HSVInRGBMAXToRGB(x, 0, iFixed);
    end
    else
    begin
      RGB1 := HSVInRGBMAXToRGB(iFixed, x, RGBMAX);
      RGB2 := HSVInRGBMAXToRGB(iFixed, x, 0);
    end;
    vert[0].Red := RGB1.rgbtRed shl 8;
    vert[0].Green := RGB1.rgbtGreen shl 8;
    vert[0].Blue := RGB1.rgbtBlue shl 8;

    vert[1].Red := RGB2.rgbtRed shl 8;
    vert[1].Green := RGB2.rgbtGreen shl 8;
    vert[1].Blue := RGB2.rgbtBlue shl 8;

    GradientFill(Bmp.Canvas.Handle, @vert, 2, @gRect, 1, GRADIENT_FILL_RECT_V);
  end;

  if chkWebsafe.Checked then
    WebsafeBitmap(Bmp);

  imgMain.Picture.Graphic := Bmp;
  Bmp.Free;
end;

// Draws a RGB multi-gradient
//  Field: Index of the field not being drawn
procedure TfColor.DrawRGBMulti(Field: byte);
var
  Bmp: TBitmap;
  x: integer;
  gRect: TGradientRect;
  vert: array[0..1] of TTriVertex;
  iFixed: integer;
begin
  Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf24bit;
  Bmp.Width := RGBMAX + 1;
  Bmp.Height := RGBMAX + 1;

  // Fixed values
  if (Field = 1) then
    iFixed := CurrentColor.RGB.rgbtGreen shl 8
  else if (Field = 2) then
    iFixed := CurrentColor.RGB.rgbtBlue shl 8
  else
    iFixed := CurrentColor.RGB.rgbtRed shl 8;
  vert[0].y := 0;
  vert[1].y := RGBMAX + 1;
  vert[0].Alpha := 0;
  vert[1].Alpha := 0;
  gRect.UpperLeft := 0;
  gRect.LowerRight := 1;

  for x := 0 to RGBMAX do
  begin
    // Width of the rectangle has to be 1
    vert[0].x := x;
    vert[1].x := x + 1;

    if (Field = 1) then
    begin
      vert[0].Red := RGBMAX shl 8;
      vert[0].Green := iFixed;
      vert[0].Blue := x shl 8;

      vert[1].Red := 0;
      vert[1].Green := iFixed;
      vert[1].Blue := x shl 8;
    end
    else if (Field = 2) then
    begin
      vert[0].Red := x shl 8;
      vert[0].Green := RGBMAX shl 8;
      vert[0].Blue := iFixed;

      vert[1].Red := x shl 8;
      vert[1].Green := 0;
      vert[1].Blue := iFixed;
    end
    else
    begin
      vert[0].Red := iFixed;
      vert[0].Green := RGBMAX shl 8;
      vert[0].Blue := x shl 8;

      vert[1].Red := iFixed;
      vert[1].Green := 0;
      vert[1].Blue := x shl 8;
    end;
    GradientFill(Bmp.Canvas.Handle, @vert, 2, @gRect, 1, GRADIENT_FILL_RECT_V);
  end;

  if chkWebsafe.Checked then
    WebsafeBitmap(Bmp);

  imgMain.Picture.Graphic := Bmp;
  Bmp.Free;
end;

//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Form events
//

procedure TfColor.FormCreate(Sender: TObject);
begin
  // Default values
  MouseDown := false;
  OldColor := clBlack;
  MousePos.X := -1;
  MousePos.Y := -1;

  // Loads the trackbar image
  imgTrack.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMP_TRACKBAR');

  //DoubleBuffering (used with Delphi 6)
  //panelMain.DoubleBuffered := true;
  //panelBar.DoubleBuffered := true;

  SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

end;

procedure TfColor.FormShow(Sender: TObject);
begin
  // Initial color
  with imgOldColor.Canvas do
  begin
    Brush.Color := OldColor;
    FillRect(ClipRect);
  end;

  // Gets the informations for the CurrentColor
  CurrentColor.RGB := ColorToRGBTriple(OldColor);
  CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
  CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);

  // Refreshes the edits
  //  (Simulates MouseDown to avoid TEdit.OnChange events)
  MouseDown := true;
  RefreshRGBs;
  RefreshHSVs;
  RefreshHSLs;
  editHexa.Text := RGBToHexa(CurrentColor.RGB);
  MouseDown := false;

  // Refreshes the images with HSV.H field by default
  radioHSVH.OnClick(Self);
  RefreshDisplay;
end;

// btnOK closes the form with ModalResult := mrOK;
procedure TfColor.btnCancelClick(Sender: TObject);
begin
  Close();
end;

procedure TfColor.btnOKClick(Sender: TObject);
begin
  // CurrentColor is not affected by the Websafe filter
  if chkWebSafe.Checked then
    CurrentColor.RGB := RGBToWebSafe(CurrentColor.RGB);
end;

//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  'TrackBar'
//

procedure TfColor.imgTrackMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Starts selection
  MouseDown := true;
  // Saves the actual position of the mouse
  TrackBarInfos.Position := Y;
end;

procedure TfColor.imgTrackMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Top, Value: integer;
begin
  // Checks if the user started the selection
  if MouseDown then
  begin
    // Calculates new imgHandle.Top
    Top := imgTrack.Top - TrackBarInfos.Position + Y;

    // Checks if the top is in the correct range
    if Top < TrackBarInfos.YMin then
      Top := TrackBarInfos.YMin
    else if Top > TrackBarInfos.YMax then
      Top := TrackBarInfos.YMax;

    // Changes the top
    if (imgTrack.Top <> Top) then
    begin
      imgTrack.Top := Top;
      // Calculates the new value within 0..TrackBarInfos.Max
      Value := (2 * (RGBMAX - Top + TrackBarInfos.YMin) * TrackBarInfos.Max +
                RGBMAX) div (2 * RGBMAX);
      TrackValueChanged(Value);
    end;
  end;
end;

procedure TfColor.imgTrackMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Stops selection
  MouseDown := false;
end;

procedure TfColor.imgBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Value: integer;
begin
  MouseDown := true;
  if Y < 0 then
    Value := TrackBarInfos.Max
  else if Y > RGBMAX then
    Value := 0
  else
    Value := (2 * (RGBMAX - Y) * TrackBarInfos.Max + RGBMAX) div (2 * RGBMAX);
  TrackValueToTop(Value);
  TrackValueChanged(Value);
  MouseDown := false;
end;

// Changes imgHeight.Top for a specific value within TrackBarInfos.Max
procedure TfColor.TrackValueToTop(Value: integer);
begin
  if Value = 0 then
    imgTrack.Top := TrackBarInfos.YMax
  else if Value = TrackBarInfos.Max then
    imgTrack.Top := TrackBarInfos.YMin
  else
    imgTrack.Top := TrackBarInfos.YMax -
                    ((2 * RGBMAX) * Value + TrackBarInfos.Max) div
                    (2 * TrackBarInfos.Max);
end;

procedure TfColor.TrackValueChanged(Value: integer);
begin
  if radioHSVH.Checked then
  begin
    CurrentColor.HSV.hsvtHue := Value;
    CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
    CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
    RefreshMain(csHSV, 0);
    RefreshEdits;
  end
  else if radioHSVS.Checked then
  begin
    CurrentColor.HSV.hsvtSaturation := Value;
    CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
    CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
    RefreshMain(csHSV, 1);
    RefreshEdits;
  end
  else if radioHSVV.Checked then
  begin
    CurrentColor.HSV.hsvtValue := Value;
    CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
    CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
    RefreshMain(csHSV, 2);
    RefreshEdits;
  end
  else if radioHSLH.Checked then
  begin
    CurrentColor.HSL.hsltHue := Value;
    CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
    CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
    RefreshMain(csHSL, 0);
    RefreshEdits;
  end
  else if radioHSLS.Checked then
  begin
    CurrentColor.HSL.hsltSaturation := Value;
    CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
    CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
    RefreshMain(csHSL, 1);
    RefreshEdits;
  end
  else if radioHSLL.Checked then
  begin
    CurrentColor.HSL.hsltLuminance := Value;
    CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
    CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
    RefreshMain(csHSL, 2);
    RefreshEdits;
  end
  else if radioRed.Checked then
  begin
    CurrentColor.RGB.rgbtRed := Value;
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    RefreshMain(csRGB, 0);
    RefreshEdits;
  end
  else if radioGreen.Checked then
  begin
    CurrentColor.RGB.rgbtGreen := Value;
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    RefreshMain(csRGB, 1);
    RefreshEdits;
  end
  else if radioBlue.Checked then
  begin
    CurrentColor.RGB.rgbtBlue := Value;
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    RefreshMain(csRGB, 2);
    RefreshEdits;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Main image selction
//

// Draws a circle as selection in the main image (inverted colors)
procedure TfColor.DrawSelector(X, Y: integer);
const
  RADIUS = 5;
begin
  imgMain.Canvas.Brush.Style := bsClear;
  imgMain.Canvas.Pen.Mode := pmNot;
  imgMain.Canvas.Ellipse(X - RADIUS, Y - RADIUS, X + RADIUS + 1, Y + RADIUS + 1);
end;

procedure TfColor.imgMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Starts the selection
  MouseDown := true;
  // Changes the position of the selection
  MainPositionChanged(X, Y);
end;

procedure TfColor.imgMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseDown then
  begin
    // Moves the selection point
    if X < 0 then
      X := 0
    else if X > imgMain.Width - 1 then
      X := imgMain.Width - 1;
    if Y < 0 then
      Y := 0
    else if Y > imgMain.Height - 1 then
      Y := imgMain.Height - 1;
    // Changes ans saves the position of the selection
    MainPositionChanged(X, Y);
  end;
end;

procedure TfColor.imgMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Stops the selection
  MouseDown := false;
end;

procedure TfColor.MainPositionChanged(X, Y: integer);
var
  oldCurrentColor: TColorInfos;
begin
  if (MousePos.X <> X) or (MousePos.Y <> Y) then
  begin
    // Erases the old point and draws the new one
    DrawSelector(MousePos.X, MousePos.Y);
    DrawSelector(X, Y);

    // Saves the position
    MousePos.X := X;
    MousePos.Y := Y;

    // Updates the color informations
    if radioHSVH.Checked then
    begin
      CurrentColor.HSV.hsvtSaturation := (2 * SLVMAX * X + RGBMAX) div (2 * RGBMAX);
      CurrentColor.HSV.hsvtValue := (2 * SLVMAX * (RGBMAX - Y) + RGBMAX) div (2 * RGBMAX);
      CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
      CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
      RefreshBar(csHSV, 0);
    end
    else if radioHSVS.Checked then
    begin
      CurrentColor.HSV.hsvtHue := (2 * HMAX * X + RGBMAX) div (2 * RGBMAX);
      CurrentColor.HSV.hsvtValue := (2 * SLVMAX * (RGBMAX - Y) + RGBMAX) div (2 * RGBMAX);
      CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
      CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
      RefreshBar(csHSV, 1);
    end
    else if radioHSVV.Checked then
    begin
      CurrentColor.HSV.hsvtHue := (2 * HMAX * X + RGBMAX) div (2 * RGBMAX);
      CurrentColor.HSV.hsvtSaturation := (2 * SLVMAX * (RGBMAX - Y) + RGBMAX) div (2 * RGBMAX);
      CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
      CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
      RefreshBar(csHSV, 2);
    end
    else if radioHSLH.Checked then
    begin
      CurrentColor.HSL.hsltSaturation := (2 * SLVMAX * X + RGBMAX) div (2 * RGBMAX);
      CurrentColor.HSL.hsltLuminance := (2 * SLVMAX * (RGBMAX - Y) + RGBMAX) div (2 * RGBMAX);
      CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
      CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
      RefreshBar(csHSL, 0);
    end
    else if radioHSLS.Checked then
    begin
      CurrentColor.HSL.hsltHue := (2 * HMAX * X + RGBMAX) div (2 * RGBMAX);
      CurrentColor.HSL.hsltLuminance := (2 * SLVMAX * (RGBMAX - Y) + RGBMAX) div (2 * RGBMAX);
      CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
      CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
      RefreshBar(csHSL, 1);
    end
    else if radioHSLL.Checked then
    begin
      CurrentColor.HSL.hsltHue := HMAX * X div RGBMAX;
      CurrentColor.HSL.hsltSaturation := SLVMAX * (RGBMAX - Y) div RGBMAX;
      CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
      CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
      RefreshBar(csHSL, 2);
    end
    else if radioRed.Checked then
    begin
      CurrentColor.RGB.rgbtGreen := RGBMAX - Y;
      CurrentColor.RGB.rgbtBlue := X;
      CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
      CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
      RefreshBar(csRGB, 0);
    end
    else if radioGreen.Checked then
    begin
      CurrentColor.RGB.rgbtRed := RGBMAX - Y;
      CurrentColor.RGB.rgbtBlue := X;
      CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
      CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
      RefreshBar(csRGB, 1);
    end
    else if radioBlue.Checked then
    begin
      CurrentColor.RGB.rgbtRed := X;
      CurrentColor.RGB.rgbtGreen := RGBMAX - Y;
      CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
      CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
      RefreshBar(csRGB, 2);
    end;
    
    // Updates the TEdits
    if chkWebsafe.Checked then
    begin
      oldCurrentColor := CurrentColor;
      CurrentColor.RGB := RGBToWebsafe(CurrentColor.RGB);
      CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
      CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
      RefreshRGBs;
      RefreshHSVs;
      RefreshHSLs;
      EditHexa.Text := RGBToHexa(CurrentColor.RGB);
      RefreshDisplay;
      CurrentColor := oldCurrentColor;
    end
    else
    begin
      RefreshRGBs;
      RefreshHSVs;
      RefreshHSLs;
      EditHexa.Text := RGBToHexa(CurrentColor.RGB);
      RefreshDisplay;
    end;
  end;
end;

//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Radio buttons
//
procedure TfColor.radioHSVHClick(Sender: TObject);
begin
  TrackBarInfos.Max := HMAX;
  TrackValueToTop(CurrentColor.HSV.hsvtHue);
  MousePos.X := (2 * RGBMAX * CurrentColor.HSV.hsvtSaturation + SLVMAX) div (2 * SLVMAX);
  MousePos.Y := (2 * RGBMAX * (SLVMAX - CurrentColor.HSV.hsvtValue) + SLVMAX) div (2 * SLVMAX);
  CurrentField.ColorSpace := csHSV;
  CurrentField.Field := 0;
  RefreshMain(csHSV, 0);
  RefreshBar(csHSV, 0);
end;

procedure TfColor.radioHSVSClick(Sender: TObject);
begin
  TrackBarInfos.Max := SLVMAX;
  TrackValueToTop(CurrentColor.HSV.hsvtSaturation);
  MousePos.X := (2 * RGBMAX * CurrentColor.HSV.hsvtHue + HMAX) div (2 * HMAX);
  MousePos.Y := (2 * RGBMAX * (SLVMAX - CurrentColor.HSV.hsvtValue) + SLVMAX) div (2 * SLVMAX);
  RefreshMain(csHSV, 1);
  RefreshBar(csHSV, 1);
end;

procedure TfColor.radioHSVVClick(Sender: TObject);
begin
  TrackBarInfos.Max := SLVMAX;
  TrackValueToTop(CurrentColor.HSV.hsvtValue);
  MousePos.X := (2 * RGBMAX * CurrentColor.HSV.hsvtHue + HMAX) div (2 * HMAX);
  MousePos.Y := (2 * RGBMAX * (SLVMAX - CurrentColor.HSV.hsvtSaturation) + SLVMAX) div (2 * SLVMAX);
  RefreshMain(csHSV, 2);
  RefreshBar(csHSV, 2);
end;

procedure TfColor.radioHSLHClick(Sender: TObject);
begin
  TrackBarInfos.Max := HMAX;
  TrackValueToTop(CurrentColor.HSL.hsltHue);
  MousePos.X := (2 * RGBMAX * CurrentColor.HSL.hsltSaturation + SLVMAX) div
                  (2 * SLVMAX);
  MousePos.Y := (2 * RGBMAX * (SLVMAX - CurrentColor.HSL.hsltLuminance) + SLVMAX) div (2 * SLVMAX);
  RefreshMain(csHSL, 0);
  RefreshBar(csHSL, 0);
end;

procedure TfColor.radioHSLSClick(Sender: TObject);
begin
  TrackBarInfos.Max := SLVMAX;
  TrackValueToTop(CurrentColor.HSL.hsltSaturation);
  MousePos.X := (2 * RGBMAX * CurrentColor.HSL.hsltHue + HMAX) div(2 * HMAX);
  MousePos.Y := (2 * RGBMAX * (SLVMAX - CurrentColor.HSL.hsltLuminance) + SLVMAX) div (2 * SLVMAX);
  RefreshMain(csHSL, 1);
  RefreshBar(csHSL, 1);
end;

procedure TfColor.radioHSLLClick(Sender: TObject);
begin
  TrackBarInfos.Max := SLVMAX;
  TrackValueToTop(CurrentColor.HSL.hsltLuminance);
  MousePos.X := (2 * RGBMAX * CurrentColor.HSL.hsltHue + HMAX) div(2 * HMAX);
  MousePos.Y := (2 * RGBMAX * (SLVMAX - CurrentColor.HSL.hsltSaturation) + SLVMAX) div (2 * SLVMAX);;
  RefreshMain(csHSL, 2);
  RefreshBar(csHSL, 2);
end;

procedure TfColor.radioRedClick(Sender: TObject);
begin
  TrackBarInfos.Max := RGBMAX;
  TrackValueToTop(CurrentColor.RGB.rgbtRed);
  MousePos.X := CurrentColor.RGB.rgbtBlue;
  MousePos.Y := RGBMAX - CurrentColor.RGB.rgbtGreen;
  RefreshMain(csRGB, 0);
  RefreshBar(csRGB, 0);
end;

procedure TfColor.radioGreenClick(Sender: TObject);
begin
  TrackBarInfos.Max := RGBMAX;
  TrackValueToTop(CurrentColor.RGB.rgbtGreen);
  MousePos.X := CurrentColor.RGB.rgbtBlue;
  MousePos.Y := RGBMAX - CurrentColor.RGB.rgbtRed;
  RefreshMain(csRGB, 1);
  RefreshBar(csRGB, 1);
end;

procedure TfColor.radioBlueClick(Sender: TObject);
begin
  TrackBarInfos.Max := RGBMAX;
  TrackValueToTop(CurrentColor.RGB.rgbtBlue);
  MousePos.X := CurrentColor.RGB.rgbtRed;
  MousePos.Y := RGBMAX - CurrentColor.RGB.rgbtGreen;
  RefreshMain(csRGB, 2);
  RefreshBar(csRGB, 2);
end;

//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  TEdits
//

// Refreshes values in TEdits
procedure TfColor.RefreshEdits;
var
  oldCurrentColor: TColorInfos;
begin
  if chkWebsafe.Checked then
  begin
    // Saves the current color
    oldCurrentColor := CurrentColor;
    // Modifies the currentColor to websafe
    CurrentColor.RGB := RGBToWebsafe(CurrentColor.RGB);
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    RefreshRGBs;
    RefreshHSVs;
    RefreshHSLs;
    editHexa.Text := RGBToHexa(CurrentColor.RGB);
    RefreshDisplay;
    // Restores the initial color
    CurrentColor := oldCurrentColor;
  end
  else
  begin
    if CurrentField.ColorSpace = csRGB then
    begin
      if CurrentField.Field = 0 then
        editRed.Text := IntToStr(CurrentColor.RGB.rgbtRed)
      else if CurrentField.Field = 1 then
        editGreen.Text := IntToStr(CurrentColor.RGB.rgbtGreen)
      else
        editBlue.Text := IntToStr(CurrentColor.RGB.rgbtBlue);
      RefreshHSVs;
      RefreshHSLs;
    end
    else if CurrentField.ColorSpace = csHSV then
    begin
      if CurrentField.Field = 0 then
        editHSVH.Text := IntToStr(CurrentColor.HSV.hsvtHue)
      else if CurrentField.Field = 1 then
        editHSVS.Text := IntToStr(CurrentColor.HSV.hsvtSaturation)
      else
        editHSVV.Text := IntToStr(CurrentColor.HSV.hsvtValue);
      RefreshRGBs;
      RefreshHSLs;
    end
    else
    begin
      if CurrentField.Field = 0 then
        editHSLH.Text := IntToStr(CurrentColor.HSL.hsltHue)
      else if CurrentField.Field = 1 then
        editHSLS.Text := IntToStr(CurrentColor.HSL.hsltSaturation)
      else
        editHSLL.Text := IntToStr(CurrentColor.HSL.hsltLuminance);
      RefreshRGBs;
      RefreshHSVs;
    end;
    // Independent of the ColorSpace
    editHexa.Text := RGBToHexa(CurrentColor.RGB);
    RefreshDisplay;
  end;
end;

// Refreshes all the RGB TEdits
procedure TfColor.RefreshRGBs;
begin
  editRed.Text := IntToStr(CurrentColor.RGB.rgbtRed);
  editGreen.Text := IntToStr(CurrentColor.RGB.rgbtGreen);
  editBlue.Text := IntToStr(CurrentColor.RGB.rgbtBlue);
end;

// Refreshes all the HSV TEdits
procedure TfColor.RefreshHSVs;
begin
  editHSVH.Text := IntToStr(CurrentColor.HSV.hsvtHue);
  editHSVS.Text := IntToStr(CurrentColor.HSV.hsvtSaturation);
  editHSVV.Text := IntToStr(CurrentColor.HSV.hsvtValue);
end;

// Refreshes all the HSL TEdits
procedure TfColor.RefreshHSLs;
begin
  editHSLH.Text := IntToStr(CurrentColor.HSL.hsltHue);
  editHSLS.Text := IntToStr(CurrentColor.HSL.hsltSaturation);
  editHSLL.Text := IntToStr(CurrentColor.HSL.hsltLuminance);
end;

procedure TfColor.editHexaKeyPress(Sender: TObject; var Key: Char);
begin
  // Only hexa and Backspace allowed
  if (((Key < '0') or (Key > '9')) and
      ((Key < 'a') or (Key > 'f')) and
      ((Key < 'A') or (Key > 'F')) and
      (Key <> Chr(VK_BACK))) then
    Key := Chr(0);
end;

procedure TfColor.editHexaChange(Sender: TObject);
var
  oldCurrentColor: TColorInfos;
begin
  // Checks if the user changed the TEdit himself and if the Hexa is valid
  if not MouseDown and (Length(editHexa.Text) = 6) then
  begin
    CurrentColor.RGB := HexaToRGB(editHexa.Text);
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);

    // Checks if the current color has to be websafe
    if chkWebsafe.Checked then
    begin
      oldCurrentColor := CurrentColor;
      CurrentColor.RGB := RGBToWebsafe(CurrentColor.RGB);
      CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
      CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    end;

    // Refreshes the Main and the TrackBar images
    if radioHSVH.Checked then
    begin
      RefreshMain(csHSV, 0);
      RefreshBar(csHSV, 0);
    end
    else if radioHSVS.Checked then
    begin
      RefreshMain(csHSV, 1);
      RefreshBar(csHSV, 1);
    end
    else if radioHSVV.Checked then
    begin
      RefreshMain(csHSV, 2);
      RefreshBar(csHSV, 2);
    end
    else if radioHSLH.Checked then
    begin
      RefreshMain(csHSL, 0);
      RefreshBar(csHSL, 0);
    end
    else if radioHSLS.Checked then
    begin
      RefreshMain(csHSL, 1);
      RefreshBar(csHSL, 1);
    end
    else if radioHSLL.Checked then
    begin
      RefreshMain(csHSL, 2);
      RefreshBar(csHSL, 2);
    end
    else if radioRed.Checked then
    begin
      RefreshMain(csRGB, 0);
      RefreshBar(csRGB, 0);
    end
    else if radioGreen.Checked then
    begin
      RefreshMain(csRGB, 1);
      RefreshBar(csRGB, 1);
    end
    else if radioBlue.Checked then
    begin
      RefreshMain(csRGB, 2);
      RefreshBar(csRGB, 2);
    end;

    // Refreshes the TEdits
    //  (Simulates MouseDown to avoid TEdit.OnChange event)
    MouseDown := true;
    RefreshRGBs;
    RefreshHSVs;
    RefreshHSLs;
    MouseDown := false;

    // Refreshes the display of the current color
    RefreshDisplay;

    // Restores the initial CurrentColor
    if chkWebsafe.Checked then
      CurrentColor := oldCurrentColor;
    end;
end;

procedure TfColor.editHSVHEnter(Sender: TObject);
begin
  // Saves the actual value in the Tag property
  TEdit(Sender).Tag := StrToInt(TEdit(Sender).Text);
end;

// Same for RGB, HSV and HSL
procedure TfColor.editHSVHKeyPress(Sender: TObject; var Key: Char);
begin
  // Only digits and Backspace allowed
  if ((Key < '0') or (Key > '9')) and
      (Key <> Chr(VK_BACK)) then
    Key := Chr(0)
  else
    // TEdit.Text is not changed as long as we are in this procedure and
    //  Sender.OnChange event is not triggered after this one.
    //  => Raising the OnChange resolves this
    (Sender as TEdit).OnChange(Sender);
end;

// editHSVH and editHSLH
procedure TfColor.editHSVHChange(Sender: TObject);
var
  Value: integer;
  Ctrl: TEdit;
begin
  // Checks if the value is changed from the TEdit
  if not MouseDown then
  begin
    Ctrl := TEdit(Sender);
    // The value is not changed if the Text is empty
    if Length(Ctrl.Text) <> 0 then
    begin
      Value := StrToInt(Ctrl.Text);
      // Checks if the value is greater than the maximum allowed
      while Value > HMAX do
        Value := Value - HMAX;

      if Ctrl.Name = 'editHSVH' then
      begin
        CurrentColor.HSV.hsvtHue := Value;
        EditChanged(csHSV, 0);
      end
      else
      begin
        CurrentColor.HSL.hsltHue := Value;
        EditChanged(csHSL, 0);
      end;
    end;
  end;
end;

procedure TfColor.editHSVSChange(Sender: TObject);
var
  Value: integer;
  Ctrl: TEdit;
begin
  // Checks if the value is changed from the TEdit
  if not MouseDown then
  begin
    Ctrl := TEdit(Sender);
    // The value is not changed if the Text is empty
    if Length(Ctrl.Text) <> 0 then
    begin
      Value := StrToInt(Ctrl.Text);
      // Checks if the value is greater than the maximum allowed
      if Value > SLVMAX then
        Value := SLVMAX;

      if Ctrl.Name = 'editHSVS' then
      begin
        CurrentColor.HSV.hsvtSaturation := Value;
        EditChanged(csHSV, 1);
      end
      else if Ctrl.Name = 'editHSVV' then
      begin
        CurrentColor.HSV.hsvtValue := Value;
        EditChanged(csHSV, 2);
      end
      else if Ctrl.Name = 'editHSLS' then
      begin
        CurrentColor.HSL.hsltSaturation := Value;
        EditChanged(csHSL, 1);
      end
      else
      begin
        CurrentColor.HSL.hsltLuminance := Value;
        EditChanged(csHSL, 2);
      end
    end;
  end;
end;

procedure TfColor.editRedChange(Sender: TObject);
var
  Value: integer;
  Ctrl: TEdit;
begin
  // Checks if the value is changed from the TEdit
  if not MouseDown then
  begin
    Ctrl := TEdit(Sender);
    // The value is not changed if the Text is empty
    if Length(Ctrl.Text) <> 0 then
    begin
      Value := StrToInt(Ctrl.Text);
      // Checks if the value is greater than the maximum allowed
      if Value > RGBMAX then
        Value := RGBMAX;

      if Ctrl.Name = 'editRed' then
      begin
        CurrentColor.RGB.rgbtRed := Value;
        EditChanged(csRGB, 0);
      end
      else if Ctrl.Name = 'editGreen' then
      begin
        CurrentColor.RGB.rgbtGreen := Value;
        EditChanged(csRGB, 1);
      end
      else
      begin
        CurrentColor.RGB.rgbtBlue := Value;
        EditChanged(csRGB, 2);
      end
    end;
  end;
end;

// Shared procedure for TEdit.OnChange
procedure TfColor.EditChanged(ColorSpace: TColorSpace; Field: byte);
var
  oldCurrentColor: TColorInfos;
begin
  // Converts to the other color spaces
  if ColorSpace = csRGB then
  begin
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
  end
  else if ColorSpace = csHSV then
  begin
    CurrentColor.RGB := HSVToRGB(CurrentColor.HSV);
    CurrentColor.HSL := HSVToHSL(CurrentColor.HSV);
  end
  else
  begin
    CurrentColor.RGB := HSLToRGB(CurrentColor.HSL);
    CurrentColor.HSV := HSLToHSV(CurrentColor.HSL);
  end;

  // Checks if the color has to be websafe
  if chkWebsafe.Checked then
  begin
    oldCurrentColor := CurrentColor;
    CurrentColor.RGB := RGBToWebsafe(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
  end;

  // Simulates MouseDown to avoid TEdit.OnChange event
  MouseDown := true;
  if ColorSpace = csRGB then
  begin
    if Field = 0 then
    begin
      editGreen.Text := IntToStr(CurrentColor.RGB.rgbtGreen);
      editBlue.Text := IntToStr(CurrentColor.RGB.rgbtBlue);
    end
    else if Field = 1 then
    begin
      editRed.Text := IntToStr(CurrentColor.RGB.rgbtRed);
      editBlue.Text := IntToStr(CurrentColor.RGB.rgbtBlue);
    end
    else
    begin
      editRed.Text := IntToStr(CurrentColor.RGB.rgbtRed);
      editGreen.Text := IntToStr(CurrentColor.RGB.rgbtGreen);
    end;
    RefreshHSVs;
    RefreshHSLs;
  end
  else if ColorSpace = csHSV then
  begin
    if Field = 0 then
    begin
      editHSVS.Text := IntToStr(CurrentColor.HSV.hsvtSaturation);
      editHSVV.Text := IntToStr(CurrentColor.HSV.hsvtValue);
    end
    else if Field = 1 then
    begin
      editHSVH.Text := IntToStr(CurrentColor.HSV.hsvtHue);
      editHSVV.Text := IntToStr(CurrentColor.HSV.hsvtValue);
    end
    else
    begin
      editHSVH.Text := IntToStr(CurrentColor.HSV.hsvtHue);
      editHSVS.Text := IntToStr(CurrentColor.HSV.hsvtSaturation);
    end;
    RefreshRGBs;
    RefreshHSLs;
  end
  else
  begin
    if Field = 0 then
    begin
      editHSLS.Text := IntToStr(CurrentColor.HSL.hsltSaturation);
      editHSLL.Text := IntToStr(CurrentColor.HSL.hsltLuminance);
    end
    else if Field = 1 then
    begin
      editHSLH.Text := IntToStr(CurrentColor.HSL.hsltHue);
      editHSLL.Text := IntToStr(CurrentColor.HSL.hsltLuminance);
    end
    else
    begin
      editHSLH.Text := IntToStr(CurrentColor.HSL.hsltHue);
      editHSLS.Text := IntToStr(CurrentColor.HSL.hsltSaturation);
    end;
    RefreshRGBs;
    RefreshHSVs;
  end;

  MouseDown := false;

  // Refreshes the images and the positions (main image and TrackBar)
  if radioHSVH.Checked then
    radioHSVH.OnClick(radioHSVH)
  else if radioHSVS.Checked then
    radioHSVS.OnClick(radioHSVS)
  else if radioHSVV.Checked then
    radioHSVV.OnClick(radioHSVV)
  else if radioHSLH.Checked then
    radioHSLH.OnClick(radioHSLH)
  else if radioHSLS.Checked then
    radioHSLS.OnClick(radioHSLS)
  else if radioHSLL.Checked then
    radioHSLL.OnClick(radioHSLL)
  else if radioRed.Checked then
    radioRed.OnClick(radioRed)
  else if radioGreen.Checked then
    radioGreen.OnClick(radioGreen)
  else
    radioBlue.OnClick(radioBlue);
  RefreshDisplay;

  // Restores the CurrentColor
  if chkWebsafe.Checked then
    CurrentColor := oldCurrentColor;
end;

//
////////////////////////////////////////////////////////////////////////////////

// Refreshes the display of the current color
procedure TfColor.RefreshDisplay;
begin
  with imgNewColor.Canvas do
  begin
    Brush.Color := RGBTripleToColor(CurrentColor.RGB);
    FillRect(ClipRect);
  end;
end;

// Refreshes the main image
//  ColorSpace: ColorSpace that has been changed
//  Field: Index of the field that has not been changed
procedure TfColor.RefreshMain(ColorSpace: TColorSpace; Field: byte);
begin
  if ColorSpace = csHSV then
    DrawHSVMulti(Field)
  else if ColorSpace = csHSL then
    DrawHSLMulti(Field)
  else
    DrawRGBMulti(Field);
  DrawSelector(MousePos.X, MousePos.Y);
end;

// Refreshes the bar image
//  ColorSpace: ColorSpace that has been changed
//  Field: Index of the field that has been changed
procedure TfColor.RefreshBar(ColorSpace: TColorSpace; Field: byte);
var
  Bmp: TBitmap;
begin
  // Creates the bitmap
  Bmp := TBitmap.Create;
  Bmp.Width := imgBar.Width;
  Bmp.Height := RGBMAX + 1;
  Bmp.PixelFormat := pf24bit;

  // Fills the bitmap
  if ColorSpace = csRGB then
    DrawRGBField(Bmp, CurrentColor.RGB, Field)
  else if ColorSpace = csHSV then
    DrawHSVField(Bmp, CurrentColor.HSV, Field)
  else
    DrawHSLField(Bmp, CurrentColor.HSL, Field);

  // Checks if the display has to be websafe
  if chkWebsafe.Checked then
    WebsafeBitmap(Bmp);

  // Assigns and frees the bitmap
  imgBar.Picture.Bitmap := Bmp;
  Bmp.Free;
end;

procedure TfColor.chkWebsafeClick(Sender: TObject);
var
  oldCurrentColor: TColorInfos;
begin
  // Checks if the current color has to be websafe
  if chkWebsafe.Checked then
  begin
    oldCurrentColor := CurrentColor;
    CurrentColor.RGB := RGBToWebsafe(CurrentColor.RGB);
    CurrentColor.HSV := RGBToHSV(CurrentColor.RGB);
    CurrentColor.HSL := RGBToHSL(CurrentColor.RGB);
  end;

  // Refreshes the Main and the TrackBar images
  if radioHSVH.Checked then
  begin
    RefreshMain(csHSV, 0);
    RefreshBar(csHSV, 0);
  end
  else if radioHSVS.Checked then
  begin
    RefreshMain(csHSV, 1);
    RefreshBar(csHSV, 1);
  end
  else if radioHSVV.Checked then
  begin
    RefreshMain(csHSV, 2);
    RefreshBar(csHSV, 2);
  end
  else if radioHSLH.Checked then
  begin
    RefreshMain(csHSL, 0);
    RefreshBar(csHSL, 0);
  end
  else if radioHSLS.Checked then
  begin
    RefreshMain(csHSL, 1);
    RefreshBar(csHSL, 1);
  end
  else if radioHSLL.Checked then
  begin
    RefreshMain(csHSL, 2);
    RefreshBar(csHSL, 2);
  end
  else if radioRed.Checked then
  begin
    RefreshMain(csRGB, 0);
    RefreshBar(csRGB, 0);
  end
  else if radioGreen.Checked then
  begin
    RefreshMain(csRGB, 1);
    RefreshBar(csRGB, 1);
  end
  else if radioBlue.Checked then
  begin
    RefreshMain(csRGB, 2);
    RefreshBar(csRGB, 2);
  end;

  // Refreshes the TEdits
  //  (Simulates MouseDown to avoid TEdit.OnChange event)
  MouseDown := true;
  RefreshRGBs;
  RefreshHSVs;
  RefreshHSLs;
  editHexa.Text := RGBToHexa(CurrentColor.RGB);
  MouseDown := false;

  // Refreshes the display of the current color
  RefreshDisplay;

  // Restores the initial CurrentColor
  if chkWebsafe.Checked then
    CurrentColor := oldCurrentColor;
end;

end.
