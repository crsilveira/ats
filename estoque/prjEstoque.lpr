program prjEstoque;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, uEstoqueAdm, uProduto, uProdutoProc, uDm, uLoteLancar,
  uPadraoBusca, uLoteBusca, uLoteTransfere;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfProduto, fProduto);
  Application.CreateForm(TfProdutoProc, fProdutoProc);
  Application.CreateForm(TfLoteLancar, fLoteLancar);
  Application.CreateForm(TfPadraoBusca, fPadraoBusca);
  Application.CreateForm(TfLoteBuscar, fLoteBuscar);
  Application.CreateForm(TfLoteTransferir, fLoteTransferir);
  Application.Run;
end.

