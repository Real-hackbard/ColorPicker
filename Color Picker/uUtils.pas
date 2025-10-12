{
    uUtils

    Misc. procedures and functions.

}
unit uUtils;

interface

uses Windows, Classes, SysUtils, Graphics, Math, ShellAPI, uColorUtil, Forms,
      Controls, Registry;

const
  // Message utilisé pour le SysTray, éviter les ID bas
  // WM_USER + 1024
  WM_TRAYNOTIFY = $0400 + 1024;

  // Valeurs pour dwInfoFlags de TNotifyIconDataEx
  _NIIF_NONE    = $00000000;
  _NIIF_INFO    = $00000001;
  _NIIF_WARNING = $00000002;
  _NIIF_ERROR   = $00000003;
  _NIF_INFO     = $00000010;

type
  // Nouvelle structure pour Windows Me, 2000 et XP
  TNotifyIconDataEx = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    uTimeout: UINT;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  end;

  // Informations de version
  TLangAndCP = record
    wLanguage : word;
    wCodePage : word;
  end;
  PLangAndCP = ^TLangAndCP;

  // Fonction retournant une taille de fichier ajustée
  function BytesToStr(Value: Int64; ByteStr: string; const Max: integer = 1024): string;

  // Fonction de transformation d'un triplet RGB en chaine
  function FormatRGB(const RGB: TRGBTriple; format: string): string;

  // Procédure d'anti-aliasing d'un bitmap
  procedure AntiAliasRect(Dest: TBitmap; Rect: TRect);

  // Procédure de récupération des informations de version
  procedure GetVersionInfo(Filename: string; List: TStringList);

  // Procédure de dessin du curseur écran dans un bitmap
  procedure DrawCursor(ScreenShotBitmap : TBitmap);

  // Fonction de chargement du curseur main de Windows
  function LoadWindowsHand: boolean;
  
implementation

// Retourne un nom de fichier avec résolution des variables d'environnement
//    Filename: nom de fichier contenant la variable à résoudre
function ExpandEnv(s: string): string;
var
  Res: Cardinal;
  Name: PChar;
begin
  // Alloue la mémoire
  GetMem(Name, MAX_PATH);
  // Appel de la fonction de résolution de variables
  Res := ExpandEnvironmentStrings(PChar(s), Name, MAX_PATH);
  // Si la mémoire allouée n'est pas assez grande, le résultat est la taille
  // nécessaire devant être allouée
  if Res > MAX_PATH then
  begin
    // Réallocation de la mémoire et nouvel appel
    GetMem(Name, Res);
    ExpandEnvironmentStrings(PChar(s), Name, Res);
  end;
  Result := Name;
  // Libération de la mémoire
  FreeMem(Name);
end;


// Change le curseur 'crHandPoint' de Delphi par celui de Windows
function LoadWindowsHand: boolean;
var
  s: string;
  Res: HCURSOR;
begin
  // Initialise les variables
  Result := true;
  s := '';

  // Vérifie si un fichier est définit dans la base de registre
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if Openkey('\Control Panel\Cursors', false) then
    begin
      s := ExpandEnv(ReadString('Hand'));
      CloseKey;
    end;
  finally
    Free;
  end;
  // Vérifie si le fichier existe
  if (s <> '') and FileExists(s) then
    // Essaie de charger le fichier
    Res := LoadCursorFromFile(Pchar(s))
  else
    // Essaie de charger le curseur Windows par défaut
    Res := LoadCursor(0, IDC_HAND);

  // Un curseur a été chargé si Res n'est pas nul
  if Res <> 0 then
    // Remplace le curseur Delphi 'crHandPoint'
    Screen.Cursors[crHandPoint] := Res
  else
    // Aucun curseur n'a été chargé
    Result := false;
end;

// Procédure de dessin du curseur écran dans un bitmap
//	Ne gère pas l'ombrage
procedure DrawCursor(ScreenShotBitmap : TBitmap);
var
  r: TRect;
  CI: TCursorInfo;
  Icon: TIcon;
  II: TIconInfo;
