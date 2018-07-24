unit uEstoqueRel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, uDm, RLReport;

type

  { TfEstoqueRel }

  TfEstoqueRel = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
  private

  public

  end;

var
  fEstoqueRel: TfEstoqueRel;

implementation

uses uLoteBusca, uLoteRel;

{$R *.lfm}

{ TfEstoqueRel }

procedure TfEstoqueRel.BitBtn1Click(Sender: TObject);
begin
  fLoteBuscar.ShowModal;
  dm.sqLote.Active:=False;
  dm.sqLote.SQL.Clear;
  dm.sqLote.SQL.Add(dm.sqProc.SQL.Text);
  dm.sqLote.Active:=True;
  fLoteRel.RLReport1.Preview();
end;

end.

