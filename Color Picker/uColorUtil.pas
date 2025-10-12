{
  Color conversions based on www.easyrgb.com/math.php
}
unit uColorUtil;

interface

uses Windows, Classes, Math, SysUtils, Graphics;

const
  // Maximum for RGB range
  RGBMAX = 255;
  // Maximum for Hue range (Best if HMAX % 6 = 0)
  HMAX = 360; // (-> in degrees)
  // Maximum for Saturation, Luminance and Value range (Best if SLVMAX % 2 = 0)
  SLVMAX = 100; // (-> in percents)
  // Maximum of TRGBTriple
  PixelCountMax = 32768;

  //.NET Web Named Color palette
  //  Stored in the Windows COLORREF byte order x00bbggrr
  clWebSnow = $FAFAFF;
  clWebFloralWhite = $F0FAFF;
  clWebLavenderBlush = $F5F0FF;
  clWebOldLace = $E6F5FD;
  clWebIvory = $F0FFFF;
  clWebCornSilk = $DCF8FF;
  clWebBeige = $DCF5F5;
  clWebAntiqueWhite = $D7EBFA;
  clWebWheat = $B3DEF5;
  clWebAliceBlue = $FFF8F0;
  clWebGhostWhite = $FFF8F8;
  clWebLavender = $FAE6E6;
  clWebSeashell = $EEF5FF;
  clWebLightYellow = $E0FFFF;
  clWebPapayaWhip = $D5EFFF;
  clWebNavajoWhite = $ADDEFF;
  clWebMoccasin = $B5E4FF;
  clWebBurlywood = $87B8DE;
  clWebAzure = $FFFFF0;
  clWebMintcream = $FAFFF5;
  clWebHoneydew = $F0FFF0;
  clWebLinen = $E6F0FA;
  clWebLemonChiffon = $CDFAFF;
  clWebBlanchedAlmond = $CDEBFF;
  clWebBisque = $C4E4FF;
  clWebPeachPuff = $B9DAFF;
  clWebTan = $8CB4D2;
  clWebYellow = $00FFFF;
  clWebDarkOrange = $008CFF;
  clWebRed = $0000FF;
  clWebDarkRed = $00008B;
  clWebMaroon = $000080;
  clWebIndianRed = $5C5CCD;
  clWebSalmon = $7280FA;
  clWebCoral = $507FFF;
  clWebGold = $00D7FF;
  clWebTomato = $4763FF;
  clWebCrimson = $3C14DC;
  clWebBrown = $2A2AA5;
  clWebChocolate = $1E69D2;
  clWebSandyBrown = $60A4F4;
  clWebLightSalmon = $7AA0FF;
  clWebLightCoral = $8080F0;
  clWebOrange = $00A5FF;
  clWebOrangeRed = $0045FF;
  clWebFirebrick = $2222B2;
  clWebSaddleBrown = $13458B;
  clWebSienna = $2D52A0;
  clWebPeru = $3F85CD;
  clWebDarkSalmon = $7A96E9;
  clWebRosyBrown = $8F8FBC;
  clWebPaleGoldenrod = $AAE8EE;
  clWebLightGoldenrodYellow = $D2FAFA;
  clWebOlive = $008080;
  clWebForestGreen = $228B22;
  clWebGreenYellow = $2FFFAD;
  clWebChartreuse = $00FF7F;
  clWebLightGreen = $90EE90;
  clWebAquamarine = $D4FF7F;
  clWebSeaGreen = $578B2E;
  clWebGoldenRod = $20A5DA;
  clWebKhaki = $8CE6F0;
  clWebOliveDrab = $238E6B;
  clWebGreen = $008000;
  clWebYellowGreen = $32CD9A;
  clWebLawnGreen = $00FC7C;
  clWebPaleGreen = $98FB98;
  clWebMediumAquamarine = $AACD66;
  clWebMediumSeaGreen = $71B33C;
  clWebDarkGoldenRod = $0B86B8;
  clWebDarkKhaki = $6BB7BD;
  clWebDarkOliveGreen = $2F6B55;
  clWebDarkgreen = $006400;
  clWebLimeGreen = $32CD32;
  clWebLime = $00FF00;
  clWebSpringGreen = $7FFF00;
  clWebMediumSpringGreen = $9AFA00;
  clWebDarkSeaGreen = $8FBC8F;
  clWebLightSeaGreen = $AAB220;
  clWebPaleTurquoise = $EEEEAF;
  clWebLightCyan = $FFFFE0;
  clWebLightBlue = $E6D8AD;
  clWebLightSkyBlue = $FACE87;
  clWebCornFlowerBlue = $ED9564;
  clWebDarkBlue = $8B0000;
  clWebIndigo = $82004B;
  clWebMediumTurquoise = $CCD148;
  clWebTurquoise = $D0E040;
  clWebCyan = $FFFF00;
  //clWebAqua = $FFFF00 = clWebCyan;
  clWebPowderBlue = $E6E0B0;
  clWebSkyBlue = $EBCE87;
  clWebRoyalBlue = $E16941;
  clWebMediumBlue = $CD0000;
  clWebMidnightBlue = $701919;
  clWebDarkTurquoise = $D1CE00;
  clWebCadetBlue = $A09E5F;
  clWebDarkCyan = $8B8B00;
  clWebTeal = $808000;
  clWebDeepskyBlue = $FFBF00;
  clWebDodgerBlue = $FF901E;
  clWebBlue = $FF0000;
  clWebNavy = $800000;
  clWebDarkViolet = $D30094;
  clWebDarkOrchid = $CC3299;
  clWebMagenta = $FF00FF;
  // clWebFuchsia = $FF00FF = clWebMagenta
  clWebDarkMagenta = $8B008B;
  clWebMediumVioletRed = $8515C7;
  clWebPaleVioletRed = $9370DB;
  clWebBlueViolet = $E22B8A;
  clWebMediumOrchid = $D355BA;
  clWebMediumPurple = $DB7093;
  clWebPurple = $800080;
  clWebDeepPink = $9314FF;
  clWebLightPink = $C1B6FF;
  clWebViolet = $EE82EE;
  clWebOrchid = $D670DA;
  clWebPlum = $DDA0DD;
  clWebThistle = $D8BFD8;
  clWebHotPink = $B469FF;
  clWebPink = $CBC0FF;
  clWebLightSteelBlue = $DEC4B0;
  clWebMediumSlateBlue = $EE687B;
  clWebLightSlateGray = $998877;
  clWebWhite = $FFFFFF;
  clWebLightgrey = $D3D3D3;
  clWebGray = $808080;
  clWebSteelBlue = $B48246;
  clWebSlateBlue = $CD5A6A;
  clWebSlateGray = $908070;
  clWebWhiteSmoke = $F5F5F5;
  clWebSilver = $C0C0C0;
  clWebDimGray = $696969;
  clWebMistyRose = $E1E4FF;
  clWebDarkSlateBlue = $8B3D48;
  clWebDarkSlategray = $4F4F2F;
  clWebGainsboro = $DCDCDC;
  clWebDarkGray = $A9A9A9;
  clWebBlack = $000000;

