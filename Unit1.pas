unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtDlgs, ExtCtrls, ComCtrls, GIFImg, JPEG, PngImage;

type
  TForm1 = class(TForm)
    Columns: TSpinEdit;
    Label1: TLabel;
    Rows: TSpinEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Picture: TImage;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Timer2: TTimer;
    Timer3: TTimer;
    Label3: TLabel;
    Label4: TLabel;
    Shape1: TShape;
    Timer4: TTimer;
    OpenPictureDialog1: TOpenPictureDialog;
    Shape2: TShape;
    Shape3: TShape;
    Image0: TImage;
    Image1: TImage;
    GroupBox2: TGroupBox;
    rbEasy: TRadioButton;
    rbNormal: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PictureClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TPnt = record
  X, Y: Real;
end;

TPic = record
  Image: TImage;
  Pos: TPoint;
  Coord: TPnt;
end;

var
  Form1: TForm1;
  X0, Y0, X1, Y1: Word;
  Dis: Real;
  Started: Boolean;
  ClickNum: ShortInt;
  Count, Moves, S, M, H: Integer;
  PosX, PosY: array [0..1] of Word;
  Parts: array [1..20, 1..20] of TPic;
  Bevels: array [1..20, 1..20] of TBevel;
  Mark: array [1..20, 1..20] of Boolean;
  A, Speed, Angle: Real;

implementation

{$R *.dfm}

procedure SwapImages(var Image1, Image2: TImage);
var
  Image: TImage;
begin
  Image := TImage.Create(Form1);
  Image.Parent := Form1;
  Image.Visible := False;
  Image.Picture := Image2.Picture;
  Image2.Picture := Image1.Picture;
  Image1.Picture := Image.Picture;
end;

procedure SwapPics(var Image1, Image2: TPic);
var
  //X, Y: Word;
  Image: TPic;
  Z: TPoint;
begin
  Image.Image := TImage.Create(Form1);
  Image.Image.Parent := Form1;
  Image.Image.Visible := False;
  Image.Image.Picture := Image2.Image.Picture;
  Image2.Image.Picture := Image1.Image.Picture;
  Image1.Image.Picture := Image.Image.Picture;
  Z := Image2.Pos;
  Image2.Pos := Image1.Pos;
  Image1.Pos := Z;
  {X := Image2.Image.Left;
  Y := Image2.Image.Top;
  Image2.Image.Left := Image1.Image.Left;
  Image2.Image.Top := Image1.Image.Top;
  Image1.Image.Left := X;
  Image1.Image.Top := Y;}
end;

procedure SwapPos(var Image1, Image2: TPic);
var
  X, Y: Word;
begin
  X := Image2.Image.Left;
  Y := Image2.Image.Top;
  Image2.Image.Left := Image1.Image.Left;
  Image2.Image.Top := Image1.Image.Top;
  Image1.Image.Left := X;
  Image1.Image.Top := Y;
end;

function Distance(X1, Y1, X2, Y2: Real): Real;
begin
  Result := Sqrt(Sqr(X2 - X1) + Sqr(Y2 - Y1));
end;

function ATan(xx, yy: Real): Real;
var
	xxx, yyy, Teta: Real;
begin
	xxx := Abs(xx);
  yyy := Abs(yy);
  if (xx >= 0) and (yy >= 0) and (xxx > yyy) then Teta := ArcTan(yyy / xxx);
  if (xx >= 0) and (yy >= 0) and (xxx < yyy) then Teta := Pi /2 - ArcTan(xxx / yyy);
  if (xx >= 0) and (yy >= 0) and (xxx = yyy) then Teta := Pi / 4;
	if (xx <  0) and (yy >= 0) and (xxx > yyy) then Teta := Pi - ArcTan(yyy / xxx);
  if (xx <  0) and (yy >= 0) and (xxx < yyy) then Teta := Pi /2 + ArcTan(xxx / yyy);
  if (xx <  0) and (yy >= 0) and (xxx = yyy) then Teta := Pi - Pi / 4;
	if (xx <  0) and (yy <  0) and (xxx > yyy) then Teta := Pi + ArcTan(yyy / xxx);
  if (xx <  0) and (yy <  0) and (xxx < yyy) then Teta := 3 * Pi / 2 - ArcTan(xxx / yyy);
	if (xx <  0) and (yy <  0) and (xxx = yyy) then Teta := Pi + Pi / 4;
  if (xx >= 0) and (yy <  0) and (xxx > yyy) then Teta := 2 * Pi - ArcTan(yyy / xxx);
	if (xx >= 0) and (yy <  0) and (xxx < yyy) then Teta := 3 * Pi / 2 + ArcTan(xxx / yyy);
  if (xx >= 0) and (yy <  0) and (xxx = yyy) then Teta := 2 * Pi - Pi / 4;
  ATan := Teta;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  X, Y, X2, Y2, X3, Y3, X4, Y4: Word;
