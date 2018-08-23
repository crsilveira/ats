unit uLoteLancar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DBGrids, DbCtrls, uPadrao,
  ACBrValidador, ACBrETQ, uDm, ACBrDevice;

type

  { TfLoteLancar }

  TfLoteLancar = class(TfPadrao)
    ACBrETQ1: TACBrETQ;
    ACBrValidador1: TACBrValidador;
    btnImp: TBitBtn;
    btnAmostra: TBitBtn;
    btnProdutoProc: TBitBtn;
    cbBackFeed: TComboBox;
    cbDPI: TComboBox;
    cbLocal: TComboBox;
    cbModelo: TComboBox;
    cbPorta: TComboBox;
    DBText1: TDBText;
    dsLote: TDataSource;
    DBGrid1: TDBGrid;
    eAvanco: TEdit;
    edData: TDateTimePicker;
    edCodProduto: TEdit;
    edQuantidade: TEdit;
    edProduto: TEdit;
    edLote: TEdit;
    eTemperatura: TEdit;
    eVelocidade: TEdit;
    Label1: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label25: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure btnAmostraClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnImpClick(Sender: TObject);
    procedure btnCANCClick(Sender: TObject);
    procedure btnEDTClick(Sender: TObject);
    procedure btnINCClick(Sender: TObject);
    procedure btnPROCClick(Sender: TObject);
    procedure btnProdutoProcClick(Sender: TObject);
    procedure btnSALVClick(Sender: TObject);
    procedure cbModeloChange(Sender: TObject);
    procedure cbPortaChange(Sender: TObject);
    procedure edCodProdutoChange(Sender: TObject);
    procedure edCodProdutoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
  private
    codProduto: Integer;
    procedure AtivarACBrETQ1 ;
  public

  end;

var
  fLoteLancar: TfLoteLancar;

implementation

uses uProdutoProc, uLoteBusca;

{$R *.lfm}

{ TfLoteLancar }


procedure TfLoteLancar.FormShow(Sender: TObject);
begin
  inherited;
  cbPorta.Enabled:= true;
  if (dm.sqPlano.Active) then
    dm.sqPlano.Close;
  dm.sqPlano.SQL.Clear;
  dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
    ' WHERE CONTAPAI = ' + QuotedStr(dm.ccusto) +
    '   AND CONSOLIDA = ' + QuotedStr('S'));
  dm.sqPlano.Active:=True;
  cbLocal.Items.Clear;
  While not dm.sqPlano.EOF do begin
    cbLocal.Items.Add(dm.sqPlanoNOME.AsString);
    dm.sqPlano.Next;
  end;
end;

procedure TfLoteLancar.Panel3Click(Sender: TObject);
begin

end;



procedure TfLoteLancar.Panel4Click(Sender: TObject);
begin

end;

procedure TfLoteLancar.btnProdutoProcClick(Sender: TObject);
begin
  fProdutoProc.ShowModal;
  edCodProduto.Text:= fProdutoProc.codProd;
  edProduto.Text   := fProdutoProc.produto;
  codProduto       := fProdutoProc.codProduto;
end;

procedure TfLoteLancar.btnPROCClick(Sender: TObject);
begin
  //inherited;
  fLoteBuscar.ShowModal;
  if (fLoteBuscar.codigoLote <> '') then
  begin
    dsLote.DataSet.Active:=False;
    dm.sqLote.Params.ParamByName('PLOTE').AsString:=fLoteBuscar.codigoLote;
    dm.sqLote.Params.ParamByName('PCODPRODUTO').AsInteger:=fLoteBuscar.LoteCodProduto;
    dm.sqLote.Params.ParamByName('PCCUSTO').AsInteger:=fLoteBuscar.LoteCCusto;
    dsLOte.DataSet.Active:=True;
  end;
end;

procedure TfLoteLancar.btnINCClick(Sender: TObject);
begin
  inherited;
  edData.Date       :=Date;
  edCodProduto.Text := '';
  edProduto.Text    := '';
  edQuantidade.Text := '';
  cbLocal.ItemIndex := -1;
  edLote.Text       := '';
  dsLote.DataSet.Active:=False;
