local QBCore = exports['qb-core']:GetCoreObject()

local showUI = false
local players = {}

-- Función para mostrar el HUD del evento PvP con las estadísticas en la derecha
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if showUI then
            -- Dibujar un rectángulo semitransparente como fondo en el lado derecho
            DrawRect(0.90, 0.2, 0.2, 0.4, 0, 0, 0, 150)
            
            -- Título del evento PvP
            drawText("Estadísticas PvP", 0.90, 0.05, 0.5, 0.7, 255, 255, 255, 255)

            -- Mostrar los jugadores y sus estadísticas
            for i, player in ipairs(players) do
                local yPos = 0.15 + (i * 0.05)
                drawText(player.name .. " - Kills: " .. player.kills, 0.90, yPos, 0.4, 0.5, 255, 255, 255, 255)
            end
        end
    end
end)

-- Evento para actualizar las estadísticas del evento PvP
RegisterNetEvent('pvp:showUI')
AddEventHandler('pvp:showUI', function(playerData)
    players = playerData
    showUI = true
end)

-- Evento para ocultar la interfaz gráfica cuando termine el evento
RegisterNetEvent('pvp:hideUI')
AddEventHandler('pvp:hideUI', function()
    showUI = false
end)

-- Función nativa para dibujar texto en la pantalla
function drawText(text, x, y, scale, font, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
