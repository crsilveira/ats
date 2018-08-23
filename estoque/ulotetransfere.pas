unit uLoteTransfere;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, DBGrids, uPadrao,
  ACBrValidador, uDm;

type

  { TfLoteTransferir }

  TfLoteTransferir = class(TfPadrao)
    ACBrValidador1: TACBrValidador;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    cbLocal: TComboBox;
    cbDestino: TComboBox;
    CheckBox1: TCheckBox;
    dsMovDet: TDataSource;
    DBGrid1: TDBGrid;
    edData: TDateTimePicker;
    edCodBarra: TEdit;
    edLote: TEdit;
    edQuantidade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbCount: TLabel;
    sqLote_Lacto: TSQLQuery;
    sqLote_LactoCCUSTO_ENT: TLongintField;
    sqLote_LactoCCUSTO_SAI: TLongintField;
    sqLote_LactoCODPRO: TStringField;
    sqLote_LactoCODPRODUTO: TLongintField;
    sqLote_LactoDATAFABRICACAO: TDateField;
    sqLote_LactoDATA_LCTO: TDateField;
    sqLote_LactoDESTINO: TStringField;
    sqLote_LactoLANCADO: TSmallintField;
    sqLote_LactoLOTE: TStringField;
    sqLote_LactoORIGEM: TStringField;
    sqLote_LactoPRODUTO: TStringField;
    sqLote_LactoQUANTIDADE: TFloatField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure btnCANCClick(Sender: TObject);
    procedure btnINCClick(Sender: TObject);
    procedure btnSALVClick(Sender: TObject);
    procedure cbDestinoChange(Sender: TObject);
    procedure cbLocalChange(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure edCodBarraEnter(Sender: TObject);
    procedure edCodBarraKeyPress(Sender: TObject; var Key: char);
    procedure edLoteExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    conta: integer;
    codLoteBarra: String;
    codProdBarra: String;
    descProdBarra: String;
    ccusto_origem: Integer;
    ccusto_destino: Integer;
    codMovimento: Integer;
    codLoteID: Integer;
    lote_dataf: TDate;
    procedure InsereItem();
    procedure InsereMov(TipoMov: String);
    procedure buscaProduto(codigoBusca: String);
    procedure insereLote();
    procedure alteraLote(codLt: Integer; tipo: String);
  public

  end;

var
  fLoteTransferir: TfLoteTransferir;

implementation

uses uLoteBusca;

{$R *.lfm}

{ TfLoteTransferir }

procedure TfLoteTransferir.FormShow(Sender: TObject);
begin
  inherited;
  conta := 0;
  codMovimento := 0;
  ccusto_destino :=0;
  ccusto_origem  :=0;
  if (dm.sqPlano.Active) then
    dm.sqPlano.Close;
  dm.sqPlano.SQL.Clear;
  dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
    ' WHERE CONTAPAI = ' + QuotedStr(dm.ccusto) +
    '   AND CONSOLIDA = ' + QuotedStr('S'));
  dm.sqPlano.Active:=True;
  cbLocal.Items.Clear;
  cbDestino.Items.Clear;
  While not dm.sqPlano.EOF do begin
    cbLocal.Items.Add(dm.sqPlanoNOME.AsString);
    cbDestino.Items.Add(dm.sqPlanoNOME.AsString);
    dm.sqPlano.Next;
  end;
  edCodBarra.Enabled:=False;
end;

