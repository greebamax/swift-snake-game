import Raylib

let screenWidth: Int32 = 800
let screenHeight: Int32 = 450

Raylib.initWindow(screenWidth, screenHeight, "Swift Snake Game")
Raylib.setTargetFPS(60)

let game = SnakeGame(screenWidth: screenWidth, screenHeight: screenHeight)
game.reset()

// Main game loop
while !Raylib.windowShouldClose {
    game.update()
    game.draw()
}

Raylib.closeWindow()
