ESX = exports["es_extended"]:getSharedObject()
CurrentAtmHandler = nil
UseATM = false
local PINCODEHASH = nil

function notify(msg)
    ESX.ShowNotification(msg)
end



local function openATM(data)
    local atmEntity = data.entity
    local atmCoords = GetEntityCoords(atmEntity)
    local atmStringCoords = Shared.CoordsToString(atmCoords)
    ESX.TriggerServerCallback('esx_realistic_atm:callbacks', function(response, data)
        if not response then
            notify('This ATM is currently in use by another player')
            return
        end
        CurrentAtmHandler = NewATMHandler(atmEntity, atmStringCoords)
        local money, bankMoney, pincodeHash = data.money, data.bank, data.pincodeHash
        local waitTime = 3000
        local playerPed = PlayerPedId()
        local atmPedCoords = TaskGoStraightToCoord(playerPed, atmCoords.x, atmCoords.y - 0.5, atmCoords.z, 1.0, waitTime, GetEntityHeading(atmEntity), 0.0)
        while waitTime > 0 do
            waitTime = waitTime - 100
            Wait(100)
            if #(GetEntityCoords(playerPed) - atmPedCoords) < 0.3 then
                break
            end
        end
        CurrentAtmHandler:openATM(money, bankMoney, pincodeHash)
        local animData = Config.Anims.OpenATM
        ESX.Streaming.RequestAnimDict(animData.AnimDict, function()
            ESX.Streaming.RequestModel(animData.Model, function()
                local boneIndex = GetPedBoneIndex(playerPed, animData.Bone)
                local cardObj = CreateObject(animData.Model, 0, 0, 0, true, true, false)
                AttachEntityToEntity(cardObj, playerPed, boneIndex, animData.Offset.x, animData.Offset.y, animData.Offset.z, animData.Rot.x, animData.Rot.y, animData.Rot.z, true, true, false, true, 1, true)
                TaskPlayAnim(playerPed, animData.AnimDict, animData.Anim, 8.0, 8.0, -1, 0, 0, false, false, false)
                Wait(5000)
                ClearPedTasks(playerPed)
                DetachEntity(cardObj, false, false)
                CurrentAtmHandler:insertCard(cardObj)

                local pincodeHash = data.pincodeHash
                local bank = data.bank
                local money = data.money
                CurrentAtmHandler:openATM(money, bank, pincodeHash)
            end)
        end)
    end, 'useATM', atmStringCoords)
end

Citizen.CreateThread(function()
    if Config.TargetOptions.Enable then
        if not Config.TargetOptions.TargetScript then
            print('esx_realistic_atm: TargetScript is not set')
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

local nuiHandlers = {
    checkPin = function(data)
       return CurrentAtmHandler:checkPin(data.pin)
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
            Citizen.Wait(0)
        end
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
    exitATM()
    cb({ok = true})
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        exitATM()
    end
end)
