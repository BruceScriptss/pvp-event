local QBCore = exports['qb-core']:GetCoreObject()
local participants = {}
local playerKills = {}
local eventActive = false

-- Función para iniciar el evento PvP
local function startPvPEvent()
    eventActive = true
    participants = {}
    playerKills = {}
    TriggerClientEvent('QBCore:Notify', -1, "¡El evento PvP ha comenzado! ¡Únete usando /joinpvp!", "success")
end

-- Comando para unirse al evento PvP
QBCore.Commands.Add("joinpvp", "Únete al evento PvP", {}, false, function(source, args)
    local player = QBCore.Functions.GetPlayer(source)

    if eventActive then
        if not participants[source] then
            participants[source] = player.PlayerData.citizenid
            playerKills[source] = 0
            TriggerClientEvent('QBCore:Notify', source, "Te has unido al evento PvP.", "success")
            TriggerClientEvent('QBCore:Notify', -1, player.PlayerData.charinfo.firstname .. " se ha unido al evento PvP.", "success")
            
            -- Actualizar estadísticas en los clientes
            updateUIForAll()
        else
            TriggerClientEvent('QBCore:Notify', source, "Ya estás en el evento PvP.", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "No hay un evento PvP activo en este momento.", "error")
    end
end)

-- Función para enviar las estadísticas actualizadas a todos los clientes
function updateUIForAll()
    local players = {}

    for k, v in pairs(participants) do
        local player = QBCore.Functions.GetPlayer(k)
        if player then
            table.insert(players, {
                name = player.PlayerData.charinfo.firstname,
                kills = playerKills[k] or 0
            })
        end
    end

    -- Enviar las estadísticas actualizadas a todos los clientes
    TriggerClientEvent('pvp:showUI', -1, players)
end

-- Evento para contar kills (jugadores asesinados)
RegisterNetEvent('pvp:playerKilled')
AddEventHandler('pvp:playerKilled', function(killerId)
    if eventActive and playerKills[killerId] then
        playerKills[killerId] = playerKills[killerId] + 1
        TriggerClientEvent('QBCore:Notify', -1, GetPlayerName(killerId) .. " ha matado a otro jugador. Total de kills: " .. playerKills[killerId], "success")
        -- Actualizar UI
        updateUIForAll()
    end
end)

-- Comando para iniciar el evento PvP
QBCore.Commands.Add("startpvp", "Inicia el evento PvP", {}, false, function(source, args)
    startPvPEvent()
end)

-- Comando para terminar el evento PvP
QBCore.Commands.Add("endpvp", "Termina el evento PvP", {}, false, function(source, args)
    eventActive = false
    TriggerClientEvent('pvp:hideUI', -1)

    local winner = nil
    local maxKills = -1

    for k, v in pairs(playerKills) do
        if v > maxKills then
            maxKills = v
            winner = k
        end
    end

    if winner then
        TriggerClientEvent('QBCore:Notify', -1, "El evento PvP ha terminado. Ganador: " .. GetPlayerName(winner) .. " con " .. maxKills .. " kills!", "success")
    end
end)
