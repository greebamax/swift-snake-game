import Raylib

let LIGHTGRAY = Color(r: 200, g: 200, b: 200, a: 255)
let BLANK = Color( r: 0, g: 0,b: 0, a: 0)
let MAGENTA = Color( r: 255, g: 0,b: 255, a: 255)
let RAYWHITE = Color( r: 245, g: 245,b: 245, a: 255 )

InitWindow(800, 450, "raylib [core] example - basic window");

while (!WindowShouldClose())
{
    BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);
    EndDrawing();
}

CloseWindow();
