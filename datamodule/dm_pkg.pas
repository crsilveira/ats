{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dm_pkg;

{$warn 5023 off : no warning about unused units}
interface

uses
  uDM, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('dm_pkg', @Register);
end.