begin
  ClickNum := 1;
  Timer3.Enabled := False;
  Started := True;
  S := 0;
  M := 0;
  H := 0;
  Moves := 0;
  Label3.Caption := 'Moves: 0';
  Label4.Caption := 'Time: 0:0:0';
  Label3.Visible := False;
  Label4.Visible := False;
  ProgressBar1.Position := 0;
  ProgressBar1.Visible := True;
  ProgressBar1.Max := Columns.Value * Rows.Value;
  Shape1.Visible := False;
  Shape2.Visible := False;
  Shape3.Visible := False;
  Image0.Visible := False;
  Image1.Visible := False;
  Timer3.Enabled := False;
  Timer4.Enabled := False;
  //if rbNormal.Checked then
  for X := 1 to Columns.Value do
    for Y := 1 to Rows.Value do
      Mark[X, Y] := False;
  for X := 1 to Columns.Value do
    for Y := 1 to Rows.Value do
    begin
      if rbNormal.Checked then
      begin
        repeat
          X3 := Random(Columns.Value) + 1;
          Y3 := Random(Rows.Value) + 1;
        until (not Mark[X3, Y3]) and ((X <> X3) or (Y <> Y3));
        Mark[X3, Y3] := True;
        Parts[X, Y].Image.Enabled := True;
      end
      else
      begin
        X3 := X;
        Y3 := Y;
      end;
      X4 := (X - 1) * Picture.Width div Columns.Value + X;
      Y4 := (Y - 1) * Picture.Height div Rows.Value + Y;
      ProgressBar1.Position := ProgressBar1.Position + 1;
      Bevels[X3, Y3] := TBevel.Create(GroupBox1);
      Bevels[X3, Y3].Parent := GroupBox1;
      Parts[X3, Y3].Image := TImage.Create(GroupBox1);
      Parts[X3, Y3].Image.Parent := GroupBox1;
      Parts[X3, Y3].Image.Left := (X3 - 1) * Picture.Width div Columns.Value + X3;
      Parts[X3, Y3].Image.Top := (Y3 - 1) * Picture.Height div Rows.Value + Y3;
      Parts[X3, Y3].Pos.X := X;
      Parts[X3, Y3].Pos.Y := Y;
      Parts[X3, Y3].Image.Width := Picture.Width div Columns.Value;
      Parts[X3, Y3].Image.Height := Picture.Height div Rows.Value;
      Parts[X3, Y3].Image.OnClick := PictureClick;
      Parts[X3, Y3].Image.Enabled := False;
      Bevels[X3, Y3].Left := Parts[X3, Y3].Image.Left - 1;
      Bevels[X3, Y3].Top := Parts[X3, Y3].Image.Top - 1;
      Bevels[X3, Y3].Width := Parts[X3, Y3].Image.Width + 2;
      Bevels[X3, Y3].Height := Parts[X3, Y3].Image.Height + 2;
      Bevels[X3, Y3].Shape := bsFrame;
      for X2 := 0 to Parts[X3, Y3].Image.Width - 1 do
        for Y2 := 0 to Parts[X3, Y3].Image.Height - 1 do
          Parts[X3, Y3].Image.Canvas.Pixels[X2, Y2] := Picture.Canvas.Pixels[X2 + X4, Y2 + Y4];
      Shape1.BringToFront;
    end;
  if rbEasy.Checked then
  begin
    Timer2.Enabled := True;
    ProgressBar1.Max := (Columns.Value * Rows.Value div 2) + (Columns.Value * Rows.Value mod 2);
  end
  else
  begin
    ProgressBar1.Position := ProgressBar1.Max;
    Count := 0;
    for X := 1 to Columns.Value do
      for Y := 1 to Rows.Value do
      begin
        Mark[X, Y] := False;
        Parts[X, Y].Image.Enabled := True;
        Bevels[X, Y].Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
        Parts[X, Y].Image.Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
      end;
    Label3.Visible := True;
    Label4.Visible := True;
    Timer3.Enabled := True;
    ProgressBar1.Visible := False;
  end;
  //Button1.Enabled := False;
  //Picture.Visible := False;
  {Button1.Enabled := False;
  Button2.Enabled := False;
  Columns.Enabled := False;
  Rows.Enabled := False;
  Label1.Enabled := False;
  Label2.Enabled := False;}
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  X, Y: Word;
  imgJPEG: TJPEGImage;
  imgGIF: TGIFImage;
  imgPng: TPngImage;
  St: string;