end;

procedure TfLoteLancar.btnEDTClick(Sender: TObject);
begin
  //inherited;
  ShowMessage('Não é possível alterar o lote, Exclua e Inclua novamente.');
end;

procedure TfLoteLancar.btnCANCClick(Sender: TObject);
begin
  inherited;
end;

procedure TfLoteLancar.btnImpClick(Sender: TObject);
var barcode: String;
  lote_bar: string;
  descricao , empresa , data_lote: string ;
begin
  barcode := FormatFloat('00000', dm.sqLoteCODPRODUTO.AsInteger);
  barcode := '21' + barcode;
  lote_bar := FormatFloat('00000', dm.sqLoteCODLOTE.AsInteger);
  barcode := barcode + lote_bar;
  ACBrValidador1.Documento   := barcode;
  ACBrValidador1.Complemento := '0';
  ACBrValidador1.IgnorarChar := './-';
  ACBrValidador1.Validar;
  lote_bar := ACBrValidador1.DigitoCalculado;
  //barcode := Copy(barcode,1,12)+lote_bar;

  dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add('SELECT EMPRESA FROM EMPRESA');
  dm.sqProc.Open;
  empresa := dm.sqProc.FieldByName('EMPRESA').AsString;

  AtivarACBrETQ1;
  with ACBrETQ1 do
  begin
    descricao := dm.sqLoteCODPRO.AsString ;
    data_lote := FormatDateTime( 'mm-dd-yyyy', dm.sqLoteDATAFABRICACAO.AsDateTime);
    ImprimirTexto(orNormal, 0, 2, 2, 10, 85, empresa, 0, True);
    ImprimirTexto(orNormal, 0, 1, 2, 23, 85, data_lote);
    ImprimirTexto(orNormal, 0, 1, 2, 23, 245, Copy(descricao,1,60));
    ImprimirBarras(orNormal, 'E30', '1', '2', 38, 110, barcode, 50, becSIM);
    Imprimir((dm.sqLoteESTOQUE.AsInteger));
    Desativar;
  end;



end;

procedure TfLoteLancar.btnAmostraClick(Sender: TObject);
var barcode: String;
  lote_bar: string;
  descricao , empresa , data_lote: string ;
begin
  barcode := FormatFloat('00000', dm.sqLoteCODPRODUTO.AsInteger);
  barcode := '21' + barcode;
  lote_bar := FormatFloat('00000', dm.sqLoteCODLOTE.AsInteger);
  barcode := barcode + lote_bar;
  ACBrValidador1.Documento   := barcode;
  ACBrValidador1.Complemento := '0';
  ACBrValidador1.IgnorarChar := './-';
  ACBrValidador1.Validar;
  lote_bar := ACBrValidador1.DigitoCalculado;
  //barcode := Copy(barcode,1,12)+lote_bar;

  dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add('SELECT EMPRESA FROM EMPRESA');
  dm.sqProc.Open;
  empresa := dm.sqProc.FieldByName('EMPRESA').AsString;

  AtivarACBrETQ1;
  with ACBrETQ1 do
  begin
    descricao := dm.sqLoteCODPRO.AsString ;
    data_lote := FormatDateTime( 'mm-dd-yyyy', dm.sqLoteDATAFABRICACAO.AsDateTime);
    ImprimirTexto(orNormal, 0, 2, 2, 10, 85, empresa, 0, True);
    ImprimirTexto(orNormal, 0, 1, 2, 23, 85, data_lote);
    ImprimirTexto(orNormal, 0, 1, 2, 23, 245, Copy(descricao,1,60));
    ImprimirBarras(orNormal, 'E30', '1', '2', 38, 110, barcode, 50, becSIM);
    Imprimir((1));
    Desativar;
  end;

end;

procedure TfLoteLancar.btnCloseClick(Sender: TObject);
begin
  inherited;
  dsLote.DataSet.Close;
end;



procedure TfLoteLancar.btnSALVClick(Sender: TObject);
var num_compra: Integer;
  num_lote: Integer;
  sql_inc_lote: String;
  qtde_float: Double;