type
  // Pointer used for Bitmap.Scanline
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax-1] of TRGBTriple;

  // HSV Type
  THSVTriple = packed record
    hsvtHue,
    hsvtSaturation,
    hsvtValue: integer;
  end;

  // HSL Type
  THSLTriple = packed record
    hsltHue,
    hsltSaturation,
    hsltLuminance: integer;
  end;

  // Corrected definitions for GradientFill (D7 and lower versions)
  PTriVertex = ^TTriVertex;
  TTriVertex = packed record
    x: Longint;
    y: Longint;
    Red: Word;
    Green: Word;
    Blue: Word;
    Alpha: Word;
  end;
  {$EXTERNALSYM GradientFill}
  function GradientFill(DC: HDC; Vertex: PTriVertex; NumVertex: ULONG; Mesh: Pointer; NumMesh, Mode: ULONG): BOOL; stdcall;

  // RGB <-> HSL
  function RGBToHSL(const RGB: TRGBTriple): THSLTriple;
  function HSLToRGB(const HSL: THSLTriple): TRGBTriple;
  function HSLInRGBMAXToRGB(const Hue, Saturation, Luminance: byte): TRGBTriple;

  // RGB <-> HSV
  function RGBToHSV(const RGB: TRGBTriple): THSVTriple;
  function HSVToRGB(const HSV: THSVTriple): TRGBTriple;
  function HSVinRGBMAXToRGB(const Hue, Saturation, Value: byte): TRGBTriple;

  // HSV <-> HSL
  function HSLToHSV(const HSL: THSLTriple): THSVTriple;
  function HSVToHSL(const HSV: THSVTriple): THSLTriple;

  // TColor <-> RGB
  function ColorToRGBTriple(const Color: TColor): TRGBTriple;
  function RGBTripleToColor(const RGB: TRGBTriple): TColor;

  // Websafe
  // Returns the nearest Websafe Byte of an TRGBTriple Byte
  function RGBByteToWebsafe(const Src: Byte): Byte;
  // Returns the nearest Websafe TRGBTriple of a TRGBTriple
  function RGBToWebsafe(const RGB: TRGBTriple): TRGBTriple;
  // Checks if a TRGBTriple is a Websafe Color
  function RGBIsWebSafe(const RGB: TRGBTriple): boolean;

  // RGB -> String
  // Converts a TRGBTriple to an Hexa string
  function RGBToHexa(const RGB: TRGBTriple): string;
  // Converts an Hexa string to a TRGBTriple
  function HexaToRGB(const Hexa: string): TRGBTriple;
  // Converts a TRGBTriple to an HTML value string
  function RGBToHTML(const RGB: TRGBTriple): string;
  // Converts a TRGBTriple to a Delphi value string
  function RGBToDelphiHEX(const RGB: TRGBTriple): string;
  // Converts a TRGBTriple to a VB value string
  function RGBToVBHEX(const RGB: TRGBTriple): string;
  // Converts a TRGBTriple to a C++ value string
  function RGBToCppHEX(const RGB: TRGBTriple): string;
  // Converts a TRGBTriple to a C# color representation
  function RGBToCSharp(const RGB: TRGBTriple): string;

implementation

////////////////////////////////////////////////////////////////////////////////
//
//  RGB <-> HSL
//
////////////////////////////////////////////////////////////////////////////////

(*******************************************************************************
  RGB -> HSL
  ==========

  Original:
  ---------
    var_R = ( R / 255 )                     //Where RGB values = 0 ÷ 255
    var_G = ( G / 255 )
    var_B = ( B / 255 )

    var_Min = min( var_R, var_G, var_B )    //Min. value of RGB
    var_Max = max( var_R, var_G, var_B )    //Max. value of RGB
    del_Max = var_Max - var_Min             //Delta RGB value

    L = ( var_Max + var_Min ) / 2

    if ( del_Max == 0 )                     //This is a gray, no chroma...
    {
      H = 0                                 //HSL results = 0 ÷ 1
      S = 0
    }
    else                                    //Chromatic data...
    {
      if ( L < 0.5 )
        S = del_Max / ( var_Max + var_Min )
      else
        S = del_Max / ( 2 - var_Max - var_Min )

      del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
      del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
      del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

      if ( var_R == var_Max )
        H = del_B - del_G
      else if ( var_G == var_Max )
        H = ( 1 / 3 ) + del_R - del_B
      else if ( var_B == var_Max )
        H = ( 2 / 3 ) + del_G - del_R

      if ( H < 0 )
        H += 1
      if ( H > 1 )
        H -= 1
    }

    Steps used to 'optimize':
    -------------------------
     - H, S and L will be converted to their defined range
        Result.H := Round(H * HMAX);
        Result.S := Round(S * SLVMAX);
        Result.L := Round(L * SLVMAX);
     - If (del_Max = 0) <=> (var_Max = var_Min) <=>
        ((var_R = var_G) and (var_G = var_B)) <=> (R = G) and (G = B)
        With R = G = B, Result.L := Round((R / RGBMAX) * SLVMAX);
     - (var_Max + var_Min) is used twice
        (2 - var_Max - var_Min <=> 2 - (var_Max + var_Min))
        => Add := var_Max + var_Min
            L := Add / 2;
            if (L < 1/2) <=> Add < 1 (= Add / 2 < 1/2)
     - With the conditions if (var_R = var_Max)... Only two of del_R, del_G and
        del_B are used only once =>
        H = del_B - del_G <=>
          H = ((((var_Max - var_B) / 6) + (del_Max / 2)) / del_Max) - ((((var_Max - var_G) / 6) + (del_Max / 2)) / del_Max)
          H = (((var_Max - var_B) / 6) + (del_Max / 2) - ((var_Max - var_G) / 6) - (del_Max / 2)) / del_Max
          H = ((var_Max - var_B - var_Max + var_G) / 6) / del_Max
          H = (var_G - var_B) / (6 * delMax)
        Applied to the 2 others
          - H = (1/3) + del_R - del_B <=>
            H = (1/3) + (var_B - var_R) / (6 * del_Max)
          - H = (2/3) + del_G - del_R <=>
            H = (2/3) + (var_R - var_G) / (6 * del_Max)
     - If (H < 0) H += 1 => H < 1, the second 'if' is useless
*******************************************************************************)
function RGBToHSL(const RGB: TRGBTriple): THSLTriple;
var
  R, G, B, Mini, Maxi, Delta, Add: Double;
