unit Main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, Math, raymath;

type
  creatures = record
    pos:        TVector2;
    speed:      Integer;
    direction:  Integer;
    color:      TColor;
    dna:        String;
    gen:        Integer;
  end;

var
  creature:          array[1..10] of creatures;
  nextGeneration:    array[1..10] of creatures;
  next:              Boolean;
  gen_text:          Integer;
  nextgen:           Integer;
  text:              string;
  pause:             Boolean;
  mouse:             TVector2;
  virtualMouse:      TVector2;

procedure initMain;
procedure updateMain;
procedure drawMain;
procedure unloadMain;
procedure calculaMouseVirtual(var mousePos: TVector2);
function regenerate(var crt: creatures): creatures;
procedure showStats(var crt: creatures);

implementation

uses
  Sceneloader;

const
  generation = 10;


procedure initMain;
var
  i:  Integer;
begin

   next:=False;
   pause:=False;
   gen_text:=0;

   calculaMouseVirtual(mouse);

  for i:= 1 to 10 do
  begin
   regenerate(creature[i]);
  end;

end;

procedure updateMain;
var
  i: Integer;
  j: Integer;
begin

  if IsWindowResized then
  begin
    calculaMouseVirtual(mouse);
  end;


  if IsKeyPressed(KEY_P) then
  begin
   pause:= not pause;
   WriteLn(pause);
  end;


  if IsKeyPressed(KEY_ENTER) then
  begin
   for i:= 1 to 10 do
   begin
     WriteLn(nextGeneration[i].gen);
     WriteLn(nextGeneration[i].dna);
   end;
   WriteLn('-----------------------');
  end;

  if IsKeyPressed(KEY_SPACE) then
  begin
  nextgen:= nextgen + 1;
  next:=True;
  if gen_text <= nextgen then
  begin
  for i:= nextgen to nextgen + 1 do
  begin
   gen_text:=  i;
   //WriteLn(gen_text);
   // run at the first generation
   if not nextgen > 1 then
   begin
   for j:= 1 to 10 do
   begin
      if Floor(creature[j].pos.x) > GameSCREEN_WIDTH - 300 then
      begin
         nextGeneration[j]:= creature[j];
         nextGeneration[j].gen:=gen_text - 1;
         nextGeneration[j].pos.x:=GetRandomValue(0,GameSCREEN_WIDTH);
         nextGeneration[j].pos.y:=GetRandomValue(0,GameSCREEN_HEIGHT);
      end
      else
      begin
         nextGeneration[j]:= regenerate(creature[j]);
      end;
   end;
   end
   else
   begin
   for j:= 1 to 10 do //run after the first generation
   begin
      if Floor(nextGeneration[j].pos.x) > GameSCREEN_WIDTH -  300 then
      begin
         nextGeneration[j]:= nextGeneration[j];
         nextGeneration[j].gen:=gen_text - 1;
         nextGeneration[j].pos.x:=GetRandomValue(0,GameSCREEN_WIDTH);
         nextGeneration[j].pos.y:=GetRandomValue(0,GameSCREEN_HEIGHT);
      end
      else
      begin
         nextGeneration[j]:= regenerate(nextGeneration[j]);
      end;

   end;
   end;
   //next:= False;
   text:= 'Gen: ' + IntToStr(gen_text);
  end;
   WaitTime(0.2);
  end;

  end;

  if pause then
  begin
    showStats(nextGeneration[j]);
  end;

end;

procedure drawMain;
var
  i: Integer;
begin

  //draw text
  DrawText('SPACE: Next Gen',0,0,50,WHITE);
  DrawText('P: Pause',0,60,50,WHITE);
  DrawRectangle(Floor(GameSCREEN_WIDTH - 300),0,20,Floor(GameSCREEN_HEIGHT),RED);
  //DrawText(PChar('Mouse_x: ' + IntToStr(Floor(mouse.x))),0,150,50,WHITE);


  if not next then
  begin
   for i:= 1 to 10 do
   begin

     if (Floor(creature[i].pos.x) > Floor(GameSCREEN_WIDTH - 10)) or (Floor(creature[i].pos.x) < 10)  then
     begin
        creature[i].pos.x:= creature[i].pos.x;
     end
     else
     begin
     if pause = False then
     begin
       creature[i].pos.x:= (creature[i].pos.x + creature[i].direction) * creature[i].speed;
     end;

     if pause = True then
     begin
      showStats(nextGeneration[i]);
     end;
     end;

     DrawCircle(Floor(creature[i].pos.x),Floor(creature[i].pos.y),10,creature[i].color);
   end;
  end
  else
  begin
    DrawText(PChar(text),0,120,50,WHITE);
    for i:= 1 to 10 do
   begin

     if (Floor(nextGeneration[i].pos.x) > Floor(GameSCREEN_WIDTH - 10)) or (Floor(nextGeneration[i].pos.x) < 10)  then
     begin
        nextGeneration[i].pos.x:= nextGeneration[i].pos.x;
     end
     else
     begin
       if pause = False then
       begin
         nextGeneration[i].pos.x:= (nextGeneration[i].pos.x + nextGeneration[i].direction) * nextGeneration[i].speed;
       end;
     end;
     if pause = True then
     begin
      showStats(nextGeneration[i]);
     end;
     DrawCircle(Floor(nextGeneration[i].pos.x),Floor(nextGeneration[i].pos.y),10,nextGeneration[i].color);
   end;
  end;



end;

procedure unloadMain;
begin

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
    crt.dna:='';

     rng_x:= GetRandomValue(0,GameSCREEN_WIDTH);
     rng_y:= GetRandomValue(0,GameSCREEN_HEIGHT);


     crt.pos.x:=rng_x;
     crt.pos.y:=rng_y;
     crt.speed:=1;

     //generate dna
     for j:= 1 to 8 do
     begin
       rng_dna:= GetRandomValue(0,1);
       crt.dna:= crt.dna +  IntToStr(rng_dna);
     end;



  //Check creature dna
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


  Result:= crt;
end;

procedure showStats(var crt: creatures);
var
  hover: Boolean;
begin
  mouse:= GetMousePosition;
  if not IsWindowResized then
  begin
   hover:= CheckCollisionPointCircle(mouse,crt.pos,20);
  end;

  if hover then
  begin
   DrawText(PChar('gen: ' + IntToStr(crt.gen)),Floor(mouse.x) + 50,Floor(mouse.y),20,WHITE);
   DrawText(PChar('dna: ' + crt.dna),Floor(mouse.x) + 50,Floor(mouse.y) + 30,20,WHITE);
  end;

end;

procedure calculaMouseVirtual(var mousePos: TVector2);
begin
  // Atualiza o mouse virtual
  virtualMouse.x := 0;
  virtualMouse.y := 0;
  virtualMouse.x := (mousePos.x - (GetScreenWidth - (GameSCREEN_WIDTH * scale)) * 0.5) / scale;
  virtualMouse.y := (mousePos.y - (GetScreenHeight -
    (GameSCREEN_HEIGHT * scale)) * 0.5) / scale;
    virtualMouse := Vector2Clamp(virtualMouse, Vector2Create(0, 0),
    Vector2Create(GameSCREEN_WIDTH, GameSCREEN_HEIGHT));


  //Aplica a mesma transformação do mouse virtual para o mouse real
  SetMouseOffset(Trunc(-(GetScreenWidth - (GameSCREEN_WIDTH * scale)) * 0.5),
    Trunc(-(GetScreenHeight - (GameSCREEN_HEIGHT * scale)) * 0.5));
  SetMouseScale(1 / scale, 1 / scale);
end;

end.


