unit uProdutoProc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, StdCtrls, udm;

type

  { TfProdutoProc }

  TfProdutoProc = class(TForm)
    btnEXC: TImage;
    btnPROC: TImage;
    btnSALV: TImage;
    chInativo: TCheckBox;
    DBGrid1: TDBGrid;
    dsProc: TDataSource;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnEXCClick(Sender: TObject);
    procedure btnPROCClick(Sender: TObject);
    procedure btnSALVClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private

  public
    codProduto: Integer;
    produto: String;
    codProd: String;
    procedure busca(codigo: String; produtoDesc: String);
  end;

var
  fProdutoProc: TfProdutoProc;

implementation

{$R *.lfm}

{ TfProdutoProc }

procedure TfProdutoProc.Edit1Enter(Sender: TObject);
begin

end;

procedure TfProdutoProc.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    busca(Edit1.Text, Edit2.Text);
  end;

end;

procedure TfProdutoProc.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    busca(Edit1.Text, Edit2.Text);
  end;
end;

procedure TfProdutoProc.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
end;

procedure TfProdutoProc.DBGrid1CellClick(Column: TColumn);
begin
  codProduto:= dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
  produto   := dm.sqProc.FieldByName('PRODUTO').AsString;
  codProd   := dm.sqProc.FieldByName('CODPRO').AsString;
  Close;
end;

procedure TfProdutoProc.btnPROCClick(Sender: TObject);
begin
  busca(Edit1.Text, Edit2.Text);
end;

procedure TfProdutoProc.btnEXCClick(Sender: TObject);
begin
  Edit1.Text:='';
  Edit2.Text:='';
end;

procedure TfProdutoProc.btnSALVClick(Sender: TObject);
begin
  codProduto:= dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
  produto   := dm.sqProc.FieldByName('PRODUTO').AsString;
  Close;
end;

procedure TfProdutoProc.FormCreate(Sender: TObject);
begin
  DBGrid1.Columns[0].FieldName:='CODPRO';
  DBGrid1.Columns[0].Title.Caption := 'Cód.';
  DBGrid1.Columns[1].FieldName:='PRODUTO';
  DBGrid1.Columns[1].Title.Caption := 'Descrição';
  DBGrid1.Columns[2].FieldName:='UNIDADEMEDIDA';
  DBGrid1.Columns[2].Title.Caption := 'Un.';
  DBGrid1.Columns[3].FieldName:='ESTOQUEATUAL';
  DBGrid1.Columns[3].Title.Caption := 'Estoque';
end;

procedure TfProdutoProc.FormKeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TfProdutoProc.FormShow(Sender: TObject);
begin
  codProduto:=0;
  produto:='';
  codProd:='';
end;

procedure TfProdutoProc.busca(codigo: String; produtoDesc: String);
var sqlProc: String;
begin
  sqlProc := 'SELECT * FROM PRODUTOS ';
  sqlProc := sqlProc + 'WHERE ((USA IS NULL) OR (USA <> ' +
    QuotedStr('N') + '))';
  if (chInativo.Checked) then
  begin
    sqlProc := 'SELECT * FROM PRODUTOS WHERE USA = ' +
      QuotedStr('N');
  end;
  if (codigo <> '') then
  begin
    sqlProc := sqlProc + ' AND CODPRO = ' + QuotedStr(codigo);
  end;
  if (produtoDesc <> '') then
  begin
    sqlProc := sqlProc + ' AND UPPER(PRODUTO) LIKE UPPER(' +
      QuotedStr('%' + produtoDesc + '%') + ')';
  end;
  if (dm.sqProc.Active) then
    dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add(sqlProc);
  dsProc.DataSet.Active:=True;
  if (not dm.sqProc.IsEmpty) then
  begin
    codProduto := dm.sqProc.FieldByName('CODPRODUTO').AsInteger;
    produto    := dm.sqProc.FieldByName('PRODUTO').AsString;
    codProd    := dm.sqProc.FieldByName('CODPRO').AsString;
    TNumericField(dm.sqProc.FieldByName('ESTOQUEATUAL')).DisplayFormat:=',##0.0';
  end;
end;

end.

