import Raylib

let LIGHTGRAY: Color = .lightGray
let BLANK: Color = .blank
let MAGENTA: Color = .magenta
let RAYWHITE: Color = .rayWhite

Raylib.initWindow(800, 450, "raylib [core] example - basic window")

while !Raylib.windowShouldClose {
    Raylib.beginDrawing()
    Raylib.clearBackground(RAYWHITE)
    Raylib.drawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY)
    Raylib.endDrawing()
}

Raylib.closeWindow()
