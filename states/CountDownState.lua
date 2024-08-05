CountDownState = Class {__includes = BaseState}

local COUNTDOWN = 3

function CountDownState:enter()
    self.count = COUNTDOWN
    self.timer = 0
end

function CountDownState:update(dt)
    self.timer = self.timer + dt
    -- One second elapsed.
    if self.timer > 1 then
        self.count = self.count - 1
        self.timer = self.timer % 1
    end
    if self.count == 0 then
        gStateMachine:change("play")
    end
end

function CountDownState:render()
    love.graphics.setFont(gFonts["super_huge"])
    love.graphics.printf(tostring(self.count), 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, "center")
end