begin
  if (RGB.rgbtRed = RGB.rgbtGreen) and (RGB.rgbtGreen = RGB.rgbtBlue) then
  begin
    Result.hsltHue := 0;
    Result.hsltSaturation := 0;
    Result.hsltLuminance := ((2 * SLVMAX) * RGB.rgbtGreen + RGBMAX) div (2 * RGBMAX);
  end
  else
  begin
    R := RGB.rgbtRed / RGBMAX;
    G := RGB.rgbtGreen / RGBMAX;
    B := RGB.rgbtBlue / RGBMAX;
    Maxi := Math.Max(Math.Max(R, G), B);
    Mini := Math.Min(Math.Min(R, G), B);
    Delta := Maxi - Mini;
    Add := Maxi + Mini;

    Result.hsltLuminance := Round(SLVMAX * Add / 2);

    if Add < 1 then
      Result.hsltSaturation := Round(SLVMAX * Delta / Add)
    else
      Result.hsltSaturation := Round(SLVMAX * Delta / (2 - Add));

    if R = Maxi then
      Result.hsltHue := Round(HMAX * (G - B) / (6 * Delta))
    else if G = Maxi then
      Result.hsltHue := Round((HMAX / 3) + HMAX * (B - R) / (6 * Delta))
    else
      Result.hsltHue := Round((2 * HMAX / 3) + HMAX * (R - G) / (6 * Delta));

    if Result.hsltHue < 0 then
      Result.hsltHue := Result.hsltHue + HMAX
    else if Result.hsltHue > HMAX then
      Result.hsltHue := Result.hsltHue - HMAX;
  end;
end;

(*******************************************************************************
  HSL -> RGB
  ==========

  Original:
  ---------
    if ( S == 0 )                       //HSL values = 0 ÷ 1
    {
      R = L * 255                      //RGB results = 0 ÷ 255
      G = L * 255
      B = L * 255
    }
    else
    {
      if ( L < 0.5 )
        var_2 = L * ( 1 + S )
      else
        var_2 = ( L + S ) - ( S * L )

      var_1 = 2 * L - var_2

      R = 255 * Hue_2_RGB( var_1, var_2, H + ( 1 / 3 ) )
      G = 255 * Hue_2_RGB( var_1, var_2, H )
      B = 255 * Hue_2_RGB( var_1, var_2, H - ( 1 / 3 ) )
    }

    Hue_2_RGB( v1, v2, vH )             //Function Hue_2_RGB
    {
      if ( vH < 0 )
        vH += 1
      if ( vH > 1 )
        vH -= 1
      if ( ( 6 * vH ) < 1 )
        return ( v1 + ( v2 - v1 ) * 6 * vH )
      if ( ( 2 * vH ) < 1 )
        return ( v2 )
      if ( ( 3 * vH ) < 2 )
        return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 )
      return ( v1 )
    }

   (...view HSLToRGB.pas)
*******************************************************************************)
function HSLToRGB(const HSL: THSLTriple): TRGBTriple;
var
  H, S, L, v1, v2: double;
begin
  if HSL.hsltSaturation = 0 then
  begin
    Result.rgbtRed := Round(HSL.hsltLuminance * RGBMAX / SLVMAX);
    Result.rgbtGreen := Result.rgbtRed;
    Result.rgbtBlue := Result.rgbtRed;
  end
  else if HSL.hsltLuminance = SLVMAX then
  begin
    Result.rgbtRed := RGBMAX;
    Result.rgbtGreen := RGBMAX;
    Result.rgbtBlue := RGBMAX;
  end
  else
  begin
    H := HSL.hsltHue / HMAX;
    S := HSL.hsltSaturation / SLVMAX;
    L := HSL.hsltLuminance / SLVMAX;
    if (L < 0.5) then
      v2 := L * (1 + S)
    else
      v2 := L + S - S * L;
    v1 := 2 * L - v2;

    // Red
    if (H > 2/3) then
    begin
      if (H < 5/6) then
        Result.rgbtRed := Round(RGBMAX * (v1 + (v2 - v1) * (6 * H - 4)))
      else
        Result.rgbtRed := Round(RGBMAX * v2);
    end
    else
    begin
      if (H < 1/6) then
        Result.rgbtRed := Round(RGBMAX * v2)
      else if (H < 1/3) then
        Result.rgbtRed := Round(RGBMAX * (v1 + (v2 - v1) * (2 - 6 * H)))
      else
        Result.rgbtRed := Round(RGBMAX * v1);
    end;

    // Green
    if (H < 1 / 6) then
      Result.rgbtGreen := Round(RGBMAX * (v1 + (v2 - v1) * 6 * H))
    else if (H < 1 / 2) then
      Result.rgbtGreen := Round(RGBMAX * v2)
    else if (H < 2 / 3) then
      Result.rgbtGreen := Round(RGBMAX * (v1 + (v2 - v1) * 6 * (2 / 3 - H)))
    else
      Result.rgbtGreen := Round(RGBMAX * v1);

    // Blue
    if (H < 1/3) or (H = 1) then
      Result.rgbtBlue := Round(RGBMAX * v1)
    else
    begin
      if (H < 1 / 2) then
        Result.rgbtBlue := Round(RGBMAX * (v1 + (v2 - v1) * (6 * H - 2)))
      else if (H < 5 / 6) then
        Result.rgbtBlue := Round(RGBMAX * v2)
      else
        Result.rgbtBlue := Round(RGBMAX * (v1 + (v2 - v1) * (6 - 6 * H)));
    end;
  end;
end;

function HSLInRGBMAXToRGB(const Hue, Saturation, Luminance: byte): TRGBTriple;
var
  v1, v2: integer;
