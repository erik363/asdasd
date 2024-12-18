ESX = exports["es_extended"]:getSharedObject()

local function openATM(data)
    local atmEntity = data.entity
    local atmCoords = GetEntityCoords(atmEntity)
    local atmStringCoords = Shared.CoordsToString(atmCoords)
    ESX.TriggerServerCallback('esx_realistic_atm:callbacks', function(response, data)
        if not response then
            notify('This ATM is currently in use by another player')
            return
        end
        NewATMHandler(atmEntity, atmStringCoords, data.money, data.bank, data.pincodeHash)
        G_CurrentAtmHandler:openATM()
    end, 'useATM', atmStringCoords)
end

local nuiHandlers = {
    checkPin = function(data)
        print(data.pin)
        print(json.encode(G_CurrentAtmHandler:checkPin(data.pin)))
       return G_CurrentAtmHandler:checkPin(data.pin)
    end,
    changePin = function(data)
        local newPin = data.newPin
        newPin = tonumber(newPin)
        local isSuccess = nil
        ESX.TriggerServerCallback('esx_realistic_atm:callbacks', function(success)
            isSuccess = success or false
        end, 'changePin', newPin)
        while isSuccess == nil do
            Citizen.Wait(0)
        end
        return isSuccess
    end,
    deposit = function(data)
        local amount = data.amount
        local isSuccess = nil
        ESX.TriggerServerCallback('esx_realistic_atm:callbacks', function(success)
            isSuccess = success or false
        end, 'deposit', amount)
        while isSuccess == nil do
            Citizen.Wait(0)
        end
        return isSuccess
    end,
    withdraw = function(data)
        local amount = data.amount
        local isSuccess = nil
        ESX.TriggerServerCallback('esx_realistic_atm:callbacks', function(success)
            isSuccess = success or false
        end, 'withdraw', amount)
        while isSuccess == nil do
            print(1)
            Citizen.Wait(0)
        end
        print(isSuccess)
        if isSuccess then
            AnimHandler.insertCashAnim(function()
            
            end)
        end
        while not AnimHandler.isAnimEnded() do
            print(2)
            Citizen.Wait(0)
        end
        print("kiveszem")
        return isSuccess
    end
}

RegisterNUICallback('handlers', function(data, cb)
    if not nuiHandlers[data.nType] then
        return cb(false)
    end
    return cb(nuiHandlers[data.nType](data))
end)

RegisterNUICallback('closeATM', function(data, cb)
    AnimHandler.removeCardAnim(function()

    end)
    if G_CurrentAtmHandler then
        G_CurrentAtmHandler:exitATM()
    end
    cb({ok = true})
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if G_CurrentAtmHandler then
            G_CurrentAtmHandler:exitATM()
        end
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    if Config.TargetOptions.Enable then
        if not Config.TargetOptions.TargetScript then
            error('esx_realistic_atm: TargetScript is not set')
            return
        end

        if Config.TargetOptions.TargetScript == 'ox_target' then
            for modelHash, _ in pairs(Config.ATMs) do
                exports['ox_target']:addModel(modelHash, {
                    label = Config.TargetOptions.TargetOptions.label,
                    icon = Config.TargetOptions.TargetOptions.icon,
                    onSelect = function(entity)
                        openATM(entity)
                    end,
                    canInteract = function(entity)
                        return not UseATM
                    end
                })
            end
        end  
    end
end)

