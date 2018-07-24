unit uProduto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DbCtrls, StdCtrls, Buttons, ComCtrls, uPadrao, ACBrValidador, uDM, Types;

type

  { TfProduto }

  TfProduto = class(TfPadrao)
    ACBrValidador1: TACBrValidador;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    CheckGroup1: TCheckGroup;
    DBComboBox1: TDBComboBox;
    DBComboBox2: TDBComboBox;
    DBComboBox3: TDBComboBox;
    DBEdit15: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit27: TDBEdit;
    DBEdit32: TDBEdit;
    DBEdit33: TDBEdit;
    DBEdit36: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    RadioGroup6: TRadioGroup;
    rbCodBarra: TCheckBox;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit9: TDBEdit;
    DBText1: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure btnPROCClick(Sender: TObject);
    procedure btnSALVClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox3Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private

  public

  end;

var
  fProduto: TfProduto;

implementation

uses uProdutoProc;

{$R *.lfm}

{ TfProduto }

procedure TfProduto.btnPROCClick(Sender: TObject);
begin
  inherited;
  fProdutoProc.ShowModal;
  if (ds.DataSet.Active) then
    ds.DataSet.Close;
  dm.sqProduto.ParamByName('CODPRODUTO').AsInteger:=fProdutoProc.codProduto;
  ds.DataSet.Active:=True;
end;

procedure TfProduto.btnSALVClick(Sender: TObject);
var barcode: String;
begin
  if ((rbCodBarra.Checked) and (dm.sqProdutoCOD_BARRA.AsString = '')) then
  begin
    if (ds.DataSet.State in [dsBrowse]) then
      ds.DataSet.Edit;
    barcode := FormatFloat('00000', dm.sqProdutoCODPRODUTO.AsInteger);
    barcode := '21' + barcode + '000000';
    ACBrValidador1.Documento   := barcode;
    ACBrValidador1.Complemento := '0';
    ACBrValidador1.IgnorarChar := './-';

    if ACBrValidador1.Validar then
      dm.sqProdutoCOD_BARRA.AsString := barcode
    else
      dm.sqProdutoCOD_BARRA.AsString := Copy(barcode,1,12)+ACBrValidador1.DigitoCalculado;
  end;
  inherited;
  dm.sqProduto.ApplyUpdates;
  dm.sTrans.Commit;
  ds.DataSet.Active:=True;
end;

procedure TfProduto.Button1Click(Sender: TObject);
begin
end;

procedure TfProduto.FormCreate(Sender: TObject);
begin
  ds.DataSet:=dm.sqProduto;
  inherited;
end;

procedure TfProduto.GroupBox3Click(Sender: TObject);
begin

end;

procedure TfProduto.Label16Click(Sender: TObject);
begin

end;

procedure TfProduto.PageControl1Change(Sender: TObject);
begin

end;

procedure TfProduto.Panel3Click(Sender: TObject);
begin

end;

procedure TfProduto.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