begin
  if (Saturation = 0) or (Luminance = 0) or (Luminance = RGBMAX) then
  begin
    Result.rgbtRed := Luminance;
    Result.rgbtGreen := Luminance;
    Result.rgbtBlue := Luminance;
  end
  else
  begin
    if Luminance < (RGBMAX / 2) then
      v2 := Luminance * (RGBMAX + Saturation)
    else
      v2 := (RGBMAX * (Luminance + Saturation) - Saturation * Luminance);
    v1 := 2 * RGBMAX * Luminance - v2;

    // Red
    if Hue > (2 * RGBMAX / 3) then
    begin
      if Hue < (5 * RGBMAX / 6) then
        Result.rgbtRed := (2 * (v1 * RGBMAX + (v2 - v1) * (6 * Hue - 4 * RGBMAX)) + RGBMAX * RGBMAX) div (2 * RGBMAX * RGBMAX)
      else
        Result.rgbtRed := (2 * v2 + RGBMAX) div (2 * RGBMAX);
    end
    else
    begin
      if Hue < (RGBMAX / 6) then
        Result.rgbtRed := (2 * v2 + RGBMAX) div (2 * RGBMAX)
      else if Hue < (RGBMAX / 3) then
        Result.rgbtRed := (2 * (v1 * RGBMAX + (v2 - v1) * (2 * RGBMAX - 6 * Hue)) + RGBMAX * RGBMAX) div (2 * RGBMAX * RGBMAX)
      else
        Result.rgbtRed := (2 * v1 + RGBMAX) div (2 * RGBMAX);
    end;

    // Green
    if Hue < (RGBMAX / 6) then
      Result.rgbtGreen := (2 * (v1 * RGBMAX + (v2 - v1) * 6 * Hue) + RGBMAX * RGBMAX) div (2 * RGBMAX * RGBMAX)
    else if Hue < (RGBMAX / 2) then
      Result.rgbtGreen := (2 * v2 + RGBMAX) div (2 * RGBMAX)
    else if Hue < (2 * RGBMAX / 3) then
      Result.rgbtGreen := (2 * (v1 * RGBMAX + (v2 - v1) * (4 * RGBMAX - 6 * Hue)) + RGBMAX * RGBMAX) div (2 * RGBMAX * RGBMAX)
    else
      Result.rgbtGreen := (2 * v1 + RGBMAX) div (2 * RGBMAX);

    // Blue
    if (Hue < (RGBMAX / 3)) or (Hue = RGBMAX) then
      Result.rgbtBlue := (2 * v1 + RGBMAX) div (2 * RGBMAX)
    else
    begin
      if Hue < (RGBMAX / 2) then
        Result.rgbtBlue := (2 * (v1 * RGBMAX + (v2 - v1) * (6 * Hue - 2 * RGBMAX)) + RGBMAX * RGBMAX) div (2 * RGBMAX * RGBMAX)
      else if Hue < (5 * RGBMAX / 6) then
        Result.rgbtBlue := (2 * v2 + RGBMAX) div (2 * RGBMAX)
      else
        Result.rgbtBlue := (2 * (v1 * RGBMAX + (v2 - v1) * (6 * RGBMAX - 6 * Hue)) + RGBMAX * RGBMAX) div (2 * RGBMAX * RGBMAX);
    end;
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//
//  RGB <-> HSV
//
////////////////////////////////////////////////////////////////////////////////

(*******************************************************************************
  RGB -> HSV
  ==========

  Original:
  ---------
    var_R = ( R / 255 )                     //RGB values = 0 ÷ 255
    var_G = ( G / 255 )
    var_B = ( B / 255 )

    var_Min = min( var_R, var_G, var_B )    //Min. value of RGB
    var_Max = max( var_R, var_G, var_B )    //Max. value of RGB
    del_Max = var_Max - var_Min             //Delta RGB value

    V = var_Max

    if ( del_Max == 0 )                     //This is a gray, no chroma...
    {
      H = 0                                 //HSV results = 0 ÷ 1
      S = 0
    }
    else                                    //Chromatic data...
    {
      S = del_Max / var_Max

      del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
      del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
      del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

      if ( var_R == var_Max )
        H = del_B - del_G
      else if ( var_G == var_Max )
        H = ( 1 / 3 ) + del_R - del_B
      else if ( var_B == var_Max )
        H = ( 2 / 3 ) + del_G - del_R

      if ( H < 0 ) ; H += 1
      if ( H > 1 ) ; H -= 1
    }

    Steps used to 'optimize':
    -------------------------
      - This function is the exact same as RGB->HSL except for S and V
*******************************************************************************)
function RGBToHSV(const RGB: TRGBTriple): THSVTriple;
var
  R, G, B, Mini, Maxi, Delta: Double;
begin
  if (RGB.rgbtRed = RGB.rgbtGreen) and (RGB.rgbtGreen = RGB.rgbtBlue) then
  begin
    Result.hsvtHue := 0;
    Result.hsvtSaturation := 0;
    Result.hsvtValue := ((2 * SLVMAX) * RGB.rgbtGreen + RGBMAX) div (2 * RGBMAX);
  end
  else
  begin
    R := RGB.rgbtRed / RGBMAX;
    G := RGB.rgbtGreen / RGBMAX;
    B := RGB.rgbtBlue / RGBMAX;
    Maxi := Math.Max(Math.Max(R, G), B);
    Mini := Math.Min(Math.Min(R, G), B);
    Delta := Maxi - Mini;

    Result.hsvtValue := Round(SLVMAX * Maxi);

    Result.hsvtSaturation := Round(SLVMAX * Delta / Maxi);

    if R = Maxi then
      Result.hsvtHue := Round(HMAX * (G - B) / (6 * Delta))
    else if G = Maxi then
      Result.hsvtHue := Round((HMAX / 3) + HMAX * (B - R) / (6 * Delta))
    else
      Result.hsvtHue := Round((2 * HMAX / 3) + HMAX * (R - G) / (6 * Delta));

    if Result.hsvtHue < 0 then
      Result.hsvtHue := Result.hsvtHue + HMAX
    else if Result.hsvtHue > HMAX then
      Result.hsvtHue := Result.hsvtHue - HMAX;
  end;
end;

(*******************************************************************************
  HSV -> RGB
  ==========

  Original:
  ---------
    if ( S == 0 )                       //HSV values = 0 ÷ 1
    {
      R = V * 255
      G = V * 255
      B = V * 255
    }
    else
    {
      var_h = H * 6
      var_i = int( var_h )             //Or ... var_i = floor( var_h )
      var_1 = V * ( 1 - S )
      var_2 = V * ( 1 - S * ( var_h - var_i ) )
      var_3 = V * ( 1 - S * ( 1 - ( var_h - var_i ) ) )

      if ( var_i == 0 ) {
        var_r = V
        var_g = var_3
        var_b = var_1
      } else if ( var_i == 1 ) {
        var_r = var_2
        var_g = V
        var_b = var_1
      } else if ( var_i == 2 ) {
        var_r = var_1
        var_g = V
        var_b = var_3
      } else if ( var_i == 3 ) {
        var_r = var_1
        var_g = var_2
        var_b = V
      } else if ( var_i == 4 ) {
        var_r = var_3
        var_g = var_1
        var_b = V
      } else {
        var_r = V
        var_g = var_1
        var_b = var_2
      }

      R = var_r * 255                  //RGB results = 0 ÷ 255
      G = var_g * 255
      B = var_b * 255
    }

   (...view HSVToRGB.pas)
*******************************************************************************)
function HSVToRGB(const HSV: THSVTriple): TRGBTriple;
var
  H, S, V, vH: Double;
  vI: integer;
