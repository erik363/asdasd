--
local G_Counter = 0
local G_Opened = false
local G_DuiIsReady = false
--

local AtmClass = {}
AtmClass.__index = AtmClass

function AtmClass:new(currentATM, atmStringCoords)
    local self = setmetatable({}, AtmClass)
    self.atmStringCoords = atmStringCoords
    self.duiobject = nil
    self.duiHandler = nil
    self.currentATM = currentATM
    self.atmModelHash = GetEntityModel(currentATM)
    self.cam = nil
    self.camOffset = Config.CamOffsets[self.atmModelHash] or Config.CamOffsets.Default
    self.camRot = Config.CamRots[self.atmModelHash] or Config.CamRots.Default
    self.ratios = Config.Ratios[self.atmModelHash] or Config.Ratios.Default
    self.newDict = nil
    self.newTexture = nil
    self.originalDict = Config.ATMs[self.atmModelHash].OriginalDict
    self.originalTexture = Config.ATMs[self.atmModelHash].OriginalTexture
    self.pincodeHash = nil

    self.money = 0
    self.bankMoney = 0
    self.pincodeHash = 0
    return self
end

function AtmClass:setCam()
    self.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(self.cam, Config.CameraFov or 70.0)
    local camCoords = GetOffsetFromEntityInWorldCoords(self.currentATM, self.camOffset.x, self.camOffset.y, self.camOffset.z)
    SetCamCoord(self.cam, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtEntity(self.cam, self.currentATM, self.camRot.x, self.camRot.y, self.camRot.z, true)
    SetCamActive(self.cam, true)
    RenderScriptCams(true, true, Config.CamEase, true, true)
end

function AtmClass:destroyCam()
    if self.cam then
        RenderScriptCams(false, true, Config.CamEase, true, true)
        DestroyCam(self.cam, false)
        self.cam = nil
    end
end

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

function AtmClass:disableControls()
    Citizen.CreateThread(function()
        while G_Opened do
            Wait(0)
            --DisableControlAction(0, 1, true)
            --DisableControlAction(0, 2, true)
            --DisableControlAction(0, 142, true)
            --DisableControlAction(0, 18, true)
            --DisableControlAction(0, 322, true)
            --DisableControlAction(0, 106, true)
        end
    end)
end

function AtmClass:inputHandler()
    Citizen.CreateThread(function()
        local resX, resY = GetActualScreenResolution()
        local function handleButtonClick(id)
            SendDuiMessage(self.duiobject, json.encode({ type = "buttonClick", btnId = id }))
        end
        SetNuiFocus(false, true)
        while G_Opened do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 24) then
                resX, resY = GetActualScreenResolution()
                local cursorX, cursorY = GetNuiCursorPosition()
                local ratioX = cursorX / resX
                local ratioY = cursorY / resY
                for i, ratio in ipairs(self.ratios) do
                    if ratioX >= ratio.x and ratioX <= ratio.x2 and ratioY >= ratio.y and ratioY <= ratio.y2 then
                        handleButtonClick(i)
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

function AtmClass:openATM(money, bankMoney, pincodeHash)
    if G_Opened then return end
    AnimHandler.insertCardAnim(function()
        self.money = money
        self.bankMoney = bankMoney
        self.pincodeHash = pincodeHash
        Citizen.CreateThread(function()
            TriggerServerEvent("esx_realistic_atm:handlers", "openATM", ATMCOORDS_STRING)
            G_Opened = true
            self:setCam()
            self:enableScorched()
            print('111')
            self:disableControls()
            print(222)
            local duiUrl = ("nui://%s/web/index.html"):format(GetCurrentResourceName())
            local res = Config.DuiRes[self.atmModelHash] or Config.DuiRes.Default
            self.duiobject = CreateDui(duiUrl, res[1], res[2])
            Wait(100)
            repeat Wait(0) until G_DuiIsReady
            local atmData = Config.ATMs[self.atmModelHash]
            SendDuiMessage(self.duiobject, json.encode({ type = "openATM", show = true, 
                        colorHash = atmData.colorHash, 
                        waterMarkLink = atmData.waterMarkLink, 
                        canDepostit = atmData.canDeposit }))
            SendDuiMessage(self.duiobject, json.encode({
                type = "updateData",
                money = money,
                bankMoney = bankMoney,
                pincodeHash = pincodeHash,
            }))
            self.duiHandler = GetDuiHandle(self.duiobject)
            local rand = math.random(1, 1000)
            G_Counter = G_Counter + 1
            local txdId = ("custom_txd_%s%s"):format(G_Counter, rand)
            local txd = CreateRuntimeTxd(txdId)
            local textureId = ("custom_texture_%s%s"):format(G_Counter, rand)
            CreateRuntimeTextureFromDuiHandle(txd, textureId, self.duiHandler)
            SetNuiFocus(false, true)
            RemoveReplaceTexture(self.originalDict, self.originalTexture)
            AddReplaceTexture(self.originalDict, self.originalTexture, txdId, textureId)
            self.newDict = txdId
            self.newTexture = textureId
            print("hesyyy")
            self:inputHandler()
        end)
    end)
end

function AtmClass:exitATM()
    G_Opened = false
    self:destroyCam()
    TriggerServerEvent("esx_realistic_atm:handlers", "exitATM", ATMCOORDS_STRING)
    SendDuiMessage(self.duiobject, json.encode({ type = "openATM", show = false }))
    Wait(10)
    DestroyDui(self.duiobject)
    G_DuiIsReady = false
    self.duiobject = nil
    Wait(50)
    RemoveReplaceTexture(self.originalDict, self.originalTexture)
    AddReplaceTexture(self.originalDict, self.originalTexture, self.newDict, self.newTexture)
    self.newDict = nil
    self.newTexture = nil
    self:disableScorched()
    SetNuiFocus(false, false)
    self = nil
end

function AtmClass:insertCard(cardObj)
    FreezeEntityPosition(cardObj, true)
    local offset = Config.Offsets.CardPos[self.atmModelHash] or Config.Offsets.CardPos.Default
    local coords = GetOffsetFromEntityInWorldCoords(self.currentATM, offset.First.x, offset.First.y, offset.First.z)
    SetEntityCoords(cardObj, coords.x, coords.y, coords.z)
    local heading = GetEntityHeading(self.currentATM)
    SetEntityRotation(cardObj, -90.0, 90.0, heading, 2, true)
    local isSliding = false
    local secondCoords = GetOffsetFromEntityInWorldCoords(self.currentATM, offset.Second.x, offset.Second.y, offset.Second.z)
    while not isSliding do
        isSliding = SlideObject(cardObj, secondCoords.x, secondCoords.y, secondCoords.z, 0.001, 0.001, 0.001, false)
        Wait(10)
    end
end

function AtmClass:checkPin(pin)
    if not self.pincodeHash then return end
    local pinHash = GetHashKey(pin)
    return { isAccepted = pinHash == self.pincodeHash }
end


function NewATMHandler(currentATM, atmStringCoords)
    return AtmClass:new(currentATM, atmStringCoords)
end

RegisterNUICallback("duiIsReady", function(_, cb)
    G_DuiIsReady = true
    cb({ok = true})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local cursorX, cursorY = GetNuiCursorPosition()
        local resX, resY = GetActualScreenResolution()
        local ratioX = cursorX / resX
        local ratioY = cursorY / resY
        --exports['qb-core']:DrawText(('%s - %s'):format(ratioX, ratioY), 0.5)
        if IsControlPressed(0, 38) then -- E key
            print(ratioX, ratioY)
            Wait(300)
        end
    end
end)

local configCam = nil
local configAtm = nil
RegisterCommand('cameraconfig', function()
    local obj = CreateObject(`prop_atm_01`, GetEntityCoords(PlayerPedId()) + vector3(0, 1.0, 0), true, false, false)
    configAtm = obj
    SetEntityAsMissionEntity(obj, true, true)
    FreezeEntityPosition(obj, true)

    local atmCoords = GetOffsetFromEntityInWorldCoords(obj, 0, -0.4, 0.0)
    local atmCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(atmCam, atmCoords.x, atmCoords.y, atmCoords.z + 1.2)
    PointCamAtEntity(atmCam, obj, 0.0, 0.2, 1.05, true)
    SetCamActive(atmCam, true)
    SetCamFov(atmCam, 70.0)
    RenderScriptCams(true, false, 0, true, true)
    configCam = atmCam

    Citizen.CreateThread(function()
        local camCoords = vector3(atmCoords.x, atmCoords.y, atmCoords.z + 1.2)
        local camPoint = vector3(0.0, 0.2, 1.0)
        while true do
            Citizen.Wait(0)
            
            if IsControlPressed(0, 32) then -- W key
                camCoords = vector3(camCoords.x, camCoords.y, camCoords.z + 0.01)
                SetCamCoord(configCam, camCoords.x, camCoords.y, camCoords.z)
                Wait(100)
            end
            if IsControlPressed(0, 33) then -- S key
                camCoords = vector3(camCoords.x, camCoords.y, camCoords.z - 0.01)
                SetCamCoord(configCam, camCoords.x, camCoords.y, camCoords.z)

            end
            if IsControlPressed(0, 34) then -- A key
                camCoords = vector3(camCoords.x, camCoords.y - 0.01, camCoords.z)
                SetCamCoord(configCam, camCoords.x, camCoords.y, camCoords.z)
            end
            if IsControlPressed(0, 35) then -- D key
                camCoords = vector3(camCoords.x, camCoords.y + 0.01, camCoords.z)
                SetCamCoord(configCam, camCoords.x, camCoords.y, camCoords.z)
            end
            if IsControlPressed(0, 44) then -- Q key
                camCoords = vector3(camCoords.x - 0.01, camCoords.y, camCoords.z)
                SetCamCoord(configCam, camCoords.x, camCoords.y, camCoords.z)
            end
            if IsControlPressed(0, 38) then -- E key
                camCoords = vector3(camCoords.x + 0.01, camCoords.y, camCoords.z)
                SetCamCoord(configCam, camCoords.x, camCoords.y, camCoords.z)
            end

            if IsControlPressed(0, 172) then -- Arrow Up
                camPoint = vector3(camPoint.x, camPoint.y, camPoint.z + 0.01)
                PointCamAtEntity(configCam, configAtm, camPoint.x, camPoint.y, camPoint.z, true)
            end
            if IsControlPressed(0, 173) then -- Arrow Down
                camPoint = vector3(camPoint.x, camPoint.y, camPoint.z - 0.01)
                PointCamAtEntity(configCam, configAtm, camPoint.x, camPoint.y, camPoint.z, true)
            end
            if IsControlPressed(0, 174) then -- Arrow Left
                camPoint = vector3(camPoint.x, camPoint.y - 0.01, camPoint.z)
                PointCamAtEntity(configCam, configAtm, camPoint.x, camPoint.y, camPoint.z, true)
            end
            if IsControlPressed(0, 175) then -- Arrow Right
                camPoint = vector3(camPoint.x, camPoint.y + 0.01, camPoint.z)
                PointCamAtEntity(configCam, configAtm, camPoint.x, camPoint.y, camPoint.z, true)
            end
            if IsControlPressed(0, 10) then -- Page Up key
                camPoint = vector3(camPoint.x + 0.01, camPoint.y, camPoint.z)
                PointCamAtEntity(configCam, configAtm, camPoint.x, camPoint.y, camPoint.z, true)
            end
            if IsControlPressed(0, 11) then -- Page Down key
                camPoint = vector3(camPoint.x - 0.01, camPoint.y, camPoint.z)
                PointCamAtEntity(configCam, configAtm, camPoint.x, camPoint.y, camPoint.z, true)
            end

            if IsControlJustPressed(0, 47) then -- G key
                local offset = GetOffsetFromEntityGivenWorldCoords(configAtm, camCoords.x, camCoords.y, camCoords.z)
                print("Camera Offset: ", offset)
                print("Camera Rotation: ", camPoint)
            end
        end
    end)
end, false)