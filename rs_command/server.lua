local VORPcore = exports.vorp_core:GetCore()

AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then

        local playerId = source
        local prefix = Configmain.Textos.Prefix

        TriggerClientEvent('chat:addOOCProximity', -1, playerId, prefix, message, 7.0)
    end
    CancelEvent()
end)

if Configmain.CommandsEnabled.Report then
    RegisterCommand(Configmain.Command.Report, function(source, args)
        local _source = source
        local msg = table.concat(args, ' ')
        if msg == '' then return end

        local name = GetPlayerName(_source)
        local User = VORPcore.getUser(_source)
        local Character = User.getUsedCharacter
        local playerName = Character.firstname .. ' ' .. Character.lastname
        local playerId = tostring(_source)

        local admins = {}
        for _, playerId in ipairs(GetPlayers()) do
            local user = VORPcore.getUser(tonumber(playerId))
            if user ~= nil then
                local group = user.getGroup
                if group and (group == "admin" or group == "moderator") then
                    table.insert(admins, tonumber(playerId))
                end
            end
        end

        TriggerClientEvent("chat:reportConfirmation", _source)

        if #admins > 0 then
            for _, adminId in ipairs(admins) do
                TriggerClientEvent("chat:sendReport", adminId, playerName, playerId, msg)
            end
        else
            local webhook = Config.ReportWebhook
            local reportData = {
                username = Configmain.Textos.ReportSytem,
                embeds = { {
                    title = Configmain.Textos.NewMes,
                    description = Configmain.Textos.TextoJugador .. playerName .. " (ID: " .. playerId .. ")\n" .. Configmain.Textos.TextoMensaje .. msg,
                    color = 16711680
                }}
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(reportData), { ['Content-Type'] = 'application/json' })
        end
    end, false)
end   

RegisterCommand(Configmain.Command.Me, function(source, args)
    local User = VORPcore.getUser(source)
    local Character = User.getUsedCharacter
    local playerName = Character.firstname .. ' ' .. Character.lastname
    local msg = table.concat(args, " ")
    TriggerClientEvent("chat:addMessageProximity", -1, source, playerName, msg, Configmain.Textos.Me, 7.0)
end)

RegisterCommand(Configmain.Command.Do, function(source, args)
    local User = VORPcore.getUser(source)
    local Character = User.getUsedCharacter
    local playerName = Character.firstname .. ' ' .. Character.lastname
    local msg = table.concat(args, " ")
    TriggerClientEvent("chat:addMessageProximity1", -1, source, playerName, msg, Configmain.Textos.Do, 7.0)
end)

RegisterCommand(Configmain.Command.Ooc, function(source, args)
    local msg = table.concat(args, " ")
    TriggerClientEvent("chat:addMessageProximity2", -1, source, msg, Configmain.Textos.Ooc, 7.0)
end)

local discordWebhookComercio = Config.Trade
local discordWebhookChisme = Config.Gossip

local function sendToDiscord(webhook, playerName, message, title)
    local data = {
        username = Configmain.Textos.ServerChat,
        embeds = {{
            title = Configmain.Textos.Title,
            description = Configmain.Textos.TextoJugador ..playerName.."\n" .. Configmain.Textos.TextoMensaje ..message,
            color = 3447003
        }}
    }
    PerformHttpRequest(webhook, function(err, text, headers) 

    end, "POST", json.encode(data), {["Content-Type"] = "application/json"})
end

if Configmain.CommandsEnabled.Trade then
    RegisterCommand(Configmain.Command.Trade, function(source, args)
        local msg = table.concat(args, " ")
        if msg == nil or msg == "" then
            TriggerClientEvent("chat:addMessage", source, {
                template = '<div style="color: lightblue;">' .. Configmain.Textos.ErrorComercioUso .. '</div>',
                args = {}
            })
            return
        end

        local SenderUser = VORPcore.getUser(source)
        if not SenderUser then return end
        local SenderCharacter = SenderUser.getUsedCharacter
        if not SenderCharacter then return end
        local senderName = SenderCharacter.firstname .. " " .. SenderCharacter.lastname

        TriggerClientEvent("chat:addMessageAll", -1, source, msg, Configmain.Textos.EtiquetaComercio)
        sendToDiscord(discordWebhookComercio, senderName, msg, Configmain.Textos.EtiquetaComercio)
    end)
end