begin
  Timer3.Enabled := False;
  Started := True;
  S := 0;
  M := 0;
  H := 0;
  Moves := 0;
  Label3.Caption := 'Moves: 0';
  Label4.Caption := 'Time: 0:0:0';
  Label3.Visible := False;
  Label4.Visible := False;
  ProgressBar1.Position := 0;
  ProgressBar1.Max := Columns.Value * Rows.Value;
  ClickNum := 1;
  Shape1.Visible := False;
  Shape2.Visible := False;
  Shape3.Visible := False;
  Image0.Visible := False;
  Image1.Visible := False;
  Timer3.Enabled := False;
  Timer4.Enabled := False;
  Picture.AutoSize := False;
  Picture.Stretch := False;
  Picture.Proportional := False;
  GroupBox1.Width := 657;
  GroupBox1.Height := 665;
  Picture.Width := 654;
  Picture.Height := 659;
  if OpenPictureDialog1.Execute then
  begin
    Label3.Visible := False;
    Label4.Visible := False;
    H := 0;
    M := 0;
    S := 0;
    St := LowerCase(Copy(OpenPictureDialog1.FileName, Length(OpenPictureDialog1.FileName) - 3, 4));
    if St[1] = '.' then
      Delete(St, 1, 1);
    if St = 'bmp' then
      Picture.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    if (St = 'jpg') or (St = 'jpeg') then
    begin
      imgJpeg := TJpegImage.Create;
      imgJpeg.LoadFromFile(OpenPictureDialog1.FileName);
      Picture.Picture.Bitmap.Assign(ImgJpeg);
    end;
    if St = 'gif' then
    begin
      imgGIF := TGIFImage.Create;
      imgGIF.LoadFromFile(OpenPictureDialog1.FileName);
      Picture.Picture.Bitmap.Assign(ImgGIF);
    end;
    if St = 'png' then
    begin
      imgPng := TPngImage.Create;
      imgPng.LoadFromFile(OpenPictureDialog1.FileName);
      Picture.Picture.Bitmap.Assign(ImgPng);
    end;
    Button1.Enabled := True;
    for X := 1 to Columns.Value do
      for Y := 1 to Rows.Value do
      begin
        Parts[X, Y].Image.Visible := False;
        Bevels[X, Y].Visible := False;
      end;
    if (Picture.Picture.Width > GroupBox1.Width - 3) or (Picture.Picture.Height > Picture.Height - 3) then
      //Picture.Stretch := True
    else
    begin
      Picture.Proportional := True;
      Picture.AutoSize := True;
      GroupBox1.Width := Picture.Width;
      GroupBox1.Height := Picture.Height;
    end;
    //Timer1.Enabled := True;
    //ResizeWidth := Picture.Picture.Height > Picture.Picture.Width;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Button1.Enabled := True;
  Button2.Enabled := True;
  Columns.Enabled := True;
  Rows.Enabled := True;
  Label1.Enabled := True;
  Label2.Enabled := True;
  //Button3.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  X, Y: Word;
begin
  Randomize;
  Count := 0;
  ClickNum := 1;
  for X := 1 to 10 do
    for Y := 1 to 10 do
    begin
      Bevels[X, Y] := TBevel.Create(GroupBox1);
      Bevels[X, Y].Parent := GroupBox1;
      Parts[X, Y].Image := TImage.Create(GroupBox1);
      Parts[X, Y].Image.Parent := GroupBox1;
      Bevels[X, Y].Visible := False;
      Parts[X, Y].Image.Visible := False;
    end;
end;

procedure TForm1.PictureClick(Sender: TObject);
var
  Win: Boolean;
  X, Y: Word;
