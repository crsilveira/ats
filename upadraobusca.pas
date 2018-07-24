unit uPadraoBusca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DBGrids;

type

  { TfPadraoBusca }

  TfPadraoBusca = class(TForm)
    btnEXC: TImage;
    btnPROC: TImage;
    btnSALV: TImage;
    chInativo: TCheckBox;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
  private

  public

  end;

var
  fPadraoBusca: TfPadraoBusca;

implementation

{$R *.lfm}

{ TfPadraoBusca }


end.