begin
  r := ScreenShotBitmap.Canvas.ClipRect;
  Icon := TIcon.Create;
  try
    CI.cbSize := SizeOf(CI);
    if GetCursorInfo(CI) then
      if CI.Flags = CURSOR_SHOWING then
      begin
        Icon.Handle := CopyIcon(CI.hCursor);
        if GetIconInfo(Icon.Handle, II) then
        begin
          ScreenShotBitmap.Canvas.Draw(
                ci.ptScreenPos.x - Integer(II.xHotspot) - r.Left,
                ci.ptScreenPos.y - Integer(II.yHotspot) - r.Top,
                Icon
                );
        end;
      end;
  finally
    Icon.Free;
  end;
end;

// Fonction de transformation d'un triplet RGB en chaine
// Formats utilises
//  - \\: affiche un '\'
//  - \x: affiche un 'x'
//  - \r, \g, \b: valeur R, G ou B de 0 à 255
//  - \R, \G ou \B: valeur R,G ou B de 000 à 255
//  - \rx, \gx, \bx: valeur R, G ou B de 0 à FF
//  - \Rx, \Gx ou \Bx: valeur R, G ou B de 00 à FF
function FormatRGB(const RGB: TRGBTriple; format: string): string;
var
  s: string;
  i: integer;