if Configmain.CommandsEnabled.Trade then
    RegisterCommand(Configmain.Command.Gossip, function(source, args)
        local msg = table.concat(args, " ")
        if msg == nil or msg == "" then
            TriggerClientEvent("chat:addMessage", source, {
                template = '<div style="color: lightblue;">' .. Configmain.Textos.ErrorChismeUso .. '</div>',
                args = {}
            })
            return
        end

        local SenderUser = VORPcore.getUser(source)
        if not SenderUser then return end
        local SenderCharacter = SenderUser.getUsedCharacter
        if not SenderCharacter then return end
        local senderName = SenderCharacter.firstname .. " " .. SenderCharacter.lastname

        TriggerClientEvent("chat:addMessageAll1", -1, source, msg, Configmain.Textos.EtiquetaChisme)
        sendToDiscord(discordWebhookChisme, senderName, msg, Configmain.Textos.EtiquetaChisme)
    end)
end

if Configmain.CommandsEnabled.Directmessage then
    RegisterCommand(Configmain.Command.Directmessage, function(source, args)
        local playerId = tonumber(args[1])
        if not playerId then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorMPUso)
            return
        end

        table.remove(args, 1)
        local msg = table.concat(args, " ")
        if msg == nil or msg == "" then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorMPVacio)
            return
        end

        local SenderUser = VORPcore.getUser(source)
        if not SenderUser then return end

        local SenderCharacter = SenderUser.getUsedCharacter
        local senderName = SenderCharacter.firstname .. " " .. SenderCharacter.lastname

        local TargetUser = VORPcore.getUser(playerId)
        if not TargetUser then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorMPNoConectado)
            return
        end

        TriggerClientEvent("chat:addMessageMP", playerId, source, senderName, msg)
        TriggerClientEvent("chatMessage", source, Configmain.Textos.MPConfirmacion .. " " .. senderName, {0,255,0})
    end)
end

local discordWebhookMedic = Config.Medic
local discordWebhookPolice = Config.Police

local function sendToDiscord(webhook, playerName, message, title)
    local data = {
        username = Configmain.Textos.ServerMp,
        embeds = {{
            title = Configmain.Textos.Dmessage,
            description = Configmain.Textos.TextoJugador ..playerName.."\n" .. Configmain.Textos.TextoMensaje ..message,
            color = 65280
        }}
    }
    PerformHttpRequest(webhook, function(err, text, headers) 

    end, "POST", json.encode(data), {["Content-Type"] = "application/json"})
end

if Configmain.CommandsEnabled.Directmessagemedic then
    RegisterCommand(Configmain.Command.Directmessagemedic, function(source, args)
        local msg = table.concat(args, " ")
        if msg == nil or msg == "" then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorMPMUso)
            return
        end

        local SenderUser = VORPcore.getUser(source)
        if not SenderUser then return end

        local SenderCharacter = SenderUser.getUsedCharacter
        if not SenderCharacter then return end

        local senderJob = SenderCharacter.job
        local isMedic = false
        for _, job in ipairs(Configmain.Jobs.Doctores) do
            if senderJob == job then
                isMedic = true
                break
            end
        end

        if not isMedic then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.Onlydoctor)
            return
        end

        local senderName = SenderCharacter.firstname .. " " .. SenderCharacter.lastname

        sendToDiscord(discordWebhookMedic, senderName, msg, Configmain.Textos.Mpm)

        for _, playerId in ipairs(GetPlayers()) do
            local TargetUser = VORPcore.getUser(playerId)
            if TargetUser then
                local TargetCharacter = TargetUser.getUsedCharacter
                if TargetCharacter and TargetCharacter.job then
                    for _, job in ipairs(Configmain.Jobs.Doctores) do
                        if TargetCharacter.job == job then
                            TriggerClientEvent("chat:addMessageMPM", tonumber(playerId), " " .. senderName, msg)
                            break
                        end
                    end
                end
            end
        end

        TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {0, 255, 100}, Configmain.Textos.Mpmok)
    end)
end

