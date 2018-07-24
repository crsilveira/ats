unit uEstoqueAdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, fileinfo, udm;

type

  { TfEstoqueAdm }

  TfEstoqueAdm = class(TForm)
    Image1: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblVersion: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    procedure atualiza(versao: String);
  public

  end;

var
  fEstoqueAdm: TfEstoqueAdm;
  FileVerInfo: TFileVersionInfo;

implementation

uses uProduto, uLoteLancar, uLoteTransfere, uLoteBusca, uEstoqueRel;

{$R *.lfm}

{ TfEstoqueAdm }

procedure TfEstoqueAdm.Image7Click(Sender: TObject);
begin
  fLoteLancar.ShowModal;
end;

procedure TfEstoqueAdm.FormCreate(Sender: TObject);
begin
  FileVerInfo:=TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    lblVersion.Caption := FileVerInfo.VersionStrings.Values['FileVersion'];
    atualiza(lblVersion.Caption);
  finally
    FileVerInfo.Free;
  end;
end;

procedure TfEstoqueAdm.Image1Click(Sender: TObject);
begin

end;

procedure TfEstoqueAdm.Image5Click(Sender: TObject);
begin
  fEstoqueRel.ShowModal;
end;

procedure TfEstoqueAdm.Image6Click(Sender: TObject);
begin
  fLoteTransferir.ShowModal;
end;

procedure TfEstoqueAdm.Image8Click(Sender: TObject);
begin
  fProduto.ShowModal;
end;

procedure TfEstoqueAdm.Image9Click(Sender: TObject);
begin
  Close
end;

procedure TfEstoqueAdm.Panel1Click(Sender: TObject);
begin

end;

procedure TfEstoqueAdm.atualiza(versao: String);
var campos: String;
begin
  if (versao = dm.versao_sistema) then
  begin
    // @@@@@@@   nao preciso disto, pois, o codigo de barra esta no produto
    // quando gerar a etiqueta : 21CODPRODUTOCODLOTE0x
    // retiro este codigo do lote do codigo de barras

    //dm.atualizaBD('LOTES','ALTER','CODBARRA','CHAR(13)', '1.0.0.1');

    // exemplo criando tabela
    // dm.atualizaBD('NOVATABELA','CREATE','CODNOVO CHAR(13) NOT NULL, ' +
    //   ' CAMPO2 INTEGER, CAMPO3 VARCHAR(80)');

    campos := ' CODLCTO INTEGER NOT NULL PRIMARY KEY, LOTE VARCHAR(13) NOT NULL,' +
       ' CODPRODUTO INTEGER NOT NULL, ' +
       ' QUANTIDADE DOUBLE PRECISION , DATA_LCTO DATE, CCUSTO_SAI INTEGER NOT NULL, ' +
       ' CCUSTO_ENT INTEGER NOT NULL, LANCADO SMALLINT ';
    dm.atualizaBD('LOTE_LACTO','CREATE', campos, '','1.0.0.0');


  end;

end;

end.