begin
  if (HSV.hsvtSaturation = 0) or (HSV.hsvtValue = 0) then
  begin
    Result.rgbtRed := ((2 * RGBMAX) * HSV.hsvtValue + SLVMAX) div (2 * SLVMAX);
    Result.rgbtGreen := Result.rgbtRed;
    Result.rgbtBlue := Result.rgbtRed;
  end
  else
  begin
    H := HSV.hsvtHue / HMAX;
    S := HSV.hsvtSaturation / SLVMAX;
    V := HSV.hsvtValue / SLVMAX;

    vH := 6 * H;
    vI := Floor(vH);

    if (vI > 2) then
    begin
      if (vI = 3) then
      begin
        Result.rgbtRed := Round(RGBMAX * (V * (1 - S)));
        Result.rgbtGreen := Round(RGBMAX * (V * (1 - S * (vH - 3))));
        Result.rgbtBlue := Round(RGBMAX * V);
      end
      else if (vI = 4) then
      begin
        Result.rgbtRed := Round(RGBMAX * (V * (1 - S * (5 - vH))));
        Result.rgbtGreen := Round(RGBMAX * (V * (1 - S)));
        Result.rgbtBlue := Round(RGBMAX * V);
      end
      else // vI = 5
      begin
        Result.rgbtRed := Round(RGBMAX * V);
        Result.rgbtGreen := Round(RGBMAX * (V * (1 - S)));
        Result.rgbtBlue := Round(RGBMAX * (V * (1 - S * (vH - 5))));
      end;
    end
    else
    begin
      if (vI = 0) then
      begin
        Result.rgbtRed := Round(RGBMAX * V);
        Result.rgbtGreen := Round(RGBMAX * (V * (1 - S * (1 - vH))));
        Result.rgbtBlue := Round(RGBMAX * (V * (1 - S)));
      end
      else if (vI = 1) then
      begin
        Result.rgbtRed := Round(RGBMAX * (V * (1 - S * (vH - 1))));
        Result.rgbtGreen := Round(RGBMAX * V);
        Result.rgbtBlue := Round(RGBMAX * (V * (1 - S)));
      end
      else // vI = 2
      begin
        Result.rgbtRed := Round(RGBMAX * (V * (1 - S)));
        Result.rgbtGreen := Round(RGBMAX * V);
        Result.rgbtBlue := Round(RGBMAX * (V * (1 - S * (3 - vH))));
      end;
    end;
  end;
end;

function HSVInRGBMAXToRGB(const Hue, Saturation, Value: byte): TRGBTriple;
var
  HSV: THSVTriple;
begin
  HSV.hsVtHue := Hue * HMAX div RGBMAX;
  HSV.hsVtSaturation := Saturation * SLVMAX div RGBMAX;
  HSV.hsvtValue := Value * SLVMAX div RGBMAX;
  Result := HSVToRGB(HSV);
end;


////////////////////////////////////////////////////////////////////////////////
//
//  HSV <-> HSL
//
////////////////////////////////////////////////////////////////////////////////

(*******************************************************************************
  HSV -> HSL
  ==========

  Simplifies HSV -> RGB -> HSL with HSL.H = HSV.H

  From RGB -> HSL
  ---------------
    del_Max = var_Max - var_Min
    L = ( var_Max + var_Min ) / 2
    if ( L < 0.5 )
      S = del_Max / ( var_Max + var_Min )
    else
      S = del_Max / ( 2 - var_Max - var_Min )

    ==> Need to find Max and Min from HSV -> RGB

  From HSV -> RGB
  ---------------
    - S = 0 or V = 0
      Maxi = Mini = V * RGBMAX
    Variables returned are V, var_1 and (var_2 or var_3)
      - var_1 = V * ( 1 - S )
      - var_2 = V * ( 1 - S * ( var_h - var_i ) )
      - var_3 = V * ( 1 - S * ( 1 - ( var_h - var_i ) ) )
    - S > 0
      -S < 0
      1 - S < 1
      V * (1 - S) < V
      var_1 < V

    - 0 <= (var_h - var_i) < 1
        var_h - var_i < 1
        1 - (var_h - var_i) > 0
        S * (1 - (var_h - var_i)) > 0
        1 - S * (1 - (var_h - var_i)) < 1
        V * (1 - S * (1 - (var_h - var_i))) < V
        var_3 < V

        var_h - var_i >= 0
        1 - (var_h - var_i) <= 1
        S * (1 - (var_h - var_i)) <= S
        1 - S * (1 - (var_h - var_i)) >= 1 - S
        V * (1 - S * (1 - (var_h - var_i))) >= V * (1 - S)
        var_3 >= var_1

        var_h - var_i < 1
        S * (var_h - var_i) < S
        1 - S * (var_h - var_i) > 1 - S
        V * (1 - 2 * (var_h - var_i)) > V * (1 - S)
        var_2 > var_1

        var_h - var_i >= 0
        S * (var_h - var_i) >= 0
        1 - S * (var_h - var_i) <= 1
        V * (1 - 2 * (var_h - var_i)) <= V
        var_2 <= V

      For any vH:
        - var_1 < var_2 <= V
        - var_1 <= var_3 < V
      => Maxi = V and Mini = V * (1 - S) (= var_1)
        Delta := V * S; (= V - V * (1 - S))
        Add := V * (2 - S); (= V + V * (1 - S))

*******************************************************************************)
function HSVToHSL(const HSV: THSVTriple): THSLTriple;
var
  Delta, Add: Double;
