-- include libraries
push = require 'push'
Class = require 'class'

-- including object classes
require 'Paddle'
require 'Ball'

-- declare constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- set title of application
  love.window.setTitle('Pong')

  -- seed our random-number generator
  math.randomseed(os.time())

  -- create small font for text
  smallFont = love.graphics.newFont('font.ttf', 8)

  -- create larger font for scores
  scoreFont = love.graphics.newFont('font.ttf', 32)

  love.graphics.setFont(smallFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

  -- track scores
  player1Score = 0
  player2Score = 0

  -- initialize Paddle objects
  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

  -- initialize Ball object
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  -- initialize game start to start state
  gameState = 'start'
end

function love.update(dt)
  if gameState == 'play' then
    -- handle paddle collisions
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + 5

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end
    if ball:collides(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - 4

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end

    -- handle boundary collisions
    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.y = VIRTUAL_HEIGHT - 4
      ball.dy = - ball.dy
    end
  end

  -- detect collision for a score
  if ball.x < 0 then
    servingPlayer = 1
    player2Score = player2Score + 1
    ball:reset()
    gameState = 'start'
  end

  if ball.x > VIRTUAL_WIDTH then
    servingPlayer = 2
    player1Score = player1Score + 1
    ball:reset()
    gameState = 'start'
  end

  -- player 1 movement
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  -- player 2 movement
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  -- ball movement in play state
  if gameState == 'play' then
    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'

      ball:reset()
    end
  end
end

function love.draw()
  push:apply('start')

  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  -- draw welcome text
  love.graphics.setFont(smallFont)

  if gameState == 'start' then
    love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
  else
    love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
  end

  -- draw scores
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  -- left paddle
  player1:render()

  -- right paddle
  player2:render()

  -- ball
  ball:render()

  -- calculate FPS
  displayFPS()

  push:apply('end')
end

function displayFPS()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 255/255, 0, 255/255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