begin
  if (edQuantidade.Text = '') then
  begin
    ShowMessage('Informe a Quantidade do Lote.');
    edQuantidade.SetFocus;
    Exit;
  end;
  if (edCodProduto.Text = '') then
  begin
    ShowMessage('Informe o Produto.');
    edCodProduto.SetFocus;
    Exit;
  end;
  if (cbLocal.Text = '') then
  begin
    ShowMessage('Informe o Local.');
    cbLocal.SetFocus;
    Exit;
  end;
  if (dm.sqPlano.Active) then
    dm.sqPlano.Close;
  dm.sqPlano.SQL.Clear;
  dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
    ' WHERE NOME = ' + QuotedStr(cbLocal.Text));
  dm.sqPlano.Active:=True;
  if (dm.sqPlano.IsEmpty) then
  begin
    ShowMessage('Local informado inválido, selecione um na Lista');
    cbLocal.SetFocus;
    Exit;
  end;

  dm.sqGen.Active:=False;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GEN_LOTE, 1) AS CHAVE_ID ' +
    ' FROM RDB$DATABASE');
  dm.sqGen.Active:=True;
  num_lote := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;

  if (edLote.Text = '') then
  begin
    edLote.Text := IntToStr(num_lote);
  end;
  fLoteBuscar.codigoLote := '';
  fLoteBuscar.busca(edLote.Text, IntToStr(codProduto), IntToStr(dm.sqPlanoCODIGO.AsInteger));
  if (fLoteBuscar.codigoLote <> '') then
  begin
    ShowMessage('Lote já cadastrado.');
    Exit;
  end;

  dm.sqGen.Active:=False;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GENMOV, 1) AS CHAVE_ID ' +
    ' FROM RDB$DATABASE');
  dm.sqGen.Active:=True;

  dm.sqMov.Active:=True;
  dm.sqMov.Insert;
  dm.sqMovCODMOVIMENTO.AsInteger    := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;
  dm.sqMovCODALMOXARIFADO.AsInteger := dm.sqPlanoCODIGO.AsInteger;
  dm.sqMovCODCLIENTE.AsInteger      := 0;
  dm.sqMovCODNATUREZA.AsInteger     := 1; // Entrada
  dm.sqMovCODUSUARIO.AsInteger      := 1;
  dm.sqMovCODVENDEDOR.AsInteger     := 1;
  dm.sqMovDATAMOVIMENTO.AsDateTime  := edData.Date;
  dm.sqMovSTATUS.AsInteger          := 0;
  dm.sqMov.Post;

  dm.sqGen.Close;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GENMOVDET, 1) AS CHAVE_ID ' +
    ' FROM RDB$DATABASE');
  dm.sqGen.Active:=True;

  dm.sqMovDet.Active:=True;
  dm.sqMovDet.Insert;
  dm.sqMovDetCODMOVIMENTO.AsInteger := dm.sqMovCODMOVIMENTO.AsInteger;
  dm.sqMovDetCODDETALHE.AsInteger   := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;
  dm.sqMovDetCODPRODUTO.AsInteger   := codProduto;
  dm.sqMovDetDESCPRODUTO.AsString   := edProduto.Text;
  dm.sqMovDetQUANTIDADE.AsFloat     := StrToFloat(edQuantidade.Text);
  dm.sqMovDetDTAFAB.AsDateTime      := edData.Date;
  dm.sqMovDetPRECO.AsFloat          := 1;
  dm.sqMovDetLOTE.AsString          := edLote.Text;
  dm.sqMovDet.Post;

  dm.sqGen.Close;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GEN_COD_COMPRA, 1) AS CHAVE_ID ' +
    ' FROM RDB$DATABASE');
  dm.sqGen.Active:=True;

  num_compra := dm.atualiza_serie('I');
  dm.sqCompra.Active:=True;
  dm.sqCompra.Insert;
  dm.sqCompraCODCOMPRA.AsInteger    := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;
  dm.sqCompraCODMOVIMENTO.AsInteger := dm.sqMovCODMOVIMENTO.AsInteger;
  dm.sqCompraCODFORNECEDOR.AsInteger:= 0;
  dm.sqCompraDATACOMPRA.AsDateTime  := edData.Date;
  dm.sqCompraDATAVENCIMENTO.AsDateTime  := edData.Date;
  dm.sqCompraCODCCUSTO.AsInteger    := dm.sqMovCODALMOXARIFADO.AsInteger;
  dm.sqCompraCODUSUARIO.AsInteger   := 1;
  dm.sqCompraSERIE.AsString         := 'I'; // serie entrada
  dm.sqCompraNOTAFISCAL.AsInteger   := num_compra;
  dm.sqCompra.Post;

  sql_inc_lote := 'INSERT INTO LOTES (CODLOTE, LOTE, CODPRODUTO, ' +
    ' DATAFABRICACAO, DATAVENCIMENTO, ESTOQUE, PRECO, CCUSTO) VALUES (';
  sql_inc_lote += IntToStr(num_lote);
  if (edLote.Text = '') then
  begin
    sql_inc_lote += ', ' + QuotedStr(IntToStr(num_lote));
  end
  else begin
    sql_inc_lote += ', ' + QuotedStr(edLote.Text);
  end;
  sql_inc_lote += ', ' + IntToStr(codProduto);
  sql_inc_lote += ', ' + QuotedStr(FormatDateTime( 'mm-dd-yyyy', edData.Date));
  sql_inc_lote += ', ' + QuotedStr(FormatDateTime( 'mm-dd-yyyy', edData.Date));
  qtde_float := StrToFloat(edQuantidade.Text);
  DefaultFormatSettings.DecimalSeparator := '.';
  sql_inc_lote += ', ' + FloatToStr(qtde_float);
  DefaultFormatSettings.DecimalSeparator :=',';
  sql_inc_lote += ', 1';
  sql_inc_lote += ', ' + IntToStr(dm.sqPlanoCODIGO.AsInteger);
  sql_inc_lote += ')';
  //dm.sqLote.Active:=False;
  //dm.sqLote.InsertSQL.Add(sql_inc_lote);

  //dm.sqLote.ExecSQL;

  dm.sqMov.ApplyUpdates;
  dm.sqMovDet.ApplyUpdates;
  dm.sqCompra.ApplyUpdates;
  dm.IBCon.ExecuteDirect(sql_inc_lote);
  dm.sTrans.Commit;
  ds.DataSet.Active:=False;

  dsLote.DataSet.Active:=False;
  dm.sqLote.Params.ParamByName('PLOTE').AsString:=edLote.Text;
  dsLote.DataSet.Active:=True;
  inherited;
