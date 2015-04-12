object MainForm: TMainForm
  Left = 189
  Top = 143
  BorderStyle = bsDialog
  Caption = 'MainForm'
  ClientHeight = 191
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnTestObjectPersonMapping: TButton
    Left = 8
    Top = 8
    Width = 189
    Height = 25
    Caption = 'Test Object Person Mapping'
    TabOrder = 0
    OnClick = btnTestObjectPersonMappingClick
  end
  object memStreamPersonMappingResult: TMemo
    Left = 204
    Top = 8
    Width = 273
    Height = 173
    Lines.Strings = (
      'memStreamPersonMappingResult')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object btnTestStreamPersonMapping: TButton
    Left = 8
    Top = 40
    Width = 189
    Height = 25
    Caption = 'Test Stream Person Mapping'
    TabOrder = 2
    OnClick = btnTestStreamPersonMappingClick
  end
end
