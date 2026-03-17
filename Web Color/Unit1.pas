unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    R: TLabel;
    G: TLabel;
    B: TLabel;
    Shape1: TShape;
    Edit1: TEdit;
    Label4: TLabel;
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
var
 i,v:integer;
 s:string;
begin
 i:=integer(Shape1.Brush.Color);
 v:=TScrollBar(Sender).Position;
 s:=IntTostr(v);
 case TScrollBar(Sender).Tag of
  0: begin R.hint:=s; i:=i and $FFFF00+v; end;
  1: begin G.hint:=s; i:=i and $FF00FF+v shl 8; end;
  2: begin B.hint:=s; i:=i and $00FFFF+v shl 16; end;
 end;
 Shape1.Brush.Color:=TColor(i);
 i:=(i and $0000FF) shl 16 +(i and $00FF00)+ (i shr 16);
 Edit1.Text:='#'+IntToHex(i,6);
end;

end.
