object fColor: TfColor
  Left = 809
  Top = 707
  BorderStyle = bsDialog
  Caption = 'Websafe filter'
  ClientHeight = 279
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object lblUnitHSVH: TLabel
    Left = 384
    Top = 98
    Width = 5
    Height = 13
    Caption = #176
  end
  object lblUnitHSVS: TLabel
    Left = 384
    Top = 122
    Width = 11
    Height = 13
    Caption = '%'
  end
  object lblUnitHSVV: TLabel
    Left = 384
    Top = 146
    Width = 11
    Height = 13
    Caption = '%'
  end
  object lblHexa: TLabel
    Left = 408
    Top = 202
    Width = 8
    Height = 13
    Caption = '#'
  end
  object lblUnitHSLH: TLabel
    Left = 480
    Top = 98
    Width = 5
    Height = 13
    Caption = #176
  end
  object lblUnitHSLS: TLabel
    Left = 480
    Top = 122
    Width = 11
    Height = 13
    Caption = '%'
  end
  object lblUnitHSLL: TLabel
    Left = 480
    Top = 146
    Width = 11
    Height = 13
    Caption = '%'
  end
  object imgTrack: TImage
    Left = 288
    Top = 256
    Width = 17
    Height = 17
    Cursor = crHandPoint
    Transparent = True
    OnMouseDown = imgTrackMouseDown
    OnMouseMove = imgTrackMouseMove
    OnMouseUp = imgTrackMouseUp
  end
  object panelMain: TPanel
    Left = 8
    Top = 8
    Width = 258
    Height = 258
    BevelOuter = bvLowered
    TabOrder = 0
    object imgMain: TImage
      Left = 1
      Top = 1
      Width = 256
      Height = 256
      Cursor = crCross
      Align = alClient
      OnMouseDown = imgMainMouseDown
      OnMouseMove = imgMainMouseMove
      OnMouseUp = imgMainMouseUp
    end
  end
  object panelBar: TPanel
    Left = 272
    Top = 8
    Width = 17
    Height = 258
    BevelOuter = bvLowered
    TabOrder = 1
    object imgBar: TImage
      Left = 1
      Top = 1
      Width = 15
      Height = 256
      Align = alClient
      OnMouseUp = imgBarMouseUp
    end
  end
  object radioHSVH: TRadioButton
    Left = 312
    Top = 98
    Width = 41
    Height = 17
    Caption = 'H:'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = radioHSVHClick
  end
  object radioHSVS: TRadioButton
    Left = 312
    Top = 122
    Width = 41
    Height = 17
    Caption = 'S:'
    TabOrder = 3
    OnClick = radioHSVSClick
  end
  object radioHSVV: TRadioButton
    Left = 312
    Top = 146
    Width = 41
    Height = 17
    Caption = 'V:'
    TabOrder = 4
    OnClick = radioHSVVClick
  end
  object radioRed: TRadioButton
    Left = 312
    Top = 178
    Width = 41
    Height = 17
    Caption = 'R:'
    TabOrder = 5
    OnClick = radioRedClick
  end
  object radioGreen: TRadioButton
    Left = 312
    Top = 202
    Width = 41
    Height = 17
    Caption = 'G:'
    TabOrder = 6
    OnClick = radioGreenClick
  end
  object radioBlue: TRadioButton
    Left = 312
    Top = 226
    Width = 41
    Height = 17
    Caption = 'B:'
    TabOrder = 7
    OnClick = radioBlueClick
  end
  object panelDisplay: TPanel
    Left = 312
    Top = 8
    Width = 81
    Height = 81
    BevelOuter = bvLowered
    TabOrder = 8
    object imgNewColor: TImage
      Left = 1
      Top = 1
      Width = 79
      Height = 41
      Align = alTop
    end
    object imgOldColor: TImage
      Left = 1
      Top = 40
      Width = 79
      Height = 40
      Align = alBottom
    end
  end
  object editHSVH: TEdit
    Left = 344
    Top = 96
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 9
    Text = '999'
    OnChange = editHSVHChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editHSVS: TEdit
    Left = 344
    Top = 120
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 10
    Text = '999'
    OnChange = editHSVSChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editHSVV: TEdit
    Left = 344
    Top = 144
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 11
    Text = '999'
    OnChange = editHSVSChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editRed: TEdit
    Left = 344
    Top = 176
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 12
    Text = '999'
    OnChange = editRedChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editGreen: TEdit
    Left = 344
    Top = 200
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 13
    Text = '999'
    OnChange = editRedChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editBlue: TEdit
    Left = 344
    Top = 224
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 14
    Text = '999'
    OnChange = editRedChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object chkWebsafe: TCheckBox
    Left = 312
    Top = 248
    Width = 185
    Height = 17
    Caption = 'Snap to websafe colors'
    Checked = True
    State = cbChecked
    TabOrder = 15
    OnClick = chkWebsafeClick
  end
  object editHexa: TEdit
    Left = 424
    Top = 200
    Width = 49
    Height = 21
    TabOrder = 16
    Text = 'FFFFFF'
    OnChange = editHexaChange
    OnKeyPress = editHexaKeyPress
  end
  object radioHSLH: TRadioButton
    Left = 408
    Top = 98
    Width = 41
    Height = 17
    Caption = 'H:'
    TabOrder = 17
    OnClick = radioHSLHClick
  end
  object radioHSLS: TRadioButton
    Left = 408
    Top = 122
    Width = 41
    Height = 17
    Caption = 'S:'
    TabOrder = 18
    OnClick = radioHSLSClick
  end
  object radioHSLL: TRadioButton
    Left = 408
    Top = 146
    Width = 41
    Height = 17
    Caption = 'L:'
    TabOrder = 19
    OnClick = radioHSLLClick
  end
  object editHSLH: TEdit
    Left = 440
    Top = 96
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 20
    Text = '999'
    OnChange = editHSVHChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editHSLS: TEdit
    Left = 440
    Top = 120
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 21
    Text = '999'
    OnChange = editHSVSChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object editHSLL: TEdit
    Left = 440
    Top = 144
    Width = 33
    Height = 21
    MaxLength = 3
    TabOrder = 22
    Text = '999'
    OnChange = editHSVSChange
    OnEnter = editHSVHEnter
    OnKeyPress = editHSVHKeyPress
  end
  object btnOK: TButton
    Left = 424
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 23
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 424
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 24
    OnClick = btnCancelClick
  end
end