begin
  if not Timer4.Enabled then
  begin
    ClickNum := (ClickNum + 1) mod 2;
    for X := 1 to Columns.Value do
      for Y := 1 to Rows.Value do
        if Parts[X, Y].Image = TImage(Sender) then
        begin
          PosX[ClickNum] := X;
          PosY[ClickNum] := Y;
          Break;
        end;
    if ClickNum = 1 then
    begin
      X0 := Parts[PosX[0], PosY[0]].Image.Left;
      X1 := Parts[PosX[1], PosY[1]].Image.Left;
      Y0 := Parts[PosX[0], PosY[0]].Image.Top;
      Y1 := Parts[PosX[1], PosY[1]].Image.Top;
      Dis := Distance(X0, Y0, X1, Y1);
      Inc(Moves);
      Label3.Caption := 'Moves: ' + IntToStr(Moves);
      Shape1.Visible := False;
      Parts[PosX[0], PosY[0]].Coord.X := Parts[PosX[0], PosY[0]].Image.Left;
      Parts[PosX[0], PosY[0]].Coord.Y := Parts[PosX[0], PosY[0]].Image.Top;
      Parts[PosX[1], PosY[1]].Coord.X := Parts[PosX[1], PosY[1]].Image.Left;
      Parts[PosX[1], PosY[1]].Coord.Y := Parts[PosX[1], PosY[1]].Image.Top;
      Speed := Dis / 1;
      Shape2.Left := Parts[PosX[0], PosY[0]].Image.Left - 1;
      Shape2.Top := Parts[PosX[0], PosY[0]].Image.Top - 1;
      Shape3.Left := Parts[PosX[1], PosY[1]].Image.Left - 1;
      Shape3.Top := Parts[PosX[1], PosY[1]].Image.Top - 1;
      Shape2.Width := Parts[PosX[0], PosY[0]].Image.Width + 2;
      Shape2.Height := Parts[PosX[0], PosY[0]].Image.Height + 2;
      Shape3.Width := Parts[PosX[1], PosY[1]].Image.Width + 2;
      Shape3.Height := Parts[PosX[1], PosY[1]].Image.Height + 2;
      Shape2.Visible := True;
      Shape3.Visible := True;
      Angle := ATan(Parts[PosX[1], PosY[1]].Image.Left - Parts[PosX[0], PosY[0]].Image.Left, Parts[PosX[1], PosY[1]].Image.Top - Parts[PosX[0], PosY[0]].Image.Top);
      Image0.Left := Parts[PosX[0], PosY[0]].Image.Left;
      Image0.Top := Parts[PosX[0], PosY[0]].Image.Top;
      Image0.Picture := Parts[PosX[0], PosY[0]].Image.Picture;
      Image1.Left := Parts[PosX[1], PosY[1]].Image.Left;
      Image1.Top := Parts[PosX[1], PosY[1]].Image.Top;
      Image1.Picture := Parts[PosX[1], PosY[1]].Image.Picture;
      for X := 1 to Columns.Value * Rows.Value - 1 do
      begin
        Image0.BringToFront;
        Image1.BringToFront;
        for Y := 0 to 3 do
          Parts[PosX[Y mod 2], PosY[Y mod 2]].Image.BringToFront;
      end;
      //Image0.SendToBack;
      //Image1.SendToBack;
      A := Timer4.Interval / 1000;
      Timer4.Enabled := True;
      //SwapPics(Parts[PosX[0], PosY[0]], Parts[PosX[1], PosY[1]]);
    end
    else
    begin
      for X := 1 to Columns.Value * Rows.Value do
        Shape1.BringToFront;
      Shape1.Visible := True;
      Shape1.Left := Parts[PosX[0], PosY[0]].Image.Left - 1;
      Shape1.Top := Parts[PosX[0], PosY[0]].Image.Top - 1;
      Shape1.Width := Parts[PosX[0], PosY[0]].Image.Width + 2;
      Shape1.Height := Parts[PosX[0], PosY[0]].Image.Height + 2;
    end;
    Win := True;
    for X := 1 to Columns.Value do
      for Y := 1 to Rows.Value do
      begin
        Bevels[X, Y].Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
        Parts[X, Y].Image.Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
        Win := Win and not Bevels[X, Y].Visible;
      end;
    if Win then
    begin
      Timer3.Enabled := False;
      ShowMessage('You win!');
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  {if ResizeWidth then
  begin
    if Round(Picture.Width / Picture.Height) <> Round(Picture.Picture.Width / Picture.Picture.Height) then
      GroupBox1.Width := GroupBox1.Width - 1;
  end
  else
    if Round(Picture.Width / Picture.Height) <> Round(Picture.Picture.Width / Picture.Picture.Height) then
      Height := Height - 1;}
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  X, Y, X2, Y2: Word;
begin
  ProgressBar1.Position := Count;
  Inc(Count);
  repeat
    X := Random(Columns.Value) + 1;
    Y := Random(Rows.Value) + 1;
  until (Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y);
  repeat
    X2 := Random(Columns.Value) + 1;
    Y2 := Random(Rows.Value) + 1;
  until (Parts[X2, Y2].Pos.X = X2) and (Parts[X2, Y2].Pos.Y = Y2) and ((X <> X2) or (Y <> Y2));
  Mark[X, Y] := True;
  Mark[X2, Y2] := True;
  SwapPics(Parts[X, Y], Parts[X2, Y2]);
  if (Columns.Value * Rows.Value mod 2 = 1) and (Count = (Columns.Value * Rows.Value div 2) + (Columns.Value * Rows.Value mod 2) - 1) then
  begin
    Inc(Count);
    for X := 1 to Columns.Value - 1 do
      for Y := 1 to Rows.Value - 1 do
        //if (Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y) then
        if not Mark[X, Y] then
        begin
          repeat
            X2 := Random(Columns.Value) + 1;
            Y2 := Random(Rows.Value) + 1;
          until (X <> X2) or (Y <> Y2);
          SwapPics(Parts[X, Y], Parts[X2, Y2]);
          Break;
        end;
  end;
  if Count = (Columns.Value * Rows.Value div 2) + (Columns.Value * Rows.Value mod 2) then
  begin
    ProgressBar1.Position := ProgressBar1.Max;
    Timer2.Enabled := False;
    Count := 0;
    for X := 1 to Columns.Value do
      for Y := 1 to Rows.Value do
      begin
        Mark[X, Y] := False;
        Parts[X, Y].Image.Enabled := True;
        Bevels[X, Y].Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
        Parts[X, Y].Image.Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
      end;
    Label3.Visible := True;
    Label4.Visible := True;
    Timer3.Enabled := True;
    ProgressBar1.Visible := False;
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  S := S + 1;
  if S = 60 then
  begin
    S := 0;
    M := M + 1;
  end;
  if M = 60 then
  begin
    M := 0;
    H := H + 1;
  end;
  Label4.Caption := 'Time: ' + IntToStr(H) + ':' + IntToStr(M) + ':' + IntToStr(S);
