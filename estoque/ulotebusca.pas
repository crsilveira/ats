unit uLoteBusca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DBGrids, uPadraoBusca, uDm;

type

  { TfLoteBuscar }

  TfLoteBuscar = class(TfPadraoBusca)
    dsProc: TDataSource;
    Edit3: TEdit;
    procedure btnPROCClick(Sender: TObject);
    procedure btnSALVClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    codigoLote: String;
    LoteCodProduto: Integer;
    LoteCCusto: Integer;
    procedure busca(codigo: String; produtoCod: String; CCusto: String);
  end;

var
  fLoteBuscar: TfLoteBuscar;

implementation

{$R *.lfm}

{ TfLoteBuscar }

procedure TfLoteBuscar.btnPROCClick(Sender: TObject);
begin
  busca(Edit1.Text, Edit2.Text, Edit3.Text);
end;

procedure TfLoteBuscar.btnSALVClick(Sender: TObject);
begin
  codigoLote    := dm.sqProc.FieldByName('LOTE').AsString;
  LoteCodProduto:= dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
  LoteCCusto    := dm.sqProc.FieldByName('CCUSTO').AsInteger;
  Close;
end;

procedure TfLoteBuscar.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    busca(Edit1.Text, Edit2.Text, Edit3.Text);
  end;
end;

procedure TfLoteBuscar.FormCreate(Sender: TObject);
begin
  DBGrid1.Columns[0].FieldName:='CODPRO';
  DBGrid1.Columns[1].FieldName:='PRODUTO';
  DBGrid1.Columns[2].FieldName:='LOTE';
  DBGrid1.Columns[3].FieldName:='ESTOQUE';
  DBGrid1.Columns[5].FieldName:='CCUSTO';
  DBGrid1.Columns[4].FieldName:='DATAFABRICACAO';
  codigoLote:='';
  LoteCCusto:=0;
  LoteCodProduto:=0;
end;

procedure TfLoteBuscar.FormShow(Sender: TObject);
begin
  Edit1.Text:=codigoLote;
  if (LoteCodProduto = 0) then
    Edit2.Text := ''
  else
    Edit2.Text := IntToStr(LoteCodProduto);
  if (LoteCCusto = 0) then
    Edit3.Text := ''
  else
    Edit3.Text := IntToStr(LoteCCusto);
end;

procedure TfLoteBuscar.busca(codigo: String; produtoCod: String; CCusto: String);
  var sqlProc: String;
begin
  sqlProc := 'SELECT LOTES.*, p.CODPRO, p.PRODUTO ' +
    ' FROM LOTES, PRODUTOS p ' +
    ' WHERE LOTES.CODPRODUTO = p.CODPRODUTO ';

  if (codigo <> '') then
  begin
    sqlProc += ' AND LOTES.LOTE  = ' + QuotedStr(codigo);
  end;
  if (produtoCod <> '') then
  begin
    sqlProc += ' AND LOTES.CODPRODUTO  = ' + produtoCod;
  end;

  if (CCusto <> '') then
  begin
    sqlProc += ' AND LOTES.CCUSTO  = ' + CCusto;
  end;

  sqlProc += ' ORDER BY LOTES.LOTE DESC';
  if (dm.sqProc.Active) then
    dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add(sqlProc);

  dsProc.DataSet.Active:=True;
  codigoLote    := dm.sqProc.FieldByName('LOTE').AsString;
  LoteCodProduto:= dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
  LoteCCusto    := dm.sqProc.FieldByName('CCUSTO').AsInteger;
end;

end.