procedure TfLoteTransferir.InsereItem();
begin
  if ((edCodBarra.Text <> '') and (codLoteBarra = '')) then
  begin
    buscaProduto(edCodBarra.Text);
  end;
  if ((edLote.Text <> '') and (codLoteBarra = '')) then
    buscaProduto(edLote.Text);

  if (codLoteBarra = '') then
  begin
    ShowMessage('Lote não encontrado.');
    Abort;
  end;
  if (codProdBarra = '') then
  begin
    ShowMessage('Produto não encontrado.');
    Abort;
  end;

  dm.sqGen.Close;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GENMOVDET, 1) AS CHAVE_ID ' +
    ' FROM RDB$DATABASE');
  dm.sqGen.Active:=True;

  if (not dm.sqMovDet.Active) then
    dm.sqMovDet.Active := True;
  dm.sqMovDet.Insert;
  dm.sqMovDetCODMOVIMENTO.AsInteger := dm.sqMovCODMOVIMENTO.AsInteger;
  dm.sqMovDetCODDETALHE.AsInteger   := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;
  dm.sqMovDetCODPRODUTO.AsInteger   := sqLote_LactoCODPRODUTO.AsInteger;
  dm.sqMovDetDESCPRODUTO.AsString   := sqLote_LactoPRODUTO.AsString;
  dm.sqMovDetQUANTIDADE.AsFloat     := sqLote_LactoQUANTIDADE.AsFloat;
  dm.sqMovDetDTAVCTO.AsDateTime     := sqLote_LactoDATA_LCTO.AsDateTime;
  dm.sqMovDetPRECO.AsFloat          := 1;
  dm.sqMovDetLOTE.AsString          := sqLote_LactoLOTE.AsString;
  dm.sqMovDet.Post;
end;

procedure TfLoteTransferir.InsereMov(TipoMov: String);
begin
  if (TipoMov = 'E') then
  begin
    if (cbLocal.Text = '') then
    begin
      ShowMessage('Informe o Local');
      cbLocal.SetFocus;
      Abort;
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
      Abort;
    end;
    ccusto_origem:= dm.sqPlanoCODIGO.AsInteger;
  end;
  if (TipoMov = 'S') then
  begin
    if (cbDestino.Text = '') then
    begin
      ShowMessage('Informe o Local de destino.');
      cbDestino.SetFocus;
      Abort;
    end;
    if (dm.sqPlano.Active) then
      dm.sqPlano.Close;
    dm.sqPlano.SQL.Clear;
    dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
      ' WHERE NOME = ' + QuotedStr(cbDestino.Text));
    dm.sqPlano.Active:=True;
    if (dm.sqPlano.IsEmpty) then
    begin
      ShowMessage('Local informado inválido, selecione um na Lista');
      cbDestino.SetFocus;
      Abort;
    end;
    ccusto_destino:= dm.sqPlanoCODIGO.AsInteger;
  end;
  dm.sqGen.Active:=False;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GENMOV, 1) AS CHAVE_ID ' +
     ' FROM RDB$DATABASE');
    dm.sqGen.Active:=True;
  dm.sqGen.ApplyUpdates;
  codMovimento := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;

  dm.sqMovCODMOVIMENTO.AsInteger    := codMovimento;

  dm.sqMovCODCLIENTE.AsInteger      := 0;
  if (TipoMov = 'E') then
  begin
    dm.sqMovCODNATUREZA.AsInteger     := 1; // Entrada
    dm.sqMovCODALMOXARIFADO.AsInteger := sqLote_LactoCCUSTO_ENT.AsInteger;
  end;
  if (TipoMov = 'S') then
  begin
    dm.sqMovCODNATUREZA.AsInteger     := 2; // Saida
    dm.sqMovCODALMOXARIFADO.AsInteger := sqLote_LactoCCUSTO_SAI.AsInteger;
  end;

  dm.sqMovCODUSUARIO.AsInteger      := 1;
  dm.sqMovCODVENDEDOR.AsInteger     := 1;
  dm.sqMovDATAMOVIMENTO.AsDateTime  := sqLote_LactoDATA_LCTO.AsDateTime;
  dm.sqMovDATA_SISTEMA.AsDateTime   := edData.DateTime;
  dm.sqMovSTATUS.AsInteger          := 0;
  dm.sqMov.Post;

end;

procedure TfLoteTransferir.buscaProduto(codigoBusca: String);
  var sqlProc: String;
