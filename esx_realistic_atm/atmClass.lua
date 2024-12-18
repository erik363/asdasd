G_CurrentAtmHandler = nil
local G_Opened = false
local G_DuiIsReady = false
local G_Counter = 0
--============================================================================
local AtmClass = {}
AtmClass.__index = AtmClass

function AtmClass:new(currentATM, atmStringCoords, money, bankMoney, pincodeHash)
    local self = setmetatable({}, AtmClass)
    self.atmId = atmStringCoords
    TriggerServerEvent("esx_realistic_atm:handlers", "openATM", self.atmId)
    self.currentATM = currentATM
    if not DoesEntityExist(self.currentATM) then
        TriggerServerEvent("esx_realistic_atm:handlers", "exitATM", self.atmId)
        error("ERROR: ATM entity does not exist")
    end
    self.atmModelHash = GetEntityModel(self.currentATM)

    --camera
    self.cam = nil
    self.camOffset = Config.CamOffsets[self.atmModelHash] or Config.CamOffsets.Default
    self.camRot = Config.CamRots[self.atmModelHash] or Config.CamRots.Default
    if not (self.camOffset and self.camRot) then
        TriggerServerEvent("esx_realistic_atm:handlers", "exitATM", self.atmId)
        error("ERROR: No camera offset or rotation found for atm model: " .. self.atmModelHash)
    end
    self.pincodeHash = nil

    --ratios
    self.ratios = Config.Ratios[self.atmModelHash]
    --duiHandle
    self.duiobject = nil
    self.duiHandler = nil
    self.newDict = nil
    self.newTexture = nil
    self.originalDict = Config.ATMs[self.atmModelHash].OriginalDict
    self.originalTexture = Config.ATMs[self.atmModelHash].OriginalTexture

    self.money = money
    self.bankMoney = bankMoney
    self.pincodeHash = pincodeHash

    self.cardObject = nil
    self.moneyObject = nil

    G_Opened = true
    return self
end

function AtmClass:getAtmObject()
    return self.currentATM
end

function AtmClass:setCardObject(cardObject)
    self.cardObject = cardObject
end

function AtmClass:getCardObject()
    return self.cardObject
end

function AtmClass:setMoneyObject(moneyObject)
    self.moneyObject = moneyObject
end

function AtmClass:getMoneyObject()
    return self.moneyObject
end

-- camera handlers
function AtmClass:setCam()
    if self.cam then return end
    self.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(self.cam, Config.CameraFov or 70.0)
    local camCoords = GetOffsetFromEntityInWorldCoords(self.currentATM, self.camOffset.x, self.camOffset.y,
        self.camOffset.z)
    SetCamCoord(self.cam, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtEntity(self.cam, self.currentATM, self.camRot.x, self.camRot.y, self.camRot.z, true)
    SetCamActive(self.cam, true)
    RenderScriptCams(true, true, Config.CamEase, true, true)
end

function AtmClass:destroyCam()
    if not self.cam then return end
    RenderScriptCams(false, true, Config.CamEase, true, true)
    DestroyCam(self.cam, true)
    self.cam = nil
end

-- handlers atm lights
function AtmClass:enableScorched()
    if not Config.Scorched.SetScorched then return end
    if not DoesEntityExist(self.currentATM) then return end
    if Config.Scorched.CustomFuncEnable then
        Config.Scorched.CustomFuncEnable(self.currentATM)
        return
    end
    SetEntityRenderScorched(self.currentATM, true)
end

function AtmClass:disableScorched()
    if not Config.Scorched.SetScorched then return end
    if not DoesEntityExist(self.currentATM) then return end
    if Config.Scorched.CustomFuncDisable then
        Config.Scorched.CustomFuncDisable(self.currentATM)
        return
    end
    SetEntityRenderScorched(self.currentATM, true)
    SetEntityRenderScorched(self.currentATM, false)
end

-- controls
function AtmClass:disableControls()
    Citizen.CreateThread(function()
        local keys = Config.DisableControls
        if not keys or #keys < 1 then return end
        local DisableControlAction = DisableControlAction
        while G_Opened do
            Wait(0)
            for _, key in ipairs(keys) do
                DisableControlAction(0, key, true)
            end
        end
    end)
end

function AtmClass:inputHandler()
    Citizen.CreateThread(function()
        local resX, resY = GetActualScreenResolution()
        local function handleButtonClick(action)
            SendDuiMessage(self.duiobject, json.encode({ type = "buttonClick", action = action }))
        end
        SetNuiFocus(false, true)
        local IsControlJustPressed = IsControlJustPressed
        local GetActualScreenResolution = GetActiveScreenResolution
        local GetNuiCursorPosition = GetNuiCursorPosition
        while G_Opened do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 24) then
                resX, resY = GetActualScreenResolution()
                local cursorX, cursorY = GetNuiCursorPosition()
                local ratioX = cursorX / resX
                local ratioY = cursorY / resY
                for i, ratio in ipairs(self.ratios) do
                    if ratioX >= ratio.x and ratioX <= ratio.x2 and ratioY >= ratio.y and ratioY <= ratio.y2 then
                        handleButtonClick(self.ratios[i].action)
                        break
                    end
                end
                Wait(100)
            end
            if IsControlJustPressed(0, 177) then -- ESC
                self:exitATM()
            end
        end
    end)
