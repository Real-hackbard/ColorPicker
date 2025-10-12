{
    uSnapShots

    Unités permettant de gérer une liste de captures d'écrans.

    nb: Créées pour possibles évolutions futures.

    08/05/2004
      TSnapshots.Increment: integer ajouté pour conserver le nombre total
        d'éléments ajoutés depuis sa création


}
unit uSnapshots;

interface

uses Windows, Classes, Types, Graphics, SysUtils;

// Constantes de version de fichier
const
	Tag: string[6] = 'ScrSrc';
  TagVer: string[3] = '200';

type
  // Définition d'un snapshot
  TSnapshot = class(TObject)
  private
    FName: string;
  	FBitmap: TBitmap;
    FTopLeft: TPoint;
    function GetSize: Int64;
  public
    constructor Create(AName: string; ABitmap: TBitmap; ATopLeft: TPoint);
    destructor Destroy; override;
  	property Name: string read FName write FName;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    property TopLeft: TPoint read FTopLeft write FTopLeft;
    property Size: Int64 read GetSize;
  end;

  // Définition d'une liste de snapshots
  TSnapshots = class(TList)
  protected
    FIncrement: integer;
    function GetItem(Index: Integer): TSnapshot;
    procedure SetItem(Index: Integer; Value: TSnapshot);
  public
    constructor Create;
  	destructor Destroy; override;
  	procedure Clear; override;
    function Add(Value: TSnapshot): Integer;
    procedure Delete(Index: integer);
    procedure Insert(Index: Integer; Value: TSnapshot);
    property Item[Index: Integer]: TSnapshot read GetItem write SetItem; default;
    property Increment: integer read FIncrement;
    procedure LoadFromFile(Filename: string);
    procedure SaveToFile(Filename: string);
  end;

implementation

{ TSnapshot }

constructor TSnapshot.Create(AName: string; ABitmap: TBitmap; ATopLeft: TPoint);
begin
	inherited Create;
	FName := AName;
	FBitmap := TBitmap.Create;
	FBitmap.Assign(ABitmap);
	FTopLeft := ATopLeft;
end;

destructor TSnapshot.Destroy;
begin
	FBitmap.Free;
	inherited Destroy;
end;

function TSnapshot.GetSize: Int64;
var
  sSize: TMemoryStream;
begin
  if not FBitmap.Empty then
  begin
    sSize := TMemoryStream.Create;
    FBitmap.SaveToStream(sSize);
    Result := sSize.Size;
    sSize.Free;
  end
  else
    Result := 0;
end;


{ TSnapshots }

constructor TSnapShots.Create;
begin
  inherited;
  // Initialise le compteur
  FIncrement := 0;
end;

destructor TSnapshots.Destroy;
begin
	Clear;
  inherited Destroy;
end;

procedure TSnapshots.Clear;
begin
	while Self.Count > 0 do
    Delete(0);
  inherited Clear;
end;

function TSnapshots.GetItem(Index: Integer): TSnapshot;
begin
	Result := TSnapshot(inherited Items[Index]);
end;

procedure TSnapshots.SetItem(Index: Integer; Value: TSnapshot);
begin
	inherited Items[Index] := Value;
end;

function TSnapshots.Add(Value: TSnapshot): Integer;
begin
  Inc(FIncrement);
	Result := inherited Add(Value);
end;

procedure TSnapshots.Insert(Index: Integer; Value: TSnapshot);
begin
  Inc(FIncrement);
	inherited Insert(Index, Value);
end;

procedure TSnapshots.Delete(Index: integer);
begin
	if (Index > -1) and (Index < Count) then
  begin
    TSnapshot(Items[Index]).Free;
    inherited Delete(Index);
  end;
end;

type
	TSnap = packed record
    TopLeft: TPoint;
    BmpSize: Int64;
	end;

procedure TSnapshots.SaveToFile(Filename: string);
var
	F: TFileStream;
  i: integer;
  Snap: TSnap;
  //Size: integer;
begin
	F := TFileStream.Create(Filename, fmCreate);
  try
  	// Ecriture de la signature et de la version
  	F.Write(Tag, SizeOf(Tag));
    F.Write(TagVer, SizeOf(TagVer));

    // On vérifie s'il y a des captures à inclure
  	if Self.Count > 0 then
  	begin
      // Ecriture de chaque Snapshot
    	for i := 0 to Self.Count - 1 do
      begin
      	// Initialise l'objet Snap
        Snap.TopLeft := TSnapshot(Items[i]).FTopLeft;
        Snap.BmpSize := TSnapshot(Items[i]).GetSize;
        // Sauvegarde de Snap et du bitmap
        F.Write(Snap, SizeOf(TSnap));
        TSnapshot(Items[i]).FBitmap.SaveToStream(F);
      end;
  	end;
  finally
  	F.Free;
  end;
end;

procedure TSnapshots.LoadFromFile(Filename: string);
var
	F: TFileStream;
  M: TMemoryStream;
  CheckTag: string[6];
  CheckVer: string[3];
  Snap: TSnap;
  Bitmap: TBitmap;
  NewSnap: TSnapshot;
  i: integer;
begin
	// Vérifie si le fichier existe
	if FileExists(Filename) then
  begin
  	// Vérification du fichier
    F := TFileStream.Create(Filename, fmOpenRead);
    try
    	if F.Size > 0 then
    	begin
      	F.Read(CheckTag, SizeOf(CheckTag));
        F.Read(CheckVer, SizeOf(CheckVer));
        if CheckTag <> Tag then
        begin
        	// Mauvaise version de fichier
          MessageBox(0, 'Le fichier de sauvegarde n''est pas compatible.', 'Erreur', MB_ICONERROR + MB_OK);
        end
        else if CheckVer <> TagVer then
        begin
        	// Traitement du fichier d'une ancienne version
          MessageBox(0, 'Les anciennes versions de sauvegardes ne sont pas compatibles.', 'Erreur', MB_ICONERROR + MB_OK);
        end
        else
        begin
        	i := 0;
        	while F.Position < F.Size do
          begin
        		// Lecture de Snap
          	F.Read(Snap, SizeOf(Snap));
          	// Lecture de l'image
          	M := TMemorystream.Create;
          	M.SetSize(Snap.BmpSize);
          	M.CopyFrom(F, Snap.BmpSize);
          	M.Position := 0;

          	Bitmap := TBitmap.Create;
          	Bitmap.LoadFromStream(M);
            Inc(i);
          	NewSnap := TSnapshot.Create('Snapshot' + IntToStr(i), Bitmap, Snap.TopLeft);
          	Self.Add(NewSnap);
          	Bitmap.free;
          	M.Free;
          end;
        end;
			end;
  	finally
    	F.Free;
    end;
  end;
end;

end.
