object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Gradient Calculator'
  ClientHeight = 410
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 540
    Height = 309
    Align = alClient
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnPaint = PaintBox1Paint
    ExplicitLeft = 8
    ExplicitTop = 26
    ExplicitWidth = 478
    ExplicitHeight = 234
  end
  object Panel1: TPanel
    Left = 0
    Top = 309
    Width = 540
    Height = 82
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 422
    DesignSize = (
      540
      82)
    object Label1: TLabel
      Left = 29
      Top = 14
      Width = 13
      Height = 15
      Caption = 'X :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 100
      Top = 14
      Width = 13
      Height = 15
      Caption = 'Y :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblRGB: TLabel
      Left = 14
      Top = 55
      Width = 28
      Height = 15
      Caption = 'RGB :'
    end
    object Button1: TButton
      Left = 426
      Top = 48
      Width = 50
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Start'
      TabOrder = 0
      TabStop = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 482
      Top = 48
      Width = 50
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Stop'
      Enabled = False
      TabOrder = 1
      TabStop = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 181
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Randomize'
      TabOrder = 2
      TabStop = False
      OnClick = Button3Click
    end
    object SpinEdit1: TSpinEdit
      Left = 48
      Top = 11
      Width = 46
      Height = 24
      TabStop = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 25
    end
    object SpinEdit2: TSpinEdit
      Left = 122
      Top = 11
      Width = 51
      Height = 24
      TabStop = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 25
    end
    object Edit1: TEdit
      Left = 48
      Top = 53
      Width = 33
      Height = 21
      Hint = 'Red'
      TabStop = False
      Color = clRed
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
      Text = '255'
    end
    object Edit2: TEdit
      Left = 89
      Top = 53
      Width = 33
      Height = 21
      Hint = 'Green'
      TabStop = False
      Color = clLime
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 6
      Text = '255'
    end
    object Edit3: TEdit
      Left = 128
      Top = 53
      Width = 33
      Height = 21
      Hint = 'Blue'
      TabStop = False
      Color = clBlue
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 7
      Text = '255'
    end
    object ComboBox1: TComboBox
      Left = 326
      Top = 11
      Width = 107
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 8
      TabStop = False
      Text = 'C/C++'
      Items.Strings = (
        'C/C++'
        'Pascal (Delphi)'
        'HTML')
    end
    object Edit4: TEdit
      Left = 439
      Top = 11
      Width = 93
      Height = 23
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 391
    Width = 540
    Height = 19
    Panels = <
      item
        Text = '0'
        Width = 50
      end
      item
        Text = 'Select two Color and click Start..'
        Width = 200
      end
      item
        Width = 50
      end>
    ExplicitTop = 503
    ExplicitWidth = 536
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 67
    Top = 39
  end
  object Timer2: TTimer
    Interval = 1
    Left = 134
    Top = 39
  end
end
