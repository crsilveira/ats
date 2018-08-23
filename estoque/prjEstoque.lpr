program prjEstoque;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, uEstoqueAdm, uProduto, uProdutoProc, uDm, dm_pkg,
  uLoteLancar, uPadraoBusca, uLoteBusca, uLoteTransfere, uEstoqueRel, uLoteRel,
  uLotePorProdutoRel;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfEstoqueAdm, fEstoqueAdm);
  Application.CreateForm(TfProduto, fProduto);
  Application.CreateForm(TfProdutoProc, fProdutoProc);
  Application.CreateForm(TfLoteLancar, fLoteLancar);
  Application.CreateForm(TfPadraoBusca, fPadraoBusca);
  Application.CreateForm(TfLoteBuscar, fLoteBuscar);
  Application.CreateForm(TfLoteTransferir, fLoteTransferir);
  Application.CreateForm(TfEstoqueRel, fEstoqueRel);
  Application.CreateForm(TfLoteRel, fLoteRel);
  Application.CreateForm(TfLotePorProdutoRel, fLotePorProdutoRel);
  Application.Run;
end.