begin
  codProdBarra := '';
  if (Length(codigoBusca) > 6) then
  begin
    codProdBarra := Copy(codigoBusca, 3,5);
    codLoteBarra:= Copy(codigoBusca, 8,5);
    sqlProc := 'SELECT * FROM PRODUTOS ';
    sqlProc := sqlProc + 'WHERE CODPRODUTO = ' + codProdBarra;
  end
  else begin
    sqlProc := 'SELECT L.*, p.CODPRODUTO, p.PRODUTO FROM LOTES L, PRODUTOS P ';
    sqlProc += 'WHERE L.CODPRODUTO = p.CODPRODUTO ';
    sqlProc += '  AND L.LOTE = ' + QuotedStr(codigoBusca);
    sqlProc += '  AND L.CCUSTO = ' + IntToStr(ccusto_origem);
    sqlProc += '  AND L.ESTOQUE > 0';
  end;
  if (dm.sqProc.Active) then
    dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add(sqlProc);
  dm.sqProc.Active:=True;
  if (not dm.sqProc.IsEmpty) then
  begin
    codProdBarra := IntToStr(dm.sqProc.FieldByName('CODPRODUTO').AsInteger);
    descProdBarra := dm.sqProc.FieldByName('PRODUTO').AsString;
  end else
  begin
    ShowMessage('Lote não encontrado.');
    Abort;
  end;
  sqlProc := 'SELECT * FROM LOTES ';
  sqlProc := sqlProc + 'WHERE CODPRODUTO = ' + codProdBarra;
  sqlProc := sqlProc + '  AND LOTE = ' + QuotedStr(codLoteBarra);
  sqlProc := sqlProc + '  AND CCUSTO = ' + IntToStr(ccusto_origem);
  sqlProc := sqlProc + '  AND ESTOQUE > 0';
  dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add(sqlProc);
  dm.sqProc.Active:=True;
  codLoteBarra := '';
  if (not dm.sqProc.IsEmpty) then
  begin
    codLoteBarra := dm.sqProc.FieldByName('LOTE').AsString;
    codLoteID    := dm.sqProc.FieldByName('CODLOTE').AsInteger;
    edQuantidade.Text:= FloatToStr(dm.sqProc.FieldByName('ESTOQUE').AsFloat);
    if (edLote.Text = '') then
      edLote.Text:= dm.sqProc.FieldByName('LOTE').AsString;
  end;

end;

procedure TfLoteTransferir.insereLote();
var sql_lote:String;
  sql_inc_lote: string;
  qtde_float: Double;
begin
  dm.sqGen.Active:=False;
  dm.sqGen.SQL.Clear;
  dm.sqGen.SQL.Add('SELECT  GEN_ID(GEN_LOTE, 1) AS CHAVE_ID ' +
    ' FROM RDB$DATABASE');
  dm.sqGen.Active:=True;

  sql_inc_lote := 'INSERT INTO LOTES (CODLOTE, LOTE, CODPRODUTO, ' +
    ' DATAFABRICACAO, DATAVENCIMENTO, ESTOQUE, PRECO, CCUSTO) VALUES (';
  sql_inc_lote += IntToStr(dm.sqGen.FieldByName('CHAVE_ID').AsInteger);
  sql_inc_lote += ', ' + QuotedStr(sqLote_LactoLOTE.AsString);
  sql_inc_lote += ', ' + IntToStr(sqLote_LactoCODPRODUTO.AsInteger);
  sql_inc_lote += ', ' + QuotedStr(FormatDateTime( 'mm-dd-yyyy', lote_dataf));
  sql_inc_lote += ', ' + QuotedStr(FormatDateTime( 'mm-dd-yyyy', sqLote_LactoDATA_LCTO.AsDateTime));
  qtde_float := sqLote_LactoQUANTIDADE.AsFloat;
  DecimalSeparator := '.';
  sql_inc_lote += ', ' + FloatToStr(qtde_float);
  DecimalSeparator := ',';
  sql_inc_lote += ', 1';
  sql_inc_lote += ', ' + IntToStr(sqLote_LactoCCUSTO_ENT.AsInteger);
  sql_inc_lote += ')';
  //dm.sqLote.Active:=False;
  //dm.sqLote.InsertSQL.Add(sql_inc_lote);
  //dm.sqLote.ExecSQL;
  dm.IBCon.ExecuteDirect(sql_inc_lote);
end;

procedure TfLoteTransferir.alteraLote(codLt: Integer; tipo: String);
var sql_lote:String;
  qtde_float: Double;
