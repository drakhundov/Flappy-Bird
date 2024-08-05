push = require "push"
Class = require "class"

require "Bird"
require "Pipe"
require "PipePair"

require "StateMachine"
require "states/BaseState"
require "states/PlayState"
require "states/MenuState"
require "states/ScoreState"
require "states/CountDownState"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local BACKGROUND_SPRITE = love.graphics.newImage("assets/sprites/background.png")
local background_scroll = 0 -- Will store the amount of pixels the background was scrolled.
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413 -- The point at which background will be scrolled back to the beginning.

local GROUND_SPRITE = love.graphics.newImage("assets/sprites/ground.png")
local GROUND_SCROLL_SPEED = 60
local ground_scroll = 0

local EVENTS = {
    jump = {
        "space",
        "left click"
    },
    dismiss = {
        "return"
    },
    pause = {
        "f"
    }
}

local BUTTONS = {
    [1] = "left",
    [2] = "right",
    [3] = "middle"
}

love.events = {}

gPaused = false

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Flappy Bird")
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = true
        }
    )
    math.randomseed(os.time())
    gFonts = {
        small = love.graphics.newFont("assets/font.ttf", 14),
        medium = love.graphics.newFont("assets/font.ttf", 28),
        huge = love.graphics.newFont("assets/font.ttf", 56),
        super_huge = love.graphics.newFont("assets/font.ttf", 100)
    }
    gSounds = {
        jump = love.audio.newSource("assets/sounds/jump.wav", "static"),
        hurt = love.audio.newSource("assets/sounds/hurt.wav", "static"),
        explosion = love.audio.newSource("assets/sounds/explosion.wav", "static"),
        score = love.audio.newSource("assets/sounds/score.wav", "static"),
        soundtrack = love.audio.newSource("assets/soundtrack.mp3", "static")
    }
    gSounds["soundtrack"]:setLooping(true)
    gSounds["soundtrack"]:play()
    gStateMachine =
        StateMachine {
        menu = function()
            return MenuState()
        end,
        play = function()
            return PlayState()
        end,
        score = function()
            return ScoreState()
        end,
        countdown = function()
            return CountDownState()
        end
    }
    gStateMachine:change("menu")
    love.events.get = {}
end

function love.update(dt)
    if not gPaused then
        background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        ground_scroll = (ground_scroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end
    gStateMachine:update(dt)
    -- Reset events (they all had already been taken into consideration).
    love.events.get = {}
end

function love.keypressed(key)
    love.events.add(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    button = BUTTONS[button] .. " click"
    love.events.add(button)
end

function love.draw()
    push:start()
    love.graphics.draw(BACKGROUND_SPRITE, -background_scroll, 0)
    gStateMachine:render()
    love.graphics.draw(GROUND_SPRITE, -ground_scroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.events.add(event)
    for name, calls in pairs(EVENTS) do
        for i, call in pairs(calls) do
            if call == event then
                love.events.get[name] = true
                break
            end
        end
    end
end
