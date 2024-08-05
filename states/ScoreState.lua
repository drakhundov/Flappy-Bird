ScoreState = Class {__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.events.get["dismiss"] then
        gStateMachine:change("countdown")
    end
end

function ScoreState:render()
    love.graphics.setFont(gFonts["small"])
    love.graphics.printf("Ooh. You Lost!", 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(gFonts["huge"])
    love.graphics.printf("Score: " .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(gFonts["medium"])
    love.graphics.printf("Press Enter", 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, "center")
end
