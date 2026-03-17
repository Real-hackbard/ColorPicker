object Form1: TForm1
  Left = 446
  Top = 164
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Color Ring'
  ClientHeight = 346
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = Init
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 14
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 278
    Height = 314
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    OnMouseDown = Square
    OnMouseMove = GetRGB
    OnPaint = Ring
  end
  object panDown: TPanel
    Left = 0
    Top = 314
    Width = 278
    Height = 32
    Align = alBottom
    Alignment = taLeftJustify
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 313
    ExplicitWidth = 274
    object Shape1: TShape
      Left = 248
      Top = 7
      Width = 20
      Height = 20
    end
  end
end