begin
  // fazendo a busca novamente, pq preciso do estoque
  sql_lote := 'SELECT * FROM LOTES ';
  sql_lote += ' WHERE CODLOTE = ' + IntToStr(codLt);
  dm.sqProc.Close;
  dm.sqProc.SQL.Clear;
  dm.sqProc.SQL.Add(sql_lote);
  dm.sqProc.Active:=True;
  if (not dm.sqProc.IsEmpty) then
  begin
    sql_lote := 'UPDATE LOTES SET DATAVENCIMENTO = ';
    sql_lote += QuotedStr(FormatDateTime( 'mm-dd-yyyy', sqLote_LactoDATA_LCTO.AsDateTime));
    sql_lote += ', ESTOQUE = ';
    if (tipo = 'E') then // Entrada
    begin
      qtde_float := sqLote_LactoQUANTIDADE.AsFloat;
      qtde_float := dm.sqProc.FieldByName('ESTOQUE').AsFloat + qtde_float;
    end;
    if (tipo = 'S') then // Saida
    begin
      if (dm.sqProc.FieldByName('ESTOQUE').AsFloat < sqLote_LactoQUANTIDADE.AsFloat) then
      begin
        ShowMessage('Quantidade maior que a existente do lote.');
        Abort;
      end;
      qtde_float := sqLote_LactoQUANTIDADE.AsFloat;
      qtde_float := dm.sqProc.FieldByName('ESTOQUE').AsFloat - qtde_float;
    end;
    DefaultFormatSettings.DecimalSeparator := '.';
    sql_lote += FloatToStr(qtde_float);
    DefaultFormatSettings.DecimalSeparator := ',';
    sql_lote += ' WHERE CODLOTE = ' + IntToStr(dm.sqProc.FieldByName('CODLOTE').AsInteger);
    dm.IBCon.ExecuteDirect(sql_lote);
  end;
end;

procedure TfLoteTransferir.cbLocalChange(Sender: TObject);
begin
  if (not dm.sqPlano.Active) then
  begin
    dm.sqPlano.SQL.Clear;
    dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
      ' WHERE CONTAPAI = ' + QuotedStr(dm.ccusto) +
      '   AND CONSOLIDA = ' + QuotedStr('S'));
    dm.sqPlano.Active:=True;
  end;
  dm.sqPlano.First;
  cbDestino.Items.Clear;
  While not dm.sqPlano.EOF do begin
    if (cbLocal.Text = dm.sqPlanoNOME.AsString) then
      ccusto_origem := dm.sqPlanoCODIGO.AsInteger;
    if (cbLocal.Text <> dm.sqPlanoNOME.AsString) then
      cbDestino.Items.Add(dm.sqPlanoNOME.AsString);
    dm.sqPlano.Next;
  end;
end;

procedure TfLoteTransferir.CheckBox1Change(Sender: TObject);
begin
  if (CheckBox1.Checked) then
  begin
    edCodBarra.Enabled:=True;
    if (ccusto_origem = 0) then
    begin
      if (dm.sqPlano.Active) then
        dm.sqPlano.Close;
      dm.sqPlano.SQL.Clear;
      dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
        ' WHERE NOME = ' + QuotedStr(cbLocal.Text));
      dm.sqPlano.Active:=True;
      if (dm.sqPlano.IsEmpty) then
      begin
        ShowMessage('Local Origem não informado, selecione um na Lista');
        cbLocal.SetFocus;
        Abort;
      end;
      ccusto_origem:= dm.sqPlanoCODIGO.AsInteger;
    end;
    if (ccusto_destino = 0) then
    begin
      if (dm.sqPlano.Active) then
        dm.sqPlano.Close;
      dm.sqPlano.SQL.Clear;
      dm.sqPlano.SQL.Add('SELECT * FROM PLANO ' +
        ' WHERE NOME = ' + QuotedStr(cbDestino.Text));
      dm.sqPlano.Active:=True;
      if (dm.sqPlano.IsEmpty) then
      begin
        ShowMessage('Local Destino não informado, selecione um na Lista');
        cbDestino.SetFocus;
        Abort;
      end;
      ccusto_destino:= dm.sqPlanoCODIGO.AsInteger;
    end;

    edCodBarra.Enabled:=CheckBox1.Checked;
    sqLote_Lacto.Params.ParamByName('PCCUSTO').AsInteger:=ccusto_origem;
    sqLote_Lacto.Active:=True;
    lbCount.Caption:=IntToStr(sqLote_Lacto.RecordCount);
    edCodBarra.SetFocus;
  end
  else
    edCodBarra.Enabled:=False;