begin
  Result.hsltHue := HSV.hsvtHue;

  if (HSV.hsvtSaturation = 0) or (HSV.hsvtValue = 0) then
  begin
    Result.hsltSaturation := 0;
    Result.hsltLuminance := HSV.hsvtValue;
  end
  else
  begin
    Delta := (HSV.hsvtValue * HSV.hsvtSaturation) / (SLVMAX * SLVMAX);
    Add := HSV.hsvtValue * (2 * SLVMAX - HSV.hsvtSaturation) / (SLVMAX * SLVMAX);

    Result.hsltLuminance := Round(Add * SLVMAX / 2);
    if (Add < 1) then
      Result.hsltSaturation := Round(SLVMAX * Delta / Add)
    else
      Result.hsltSaturation := Round(SLVMAX * Delta / (2 - Add));
  end;
end;

(*******************************************************************************
  HSL -> HSV
  ==========

  Simplifies HSL -> RGB -> HSV with HSV.H = HSL.H

  From RGB -> HSV
  ---------------
    del_Max = var_Max - var_Min
    V = var_Max
    S = del_Max / var_Max

    ==> Need to find Max and Min from HSL -> RGB

  From HSL -> RGB
  ---------------
    - S = 0 or L = 0 or L = 1
      Maxi = Mini = L

    - Variables returned
        v1, v2, v1 + ( v2 - v1 ) * 6 * vH, or v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6

        if L < 1/2 then
          - v2 := L * ( 1 + S )
            S > 0
            1 + S > 1
            L * (1 + S) > L

          - v1 := L * (1 - S) (= 2 * L - L - S * L)
            S > 0
            1 - S < 1
            L * (1 - S) < L

            v2 > L > v1
        else
          - v2 :=  L + S * (1 - L);
            L <= 1
            1 - L >= 0
            S * (1 - L) >= 0
            L + S * (1 - L) >= L

          - v1 := L - S * (1 - L) (= 2 * L - L - S * (1 - L))
            L <= 1
            1 - L >= 0
            S * (1 - L) >= 0
            L - S * (1 - L) <= L

            v2 >= L >= v1

        v2 - v1 >= 0

        if (vH < 1/6) then
          result := v1 + (v2 - v1) * 6 * vH
            - vH < 1/6
              vH * 6 < 1
              (v2 - v1) * 6 * vH < v2 - v1
              v1 + (v2 - v1) * 6 * vH < v2

            - vH >= 0
              vH * 6 >= 0
              (v2 - v1) * 6 * vH >= 0
              v1 + (v2 - v1) * 6 * vH >= v1

        if (vH < 2/3) then
          result := v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6
            - vH < 2/3
              2/3 - vH > 0
              (v2 - v1) * (2/3 - vH) * 6 > 0
              v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 > v1

            - vH >= 1/2
              -vH <= -1/2
              2/3 - vH <= 1/6 (= 2/3 - 1/2)
              (2/3 - vH) * 6 <= 1
              (v2 - v1) * (2/3 - vH) * 6 <= v2 - v1
              v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 <= v2

        To have v2 in the results
          - 1/6 <= H < 2/3
          - 1/6 <= H + 1/3 < 2/3 -> -1/6 <= H <= 1/2 -> 0 <= H <= 1/2 and 5/6 <= H <= 1
          - 1/6 <= H - 1/3 < 2/3 -> 1/2 <= H < 1
        -> v2 always included

        To have v1 in the results
          - 2/3 <= H < 1
          - 2/3 <= H + 1/3 < 1 -> 1/3 <= H < 2/3
          - 2/3 <= H - 1/3 < 1 -> 0 (= 1) <= H < 1/3 (= 4/3)
        -> v1 always included

    => Maxi := v2; Mini := v1;

*******************************************************************************)
function HSLToHSV(const HSL: THSLTriple): THSVTriple;
var
  L, Maxi, Mini: double;
begin
  Result.hsvtHue := HSL.hsltHue;

  if (HSL.hsltSaturation = 0) or (HSL.hsltLuminance = 0) or
      (HSL.hsltLuminance = SLVMAX) then
  begin
    Result.hsvtSaturation := 0;
    Result.hsvtValue := HSL.hsltLuminance;
  end
  else
  begin
    L := HSL.hsltLuminance / SLVMAX;
    if L < 1/2 then
      Maxi := L * (1 + HSL.hsltSaturation / SLVMAX)
    else
      Maxi := L + (1 - L) * HSL.hsltSaturation / SLVMAX;
    Mini := 2 * L - Maxi;

    Result.hsvtValue := Round(SLVMAX * Maxi);

    Result.hsvtSaturation := Round(SLVMAX * (Maxi - Mini) / Maxi);
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//
//  TColor <-> TRGBTriple
//
////////////////////////////////////////////////////////////////////////////////

// TColor -> TRGBTriple
function ColorToRGBTriple(const Color: TColor): TRGBTriple;
asm
  // Result.rgbtRed := Color and $FF;
  // 'and $FF' return the last byte from Color => al
  mov [edx+02],al
  // Result.rgbtGreen := (Color shr 8) and $FF;
  // 'shr 8) and $FF' right shift one byte and return the last byte from Color
  // eax is still Color => right shift one byte on eax then last byte => al
  shr eax,8
  mov [edx+$01],al
  // Result.rgbtBlue := (Color shr 16) and $FF;
  // 'shr 16) and $FF right shift two bytes an dreturn the last byte from Color
  // eax is Color right shifted by one byte => right shift one byte on eax then last byte => al
  shr eax,8
  mov [edx],al
end;

// TRGBTriple -> TColor
function RGBTripleToColor(const RGB: TRGBTriple): TColor;
begin
  Result := RGB.rgbtRed + RGB.rgbtGreen shl 8 + RGB.rgbtBlue shl 16;
end;


////////////////////////////////////////////////////////////////////////////////
//
//  Websafe
//
////////////////////////////////////////////////////////////////////////////////

// Returns the nearest Websafe Byte of a TRGBTriple Byte
//  Assumes RGBMAX = 255
function RGBByteToWebsafe(const Src: Byte): Byte;
begin
  // Result := Round(Src / 51) * 51;
  if Src < 128 then
  begin
    if Src > 76 then
      Result := 102
    else if Src > 25 then
      Result := 51
    else
      Result := 0;
  end
  else
  begin
    if Src < 179 then
      Result := 153
    else if Src < 230 then
      Result := 204
    else
      Result := 255
  end;
end;

// Returns the nearest Websafe TRGBTriple of a TRGBTriple
function RGBToWebsafe(const RGB: TRGBTriple): TRGBTriple;
begin
    Result.rgbtRed := RGBByteToWebsafe(RGB.rgbtRed);
    Result.rgbtGreen := RGBByteToWebsafe(RGB.rgbtGreen);
    Result.rgbtBlue := RGBByteToWebsafe(RGB.rgbtBlue);
