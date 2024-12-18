
local isInAnim = false

local function isAnimEnded()
    return not isInAnim
end

local function loadModel(model, cb)
    ESX.Streaming.RequestModel(model, cb)
end

local function loadAnimDict(dict, cb)
    ESX.Streaming.RequestAnimDict(dict, cb)
end

local function insertCardAnim(cb)
    isInAnim = true
    print("asdasd1")
    local dict = 'amb@prop_human_atm@male@enter'
    local anim = 'enter'
    loadAnimDict(dict, function()
        local model = Config.Objects.Card
        print("asdasd")
        loadModel(model, function()
            local playerPed = PlayerPedId()
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            local cardObj = CreateObject(model, 0, 0, 0, true, true, false)
            G_CurrentAtmHandler:setCardObject(cardObj)
            local offset = vector3(0.1, 0.03, -0.05)
            local rot = vector3(0.0, 0.0, 180.0)
            AttachEntityToEntity(cardObj, playerPed, boneIndex, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, true, true, false, true, 1, true)
            TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
            Wait(1500)
            ClearPedTasks(playerPed)
            DetachEntity(cardObj, false, false)
            FreezeEntityPosition(cardObj, true)
            local atmObject = G_CurrentAtmHandler:getAtmObject()
            local modelHash = GetEntityModel(atmObject)
            local offset = Config.Offsets.CardPos[modelHash] or Config.Offsets.CardPos.Default
            local coords = GetOffsetFromEntityInWorldCoords(atmObject, offset.First.x, offset.First.y, offset.First.z)
            SetEntityCoords(cardObj, coords.x, coords.y, coords.z)
            local heading = GetEntityHeading(atmObject)
            SetEntityRotation(cardObj, -90.0, 90.0, heading, 2, true)
            local isSliding = false
            local secondCoords = GetOffsetFromEntityInWorldCoords(atmObject, offset.Second.x, offset.Second.y, offset.Second.z)
            while not isSliding do
                isSliding = SlideObject(cardObj, secondCoords.x, secondCoords.y, secondCoords.z, 0.001, 0.001, 0.001, false)
                Wait(10)
            end
            SetEntityAlpha(playerPed, 120, false)
            isInAnim = false
            return cb(cardObj)
        end)
    end)
end

local function removeCardAnim(cb)
    isInAnim = true
    local dict = 'amb@prop_human_atm@male@exit'
    local anim = 'exit'
    loadAnimDict(dict, function()
        local model = Config.Objects.Card
        local playerPed = PlayerPedId()
        local boneIndex = GetPedBoneIndex(playerPed, 28422)
        local offset = vector3(0.1, 0.03, -0.05)
        local rot = vector3(0.0, 0.0, 180.0)
        local cardObj = G_CurrentAtmHandler:getCardObject()
        AttachEntityToEntity(cardObj, playerPed, boneIndex, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, true, true, false, true, 1, true)
        TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
        Wait(3000)
        ClearPedTasks(playerPed)
        DetachEntity(cardObj, false, false)
        DeleteEntity(cardObj)
        isInAnim = false
        return cb(cardObj)
    end)
end

local function insertCashAnim(cb)
    isInAnim = true
    local dict = 'mp_common'
    local anim = 'givetake1_a'
    loadAnimDict(dict, function()
        local model = Config.Objects.Cash
        local playerPed = PlayerPedId()
        local boneIndex = GetPedBoneIndex(playerPed, 57005)
        local cashObj = CreateObject(model, 0, 0, 0, true, true, false)
        AttachEntityToEntity(cashObj, playerPed, boneIndex, 0.1, 0.03, -0.05, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
        TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
        Wait(3000)
        ClearPedTasks(playerPed)
        DetachEntity(cashObj, false, false)
        FreezeEntityPosition(cashObj, true)
        local atmObject = G_CurrentAtmHandler:getAtmObject()
        local modelHash = GetEntityModel(atmObject)
        local offset = Config.Offsets.MoneyWithdraw[modelHash] or Config.Offsets.CashPos.Default
        local coords = GetOffsetFromEntityInWorldCoords(atmObject, offset.First.x, offset.First.y, offset.First.z)
        SetEntityCoords(cashObj, coords.x, coords.y, coords.z)
        local heading = GetEntityHeading(atmObject)
        SetEntityRotation(cashObj, -90.0, 90.0, heading, 2, true)
        local isSliding = false
        local secondCoords = GetOffsetFromEntityInWorldCoords(atmObject, offset.Second.x, offset.Second.y, offset.Second.z)
        print(cashObj)
        while not isSliding do
            isSliding = SlideObject(cashObj, secondCoords.x, secondCoords.y, secondCoords.z, 0.001, 0.001, 0.001, false)
            Wait(10)
        end
        DeleteEntity(cashObj)
        isInAnim = false
        return cb()
    end)
end

local function removeCashAnim(cb)
    isInAnim = true
    local dict = 'mp_common'
    local anim = 'givetake1_a'
    loadAnimDict(dict, function()
        local model = Config.Objects.Cash
        local playerPed = PlayerPedId()
        local boneIndex = GetPedBoneIndex(playerPed, 57005)
        local cashObj = CreateObject(model, 0, 0, 0, true, true, false)
        local atmObject = G_CurrentAtmHandler:getAtmObject()
        local modelHash = GetEntityModel(atmObject)
        local offset = Config.Offsets.MoneyDeposit[modelHash] or Config.Offsets.CashPos.Default
        local coords = GetOffsetFromEntityInWorldCoords(atmObject, offset.Second.x, offset.Second.y, offset.Second.z)
        SetEntityCoords(cashObj, coords.x, coords.y, coords.z)
        local heading = GetEntityHeading(atmObject)
        SetEntityRotation(cashObj, -90.0, 90.0, heading, 2, true)
        TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
        Wait(3000)
        ClearPedTasks(playerPed)
        AttachEntityToEntity(cashObj, playerPed, boneIndex, 0.1, 0.03, -0.05, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
        Wait(1000)
        DetachEntity(cashObj, false, false)
        DeleteEntity(cashObj)
        isInAnim = false
        return cb()
    end)
end

AnimHandler = {
    insertCardAnim = insertCardAnim,
    removeCardAnim = removeCardAnim,
    insertCashAnim = insertCashAnim,
    removeCashAnim = removeCashAnim,
    isAnimEnded = isAnimEnded
}