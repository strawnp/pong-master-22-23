push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- seed our random-number generator
  math.randomseed(os.time())

  -- create small font for text
  smallFont = love.graphics.newFont('font.ttf', 8)
  love.graphics.setFont(smallFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-50, 50)

  gameState = 'start'
end

function love.update(dt)
  -- player 1 movement
  if love.keyboard.isDown('w') then
    player1Y = player1Y + -PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') then
    player1Y = player1Y + PADDLE_SPEED * dt
  end

  -- player 2 movement
  if love.keyboard.isDown('up') then
    player2Y = player2Y + -PADDLE_SPEED * dt
  elseif love.keyboard.isDown('down') then
    player2Y = player2Y + PADDLE_SPEED * dt
  end

  -- ball movement in play state
  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'

      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

      ballDX = math.random(2) == 1 and 100 or -100
      ballDY = math.random(-50, 50) * 1.5
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

    -- left paddle
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    push:apply('end')
end
