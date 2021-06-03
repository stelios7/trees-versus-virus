

function MapToScreenCoords(mx, my)
    return {
        x = (mx - my - 1 + WINDOW_WIDTH / TILE_WIDTH) * TILE_WIDTH * 0.5,
        y = (mx + my) * TILE_HEIGHT / 4
    }
end

function ScreenToMapCoords(factor, offsetX, offsetY)
    local screenX = (GetMouseX() - (offsetX or 0)) / (factor or 1)
    local screenY = (GetMouseY() - (offsetY or 0)) / (factor or 1)

    return {
        x = math.floor(2 * screenY / TILE_HEIGHT - WINDOW_WIDTH / (2 * TILE_WIDTH) + screenX / TILE_WIDTH) + 1,
        y = math.floor(2 * (screenY / TILE_HEIGHT) + WINDOW_WIDTH / (2 * TILE_WIDTH) - screenX / TILE_WIDTH) + 1
    }
end

function MaxZoomOut(x)
    local e = math.exp(1)
    local ln = math.log
    local f = function(k)
        return ln(k)/((1+math.pow(e, -k)) * k)
    end
    return 25 * f(x);
end

function GetMouseX()
    return love.mouse:getX() * (VIRTUAL_WIDTH / WINDOW_WIDTH)
end

function GetMouseY()
    return love.mouse:getY() * (VIRTUAL_HEIGHT / WINDOW_HEIGHT)
end