ESX = exports["es_extended"]:getSharedObject()
Config = Config or {}


ESX.RegisterServerCallback("farmer:MilkingCow", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.canCarryItem("lait_brut", 1) then
        xPlayer.addInventoryItem("lait_brut", 1)
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("farmer:ProcessMilk")
AddEventHandler("farmer:ProcessMilk", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local rawMilk = xPlayer.getInventoryItem("lait_brut").count

    if rawMilk > 0 then
        while rawMilk > 0 do
            xPlayer.removeInventoryItem("lait_brut", 1)
            xPlayer.addInventoryItem("lait_demi", 1)
            rawMilk = rawMilk - 1
        end
        TriggerClientEvent("esx:showNotification", source, "Vous avez transformé le lait brut en lait demi-écrémé.")
    else
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas de lait brut à traiter.")
    end
end)

RegisterNetEvent("farmer:SellMilk")
AddEventHandler("farmer:SellMilk", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local processedMilk = xPlayer.getInventoryItem("fromage").count

    if processedMilk > 0 then
        local price = processedMilk * Config.MilkPrice
        xPlayer.removeInventoryItem("fromage", processedMilk)
        xPlayer.addMoney(price)
        TriggerClientEvent("esx:showNotification", source, "Vous avez vendu " .. processedMilk .. " bouteilles de lait pour $" .. price)
    else
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas de lait à vendre.")
    end
end)
