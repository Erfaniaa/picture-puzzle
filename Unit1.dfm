object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RiseFashion Puzzle Game'
  ClientHeight = 667
  ClientWidth = 834
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 694
    Top = 27
    Width = 44
    Height = 13
    Caption = 'Columns:'
  end
  object Label2: TLabel
    Left = 694
    Top = 55
    Width = 30
    Height = 13
    Caption = 'Rows:'
  end
  object Label3: TLabel
    Left = 663
    Top = 206
    Width = 50
    Height = 13
    Caption = 'Moves: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Label4: TLabel
    Left = 663
    Top = 225
    Width = 61
    Height = 13
    Caption = 'Time: 0:0:0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Columns: TSpinEdit
    Left = 744
    Top = 24
    Width = 57
    Height = 22
    MaxValue = 10
    MinValue = 2
    TabOrder = 0
    Value = 4
  end
  object Rows: TSpinEdit
    Left = 744
    Top = 52
    Width = 57
    Height = 22
    MaxValue = 10
    MinValue = 2
    TabOrder = 1
    Value = 4
  end
  object Button1: TButton
    Left = 694
    Top = 175
    Width = 107
    Height = 25
    Caption = 'New game'
    Enabled = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 694
    Top = 144
    Width = 107
    Height = 25
    Caption = 'Load an image'
    TabOrder = 3
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 657
    Height = 665
    Align = alCustom
    TabOrder = 4
    object Picture: TImage
      Left = 0
      Top = 3
      Width = 654
      Height = 659
    end
    object Shape1: TShape
      Left = 0
      Top = 3
      Width = 120
      Height = 120
      Brush.Style = bsClear
      Pen.Color = clRed
      Visible = False
    end
    object Image0: TImage
      Left = 378
      Top = 3
      Width = 120
      Height = 120
      AutoSize = True
      Center = True
      Visible = False
    end
    object Image1: TImage
      Left = 504
      Top = 3
      Width = 120
      Height = 120
      AutoSize = True
      Center = True
      Visible = False
    end
    object Shape2: TShape
      Left = 126
      Top = 3
      Width = 120
      Height = 120
      Visible = False
    end
    object Shape3: TShape
      Left = 252
      Top = 3
      Width = 120
      Height = 120
      Visible = False
    end
  end
  object ProgressBar1: TProgressBar
    Left = 663
    Top = 252
    Width = 163
    Height = 25
    TabOrder = 5
    Visible = False
  end
  object GroupBox2: TGroupBox
    Left = 663
    Top = 80
    Width = 163
    Height = 57
    Caption = 'Difficulty'
    TabOrder = 6
    object rbEasy: TRadioButton
      Left = 27
      Top = 24
      Width = 38
      Height = 17
      Caption = 'Easy'
      TabOrder = 0
    end
    object rbNormal: TRadioButton
      Left = 83
      Top = 23
      Width = 54
      Height = 17
      Caption = 'Normal'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 736
    Top = 544
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer2Timer
    Left = 736
    Top = 496
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Left = 736
    Top = 448
  end
  object Timer4: TTimer
    Enabled = False
    Interval = 30
    OnTimer = Timer4Timer
    Left = 736
    Top = 400
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.gif;*.png;*.jpg;*.jpeg;*.bmp)|*.gif;*.png;*.jpg;*.jpeg;*.' +
      'bmp|GIF Image (*.gif)|*.gif|Portable Network Graphics (*.png)|*.' +
      'png|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpe' +
      'g|Bitmaps (*.bmp)|*.bmp'
    Left = 736
    Top = 600
  end
end