end;

procedure TfLoteTransferir.btnSALVClick(Sender: TObject);
var num_chave: Integer;
  sqlproc: String;
  insere_lacto: String;
  qtde_float: Double;
begin
  sqlproc := 'SELECT L.LOTE, L.CODPRODUTO, SUM(L.QUANTIDADE) QUANTIDADE,' +
    ' L.DATA_LCTO, L.CCUSTO_SAI, L.CCUSTO_ENT, L.LANCADO, p.CODPRO,' +
    ' p.PRODUTO, plo.NOME as ORIGEM, pld.NOME as DESTINO ' +
    ' , LT.DATAFABRICACAO ' +
    ' FROM LOTE_LACTO L, PRODUTOS p, LOTES LT ' +
    ' INNER JOIN PLANO plo on plo.CODIGO = L.CCUSTO_SAI ' +
    ' INNER JOIN PLANO pld on pld.CODIGO = L.CCUSTO_ENT ' +
    ' WHERE L.CODPRODUTO = p.CODPRODUTO ' +
    '   AND LT.LOTE = L.LOTE ' +
    '   AND L.LANCADO = 0 ' +
    '   AND L.CCUSTO_SAI = :PCCUSTO ' +
    ' GROUP BY L.LOTE, L.CODPRODUTO,L.DATA_LCTO, L.CCUSTO_SAI,L.CCUSTO_ENT,' +
    ' L.LANCADO, p.CODPRO, p.PRODUTO, plo.NOME, pld.NOME, LT.DATAFABRICACAO  ';
  sqLote_Lacto.Active:=False;
  sqLote_Lacto.SQL.Clear;
  sqLote_Lacto.SQL.Add(sqlproc);
  //sqLote_Lacto.ExecSQL;
  sqLote_Lacto.Params.ParamByName('PCCUSTO').AsInteger:=ccusto_origem;
  sqLote_Lacto.Active:=True;
  if (sqLote_Lacto.IsEmpty) then
  begin
    // inserindo lote manual
    insere_lacto := 'INSERT INTO LOTE_LACTO(LOTE, CODPRODUTO, QUANTIDADE, DATA_LCTO, ' +
      'CCUSTO_SAI, CCUSTO_ENT, LANCADO) VALUES (';
    insere_lacto += QuotedStr(codLoteBarra);
    insere_lacto += ', ' + codProdBarra;
    qtde_float := StrToFloat(edQuantidade.Text);
    DefaultFormatSettings.DecimalSeparator := '.';
    insere_lacto += ', ' + FloatToStr(qtde_float);
    DefaultFormatSettings.DecimalSeparator := ',';
    insere_lacto += ', ' + QuotedStr(FormatDateTime( 'mm-dd-yyyy', edData.Date));
    insere_lacto += ', ' + IntToStr(ccusto_origem);
    insere_lacto += ', ' + IntToStr(ccusto_destino);
    insere_lacto += ', 0';
    insere_lacto += ')';
    dm.IBCon.ExecuteDirect(insere_lacto);
    sqLote_Lacto.Active:=False;
    sqLote_Lacto.Active:=True;
  end;
  lote_dataf := sqLote_Lacto.FieldByName('DATAFABRICACAO').AsDateTime;
  While not sqLote_Lacto.EOF do
  begin
    if (sqLote_LactoLOTE.AsString = '') then
      sqLote_Lacto.Next;
    if (dm.sqMovCODMOVIMENTO.AsInteger = 0) then
    begin
      InsereMov('S');
      //if (sqLote_LactoLOTE.AsString <> '') then
      //begin
        codLoteBarra := sqLote_LactoLOTE.AsString;;
        codProdBarra := IntToStr(sqLote_LactoCODPRODUTO.AsInteger);
        InsereItem();
      //end;
    end;
    // Insiro a Saida Primeiro por causa do estoque
    dm.sqGen.Close;
    dm.sqGen.SQL.Clear;
    dm.sqGen.SQL.Add('SELECT  GEN_ID(GENVENDA, 1) AS CHAVE_ID ' +
      ' FROM RDB$DATABASE');
    dm.sqGen.Active:=True;

    num_chave := dm.atualiza_serie('O');
    dm.sqVenda.Active:=True;
    dm.sqVenda.Insert;
    dm.sqVendaCODVENDA.AsInteger    := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;
    dm.sqVendaCODMOVIMENTO.AsInteger := dm.sqMovCODMOVIMENTO.AsInteger;
    dm.sqVendaCODCLIENTE.AsInteger:= 0;
    dm.sqVendaDATAVENDA.AsDateTime  := sqLote_LactoDATA_LCTO.AsDateTime;
    dm.sqVendaDATAVENCIMENTO.AsDateTime  := sqLote_LactoDATA_LCTO.AsDateTime;
    dm.sqVendaCODCCUSTO.AsInteger    := sqLote_LactoCCUSTO_SAI.AsInteger;
    dm.sqVendaCODUSUARIO.AsInteger   := 1;
    dm.sqVendaCODVENDEDOR.AsInteger  := 1;
    dm.sqVendaSERIE.AsString         := 'O'; // serie entrada
    dm.sqVendaNOTAFISCAL.AsInteger   := num_chave;
    dm.sqVenda.Post;

    dm.sqMov.ApplyUpdates;
    dm.sqMovDet.ApplyUpdates;
    dm.sqVenda.ApplyUpdates;

    //dar baixa no lote
    alteraLote(codLoteID, 'S');

    // Inserindo a Entrada no novo Local
    if (not dm.sqMov.Active) then
    begin
       dm.sqMov.Active:=True;
    end;
    dm.sqMov.Insert;

    InsereMov('E');
    if ((edLote.Text <> '') or (edCodBarra.Text <> '')) then
      InsereItem();

    dm.sqGen.Close;
    dm.sqGen.SQL.Clear;
    dm.sqGen.SQL.Add('SELECT  GEN_ID(GEN_COD_COMPRA, 1) AS CHAVE_ID ' +
      ' FROM RDB$DATABASE');
    dm.sqGen.Active:=True;

    num_chave := dm.atualiza_serie('I');
    dm.sqCompra.Active:=True;
    dm.sqCompra.Insert;
    dm.sqCompraCODCOMPRA.AsInteger    := dm.sqGen.FieldByName('CHAVE_ID').AsInteger;
    dm.sqCompraCODMOVIMENTO.AsInteger := dm.sqMovCODMOVIMENTO.AsInteger;
    dm.sqCompraCODFORNECEDOR.AsInteger:= 0;
    dm.sqCompraDATACOMPRA.AsDateTime  := sqLote_LactoDATA_LCTO.AsDateTime;
    dm.sqCompraDATAVENCIMENTO.AsDateTime  := sqLote_LactoDATA_LCTO.AsDateTime;
    dm.sqCompraCODCCUSTO.AsInteger    := sqLote_LactoCCUSTO_ENT.AsInteger;
    dm.sqCompraCODUSUARIO.AsInteger   := 1;
    dm.sqCompraSERIE.AsString         := 'I'; // serie entrada
    dm.sqCompraNOTAFISCAL.AsInteger   := num_chave;
    dm.sqCompra.Post;

    // ja existe este lote neste local ?
    sqlProc := 'SELECT * FROM LOTES ';
    sqlProc := sqlProc + 'WHERE CODPRODUTO = ' + IntToStr(sqLote_LactoCODPRODUTO.AsInteger);
    sqlProc := sqlProc + '  AND LOTE = ' + QuotedStr(sqLote_LactoLOTE.AsString);
    sqlProc := sqlProc + '  AND CCUSTO = ' + IntToStr(sqLote_LactoCCUSTO_ENT.AsInteger);
    dm.sqProc.Close;
    dm.sqProc.SQL.Clear;
    dm.sqProc.SQL.Add(sqlProc);
    dm.sqProc.Active:=True;
    if (dm.sqProc.IsEmpty) then
    begin
      insereLote();
    end
    else begin
      alteraLote(dm.sqProc.FieldByName('CODLOTE').AsInteger, 'E');
    end;
    dm.sqMov.ApplyUpdates;
    dm.sqMovDet.ApplyUpdates;
    dm.sqCompra.ApplyUpdates;
    dm.IBCon.ExecuteDirect('UPDATE LOTE_LACTO SET LANCADO = 1 ' +
      'WHERE LANCADO = 0 ' +
      ' AND LOTE = ' + QuotedStr(sqLote_LactoLOTE.AsString) +
      ' AND CODPRODUTO = ' + IntToStr(sqLote_LactoCODPRODUTO.AsInteger) +
      ' AND CCUSTO_SAI = ' + IntToStr(sqLote_LactoCCUSTO_SAI.AsInteger));
    ds.DataSet.Active:=False;
    dm.sqMov.Params.ParamByName('PCODMOV').AsInteger:=codMovimento;
    dm.sqMovDet.Params.ParamByName('PCODMOV').AsInteger:=codMovimento;
    //dm.sqLote.Params.ParamByName('PLOTE').AsString:=edLote.Text;
    ds.DataSet.Active:=True;
    sqLote_Lacto.Next;
  end;
  inherited;
  dm.sTrans.Commit;
  dsMovDet.DataSet.Active:=False;
  dsMovDet.DataSet.Active:=True;
  ShowMessage('Transferencia realizada com sucesso.');