end;

procedure TForm1.Timer4Timer(Sender: TObject);
var
  I: ShortInt;
  X, Y: ShortInt;
  Win: Boolean;
begin
  if Distance(Parts[PosX[0], PosY[0]].Image.Left, Parts[PosX[0], PosY[0]].Image.Top, X1, Y1) > Speed * A then
  begin
    for I := 0 to 1 do
    begin
      with Parts[PosX[I], PosY[I]] do
      begin
        if I = 0 then
        begin
          Coord.X := Coord.X + Cos(Angle) * Speed * A;
          Coord.Y := Coord.Y + Sin(Angle) * Speed * A;
        end
        else
        begin
          Coord.X := Coord.X - Cos(Angle) * Speed * A;
          Coord.Y := Coord.Y - Sin(Angle) * Speed * A;
        end;
        Image.Left := Round(Coord.X);
        Image.Top := Round(Coord.Y);
      end;
    end;
    Image0.Left := Parts[PosX[0], PosY[0]].Image.Left;
    Image0.Top := Parts[PosX[0], PosY[0]].Image.Top;
    Image1.Left := Parts[PosX[1], PosY[1]].Image.Left;
    Image1.Top := Parts[PosX[1], PosY[1]].Image.Top;
  end
  else
  begin
    Parts[PosX[0], PosY[0]].Image.Left := X0;
    Parts[PosX[0], PosY[0]].Image.Top := Y0;
    Parts[PosX[1], PosY[1]].Image.Left := X1;
    Parts[PosX[1], PosY[1]].Image.Top := Y1;
    SwapPics(Parts[PosX[0], PosY[0]], Parts[PosX[1], PosY[1]]);
    Parts[PosX[0], PosY[0]].Image.OnClick := PictureClick;
    Parts[PosX[1], PosY[1]].Image.OnClick := PictureClick;
    Parts[PosX[0], PosY[0]].Image.Visible := True;
    Parts[PosX[1], PosY[1]].Image.Visible := True;
    Timer4.Enabled := False;
    Shape2.Visible := False;
    Shape3.Visible := False;
    for X := 1 to Columns.Value * Rows.Value - 1 do
      for Y := 0 to 1 do
        Parts[PosX[Y], PosY[Y]].Image.BringToFront;
    Win := True;
    for X := 1 to Columns.Value do
      for Y := 1 to Rows.Value do
      begin
        Bevels[X, Y].Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
        Parts[X, Y].Image.Visible := not((Parts[X, Y].Pos.X = X) and (Parts[X, Y].Pos.Y = Y));
        Win := Win and not Bevels[X, Y].Visible;
      end;
    if Win then
    begin
      Timer3.Enabled := False;
      ShowMessage('You win!');
    end;
  end;
end;

end.
