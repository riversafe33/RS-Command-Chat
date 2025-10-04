Config = {}
Config.BlipCallTimer = 180

local VORPcore = exports.vorp_core:GetCore()


local CHAT_FADE_TIME = Configmain.ChatAutoFade.FadeTimeSeconds * 1000
local chatTimer = nil
local chatInputActive = false

RegisterNetEvent('chat:inputActive')
AddEventHandler('chat:inputActive', function(active)
    chatInputActive = active
end)

AddEventHandler('chat:addMessage', function(message)
    if not Configmain.ChatAutoFade.Enabled then
        return
    end

    SendNUIMessage({
        type = 'ON_SCREEN_STATE_CHANGE',
        hideState = 1,
        fromUserInteraction = true
    })

    if chatTimer then
        Citizen.ClearTimeout(chatTimer)
        chatTimer = nil
    end

    chatTimer = Citizen.SetTimeout(CHAT_FADE_TIME, function()
        if not chatInputActive then
            SendNUIMessage({
                type = 'ON_SCREEN_STATE_CHANGE',
                hideState = -1,
                fromUserInteraction = true
            })
        end
    end)
end)

RegisterNetEvent('chat:addOOCProximity')
AddEventHandler('chat:addOOCProximity', function(senderId, prefix, message, distance)
    local playerPed = PlayerPedId()
    local senderPed = GetPlayerPed(GetPlayerFromServerId(senderId))
    local playerCoords = GetEntityCoords(playerPed)
    local senderCoords = GetEntityCoords(senderPed)

    local dist = #(playerCoords - senderCoords)
    if dist <= distance then
        TriggerEvent('chat:addMessage', {
            template = '<div style="color: lightblue;">{0} (ID: {1}): {2}</div>',
            args = {prefix, senderId, message}
        })
    end
end)

RegisterNetEvent("chat:addMessageProximity")
AddEventHandler("chat:addMessageProximity", function(sender, playerName, msg, tipo, distancia)
    local playerPed = PlayerPedId()
    local senderPed = GetPlayerPed(GetPlayerFromServerId(sender))
    local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(senderPed))

    if dist <= distancia then
        TriggerEvent("chat:addMessage", {
            template = '<div style="color: violet;">[{0}] {1} (ID: {2}): {3}</div>',
            args = {tipo, playerName, sender, msg}
        })
    end
end)

RegisterNetEvent("chat:addMessageProximity1")
AddEventHandler("chat:addMessageProximity1", function(sender, playerName, msg, tipo, distancia)
    local playerPed = PlayerPedId()
    local senderPed = GetPlayerPed(GetPlayerFromServerId(sender))
    local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(senderPed))

    if dist <= distancia then
        TriggerEvent("chat:addMessage", {
            template = '<div style="color: yellow;">[{0}] {1} (ID: {2}): {3}</div>',
            args = {tipo, playerName, sender, msg}
        })
    end
end)

RegisterNetEvent("chat:addMessageProximity2")
AddEventHandler("chat:addMessageProximity2", function(sender, msg, tipo, distancia)
    local playerPed = PlayerPedId()
    local senderPed = GetPlayerPed(GetPlayerFromServerId(sender))
    local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(senderPed))

    if dist <= distancia then
        TriggerEvent("chat:addMessage", {
            template = '<div style="color: lightblue;">[{0}] (ID: {1}): {2}</div>',
            args = {tipo, sender, msg}
        })
    end
end)

RegisterNetEvent("chat:addMessageAll")
AddEventHandler("chat:addMessageAll", function(sender, msg, tag)
    local idText = "(ID: " .. tostring(sender) .. ")"
    TriggerEvent("chat:addMessage", {
        template = '<div style="color: lightgreen;">[{0}] {1}: {2}</div>',
        args = { tag, idText, msg }
    })
end)

RegisterNetEvent("chat:addMessageAll1")
AddEventHandler("chat:addMessageAll1", function(sender, msg, tag)
    local idText = "(ID: " .. tostring(sender) .. ")"
    TriggerEvent("chat:addMessage", {
        template = '<div style="color: orange;">[{0}] {1}: {2}</div>',
        args = { tag, idText, msg }
    })
end)

RegisterNetEvent("chat:addMessageMPM")
AddEventHandler("chat:addMessageMPM", function(senderName, msg)
    TriggerEvent("chat:addMessage", {
        template = '<div style="color: turquoise;">[' .. Configmain.Textos.Doctor .. ' {0}]: {1}</div>',
        args = {senderName, msg}
    })
end)

RegisterNetEvent("chat:addMessageMPP")
AddEventHandler("chat:addMessageMPP", function(senderName, msg)
    TriggerEvent("chat:addMessage", {
        template = '<div style="color: turquoise;">[' .. Configmain.Textos.PrefijoAgenteLey .. ' {0}]: {1}</div>',
        args = {senderName, msg}
    })
end)

RegisterNetEvent("chat:addMessageMP")
AddEventHandler("chat:addMessageMP", function(senderId, senderName, msg)
    TriggerEvent("chat:addMessage", {
        template = '<div style="color: lavender;">[' .. Configmain.Textos.PrefijoMensajePrivado .. ' {0} ID: {1}]: {2}</div>',
        args = {senderName, senderId, msg}
    })
end)