end;

procedure TfLoteTransferir.cbDestinoChange(Sender: TObject);
begin
  dm.sqPlano.First;
  While not dm.sqPlano.EOF do begin
    if (cbDestino.Text = dm.sqPlanoNOME.AsString) then
      ccusto_destino := dm.sqPlanoCODIGO.AsInteger;
    dm.sqPlano.Next;
  end;
end;

procedure TfLoteTransferir.BitBtn1Click(Sender: TObject);
begin
  if (ds.DataSet.State in [dsEdit, dsInsert]) then
  begin
    if (dm.sqMovCODMOVIMENTO.AsInteger = 0) then
    begin
      InsereMov('S');
    end;
    if ((edLote.Text <> '') or (edCodBarra.Text <> '')) then
      InsereItem();
  end;
end;

procedure TfLoteTransferir.BitBtn2Click(Sender: TObject);
begin
  dm.IBCon.ExecuteDirect('DELETE FROM LOTE_LACTO ' +
    ' WHERE CODPRODUTO = ' + IntToStr(sqLote_LactoCODPRODUTO.AsInteger) +
    '   AND LOTE = ' + QuotedStr(sqLote_LactoLOTE.AsString) +
    '   AND CCUSTO_ENT = ' + IntToStr(sqLote_LactoCCUSTO_ENT.AsInteger) +
    '   AND LANCADO = 0');
  dsMovDet.DataSet.Active:=False;
  dsMovDet.DataSet.Active:=True;
  dm.sTrans.Commit;
  ds.DataSet.Active:=True;
