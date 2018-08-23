unit uLoteRel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RLReport, uDm;

type

  { TfLoteRel }

  TfLoteRel = class(TForm)
    ds: TDataSource;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLDBResult1: TRLDBResult;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLReport1: TRLReport;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    procedure FormShow(Sender: TObject);
    procedure RLDBResult1AfterPrint(Sender: TObject);
    procedure RLDBText3AfterPrint(Sender: TObject);
  private

  public

  end;

var
  fLoteRel: TfLoteRel;

implementation

{$R *.lfm}

{ TfLoteRel }

procedure TfLoteRel.FormShow(Sender: TObject);
begin

end;

procedure TfLoteRel.RLDBResult1AfterPrint(Sender: TObject);
begin

end;

procedure TfLoteRel.RLDBText3AfterPrint(Sender: TObject);
begin

end;

end.