end;

procedure TfLoteLancar.cbModeloChange(Sender: TObject);
begin

end;

procedure TfLoteLancar.cbPortaChange(Sender: TObject);
begin

end;

procedure TfLoteLancar.edCodProdutoChange(Sender: TObject);
begin

end;

procedure TfLoteLancar.edCodProdutoExit(Sender: TObject);
begin
  if (edCodProduto.Text <> '') then
  begin
    fProdutoProc.busca(edCodProduto.Text,'');
    edProduto.Text := fProdutoProc.produto;
    codProduto := fProdutoProc.codProduto;
  end;
end;

procedure TfLoteLancar.FormCreate(Sender: TObject);
begin
  ds.DataSet:=dm.sqMov;
  inherited;
end;


procedure TfLoteLancar.AtivarACBrETQ1;
begin
  with ACBrETQ1 do
  begin
     DPI           := TACBrETQDPI(cbDPI.ItemIndex);
     Modelo        := TACBrETQModelo(cbModelo.ItemIndex);
     Porta         := cbPorta.Text;
    // LimparMemoria := ckMemoria.Checked;
    // Temperatura   := StrToInt(eTemperatura.Text);
     Velocidade    := StrToInt(eVelocidade.Text);
     BackFeed      := TACBrETQBackFeed(cbBackFeed.ItemIndex);

     Ativar;
  end;
end;

end.