begin
  s := '';
  i := 1;
  // Parcours de la chaine
  while (i <= Length(format)) do
  begin
    if (format[i] = '\') then
    begin
      if(format[i+1] = '\') then
      begin
        s := s + '\';
        inc(i);
      end
      else if(format[i+1] = 'x') then
      begin
        s := s + 'x';
        Inc(i);
      end
      else if (format[i+1] = 'r') then
      begin
        if (format[i+2] = 'x') then
        begin
          s := s + IntToHex(RGB.rgbtRed, 1);
          i := i + 2;
        end
        else
        begin
          s := s + IntToStr(RGB.rgbtRed);
          Inc(i);
        end;
      end
      else if (format[i+1] = 'g') then
      begin
        if (format[i+2] = 'x') then
        begin
          s := s + IntToHex(RGB.rgbtGreen, 1);
          i := i + 2;
        end
        else
        begin
          s := s + IntToStr(RGB.rgbtGreen);
          Inc(i);
        end;
      end
      else if (format[i+1] = 'b') then
      begin
        if (format[i+2] = 'x') then
        begin
          s := s + IntToHex(RGB.rgbtBlue, 1);
          i := i + 2;
        end
        else
        begin
          s := s + IntToStr(RGB.rgbtBlue);
          Inc(i);
        end;
      end
      else if (format[i+1] = 'R') then
      begin
        if (format[i+2] = 'x') then
        begin
          s := s + IntToHex(RGB.rgbtRed, 2);
          i := i + 2;
        end
        else
        begin
          if (RGB.rgbtRed < 10) then
            s := s + '0';
          if (RGB.rgbtRed < 100) then
            s := s + '0';
          s := s + IntToStr(RGB.rgbtRed);
          Inc(i);
        end;
      end
      else if (format[i+1] = 'G') then
      begin
        if (format[i+2] = 'x') then
        begin
          s := s + IntToHex(RGB.rgbtGreen, 2);
          i := i + 2;
        end
        else
        begin
          if (RGB.rgbtGreen < 10) then
            s := s + '0';
          if (RGB.rgbtGreen < 100) then
            s := s + '0';
          s := s + IntToStr(RGB.rgbtGreen);
          Inc(i);
        end;
      end
      else if (format[i+1] = 'B') then
      begin
        if (format[i+2] = 'x') then
        begin
          s := s + IntToHex(RGB.rgbtBlue, 2);
          i := i + 2;
        end
        else
        begin
          if (RGB.rgbtBlue < 10) then
            s := s + '0';
          if (RGB.rgbtBlue < 100) then
            s := s + '0';
          s := s + IntToStr(RGB.rgbtBlue);
          Inc(i);
        end;
      end;
    end
    else
      s := s + format[i];
    Inc(i);
  end;

  Result := s;
end;

// Fonction retournant une taille de fichier ajustée
function BytesToStr(Value: Int64; ByteStr: string; const Max: integer = 1024): string;
var
	sUnit : string;
	dSize : double;
begin
	dSize := Value;
	if dSize > Max then
	begin
		dSize := dSize / 1024;
		sUnit := 'K' + ByteStr;
		if dSize > Max then
		begin
			dSize := dSize / 1024;
			sUnit := 'M' + ByteStr;
		end;
		if dSize > Max then
		begin
			dSize := dSize / 1024;
			sUnit := 'G' + ByteStr;
		end;
		Result := Format('%3.2f %s', [ dSize, sUnit ]);
	end
	else
		Result := IntToStr(Value) + ' ' + ByteStr;
end;

// Procédure d'antialiasing d'un bitmap
procedure AntiAliasRect(Dest: TBitmap; Rect: TRect);
var
  rDest: TRect;
  x, y: integer;
  p0 ,p1 ,p2: PByteArray;
begin
  if not IsRectEmpty(Rect) then
  begin
    // Définit un rectangle contenu dans Dest avec une marge de 1 pixel
    rDest.Left := Max(1, Rect.Left);
    rDest.Top := Max(1, Rect.Top);
    rDest.Right := Min(Dest.Width - 2, Rect.Right);
    rDest.Bottom := Min(Dest.Height - 2, Rect.Bottom);

    // Assure que Dest peut être traité
    Dest.PixelFormat := pf24bit;

    // Traitement
    for y := rDest.Top to rDest.Bottom do
    begin
      p0 := Dest.ScanLine[y - 1];
      p1 := Dest.ScanLine[y];
      P2 := Dest.ScanLine[y + 1];
      for x := rDest.Left to rDest.Right do
      begin
        p1[x*3] := (p0[x*3] + p2[x*3] + p1[(x-1)*3] + p1[(x+1)*3]) div 4;
        p1[x*3+1] := (p0[x*3+1] + p2[x*3+1] + p1[(x-1)*3+1] + p1[(x+1)*3+1]) div 4;
        p1[x*3+2] := (p0[x*3+2] + p2[x*3+2] + p1[(x-1)*3+2] + p1[(x+1)*3+2]) div 4;
      end;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Version informations
////////////////////////////////////////////////////////////////////////////////
procedure DecodeVersionInfo(pInfo : pointer; VersionStrings: TStringList);
var
	pItem : pointer;
	itemLen : UInt;
	FixedFileInfo : PVSFixedFileInfo;
	VersionSection : string;
	s : string;
	Lang : PLangAndCP;

  procedure AddExtVer(StrName, StrValue : string);
  begin
    VersionStrings.Add(StrName+'='+StrValue);
  end;

begin
	if VerQueryValue(pInfo, '\', Pointer(FixedFileInfo), itemLen) then
  begin
    // File Version
		s := IntToStr(HIWORD(FixedFileInfo^.dwFileVersionMS)) +
			'.' + IntToStr(LOWORD(FixedFileInfo^.dwFileVersionMS)) +
			'.' +	IntToStr(HIWORD(FixedFileInfo^.dwFileVersionLS)) +
			'.' + IntToStr(LOWORD(FixedFileInfo^.dwFileVersionLS));

    // This will make it compatible with all other Version programs and fit
    // into Microsoft's standard's }
    while ((copy(s, length(s), 1) = '0') or (copy(s, length(s), 1) = '.')) do
      s := copy(s, 1, length(s)-1);
    if (Pos('.', s) <= 0) then
      s := s + '.0';
    AddExtVer('FileVersion', s);

    // Product Version
		s :=  IntToStr(HIWORD(FixedFileInfo^.dwProductVersionMS)) +
			    '.' +	IntToStr(LOWORD(FixedFileInfo^.dwProductVersionMS)) +
			    '.' + IntToStr(HIWORD(FixedFileInfo^.dwProductVersionLS)) +
			    '.' + IntToStr(LOWORD(FixedFileInfo^.dwProductVersionLS));
    AddExtVer('ProductVersion', s);

    // Operating System
		case FixedFileInfo^.dwFileOS of
      VOS_DOS :           s := 'MS-DOS';
      VOS_OS216 :         s := '16-bit OS/2';
      VOS_OS232 :         s := '32-bit OS/2';
      VOS_NT :            s := 'Windows NT';
      VOS__WINDOWS16 :    s := 'Windows 3.xx';
      VOS__PM16 :         s := '16-bit OS/2 Presentation Manager';
      VOS__PM32 :         s := '32-bit OS/2 Presentation Manager';
      VOS__WINDOWS32 :    s := '32-bit Windows';
      VOS_DOS_WINDOWS16 : s := 'Windows 3.xx with MS-DOS';
      VOS_DOS_WINDOWS32 : s := '32-bit Windows with MS-DOS';
      VOS_OS216_PM16 :    s := '16-bit OS/2 with Presentation Manager';
      VOS_OS232_PM32 :    s := '32-bit OS/2 with Presentation Manager';
      VOS_NT_WINDOWS32 :  s := 'Windows NT with 32 bit Windows';
      else
        s := 'Unknown';
    end;
    AddExtVer('OperatingSystem', s);

    // File Type
		case FixedFileInfo^.dwFileType of
      VFT_APP :         s := 'Application';
      VFT_DLL :         s := 'Dynamic-Link Library';
      VFT_DRV :         s := 'Device Driver';
      VFT_FONT :        s := 'Font';
      VFT_VXD :         s := 'Virtual Device Driver';
      VFT_STATIC_LIB :  s := 'Static-Link Library';
      else
        s := 'Unknown';
    end;
    AddExtVer('FileType', s);

    // Version Strings
    VerQueryValue(
      pInfo,
      PChar('\\VarFileInfo\\Translation'),
      Pointer(Lang),
      itemLen);

    VersionSection := Format(
                        '\\StringFileInfo\\%.4x%.4x\\',
                        [Lang^.wLanguage,Lang^.wCodePage]);
                        
 		if VerQueryValue(pInfo, PChar(VersionSection + 'Comments'), pItem, itemLen) then
 			AddExtVer('Comments', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'CompanyName'), pItem, itemLen) then
 			AddExtVer('CompanyName', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'FileDescription'), pItem, itemLen) then
 			AddExtVer('FileDescription', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'InternalName'), pItem, itemLen) then
 			AddExtVer('InternalName', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'LegalCopyright'), pItem, itemLen) then
 			AddExtVer('LegalCopyright', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'LegalTradeMarks'), pItem, itemLen) then
 			AddExtVer('LegalTrademarks', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'OriginalFileName'), pItem, itemLen) then
 			AddExtVer('OriginalFilename', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'PrivateBuild'), pItem, itemLen) then
 			AddExtVer('PrivateBuild', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'ProductName'), pItem, itemLen) then
 			AddExtVer('ProductName', PChar(pItem));
 		if VerQueryValue(pInfo, PChar(VersionSection + 'SpecialBuild'), pItem, itemLen) then
 			AddExtVer('SpecialBuild', PChar(pItem));
	end;
end;

procedure GetVersionInfo(Filename: string; List: TStringList);
var
  VersionSize, VersionHandle: DWord;
  pVersionInfo : pointer;
begin
  List.Clear;
  if FileExists(Filename) then
  begin
    VersionSize := GetFileVersionInfoSize(PChar(FileName), VersionHandle);
    if VersionSize > 0 then
    begin
      GetMem(pVersionInfo, VersionSize);
      try
        if GetFileVersionInfo(
            PChar(FileName),
            VersionHandle,
            VersionSize,
            pVersionInfo) then
          DecodeVersionInfo(pVersionInfo, List);
      finally
        FreeMem(pVersionInfo, VersionSize);
      end;
    end;
  end;
end;

end.
