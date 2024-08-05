MenuState = Class {__includes = BaseState}

function MenuState:update(dt)
    if love.events.get["dismiss"] then
        gStateMachine:change("countdown")
    end
end

function MenuState:render()
    love.graphics.setFont(gFonts["huge"])
    love.graphics.printf("Flappy Bird", 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, "center")
    love.graphics.setFont(gFonts["medium"])
    love.graphics.printf("Press Enter", 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, "center")
end
