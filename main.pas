unit Main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, Math;

type
  creatures = record
    x:          Double;
    y:          Double;
    speed:      Integer;
    direction:  Integer;
    color:      TColor;
    dna:        String;
  end;

var
  creature: array[1..10] of creatures;
  nextGeneration: array[1..10] of creatures;
  next:           Boolean;
  gen_text:  Integer;

procedure initMain;
procedure updateMain;
procedure drawMain;
procedure unloadMain;
procedure generateCreature;
function regenerate(var crt: creatures): creatures;

implementation

uses
  Sceneloader;

const
  generation = 10;







procedure initMain;
begin


   next:=False;
   gen_text:=0;

   generateCreature;

  //for i:= 1 to 10 do
  //begin
   // WriteLn(creature[i].dna);
  //end;

end;

procedure updateMain;
var
  i: Integer;
  j: Integer;
begin


  if IsKeyPressed(KEY_SPACE) then
  begin
  next:=True;
  if gen_text <= generation then
  begin
  for i:= 1 to generation do
  begin
   gen_text:=  i;
   WriteLn(gen_text);
   for j:= 1 to 10 do
   begin
      //nextGeneration[j]:= creature[j];
      if creature[j].direction = 1 then
      begin
         nextGeneration[j]:= creature[j];
      end
      else
      begin
         nextGeneration[j]:= regenerate(nextGeneration[j]);
      end;

   end;

  end;
   //WaitTime(0.5);
  end;
  end;

  if IsKeyPressed(KEY_ENTER) then
  begin
       for i:= 1 to 10 do
       begin
        WriteLn(nextGeneration[i].dna);
       end;
  end;





end;

procedure drawMain;
var
  i: Integer;
begin

  if not next then
  begin
   for i:= 1 to 10 do
   begin

     if (Floor(creature[i].x) > Floor(GameSCREEN_WIDTH - 10)) or (Floor(creature[i].x) < 10)  then
     begin
        creature[i].x:= creature[i].x;
     end
     else
     begin
       creature[i].x:= (creature[i].x + creature[i].direction) * creature[i].speed;
     end;

     DrawCircle(Floor(creature[i].x),Floor(creature[i].y),10,creature[i].color);
   end;
  end
  else
  begin
    for i:= 1 to 10 do
   begin

     if (Floor(nextGeneration[i].x) > Floor(GameSCREEN_WIDTH - 10)) or (Floor(nextGeneration[i].x) < 10)  then
     begin
        nextGeneration[i].x:= nextGeneration[i].x;
     end
     else
     begin
       nextGeneration[i].x:= (nextGeneration[i].x + nextGeneration[i].direction) * nextGeneration[i].speed;
     end;

     DrawCircle(Floor(nextGeneration[i].x),Floor(nextGeneration[i].y),10,nextGeneration[i].color);
   end;
  end;



end;

procedure unloadMain;
begin

end;

procedure generateCreature;
var
  i:         Integer;
  j:         Integer;
  rng_x:     Integer;
  rng_y:     Integer;
  rng_dna:   Integer;
  dna_str:   String;
begin

  dna_str:='';

  for i:= 1 to 10 do
   begin

     rng_x:= GetRandomValue(0,SCREEN_WIDTH);
     rng_y:= GetRandomValue(0,SCREEN_HEIGHT);


     creature[i].x:=rng_x;
     creature[i].y:=rng_y;
     creature[i].speed:=1;

     for j:= 1 to 8 do
     begin
       rng_dna:= GetRandomValue(0,1);
       creature[i].dna:= creature[i].dna +  IntToStr(rng_dna);
     end;
   end;



  for i:= 1 to 10 do
  begin

    dna_str:='';

    for j:= 5 to 8 do
    begin
       dna_str:= dna_str + creature[i].dna[j];
    end;


    case dna_str of
          '1001':   creature[i].direction:=1;
          '0110':   creature[i].direction:=-1;
          '1111':   creature[i].direction:=-1;
          '0000':   creature[i].direction:=1;
          '0011':   creature[i].color:=RED;
          '1100':   creature[i].color:=BLUE;
                    else
                      creature[i].color:=WHITE;
     end;

    dna_str:='';

    for j:= 1 to 4 do
    begin
       dna_str:= dna_str + creature[i].dna[j];
    end;


    case dna_str of
          '1001':   creature[i].direction:=1;
          '0110':   creature[i].direction:=-1;
          '1111':   creature[i].direction:=-1;
          '0000':   creature[i].direction:=1;
          '0011':   creature[i].color:=RED;
          '1100':   creature[i].color:=BLUE;
                    else
                      creature[i].color:=WHITE;
     end;

  end;
end;

function regenerate(var crt: creatures): creatures;
var
  i:         Integer;
  j:         Integer;
  rng_x:     Integer;
  rng_y:     Integer;
  rng_dna:   Integer;
  dna_str:   String;
begin
  dna_str:='';


     rng_x:= GetRandomValue(0,SCREEN_WIDTH);
     rng_y:= GetRandomValue(0,SCREEN_HEIGHT);


     crt.x:=rng_x;
     crt.y:=rng_y;
     crt.speed:=1;

     for j:= 1 to 8 do
     begin
       rng_dna:= GetRandomValue(0,1);
       crt.dna:= crt.dna +  IntToStr(rng_dna);
     end;




  for i:= 1 to 10 do
  begin

    dna_str:='';

    for j:= 5 to 8 do
    begin
       dna_str:= dna_str + crt.dna[j];
    end;


    case dna_str of
          '1001':   crt.direction:=1;
          '0110':   crt.direction:=-1;
          '1111':   crt.direction:=-1;
          '0000':   crt.direction:=1;
          '0011':   crt.color:=RED;
          '1100':   crt.color:=BLUE;
                    else
                      crt.color:=WHITE;
     end;

    dna_str:='';

    for j:= 1 to 4 do
    begin
       dna_str:= dna_str + crt.dna[j];
    end;


    case dna_str of
          '1001':   crt.direction:=1;
          '0110':   crt.direction:=-1;
          '1111':   crt.direction:=-1;
          '0000':   crt.direction:=1;
          '0011':   crt.color:=RED;
          '1100':   crt.color:=BLUE;
                    else
                      crt.color:=WHITE;
     end;

  end;

  Result:= crt;
end;

end.