if Configmain.CommandsEnabled.Directmessagepolice then
    RegisterCommand(Configmain.Command.Directmessagepolice, function(source, args)
        local msg = table.concat(args, " ")
        if msg == nil or msg == "" then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorMPPUso)
            return
        end

        local SenderUser = VORPcore.getUser(source)
        if not SenderUser then return end

        local SenderCharacter = SenderUser.getUsedCharacter
        if not SenderCharacter then return end

        local senderJob = SenderCharacter.job
        local isPolice = false
        for _, job in ipairs(Configmain.Jobs.Policias) do
            if senderJob == job then
                isPolice = true
                break
            end
        end

        if not isPolice then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.Onlypolice)
            return
        end

        local senderName = SenderCharacter.firstname .. " " .. SenderCharacter.lastname

        sendToDiscord(discordWebhookPolice, senderName, msg, Configmain.Textos.Mpp)

        for _, playerId in ipairs(GetPlayers()) do
            local TargetUser = VORPcore.getUser(playerId)
            if TargetUser then
                local TargetCharacter = TargetUser.getUsedCharacter
                if TargetCharacter and TargetCharacter.job then
                    for _, job in ipairs(Configmain.Jobs.Policias) do
                        if TargetCharacter.job == job then
                            TriggerClientEvent("chat:addMessageMPP", tonumber(playerId), " " .. senderName, msg)
                            break
                        end
                    end
                end
            end
        end

        TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {0, 255, 100}, Configmain.Textos.Policeok)
    end)
end

local huidaPlayers = {}
local auxiliosEnProceso = {}
local discordWebhookTestigo = Config.Witness
local discordWebhookAuxilio = Config.Help
local discordWebhookHuida = Config.Flight

local function sendToDiscord(webhook, playerName, message, title)
    local data = {
        username = Configmain.Textos.ServerEmer,
        embeds = { {
            title = Configmain.Textos.Emer,
            description = Configmain.Textos.TextoJugador ..playerName.."\n" .. Configmain.Textos.TextoMensaje ..message,
            color = 16711680
        } }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode(data), {["Content-Type"] = "application/json"})
end

RegisterNetEvent('chat:sendcall', function(targetCoords, msg, emergency)
    local _source = source
    local User = VORPcore.getUser(_source)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end
    local players = GetPlayers()
    local senderName = Character.firstname .. " " .. Character.lastname

    if emergency == 'testigo' then
        for _, v in pairs(players) do
            local othPly = VORPcore.getUser(v)
            if othPly then
                local othCharacter = othPly.getUsedCharacter
                if othCharacter then
                    for _, job in ipairs(Configmain.Jobs.Policias) do
                        if othCharacter.job == job then
                            TriggerClientEvent("chatMessage", v, Configmain.Textos.EtiquetaTestigo .. " (ID: " .. _source .. ")", {255, 0, 0}, msg)
                            TriggerClientEvent('chat:marcador', v, targetCoords, emergency, -1747825963)
                        end
                    end
                end
            end
        end

        TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaSistema, {0, 255, 0}, Configmain.Textos.MensajeTestigoEnviado)
        sendToDiscord(discordWebhookTestigo, senderName, msg, Configmain.Textos.EtiquetaTestigos)

    elseif emergency == 'huida' then
        if huidaPlayers[_source] then
            TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaSistema, {255, 255, 0}, Configmain.Textos.MensajeHuidaActiva)
            return
        end

        huidaPlayers[_source] = { time = os.time(), active = true }

        TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaHuida, {255, 0, 0}, Configmain.Textos.MensajeHuidaInicio)
        TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaSistema, {0, 255, 0}, Configmain.Textos.MensajeHuidaEnviada)

        sendToDiscord(discordWebhookHuida, senderName, msg, Configmain.Textos.EtiquetaHuidas)

        local function enviarMarcadorIndividual()
            for _, v in pairs(players) do
                local othPly = VORPcore.getUser(v)
                if othPly then
                    local othCharacter = othPly.getUsedCharacter
                    if othCharacter then
                        for _, job in ipairs(Configmain.Jobs.Policias) do
                            if othCharacter.job == job then
                                local playerPed = GetPlayerPed(_source)
                                if playerPed then
                                    local playerCoords = GetEntityCoords(playerPed)
                                    TriggerClientEvent('chat:marcador', v, playerCoords, "huida", -2018361632)
                                    VORPcore.NotifyAvanced(v, Configmain.Textos.NotificacionHuida, "generic_textures", "tick", "COLOR_RED", 4000)
                                end
                            end
                        end
                    end
                end
            end
        end

        local count = 0
        local function loopTemporizador()
            if not huidaPlayers[_source] then return end

            enviarMarcadorIndividual()
            count = count + 1

            if count < 10 then
                Citizen.SetTimeout(30000, loopTemporizador)
            else
                huidaPlayers[_source] = nil
                TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaSistema, {255, 255, 0}, Configmain.Textos.MensajeHuidaFin)
            end
        end

        loopTemporizador()

    elseif emergency == 'auxilio' then
        auxiliosEnProceso[_source] = {
            coords = targetCoords,
            msg = msg,
            timestamp = os.time()
        }

        for _, v in pairs(players) do
            local othPly = VORPcore.getUser(v)
            if othPly then
                local othCharacter = othPly.getUsedCharacter
                if othCharacter then
                    for _, job in ipairs(Configmain.Jobs.Doctores) do
                        if othCharacter.job == job then
                            TriggerClientEvent("chatMessage", v, Configmain.Textos.EtiquetaAuxilio .. " (ID: " .. _source .. ")", {255, 0, 0}, msg)
                            TriggerClientEvent('chat:marcador', v, targetCoords, emergency, 1000514759)
                        end
                    end
                end
            end
        end

        TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaSistema, {0, 255, 0}, Configmain.Textos.MensajeAuxilioEnviado)
        sendToDiscord(discordWebhookAuxilio, senderName, msg, Configmain.Textos.EtiquetaAuxilios)
    end
