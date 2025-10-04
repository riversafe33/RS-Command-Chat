Configmain = {}

Configmain.ChatAutoFade = { -- Use this if you are using the native CFX chat
    Enabled = false,         -- true = enabled only whith native CFX chat,
    FadeTimeSeconds = 5     -- time the chat remains visible after a message
}

Configmain.Textos = {
    PrefijoReporte = "[REPORT]",
    ConfirmacionReporte = "[System] Your report has been sent successfully.",
    PrefijoAgenteLey = "Law Enforcement Officer",
    PrefijoMensajePrivado = "Private Message from",
    Doctor = "Doctor",
    EtiquetaSistema = "[System]",
    EtiquetaComercio = "Trade",
    EtiquetaChisme = "Gossip",
    MPConfirmacion = "DM sent to",
    ErrorComercioUso = "You must write a message. Usage: /trade [message]",
    ErrorChismeUso = "You must write a message. Usage: /gossip [message]",
    ErrorMPUso = "Usage: /dm [ID] [message]",
    ErrorMPVacio = "The message cannot be empty",
    ErrorMPNoConectado = "The player is not connected.",
    ErrorMPMUso = "Usage: /dmm [message]",
    Onlydoctor = "Only Doctors can use this command.",
    Mpm = "DM Medic",
    Mpmok = "DM sent to the doctors",
    ErrorMPPUso = "Usage: /dmp [message]",
    Onlypolice = "Only Sheriffs can use this command.",
    Mpp = "DM Police",
    Policeok = "DM sent to the Sheriffs",
    MensajeTestigoEnviado = "Witness sent",
    MensajeHuidaEnviada = "Escape sent",
    MensajeAuxilioEnviado = "Help sent",
    MensajeHuidaActiva = "You have already started an escape. Wait until it ends.",
    MensajeHuidaInicio = "From now on, a message and your position will be sent to the Sheriffs every 30 seconds for 5 minutes.",
    MensajeHuidaFin = "The escape has ended.",
    NotificacionHuida = "Bandit on the run, location sent.",
    EtiquetaTestigo = "[Witness]",
    EtiquetaTestigos = "Witness",
    EtiquetaHuida = "[Escape]",
    EtiquetaHuidas = "Escape",
    EtiquetaAuxilio = "[Help]",
    EtiquetaAuxilios = "Help",
    ErrorUsuarioNoEncontrado = "Error: User not found.",
    ErrorPersonajeNoEncontrado = "Error: Character not found.",
    ErrorSinPermiso = "You do not have permission to use this command.",
    ErrorIDNoValido = "You must specify the ID of the player who requested help.",
    AvisoDoctorEnCamino = "A doctor has received your call for help and is on the way.",
    AvisoEnviado = "Notice sent to ID: ",
    ErrorSinAuxilio = "There is no active help for the player with ID ",
    ErrorSinPermisoBengala = "You do not have access to this command.",
    MensajeAccionBengala = "Takes out a flare and lights it, illuminating the sky in red.",
    MensajeGlobalBengala = "A red flare rises into the sky, lighting up the horizon.",
    EtiquetaBengala = "[Flare]",
    TextoJugador = "**Player:** ",
    TextoMensaje = "**Message:** ",
    ReportSytem = "Report System",
    NewMes = "New report",
    ServerChat = "Server Chat",
    Title = "Message",
    ServerMp = "Server DM",
    Dmessage = "Direct Message",
    ServerEmer = "Server Emergencies",
    Emer = "Emergency",
    Me = "ME",
    Do = "DO",
    Ooc = "OOC",
    Prefix = "[OOC]",
    Directmessage = "Send a direct message to another player",
    Directmessagemedic = "Send a message between medics",
    Directmessagepolice = "Send a message between Sheriffs",
    Playerid = "Player ID",
    Message = "Message",
    Ontheway = "Send a message to the injured that you are on the way",
    Help = "Request help from the on-duty medics",
    Flight = "Send your location every 30 seconds to the Sheriffs after a robbery",
    Bengal = "Launch a flare to notify the other Sheriffs of your location",
    Report = "Send a report to the admins about your issue",
    Trade = "Notify other players that you have opened or closed your business",
    Gossip = "This command simulates gossip or what a neighbor might have seen",
    Witness = "Notify the Sheriffs that you are about to commit a crime",
}

Configmain.CommandsEnabled = {
    Help = true,  -- true = enabled, false = disabled
    Witness = true,
    Flight = true,
    Bengal = true,
    Report = true,
    Trade = true,
    Gossip = true,
    Directmessage = true,
    Directmessagemedic = true,
    Directmessagepolice = true, 
    Ontheway = true,
}

Configmain.Command = {
    Witness = "witness", -- Players notify the Sheriffs that they are about to commit a crime
    Flight = "flight", -- Players use this after committing a robbery to send their location to the Sheriffs every 30 seconds for 5 minutes
    Help = "help", -- Command to request help from doctors
    Bengal = "flare", -- This command is used as a flare for Sheriffs to request assistance from other on-duty Sheriffs, accompanied by these messages: MensajeAccionBengala, MensajeGlobalBengala
    Report = "report", -- Allows players to send in-game reports; if there are active admins, they receive the message in-game, otherwise via webhook
    Trade = "trade", -- Allows players to notify when they open or close their business
    Gossip = "gossip", -- This command simulates gossip or what a neighbor might have seen
    Directmessage = "dm", -- Direct message between players
    Directmessagemedic = "dmm", -- Direct message between doctors
    Directmessagepolice = "dmp", -- Direct message between police officers
    Ontheway = "ontheway", -- When a player sends a help request, a doctor can use this to notify that they are on their way by typing /ontheway plus the player ID
    Me = "me",
    Do = "do",
    Ooc = "ooc",
}


-- Police jobs for Directmessagepolice and Bengal
-- Doctor jobs for Directmessagemedic and Ontheway
Configmain.Jobs = {
    Policias = { "police" },
    Doctores = {
        "doctorsd", "doctorbw", "doctorrh",
        "doctorsw", "doctorvl", "doctorar"
    }
}
