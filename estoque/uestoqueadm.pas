unit uEstoqueAdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, fileinfo, udm;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    lblVersion: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure atualiza(versao: String);
  public

  end;

var
  Form1: TForm1;
  FileVerInfo: TFileVersionInfo;

implementation

uses uProduto, uLoteLancar, uLoteTransfere;

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  fProduto.ShowModal;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  fLoteLancar.ShowModal;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  fLoteTransferir.ShowModal;
end;

procedure TForm1.FormCreate(Sender: TObject);
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

procedure TForm1.atualiza(versao: String);
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

