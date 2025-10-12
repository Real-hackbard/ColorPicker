unit uLang;

interface

uses Windows, Classes, Forms, StdCtrls, ComCtrls, SysUtils, IniFiles, Menus;

type
  TLanguages = class(TObject)
  private
    FDir: string;
    FExt: string;
    FFiles: TStringList;
    FResStr: TStringList;
    FDefaultStr: TStringList;
    procedure SetDir(Value: string);
    procedure SetExtension(Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function GetResStrCount: integer;
    function GetResStrValue(const Name: string): string; overload;
    function GetResStrValue(const Index: integer): string; overload;
    function GetResStrName(const Index: integer): string;
    function GetLanguages: boolean;
    procedure LoadLanguage(Filename: string);
    procedure GetDefault(Component: TComponent);
  published
    property DefaultStr: TStringList read FDefaultStr write FDefaultStr;
    property Directory: string read FDir write SetDir;
    property Extension: string read FExt write SetExtension;
    property Files: TStringList read FFiles;
    property ResStr: TStringList read FResStr;
    property StrCount: integer read GetResStrCount;
  end;

implementation

constructor TLanguages.Create;
begin
    inherited;
    FDefaultStr := TStringList.Create;
    FFiles := TStringList.Create;
    FResStr := TStringList.Create;
    FDir := ExtractFilePath(Application.ExeName) + 'Data\Language\';
    FExt := '.lng';
end;

destructor TLanguages.Destroy;
begin
    FResStr.Free;
    FFiles.Free;
    inherited;
end;

procedure TLanguages.SetDir(Value: string);
begin
    if (FDir <> Value) and DirectoryExists(Value) then
        FDir := Value;
end;

procedure TLanguages.SetExtension(Value: string);
begin
    // Valide extension
    if (FExt <> Value) and (Length(Value) > 1) then
    begin
        if Value[1] <> '.' then
            FExt := '.' + Value
        else
            FExt := Value;
    end;
end;


function TLanguages.GetResStrCount: integer;
begin
    Result := FResStr.Count;
end;

function TLanguages.GetResStrValue(const Name: string): string;
var
    i: integer;
begin
    if (FResStr.Count > 0) then
    begin
        i := FResStr.IndexOfName(Name);
        if i > -1 then
            Result := FResStr.Values[Name]
        else
            Result := FDefaultStr.Values[Name];
    end
    else
        Result := FDefaultStr.Values[Name];
end;

function TLanguages.GetResStrValue(const Index: integer): string;
begin
    if (FResStr.Count > 0) and (Index > -1) and (Index < FResStr.Count) then
        Result := FResStr.Values[FResStr.Names[Index]]
    else
        Result := FDefaultStr.Values[FDefaultStr.Names[Index]];
end;

function TLanguages.GetResStrName(const Index: integer): string;
begin
    if (FResStr.Count > 0) and (Index > -1) and (Index < FResStr.Count) then
        Result := FResStr.Names[Index]
    else
        Result := FDefaultStr.Names[Index];
end;

function TLanguages.GetLanguages: boolean;
var
	Search: TSearchRec;
	Resultat: integer;
    s: string;
begin
  Result := false;
  FFiles.Clear;
	Resultat := FindFirst(FDir + '*' + FExt, 1 or 2 or 4 or 32, Search);
	while Resultat = 0 do
	begin
		with TIniFile.Create(FDir + Search.Name) do
    begin
      s := ReadString('INFOS', 'FriendlyName', '');
      if s <> '' then
      begin
        FFiles.Add(s + '=' + FDir + Search.Name);
        Result := true;
      end;
      Free;
    end;
		Resultat := FindNext(Search);
	end;
	FindClose(Search);
end;

procedure TLanguages.LoadLanguage(Filename: string);

  procedure ScanComponent(Component: TComponent; LngLst: TStringList);
  var
    i: integer;
  begin
      try
          if Component.ComponentCount > 0 then
              for i := 0 to Component.ComponentCount - 1 do
                ScanComponent(Component.Components[i], LngLst);
          i := LngLst.IndexOfName(Component.Name);
          if i > -1 then
          begin
              if Component is TCustomLabel then
                (Component as TCustomLabel).Caption := LngLst.Values[Component.Name]
              else if Component is TButton then
                (Component as TButton).Caption := LngLst.Values[Component.Name]
              else if Component is TTabSheet then
                (Component as TTabSheet).Caption := LngLst.Values[Component.Name]
              else if Component is TGroupBox then
                (Component as TGroupBox).Caption := LngLst.Values[Component.Name]
              else if Component is TCheckBox then
                (Component as TCheckBox).Caption := LngLst.Values[Component.Name]
              else if Component is TMenuItem then
                (Component as TMenuItem).Caption := LngLst.Values[Component.Name];
          end;
      except
      end;
  end;

begin
    FResStr.Clear;
    if (Filename <> '') and FileExists(Filename) then
        with TIniFile.Create(Filename) do
        begin
            ReadSectionValues('STRINGS', FResStr);
            ScanComponent(Application.MainForm, FResStr);
            Free;
        end
    else
        ScanComponent(Application.MainForm, FDefaultStr);
end;

procedure TLanguages.GetDefault(Component: TComponent);
var
    i: integer;
    s: string;
begin
    if Component.ComponentCount > 0 then
        for i := 0 to Component.ComponentCount - 1 do
            GetDefault(Component.Components[i]);
    if Component is TCustomLabel then
        s := (Component as TCustomLabel).Caption
    else if Component is TButton then
        s := (Component as TButton).Caption
    else if Component is TTabSheet then
        s := (Component as TTabSheet).Caption
    else if Component is TGroupBox then
        s := (Component as TGroupBox).Caption
    else if Component is TCheckBox then
        s := (Component as TCheckBox).Caption
    else if Component is TMenuItem then
        s := (Component as TMenuItem).Caption;
    FDefaultStr.Add(Component.Name + '=' + s);
end;

end.
