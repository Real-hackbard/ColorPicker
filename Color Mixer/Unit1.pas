unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    panUnten: TPanel;
    sbRot: TScrollBar;
    sbGruen: TScrollBar;
    sbBlau: TScrollBar;
    lblRGB: TLabel;
    panBig: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure MixColor(Sender:TObject);
    procedure FormCreate(Sender: TObject);
  private
    Rot: integer;
    Gruen: integer;
    Blau: integer;
    ActiveColor: TColor;
  end;

var Form1: TForm1;

implementation
{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered  := true;
end;

procedure TForm1.MixColor(Sender: TObject);
begin
  Rot := sbRot.Position;
  Gruen := sbGruen.Position;
  Blau := sbBlau.Position;
  // panBig.Color := 65536*Blau + 256*Gruen + Rot;
  panBig.Color := Blau SHL 16 + Gruen SHL 8 + Rot;
  lblRGB.Caption := 'R:' + IntToStr(Rot) +
                    '   G:' +IntToStr(Gruen) +
                    '   B:' + IntToStr(Blau)+
    ' ; HTML: '+inttohex(panbig.color,6);
end;

end.

