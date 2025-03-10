ESX = exports["es_extended"]:getSharedObject()
Config = Config or {}

local isMilking = false

print(Config.CowLocations)

-- Spawn des vaches
Citizen.CreateThread(function()
    for _, coords in pairs(Config.CowLocations) do
        local hash = GetHashKey("a_c_cow")
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end

        local cow = CreatePed(4, hash, coords.x, coords.y, coords.z, 0.0, false, true)
        SetEntityInvincible(cow, true)
        SetBlockingOfNonTemporaryEvents(cow, true)
    end
end)

-- spawn ped pour la transformation du lait
Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_m_linecook")
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end

    local ped = CreatePed(4, hash, Config.MilkProcessing.x, Config.MilkProcessing.y, Config.MilkProcessing.z, 0.0, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- spawn ped pour la vente du lait
Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_m_linecook")
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end

    local ped = CreatePed(4, hash, Config.MilkSelling.x, Config.MilkSelling.y, Config.MilkSelling.z, 0.0, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- Blips sur la carte
Citizen.CreateThread(function()
    for _, info in pairs(Config.Blips) do
        local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
        SetBlipSprite(blip, info.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, info.scale)
        SetBlipColour(blip, info.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Fonction de traite
function StartMilking()
    if isMilking then return end
    isMilking = true

    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    ESX.ShowNotification("Vous commencez à traire la vache...")

    Citizen.Wait(5000) -- 5 secondes de traite

    ClearPedTasksImmediately(playerPed)
    
    ESX.TriggerServerCallback("farmer:MilkingCow", function(success)
        if success then
            ESX.ShowNotification("Vous avez obtenu ~g~1x Lait Brut~s~.")
        else
            ESX.ShowNotification("~r~Votre inventaire est plein !")
        end
        isMilking = false
    end)
end

-- Détection des vaches pour traire
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, coords in pairs(Config.CowLocations) do
            if #(playerCoords - coords) < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traire la vache.")
                if IsControlJustPressed(0, 38) then
                    StartMilking()
                end
            end
        end
    end
end)

-- Transformation du lait
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        if #(playerCoords - Config.MilkProcessing) < 2.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour transformer le lait.")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("farmer:ProcessMilk")
            end
        end
    end
end)

-- Vente du lait
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        if #(playerCoords - Config.MilkSelling) < 2.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre le lait.")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("farmer:SellMilk")
            end
        end
    end
end)