end;

// Verifies if a TRGBTriple is a Websafe Color
function RGBIsWebsafe(const RGB: TRGBTriple): boolean;
begin
  Result := ((RGB.rgbtRed mod 51) = 0) and
            ((RGB.rgbtGreen mod 51) = 0) and
            ((RGB.rgbtBlue mod 51) = 0);
end;


////////////////////////////////////////////////////////////////////////////////
//
//  RGB -> String
//
////////////////////////////////////////////////////////////////////////////////

// Converts a TRGBTriple to an Hexa string
function RGBToHexa(const RGB: TRGBTriple): string;
begin
  Result := UpperCase(Format('%.2x%.2x%.2x', [RGB.rgbtRed, RGB.rgbtGreen, RGB.rgbtBlue]));
end;

// Converts an hexa string to an integer
function HexToInt(s: string): integer;
var
  i, t, u, len: integer;
begin
  // Makes sure s is not empty
  len := Length(s);
  if len <> 0 then
  begin
    t := 0;
    i := 1;
    while (i <= len) and (t >= 0) do
    begin
      case s[i] of
        '0'..'9': u := Ord(s[i]) - Ord('0');
        'A'..'F': u := Ord(s[i]) - Ord('A') + 10;
        'a'..'f': u := Ord(s[i]) - Ord('a') + 10;
        else
          u := -1;
      end;
      if u >= 0 then
        t := t * 16 + u
      else
        t := -1;
      Inc(i);
    end;
    Result := t;
  end
  else
    Result := -1;
end;

// Converts an Hexa string to a TRGBTriple
//  (nil on error)
function HexaToRGB(const Hexa: string): TRGBTriple;
var
  R, G, B: integer;
begin
  Result.rgbtRed := 0;
  Result.rgbtGreen := 0;
  Result.rgbtBlue := 0;

  // String must be 6 chars long
  if Length(Hexa) = 6 then
  begin
    // String is 'RRGGBB'
    R := HexToInt(Copy(Hexa, 1, 2));
    if R >= 0 then
    begin
      G := HexToInt(Copy(Hexa, 3, 2));
      if G >= 0 then
      begin
        B := HexToInt(Copy(Hexa, 5, 2));
        if B >= 0 then
        begin
          Result.rgbtRed := R;
          Result.rgbtGreen := G;
          Result.rgbtBlue := B;
        end;
      end;
    end;
  end;
end;

// Converts a TRGBTriple to an HTML value string
function RGBToHTML(const RGB: TRGBTriple): string;
begin
  Result := '#' + RGBToHexa(RGB);
end;

// Converts a TRGBTriple to a Delphi value string
function RGBToDelphiHEX(const RGB: TRGBTriple): string;
begin
  Result := UpperCase(Format('$00%.2x%.2x%.2x', [RGB.rgbtBlue, RGB.rgbtGreen, RGB.rgbtRed]));
end;

// Converts a TRGBTriple to a VB value string
function RGBToVBHEX(const RGB: TRGBTriple): string;
begin
  Result := '&h' + RGBToHexa(RGB);
end;

// Converts a TRGBTriple to a C++ value string
function RGBToCppHEX(const RGB: TRGBTriple): string;
begin
  Result := '0x00' + RGBToHexa(RGB);
end;

