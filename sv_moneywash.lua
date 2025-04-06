local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("randol_moneywash:server:checkforbills", function(itemName, washAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rate = Config.MoneyWashRates[itemName]

    if not rate then
        TriggerClientEvent('QBCore:Notify', src, "Tipo de dinero inválido.", "error")
        return
    end

    local item = Player.Functions.GetItemByName(itemName)
    if item and item.amount >= washAmount then
        local cleanCash = math.floor(washAmount * rate)
        Player.Functions.RemoveItem(itemName, washAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], "remove", washAmount)
        TriggerClientEvent('randol_moneywash:client:exchangebills', src, cleanCash)
    else
        TriggerClientEvent('QBCore:Notify', src, "No tienes suficiente dinero ilegal.", "error")
    end
end)

RegisterNetEvent("randol_moneywash:server:returncleancash", function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', amount)
    TriggerClientEvent('QBCore:Notify', src, 'Has recibido $'..amount..' en efectivo limpio.', 'success')
end)

QBCore.Functions.CreateCallback('randol_moneywash:server:getItemCount', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    local item = Player.Functions.GetItemByName(itemName)
    cb(item and item.amount or 0)
end)