if Configmain.CommandsEnabled.Witness then
    RegisterCommand(Configmain.Command.Witness, function(source, args, rawCommand)
        local playerCoords = GetEntityCoords(PlayerPedId(), true)
        local msg = table.concat(args, " ")
        local emergency = 'testigo'
        TriggerServerEvent('chat:sendcall', { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z }, msg, emergency)
    end, false)
end

if Configmain.CommandsEnabled.Flight then
    RegisterCommand(Configmain.Command.Flight, function(source, args, rawCommand)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, true)
        local msg = table.concat(args, " ")
        local emergency = 'huida'
    
        TriggerServerEvent('chat:sendcall', {
            x = playerCoords.x,
            y = playerCoords.y,
            z = playerCoords.z
        }, msg, emergency)
    end, false)
end

if Configmain.CommandsEnabled.Help then
    RegisterCommand(Configmain.Command.Help, function(source, args, rawCommand)
        local playerCoords = GetEntityCoords(PlayerPedId(), true)
        local msg = table.concat(args, " ")
        local emergency = 'auxilio'
        TriggerServerEvent('chat:sendcall', { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z }, msg, emergency)
    end, false)
end

RegisterNetEvent('chat:marcador', function(targetCoords, type, blip)
    local duration = Config.BlipCallTimer
    local call = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, targetCoords.x, targetCoords.y, targetCoords.z)

    SetBlipSprite(call, blip, 1)
    Citizen.InvokeNative(0x662D364ABF16DE2F, call, `BLIP_MODIFIER_MP_COLOR_10`)
    Citizen.InvokeNative(0x9CB1A1623062F402, call, type)

    while duration > 0 do
        Citizen.Wait(1000)
        duration = duration - 1
    end

    RemoveBlip(call)
end)

RegisterNetEvent("chat:sendReport")
AddEventHandler("chat:sendReport", function(playerName, playerId, message)
    TriggerEvent('chat:addMessage', {
        template = '<div style="color: lightgreen;">' .. Configmain.Textos.PrefijoReporte .. ' <strong>{0}</strong> (ID: {1}): {2}</div>',
        args = { playerName, playerId, message }
    })
end)

RegisterNetEvent("chat:reportConfirmation")
AddEventHandler("chat:reportConfirmation", function()
    TriggerEvent("chat:addMessage", {
        template = '<div style="color: lightblue;">' .. Configmain.Textos.ConfirmacionReporte .. '</div>',
        args = nil
    })
end)

if Configmain.CommandsEnabled.Bengal then
    RegisterCommand(Configmain.Command.Bengal, function()
        TriggerServerEvent('chat:triggerBengala')
    end, false)
end

RegisterNetEvent('chat:bengala', function(targetCoords)
    local duration = Config.BlipCallTimer
    local radius = 50.0
    local colourBlip = "BLIP_MODIFIER_DEBUG_RED"

    local blip = Citizen.InvokeNative(
        0x45F13B7E0A15C880,
        GetHashKey(colourBlip),
        targetCoords.x, targetCoords.y, targetCoords.z,
        radius
    )

    SetBlipSprite(blip, 1)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Bengala")

    while duration > 0 do
        Citizen.Wait(1000)
        duration = duration - 1
    end

    RemoveBlip(blip)
end)


Citizen.CreateThread(function()

    if Configmain.CommandsEnabled.Directmessage then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Directmessage, Configmain.Textos.Directmessage, {
            { name = Configmain.Textos.Playerid, help = Configmain.Textos.Playerid},
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Directmessagemedic then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Directmessagemedic, Configmain.Textos.Directmessagemedic, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Directmessagepolice then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Directmessagepolice, Configmain.Textos.Directmessagepolice, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Ontheway then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Ontheway, Configmain.Textos.Ontheway, {
            { name = Configmain.Textos.Playerid, help = Configmain.Textos.Playerid},
        })
    end

    if Configmain.CommandsEnabled.Help then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Help, Configmain.Textos.Help, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Flight then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Flight, Configmain.Textos.Flight, {})
    end

    if Configmain.CommandsEnabled.Bengal then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Bengal, Configmain.Textos.Bengal, {})
    end

    if Configmain.CommandsEnabled.Report then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Report, Configmain.Textos.Report, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Trade then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Trade, Configmain.Textos.Trade, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Gossip then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Gossip, Configmain.Textos.Gossip, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    if Configmain.CommandsEnabled.Witness then
        TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Witness, Configmain.Textos.Witness, {
            { name = Configmain.Textos.Message, help = Configmain.Textos.Message}
        })
    end

    -- Estos comandos siempre están habilitados
    TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Do, "", {
        { name = Configmain.Textos.Message }
    })

    TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Me, "", {
        { name = Configmain.Textos.Message }
    })

    TriggerEvent('chat:addSuggestion', '/' .. Configmain.Command.Ooc, "", {
        { name = Configmain.Textos.Message }
    })
    
end)
