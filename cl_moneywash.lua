local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, location in pairs(Config.PedLocations) do
        local coords = vector3(location.x, location.y, location.z)
        local heading = location.w

        RequestModel(Config.PedModel)
        while not HasModelLoaded(Config.PedModel) do Wait(0) end

        local ped = CreatePed(0, Config.PedModel, coords.x, coords.y, coords.z - 1.0, heading, false, false)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        TaskStartScenarioInPlace(ped, "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", 0, true)

        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    label = "Lavar dinero",
                    icon = "fas fa-money-bill",
                    action = function()
                        OpenMoneyWashMenu()
                    end,
                }
            },
            distance = 2.0
        })
    end
end)

function OpenMoneyWashMenu()
    local menu = {
        {
            header = "Selecciona tipo de dinero ilegal",
            isMenuHeader = true
        }
    }

    for item, rate in pairs(Config.MoneyWashRates) do
        table.insert(menu, {
            header = QBCore.Shared.Items[item].label,
            txt = "Tasa: "..(rate * 100).."%",
            params = {
                event = "randol_moneywash:client:inputamount",
                args = { itemName = item, rate = rate }
            }
        })
    end

    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent("randol_moneywash:client:inputamount", function(data)
    local itemName = data.itemName
    local rate = data.rate

    QBCore.Functions.TriggerCallback('randol_moneywash:server:getItemCount', function(count)
        if count and count > 0 then
            local input = exports['qb-input']:ShowInput({
                header = "¿Cuánto quieres lavar?",
                submitText = "Lavar",
                inputs = {
                    {
                        text = "Cantidad disponible: "..count,
                        name = "amount",
                        type = "number",
                        isRequired = true
                    }
                }
            })

            if input and input.amount then
                local washAmount = tonumber(input.amount)
                if washAmount and washAmount > 0 and washAmount <= count then
                    TriggerServerEvent("randol_moneywash:server:checkforbills", itemName, washAmount)
                else
                    QBCore.Functions.Notify("Cantidad inválida.", "error")
                end
            end
        else
            QBCore.Functions.Notify("No tienes suficiente de ese tipo de dinero ilegal.", "error")
        end
    end, itemName)
end)

RegisterNetEvent("randol_moneywash:client:exchangebills", function(amount)
    QBCore.Functions.Progressbar("washing_money", "Lavando dinero...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent("randol_moneywash:server:returncleancash", amount)
    end, function()
        QBCore.Functions.Notify("Cancelado", "error")
    end)
end)