end;

procedure TfLoteTransferir.BitBtn3Click(Sender: TObject);
begin
  fLoteBuscar.codigoLote    := '';
  fLoteBuscar.LoteCCusto    := ccusto_origem;
  fLoteBuscar.LoteCodProduto:= 0;
  fLoteBuscar.ShowModal;
  if (fLoteBuscar.codigoLote <> '') then
  begin
    dm.sqLote.Active:=False;
    dm.sqLote.Params.ParamByName('PLOTE').AsString := fLoteBuscar.codigoLote;
    dm.sqLote.Params.ParamByName('PCODPRODUTO').AsInteger := fLoteBuscar.LoteCodProduto;
    dm.sqLote.Params.ParamByName('PCCUSTO').AsInteger := fLoteBuscar.LoteCCusto;
    dm.sqLote.Active:=True;
    if (dm.sqLoteESTOQUE.AsFloat = 0) then
    begin
      ShowMessage('Lote não encontrado neste Local de Origem.');
      Abort;
    end;
    codProdBarra := IntToStr(dm.sqLoteCODPRODUTO.AsInteger);
    descProdBarra:= dm.sqLotePRODUTO.AsString;
    codLoteBarra := dm.sqLoteLOTE.AsString;
    edLote.Text  := dm.sqLoteLOTE.AsString;
    codLoteID    := dm.sqLoteCODLOTE.AsInteger;
    edQuantidade.Text := FloatToStr(dm.sqLoteESTOQUE.AsFloat);
  end;