// Converts a TRGBTriple to a C# color representation
function RGBToCSharp(const RGB: TRGBTriple): string;
begin
  case RGBTripleToColor(RGB) of
    clWebSnow:            Result := 'Color.Snow';
    clWebFloralWhite:     Result := 'Color.FloralWhite';
    clWebLavenderBlush:   Result := 'Color.LavenderBlush';
    clWebOldLace:         Result := 'Color.OldLace';
    clWebIvory:           Result := 'Color.Ivory';
    clWebCornSilk:        Result := 'Color.CornSilk';
    clWebBeige:           Result := 'Color.Beige';
    clWebAntiqueWhite:    Result := 'Color.AntiqueWhite';
    clWebWheat:           Result := 'Color.Wheat';
    clWebAliceBlue:       Result := 'Color.AliceBlue';
    clWebGhostWhite:      Result := 'Color.GhostWhite';
    clWebLavender:        Result := 'Color.Lavender';
    clWebSeashell:        Result := 'Color.Seashell';
    clWebLightYellow:     Result := 'Color.LightYellow';
    clWebPapayaWhip:      Result := 'Color.PapayaWhip';
    clWebNavajoWhite:     Result := 'Color.NavajoWhite';
    clWebMoccasin:        Result := 'Color.Moccasin';
    clWebBurlywood:       Result := 'Color.BurlyWood';
    clWebAzure:           Result := 'Color.Azure';
    clWebMintcream:       Result := 'Color.MintCream';
    clWebHoneydew:        Result := 'Color.Honeydew';
    clWebLinen:           Result := 'Color.Linen';
    clWebLemonChiffon:    Result := 'Color.LemonChiffon';
    clWebBlanchedAlmond:  Result := 'Color.BlanchedAlmond';
    clWebBisque:          Result := 'Color.Bisque';
    clWebPeachPuff:       Result := 'Color.PeachPuff';
    clWebTan:             Result := 'Color.Tan';
    clWebYellow:          Result := 'Color.Yellow';
    clWebDarkOrange:      Result := 'Color.DarkOrange';
    clWebRed:             Result := 'Color.Red';
    clWebDarkRed:         Result := 'Color.DarkRed';
    clWebMaroon:          Result := 'Color.Maroon';
    clWebIndianRed:       Result := 'Color.IndianRed';
    clWebSalmon:          Result := 'Color.Salmon';
    clWebCoral:           Result := 'Color.Coral';
    clWebGold:            Result := 'Color.Gold';
    clWebTomato:          Result := 'Color.Tomato';
    clWebCrimson:         Result := 'Color.Crimson';
    clWebBrown:           Result := 'Color.Brown:';
    clWebChocolate:       Result := 'Color.Chocolate';
    clWebSandyBrown:      Result := 'Color.SandyBrown';
    clWebLightSalmon:     Result := 'Color.LightSalmon';
    clWebLightCoral:      Result := 'Color.LightCoral';
    clWebOrange:          Result := 'Color.Orange';
    clWebOrangeRed:       Result := 'Color.OrangeRed';
    clWebFirebrick:       Result := 'Color.Firebrick';
    clWebSaddleBrown:     Result := 'Color.SaddleBrown';
    clWebSienna:          Result := 'Color.Sienna';
    clWebPeru:            Result := 'Color.Peru';
    clWebDarkSalmon:      Result := 'Color.DarkSalmon';
    clWebRosyBrown:       Result := 'Color.RosyBrown';
    clWebPaleGoldenrod:   Result := 'Color.PaleGoldenrod';
    clWebLightGoldenrodYellow: Result := 'Color.LightGoldenrodYellow';
    clWebOlive:           Result := 'Color.Olive';
    clWebForestGreen:     Result := 'Color.ForestGreen';
    clWebGreenYellow:     Result := 'Color.GreenYellow';
    clWebChartreuse:      Result := 'Color.Chartreuse';
    clWebLightGreen:      Result := 'Color.LightGreen';
    clWebAquamarine:      Result := 'Color.Aquamarine';
    clWebSeaGreen:        Result := 'Color.SeaGreen';
    clWebGoldenRod:       Result := 'Color.GoldenRod';
    clWebKhaki:           Result := 'Color.Khaki';
    clWebOliveDrab:       Result := 'Color.OliveDrab';
    clWebGreen:           Result := 'Color.Green';
    clWebYellowGreen:     Result := 'Color.YellowGreen';
    clWebLawnGreen:       Result := 'Color.LawnGreen';
    clWebPaleGreen:       Result := 'Color.PaleGreen';
    clWebMediumAquamarine: Result := 'Color.MediumAquamarine';
    clWebMediumSeaGreen:  Result := 'Color.MediumSeaGreen';
    clWebDarkGoldenRod:   Result := 'Color.DarkGoldenRod';
    clWebDarkKhaki:       Result := 'Color.DarkKhaki';
    clWebDarkOliveGreen:  Result := 'Color.DarkOliveGreen';
    clWebDarkgreen:       Result := 'Color.Darkgreen';
    clWebLimeGreen:       Result := 'Color.LimeGreen';
    clWebLime:            Result := 'Color.Lime';
    clWebSpringGreen:     Result := 'Color.SpringGreen';
    clWebMediumSpringGreen: Result := 'Color.MediumSpringGreen';
    clWebDarkSeaGreen:    Result := 'Color.DarkSeaGreen';
    clWebLightSeaGreen:   Result := 'Color.LightSeaGreen';
    clWebPaleTurquoise:   Result := 'Color.PaleTurquoise';
    clWebLightCyan:       Result := 'Color.LightCyan';
    clWebLightBlue:       Result := 'Color.LightBlue';
    clWebLightSkyBlue:    Result := 'Color.LightSkyBlue';
    clWebCornFlowerBlue:  Result := 'Color.CornFlowerBlue';
    clWebDarkBlue:        Result := 'Color.DarkBlue';
    clWebIndigo:          Result := 'Color.Indigo';
    clWebMediumTurquoise: Result := 'Color.MediumTurquoise';
    clWebTurquoise:       Result := 'Color.Turquoise';
    clWebCyan:            Result := 'Color.Cyan'; //   clWebCyan = clWebAqua
    clWebPowderBlue:      Result := 'Color.PowderBlue';
    clWebSkyBlue:         Result := 'Color.SkyBlue';
    clWebRoyalBlue:       Result := 'Color.RoyalBlue';
    clWebMediumBlue:      Result := 'Color.MediumBlue';
    clWebMidnightBlue:    Result := 'Color.MidnightBlue';
    clWebDarkTurquoise:   Result := 'Color.DarkTurquoise';
    clWebCadetBlue:       Result := 'Color.CadetBlue';
    clWebDarkCyan:        Result := 'Color.DarkCyan';
    clWebTeal:            Result := 'Color.Teal';
    clWebDeepskyBlue:     Result := 'Color.DeepskyBlue';
    clWebDodgerBlue:      Result := 'Color.DodgerBlue';
    clWebBlue:            Result := 'Color.Blue';
    clWebNavy:            Result := 'Color.Navy';
    clWebDarkViolet:      Result := 'Color.DarkViolet';
    clWebDarkOrchid:      Result := 'Color.DarkOrchid';
    clWebMagenta:         Result := 'Color.Magenta'; //   clWebMagenta = clWebFuchsia
    clWebDarkMagenta:     Result := 'Color.DarkMagenta';
    clWebMediumVioletRed: Result := 'Color.MediumVioletRed';
    clWebPaleVioletRed:   Result := 'Color.PaleVioletRed';
    clWebBlueViolet:      Result := 'Color.BlueViolet';
    clWebMediumOrchid:    Result := 'Color.MediumOrchid';
    clWebMediumPurple:    Result := 'Color.MediumPurple';
    clWebPurple:          Result := 'Color.Purple';
    clWebDeepPink:        Result := 'Color.DeepPink';
    clWebLightPink:       Result := 'Color.LightPink';
    clWebViolet:          Result := 'Color.Violet';
    clWebOrchid:          Result := 'Color.Orchid';
    clWebPlum:            Result := 'Color.Plum';
    clWebThistle:         Result := 'Color.Thistle';
    clWebHotPink:         Result := 'Color.HotPink';
    clWebPink:            Result := 'Color.Pink';
    clWebLightSteelBlue:  Result := 'Color.LightSteelBlue';
    clWebMediumSlateBlue: Result := 'Color.MediumSlateBlue';
    clWebLightSlateGray:  Result := 'Color.LightSlateGray';
    clWebWhite:           Result := 'Color.White';
    clWebLightgrey:       Result := 'Color.Lightgrey';
    clWebGray:            Result := 'Color.Gray';
    clWebSteelBlue:       Result := 'Color.SteelBlue';
    clWebSlateBlue:       Result := 'Color.SlateBlue';
    clWebSlateGray:       Result := 'Color.SlateGray';
    clWebWhiteSmoke:      Result := 'Color.WhiteSmoke';
    clWebSilver:          Result := 'Color.Silver';
    clWebDimGray:         Result := 'Color.DimGray';
    clWebMistyRose:       Result := 'Color.MistyRose';
    clWebDarkSlateBlue:   Result := 'Color.DarkSlateBlue';
    clWebDarkSlategray:   Result := 'Color.DarkSlategray';
    clWebGainsboro:       Result := 'Color.Gainsboro';
    clWebDarkGray:        Result := 'Color.DarkGray';
    clWebBlack:           Result := 'Color.Black';
    else
      Result := 'Color.FromArgb(' + IntToStr(RGB.rgbtRed) + ',' +
                  IntToStr(RGB.rgbtGreen) + ',' + IntToStr(RGB.rgbtBlue) + ')';
  end;
end;

function GradientFill; external msimg32 name 'GradientFill';

end.