end)

if Configmain.CommandsEnabled.Ontheway then
    RegisterCommand(Configmain.Command.Ontheway, function(source, args)
        local doctorPly = VORPcore.getUser(source)
        if not doctorPly then 
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorUsuarioNoEncontrado)
            return
        end

        local doctorChar = doctorPly.getUsedCharacter
        if not doctorChar then 
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorPersonajeNoEncontrado)
            return
        end

        local jobName = doctorChar.job
        local tienePermiso = false
        for _, job in ipairs(Configmain.Jobs.Doctores) do
            if jobName == job then
                tienePermiso = true
                break
            end
        end

        if not tienePermiso then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorSinPermiso)
            return
        end

        local targetId = tonumber(args[1])
        if not targetId then
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorIDNoValido)
            return
        end

        if auxiliosEnProceso[targetId] then
            TriggerClientEvent("chatMessage", targetId, Configmain.Textos.EtiquetaAuxilio, {0,255,0}, Configmain.Textos.AvisoDoctorEnCamino)
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {0,255,0}, Configmain.Textos.AvisoEnviado .. targetId)
        else
            TriggerClientEvent("chatMessage", source, Configmain.Textos.EtiquetaSistema, {255,0,0}, Configmain.Textos.ErrorSinAuxilio .. targetId)
        end
    end, false)
end


RegisterNetEvent('chat:triggerBengala')
AddEventHandler('chat:triggerBengala', function()
    local _source = source
    local User = VORPcore.getUser(_source)
    if not User then return end
    local Character = User.getUsedCharacter
    if not Character then return end

    local job = Character.job
    local tienePermiso = false
    for _, j in ipairs(Configmain.Jobs.Policias) do
        if job == j then
            tienePermiso = true
            break
        end
    end

    if not tienePermiso then
        TriggerClientEvent("chatMessage", _source, Configmain.Textos.EtiquetaSistema, {255, 0, 0}, Configmain.Textos.ErrorSinPermisoBengala)
        return
    end

    local playerName = Character.firstname .. ' ' .. Character.lastname
    TriggerClientEvent("chat:addMessageProximity", -1, _source, playerName, Configmain.Textos.MensajeAccionBengala, "ME", 7.0)

    local players = GetPlayers()
    for _, v in pairs(players) do
        local other = VORPcore.getUser(v)
        if other then
            local otherChar = other.getUsedCharacter
            if otherChar then
                for _, j in ipairs(Configmain.Jobs.Policias) do
                    if otherChar.job == j then
                        TriggerClientEvent("chatMessage", v, Configmain.Textos.EtiquetaBengala, {255, 0, 0}, Configmain.Textos.MensajeGlobalBengala)
                    end
                end
            end
        end
    end

    local ped = GetPlayerPed(_source)
    if not ped then return end
    local coords = GetEntityCoords(ped)

    for _, v in pairs(players) do
        local other = VORPcore.getUser(v)
        if other then
            local otherChar = other.getUsedCharacter
            if otherChar then
                for _, j in ipairs(Configmain.Jobs.Policias) do
                    if otherChar.job == j then
                        TriggerClientEvent('chat:bengala', v, coords)
                    end
                end
            end
        end
    end
end)