end;

procedure TfLoteTransferir.btnCANCClick(Sender: TObject);
begin
  inherited;
  cbDestino.ItemIndex:=-1;
  cbLocal.ItemIndex:=-1;
  dsMovDet.DataSet.Active:=False;
  CheckBox1.Checked:=False;
end;

procedure TfLoteTransferir.btnINCClick(Sender: TObject);
begin
  inherited;
  edData.Date:=Date;
  dm.sqMovCODMOVIMENTO.AsInteger:=0;
  edLote.Text       := '';
  edQuantidade.Text := '';
  cbLocal.ItemIndex := -1;
  cbDestino.ItemIndex:= -1;
  edCodBarra.Text   := '';
  dsMovDet.DataSet.Active:=False;
  codProdBarra := '';
  codLoteBarra := '';
  descProdBarra:= '';
  ccusto_origem:= 0;
  edCodBarra.Enabled := False;
end;

procedure TfLoteTransferir.edCodBarraEnter(Sender: TObject);
begin

end;

procedure TfLoteTransferir.edCodBarraKeyPress(Sender: TObject; var Key: char);
var insere_lacto: string;
begin
  if Key = #13 then
  begin
    Key := #0;
    if (edCodBarra.Text <> '') then
    begin
      edQuantidade.Text:='1';
      buscaProduto(edCodBarra.Text);
      //InsereItem();
      insere_lacto := 'INSERT INTO LOTE_LACTO(LOTE, CODPRODUTO, QUANTIDADE, DATA_LCTO, ' +
        'CCUSTO_SAI, CCUSTO_ENT, LANCADO) VALUES (';
      insere_lacto += QuotedStr(codLoteBarra);
      insere_lacto += ', ' + codProdBarra;
      insere_lacto += ', 1';
      insere_lacto += ', ' + QuotedStr(FormatDateTime( 'mm-dd-yyyy', edData.Date));
      insere_lacto += ', ' + IntToStr(ccusto_origem);
      insere_lacto += ', ' + IntToStr(ccusto_destino);
      insere_lacto += ', 0';
      insere_lacto += ')';
      //sqLote_Lacto.Append;
      {
      sqLote_Lacto.Params.ParamByName('PDATA_LCTO').AsDateTime := edData.Date;
      sqLote_Lacto.Params.ParamByName('PCODPRODUTO').AsInteger := StrToInt(codProdBarra);
      sqLote_Lacto.Params.ParamByName('PLOTE').AsString        := codLoteBarra;
      sqLote_Lacto.Params.ParamByName('PCCUSTO_SAI').AsInteger := ccusto_origem;
      sqLote_Lacto.Params.ParamByName('PCCUSTO_ENT').AsInteger := ccusto_destino;
      sqLote_Lacto.Params.ParamByName('PQUANTIDADE').AsFloat := 1;
      sqLote_Lacto.Params.ParamByName('PLANCADO').AsInteger  := 0;
      sqLote_Lacto.ExecSQL;}
      dm.IBCon.ExecuteDirect(insere_lacto);
      sqLote_Lacto.Active := False;
      sqLote_Lacto.Active := True;
      lbCount.Caption := IntToStr(StrToint(lbCount.Caption) + 1);
      if (conta = 2) then // AUMENTAR para 20
      begin
        sqLote_Lacto.Cancel;
        dm.sTrans.Commit;
        sqLote_Lacto.Active:=False;
        sqLote_Lacto.Params.ParamByName('PCCUSTO').AsInteger:=ccusto_origem;
        sqLote_Lacto.Active:=True;
        conta := 0;
      end;
      conta += 1;
      edCodBarra.Text := '';
      edCodBarra.SetFocus;
    end;
  end;
end;

procedure TfLoteTransferir.edLoteExit(Sender: TObject);
begin
  buscaProduto(edLote.Text);
end;

end.

