unit uLoteBusca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DBGrids, Buttons, uPadraoBusca, uDm;

type

  { TfLoteBuscar }

  TfLoteBuscar = class(TfPadraoBusca)
    btnProdutoProc: TBitBtn;
    cbLocal: TComboBox;
    dsProc: TDataSource;
    edProduto: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnEXCClick(Sender: TObject);
    procedure btnPROCClick(Sender: TObject);
    procedure btnProdutoProcClick(Sender: TObject);
    procedure btnSALVClick(Sender: TObject);
    procedure cbLocalChange(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    ordenar: String;
  public
    codigoLote: String;
    LoteCodProduto: Integer;
    LoteCCusto: Integer;
    LoteCcustoIndex: Integer;
    procedure busca(codigo: String; produtoCod: String; CCusto: String);
  end;

var
  fLoteBuscar: TfLoteBuscar;

implementation

uses uProdutoProc;

{$R *.lfm}

{ TfLoteBuscar }

procedure TfLoteBuscar.btnPROCClick(Sender: TObject);
begin
  busca(Edit2.Text, IntToStr(LoteCodProduto), IntToStr(LoteCCusto));
end;

procedure TfLoteBuscar.btnEXCClick(Sender: TObject);
begin
  inherited;
  LoteCodProduto:=0;
  LoteCCusto    :=0;
end;

procedure TfLoteBuscar.btnProdutoProcClick(Sender: TObject);
begin
  fProdutoProc.ShowModal;
  edit1.Text     := fProdutoProc.codProd;
  edProduto.Text := fProdutoProc.produto;
  LoteCodProduto := fProdutoProc.codProduto;
end;

procedure TfLoteBuscar.btnSALVClick(Sender: TObject);
begin
  codigoLote    := dm.sqProc.FieldByName('LOTE').AsString;
  LoteCodProduto:= dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
  LoteCCusto    := dm.sqProc.FieldByName('CCUSTO').AsInteger;
  Close;
end;

procedure TfLoteBuscar.cbLocalChange(Sender: TObject);
begin
  LoteCCusto:=0;
  if (dm.sqPlano.Active) then
    dm.sqPlano.Close;
  dm.sqPlano.SQL.Clear;
  dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
    ' WHERE CONTAPAI = ' + QuotedStr(dm.ccusto) +
    '   AND CONSOLIDA = ' + QuotedStr('S'));
  dm.sqPlano.Active:=True;

  While not dm.sqPlano.EOF do
  begin
    if (dm.sqPlanoNOME.AsString = cbLocal.Text) then
    begin
      LoteCcustoIndex := dm.sqplano.RecNo-1;
      LoteCCusto := dm.sqPlanoCODIGO.AsInteger;
    end;
    dm.sqPlano.Next;
  end;
end;

procedure TfLoteBuscar.DBGrid1TitleClick(Column: TColumn);
begin
  // ordenar pela coluna selecionada
  if (ordenar = Column.FieldName) then
    ordenar := Column.FieldName + ' DESC'
  else
    ordenar := Column.FieldName;
  busca(Edit2.Text, IntToStr(LoteCodProduto), IntToStr(LoteCCusto));
end;

procedure TfLoteBuscar.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    fProdutoProc.busca(Edit1.Text, '');
    edProduto.Text := fProdutoProc.produto;
    LoteCodProduto := fProdutoProc.codProduto;
    // Lote, Produto, CCusto
    busca(Edit2.Text, IntToStr(LoteCodProduto), IntToStr(LoteCCusto));
  end;
end;

procedure TfLoteBuscar.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    // Lote, Produto, CCusto
    busca(Edit2.Text, IntToStr(LoteCodProduto), IntToStr(LoteCCusto));
  end;
end;

procedure TfLoteBuscar.FormCreate(Sender: TObject);
begin
  DBGrid1.Columns[0].FieldName:='CODPRO';
  DBGrid1.Columns[1].FieldName:='PRODUTO';
  DBGrid1.Columns[2].FieldName:='LOTE';
  DBGrid1.Columns[3].FieldName:='ESTOQUE';
  DBGrid1.Columns[5].FieldName:='NOME';
  DBGrid1.Columns[4].FieldName:='DATAFABRICACAO';
  DBGrid1.Columns[6].FieldName:='DATAVENCIMENTO';
  codigoLote:='';
  LoteCCusto:=0;
  LoteCodProduto:=0;
end;

procedure TfLoteBuscar.FormShow(Sender: TObject);
begin
  LoteCcustoIndex := -1;
  ordenar := '';
  if (dm.sqPlano.Active) then
    dm.sqPlano.Close;
  dm.sqPlano.SQL.Clear;
  dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
    ' WHERE CONTAPAI = ' + QuotedStr(dm.ccusto) +
    '   AND CONSOLIDA = ' + QuotedStr('S'));
  dm.sqPlano.Active:=True;
  cbLocal.Items.Clear;
  While not dm.sqPlano.EOF do
  begin
    cbLocal.Items.Add(dm.sqPlanoNOME.AsString);
    if (dm.sqPlanoCODIGO.AsInteger = LoteCCusto) then
      LoteCcustoIndex := dm.sqplano.RecNo-1;
    dm.sqPlano.Next;
  end;
  cbLocal.ItemIndex:=LoteCcustoIndex;
  Edit2.Text := codigoLote;
  if (LoteCodProduto = 0) then
    Edit1.Text := ''
  else
    Edit1.Text := IntToStr(LoteCodProduto);
end;

procedure TfLoteBuscar.busca(codigo: String; produtoCod: String; CCusto: String);
  var sqlProc: String;
begin
  sqlProc := 'SELECT LOTES.*, p.CODPRO, p.PRODUTO, pl.NOME ' +
    ' FROM LOTES, PRODUTOS p, PLANO pl ' +
    ' WHERE LOTES.CODPRODUTO = p.CODPRODUTO ' +
    '   AND PL.CODIGO = LOTES.CCUSTO ';

  if (codigo <> '') then
  begin
    sqlProc += ' AND LOTES.LOTE  = ' + QuotedStr(codigo);
  end;
  if ((produtoCod <> '') and (produtoCod <> '0')) then
  begin
    sqlProc += ' AND LOTES.CODPRODUTO  = ' + produtoCod;
  end;
  if (cbLocal.Text = '') then
    CCusto := '0';
  if ((CCusto <> '') and (CCusto <> '0')) then
  begin
    sqlProc += ' AND LOTES.CCUSTO  = ' + CCusto;
  end;
  if (not chInativo.Checked) then
  begin
    sqlProc += ' AND LOTES.ESTOQUE  > 0';
  end;
  if (ordenar = '') then
    sqlProc += ' ORDER BY PL.NOME, LOTES.LOTE DESC'
  else
    sqlProc += ' ORDER BY ' + ordenar;
  if (dm.sqProc.Active) then
    dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add(sqlProc);

  dsProc.DataSet.Active:=True;
  //codigoLote    := dm.sqProc.FieldByName('LOTE').AsString;
  //LoteCodProduto:= dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
  //LoteCCusto    := dm.sqProc.FieldByName('CCUSTO').AsInteger;
end;

end.

