program geneticalgol;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, Sceneloader;

begin
  initLoader;
end.