end

-- checkers
function AtmClass:isPlayerNear()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local atmCoords = GetEntityCoords(self.currentATM)
    local distance = #(playerCoords - atmCoords)
    return distance <= Config.MaxDistance
end

function AtmClass:checkPin(pin)
    if not self.pincodeHash then return end
    if not pin then return end
    local pinHash = GetHashKey(pin)
    return { isAccepted = pinHash == self.pincodeHash }
end

--duiHandlers
function AtmClass:duiCreator()
    local duiUrl = Config.DuiUrl
    local res = Config.DuiRes[self.atmModelHash] or Config.DuiRes.Default
    self.duiobject = CreateDui(duiUrl, res[1], res[2])
    print("DUI:", G_DuiIsReady)
    Wait(100)
    repeat
        SendDuiMessage(self.duiobject, json.encode({ type = "getDuiState" }))
        Wait(50)
    until G_DuiIsReady
    local atmData = Config.ATMs[self.atmModelHash]
    if not atmData then return end
    SendDuiMessage(self.duiobject, json.encode({
        type = "openATM",
        show = true,
        modelName = atmData.modelName,
        colorHash = atmData.colorHash,
        waterMarkLink = atmData.waterMarkLink,
        disablePincode = Config.DisablePincode,
        canDepostit = atmData.canDeposit
    }))
    SendDuiMessage(self.duiobject, json.encode({
        type = "updateData",
        money = self.money,
        bankMoney = self.bankMoney,
        pincodeHash = self.pincodeHash,
    }))
    self.duiHandler = GetDuiHandle(self.duiobject)
    local rand = math.random(1, 1000) -- doesnt need but why not
    G_Counter = G_Counter + 1
    local txdId = ("custom_txd_%s%s"):format(G_Counter, rand)
    local textureId = ("custom_texture_%s%s"):format(G_Counter, rand)
    local txd = CreateRuntimeTxd(txdId)
    CreateRuntimeTextureFromDuiHandle(txd, textureId, self.duiHandler)
    RemoveReplaceTexture(self.originalDict, self.originalTexture)
    AddReplaceTexture(self.originalDict, self.originalTexture, txdId, textureId)
    self.newDict = txdId
    self.newTexture = textureId
    SetNuiFocus(false, true)
end

function AtmClass:destroyDui()
    if self.duiobject then
        SendDuiMessage(self.duiobject, json.encode({ type = "openATM", show = false }))
        DestroyDui(self.duiobject)
    end
    Wait(50)
    G_DuiIsReady = false
    self.duiobject = nil
    RemoveReplaceTexture(self.newDict, self.newTexture)
    AddReplaceTexture(self.originalDict, self.originalTexture, self.originalDict, self.originalTexture)
    self.newDict = nil
    self.newTexture = nil
end

function AtmClass:openATM()
    AnimHandler.insertCardAnim(function()
        self:setCam()
    end)
    self:enableScorched()
    self:disableControls()
    self:duiCreator()
    self:inputHandler()
end

function AtmClass:exitATM()
    G_Opened = false
    self:destroyCam()
    TriggerServerEvent("esx_realistic_atm:handlers", "exitATM", self.atmId)
    self:destroyDui()
    self:disableScorched()
    SetNuiFocus(false, false)
    G_CurrentAtmHandler = nil
    self = nil
    ResetEntityAlpha(PlayerPedId())
end

-- NUI handlers
RegisterNUICallback("duiIsReady", function(_, cb)
    G_DuiIsReady = true
    cb({ ok = true })
end)

function NewATMHandler(currentATM, atmStringCoords, money, bankMoney, pincodeHash)
    if G_CurrentAtmHandler then
        G_CurrentAtmHandler:exitATM()
    end
    local atm = AtmClass:new(currentATM, atmStringCoords, money, bankMoney, pincodeHash)
    G_CurrentAtmHandler = atm
    return G_CurrentAtmHandler
end
