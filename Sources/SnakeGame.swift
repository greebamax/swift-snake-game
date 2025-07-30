import Raylib

public class SnakeGame {
    // MARK: - Constants

    private let squareSize: Float = 32
    public let screenWidth: Int32
    public let screenHeight: Int32
    private static let snakeMaxSegments = 256

    // MARK: - State

    private var framesElapsed: Int32 = 0
    private var isGameOver: Bool = false
    private var isGamePaused: Bool = false

    private var snake = Array(
        repeating: Snake(position: .zero, size: .zero, speed: .zero, color: .skyBlue),
        count: snakeMaxSegments)
    private var snakePosition = Array(repeating: Vector2(), count: snakeMaxSegments)
    private var allowMove = false
    private var offset: Vector2 = .zero
    private var snakeSegmentCount = 0

    private var apple = Apple(position: .zero, size: .zero, isActive: false, color: .red)

    // MARK: - Init

    public init(screenWidth: Int32, screenHeight: Int32) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }

    // MARK: - Game Setup

    public func reset() {
        framesElapsed = 0
        isGameOver = true
        isGamePaused = false
        allowMove = false
        snakeSegmentCount = 2

        offset = Vector2(
            x: Float(screenWidth).truncatingRemainder(dividingBy: squareSize),
            y: Float(screenHeight).truncatingRemainder(dividingBy: squareSize)
        )

        for i in 0..<Self.snakeMaxSegments {
            snake[i] = Snake(
                position: Vector2(x: offset.x / 2, y: offset.y / 2),
                size: Vector2(x: squareSize, y: squareSize),
                speed: Vector2(x: squareSize, y: 0),
                color: i == 0 ? .darkBlue : .skyBlue
            )
            snakePosition[i] = .zero
        }

        apple = Apple(
            position: .zero, size: Vector2(x: squareSize, y: squareSize), isActive: false,
            color: .red)
    }

    // MARK: - Update Loop

    public func update() {
        if isGameOver {
            if Raylib.isKeyPressed(.enter) {
                reset()
                isGameOver = false
            }
            return
        }

        handlePauseInput()
        guard !isGamePaused else { return }

        handleMovementInput()
        updateSnakePosition()
        checkWallCollision()
        checkSelfCollision()
        spawnAppleIfNeeded()
        checkAppleCollision()

        framesElapsed += 1
    }

    // MARK: - Draw Loop

    public func draw() {
        Raylib.beginDrawing()
        Raylib.clearBackground(.rayWhite)

        if isGameOver {
            drawGameOverText()
        } else {
            drawGrid()
            drawSnake()
            drawApple()
            drawPauseOverlay()
        }

        Raylib.endDrawing()
    }

    // MARK: - Input

    private func handlePauseInput() {
        if Raylib.isKeyPressed(.letterP) {
            isGamePaused.toggle()
        }
    }

    private func handleMovementInput() {
        if Raylib.isKeyPressed(.right), snake[0].speed.x == 0, allowMove {
            snake[0].speed = Vector2(x: squareSize, y: 0)
            allowMove = false
        }
        if Raylib.isKeyPressed(.left), snake[0].speed.x == 0, allowMove {
            snake[0].speed = Vector2(x: -squareSize, y: 0)
            allowMove = false
        }
        if Raylib.isKeyPressed(.up), snake[0].speed.y == 0, allowMove {
            snake[0].speed = Vector2(x: 0, y: -squareSize)
            allowMove = false
        }
        if Raylib.isKeyPressed(.down), snake[0].speed.y == 0, allowMove {
            snake[0].speed = Vector2(x: 0, y: squareSize)
            allowMove = false
        }
    }

    // MARK: - Snake Logic

    private func updateSnakePosition() {
        for i in 0..<snakeSegmentCount {
            snakePosition[i] = snake[i].position
        }

        if framesElapsed % 10 == 0 {
            for i in (0..<snakeSegmentCount).reversed() {
                if i == 0 {
                    snake[0].position.x += snake[0].speed.x
                    snake[0].position.y += snake[0].speed.y
                    allowMove = true
                } else {
                    snake[i].position = snakePosition[i - 1]
                }
            }
        }
    }

    private func checkWallCollision() {
        let head = snake[0].position
        if head.x > Float(screenWidth) - offset.x || head.y > Float(screenHeight) - offset.y
            || head.x < 0 || head.y < 0
        {
            isGameOver = true
        }
    }

    private func checkSelfCollision() {
        let head = snake[0].position
        for i in 1..<snakeSegmentCount {
            if snake[i].position == head {
                isGameOver = true
                break
            }
        }
    }

    // MARK: - Apple Logic

    private func spawnAppleIfNeeded() {
        guard !apple.isActive else { return }

        apple.isActive = true
        apple.position = randomApplePosition()

        var i = 0
        while i < snakeSegmentCount {
            if apple.position == snake[i].position {
                apple.position = randomApplePosition()
                i = 0
                continue
            }

            i += 1
        }
    }

    private func randomApplePosition() -> Vector2 {
        let x =
            Float(Int32.random(in: 0..<(screenWidth / Int32(squareSize)))) * squareSize + offset.x
            / 2
        let y =
            Float(Int32.random(in: 0..<(screenHeight / Int32(squareSize)))) * squareSize + offset.y
            / 2
        return Vector2(x: x, y: y)
    }

    private func checkAppleCollision() {
        let head = snake[0]
        if head.position.x < apple.position.x + apple.size.x,
            head.position.x + head.size.x > apple.position.x,
            head.position.y < apple.position.y + apple.size.y,
            head.position.y + head.size.y > apple.position.y
        {
            snake[snakeSegmentCount].position = snakePosition[snakeSegmentCount - 1]
            snakeSegmentCount += 1
            apple.isActive = false
        }
    }

    // MARK: - Drawing Helpers

    private func drawGrid() {
        for i in 0...screenWidth / Int32(squareSize) {
            let x = squareSize * Float(i) + offset.x / 2
            Raylib.drawLineV(
                Vector2(x: x, y: offset.y / 2),
                Vector2(x: x, y: Float(screenHeight) - offset.y / 2), .lightGray)
        }

        for i in 0...screenHeight / Int32(squareSize) {
            let y = squareSize * Float(i) + offset.y / 2
            Raylib.drawLineV(
                Vector2(x: offset.x / 2, y: y), Vector2(x: Float(screenWidth) - offset.x / 2, y: y),
                .lightGray)
        }
    }

    private func drawSnake() {
        for i in 0..<snakeSegmentCount {
            Raylib.drawRectangleV(snake[i].position, snake[i].size, snake[i].color)
        }
    }

    private func drawApple() {
        Raylib.drawRectangleV(apple.position, apple.size, apple.color)
    }

    private func drawPauseOverlay() {
        guard isGamePaused else { return }
        let text = "GAME PAUSED"
        let size: Int32 = 40
        let x = screenWidth / 2 - Raylib.measureText(text, size) / 2
        let y = screenHeight / 2 - size
        Raylib.drawText(text, x, y, size, .gray)
    }

    private func drawGameOverText() {
        let text = "PRESS [ENTER] TO PLAY AGAIN"
        let size: Int32 = 20
        let x = screenWidth / 2 - Raylib.measureText(text, size) / 2
        let y = screenHeight / 2 - 50
        Raylib.drawText(text, x, y, size, .gray)
    }
}
