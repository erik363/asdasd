local Ratios = {
    {x = 0.34033613445378, y = 0.33973128598848, x2 = 0.36397058823529, y2 = 0.3637236084453}, -- btn 1
    {x = 0.34401260504202, y = 0.41554702495202, x2 = 0.36764705882353, y2 = 0.43857965451056}, -- btn 2
    {x = 0.34768907563025, y = 0.49520153550864, x2 = 0.37079831932773, y2 = 0.51631477927063}, -- btn 3
    {x = 0.35084033613445, y = 0.56525911708253, x2 = 0.37394957983193, y2 = 0.58541266794626}, -- btn 4
    {x = 0.60504201680672, y = 0.33973128598848, x2 = 0.6281512605042, y2 = 0.36276391554702}, -- btn 5 (1)
    {x = 0.60189075630252, y = 0.41554702495202, x2 = 0.625, y2 = 0.43953934740883}, -- btn 6 (2)
    {x = 0.59978991596639, y = 0.49520153550864, x2 = 0.62132352941176, y2 = 0.51727447216891}, -- btn 7 (3)
    {x = 0.59821428571429, y = 0.56525911708253, x2 = 0.6202731092437, y2 = 0.58925143953935}, -- btn 8 (4)
    {x = 0.4406512605042, y = 0.76775431861804, x2 = 0.45693277310924, y2 = 0.80134357005758}, -- 1
    {x = 0.46271008403361, y = 0.76775431861804, x2 = 0.47951680672269, y2 = 0.80134357005758}, -- 2
    {x = 0.48424369747899, y = 0.76775431861804, x2 = 0.50210084033613, y2 = 0.80038387715931}, -- 3
    {x = 0.50577731092437, y = 0.76775431861804, x2 = 0.52415966386555, y2 = 0.80134357005758}, -- CANCEL
    {x = 0.4375, y = 0.81094049904031, x2 = 0.45430672268908, y2 = 0.84740882917466}, -- 4
    {x = 0.46113445378151, y = 0.80998080614203, x2 = 0.47846638655462, y2 = 0.84740882917466}, -- 5
    {x = 0.48371848739496, y = 0.81094049904031, x2 = 0.50210084033613, y2 = 0.84644913627639}, -- 6
    {x = 0.5063025210084, y = 0.81094049904031, x2 = 0.52573529411765, y2 = 0.84836852207294}, -- CLEAR
    {x = 0.43487394957983, y = 0.85700575815739, x2 = 0.45273109243697, y2 = 0.89635316698656}, -- 7
    {x = 0.45903361344538, y = 0.85796545105566, x2 = 0.47794117647059, y2 = 0.89731285988484}, -- 8
    {x = 0.48266806722689, y = 0.85796545105566, x2 = 0.50210084033613, y2 = 0.89827255278311}, -- 9
    {x = 0.5063025210084, y = 0.85700575815739, x2 = 0.52731092436975, y2 = 0.89731285988484}, -- ENTER
    {x = 0.43172268907563, y = 0.90978886756238, x2 = 0.44957983193277, y2 = 0.95297504798464}, -- 
    {x = 0.45693277310924, y = 0.90882917466411, x2 = 0.47636554621849, y2 = 0.95393474088292}, -- 0
    {x = 0.48161764705882, y = 0.90882917466411, x2 = 0.50210084033613, y2 = 0.95489443378119}, -- 
    {x = 0.50682773109244, y = 0.90882917466411, x2 = 0.52836134453782, y2 = 0.95489443378119} -- 
}

local DuiObject = nil
local DuiIsReady = false
local Counter = 0
local NewDict = nil
local NewTexture = nil
local Opened = false
local CAM = nil
local CurrentATM = nil

-- Camera handlers

local function setCam(atmEntity)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(cam, 70.0)
    local offset = vector3(-0.09994507, -0.4500122, 1.379971)
    local camCoords = GetOffsetFromEntityInWorldCoords(atmEntity, offset.x, offset.y, offset.z)
    SetCamCoord(cam, camCoords.x, camCoords.y, camCoords.z)
    local camrot = vector3(-0.1, 3.739997, -0.7399989)
    PointCamAtEntity(cam, atmEntity, camrot.x, camrot.y, camrot.z, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
    CAM = cam
end

local function destroyCam()
    if CAM then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(CAM, false)
        CAM = nil
    end
end

-- Scorched ATM

local function disableScorched(atmEntity)
    if not Config.Scorched.SetScorched then return end
    if not DoesEntityExist(atmEntity) then return end
    if Config.Scorched.CustomFuncDisable then
        Config.Scorched.CustomFuncDisable(atmEntity)
        return
    end
    SetEntityRenderScorched(atmEntity, true)
    SetEntityRenderScorched(atmEntity, false)
end

local function enableScorched(atmEntity)
    if not Config.Scorched.SetScorched then return end
    if not DoesEntityExist(atmEntity) then return end
    if Config.Scorched.CustomFuncEnable then
        Config.Scorched.CustomFuncEnable(atmEntity)
        return
    end
    SetEntityRenderScorched(atmEntity, true)
end

-- playerControls

local function freezePedAndDisableControls(bool)
    local ped = PlayerPedId()
    --FreezeEntityPosition(ped, bool)
    if bool then
        --FreezeEntityPosition(ped, true)
    else
        --FreezeEntityPosition(ped, false)
    end
end

function exitATM()
    UseATM = false
    if not Opened then return end
    TriggerServerEvent("esx_realistic_atm:handlers", "exitATM", ATMCOORDS_STRING)
    Opened = false
    if DuiObject then
        SendDuiMessage(DuiObject, json.encode({ type = "openATM", show = false }))
        DestroyDui(DuiObject)
        DuiObject = nil
    end
    Wait(500)
    destroyCam()
    if NewDict and NewTexture then
        RemoveReplaceTexture(NewDict, NewTexture)
    end
    local atmData = Config.ATMs[GetEntityModel(CurrentATM)]
    if not atmData then return end
    local OD = atmData.OriginalDict
    local OT = atmData.OriginalTexture
    AddReplaceTexture(OD, OT, OD, OT)
    SetNuiFocus(false, false)
    freezePedAndDisableControls(false)
    CurrentATM = nil
    NewDict = nil
    NewTexture = nil
    enableScorched(CurrentATM)
end

local function startInputThread()
    Citizen.CreateThread(function()
        local resX, resY = GetActualScreenResolution()
        local function handleButtonClick(id)
            SendDuiMessage(DuiObject, json.encode({ type = "buttonClick", btnId = id }))
        end

        while Opened do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 24) then
                resX, resY = GetActualScreenResolution()
                local cursorX, cursorY = GetNuiCursorPosition()
                local ratioX = cursorX / resX
                local ratioY = cursorY / resY
                for i, ratio in ipairs(Ratios) do
                    if ratioX >= ratio.x and ratioX <= ratio.x2 and ratioY >= ratio.y and ratioY <= ratio.y2 then
                        handleButtonClick(i)
                        break
                    end
                end
                Wait(100)
            end
            if IsControlJustPressed(0, 177) then -- ESC
                exitATM()
            end
            
        end
    end)
end

function OpenATM(atmEntity, money, bankMoney, pincodeHash)
    freezePedAndDisableControls(true)
    local entityModel = GetEntityModel(atmEntity)
    local atmData = Config.ATMs[entityModel]
    if not atmData then return end
    CurrentATM = atmEntity
    Opened = true
    local duiUrl = ("nui://%s/web/index.html"):format(GetCurrentResourceName())
    DuiObject = CreateDui(duiUrl, 742, 512)
    Wait(500)
    repeat Wait(0) until DuiIsReady
    print("uggf")

    SendDuiMessage(DuiObject, json.encode({ type = "openATM", show = true, 
                colorHash = atmData.colorHash, 
                waterMarkLink = atmData.waterMarkLink, 
                canDepostit = atmData.canDeposit }))
    SendDuiMessage(DuiObject, json.encode({
        type = "updateData",
        money = money,
        bankMoney = bankMoney,
        pincodeHash = pincodeHash,
    }))

    local duiHandle = GetDuiHandle(DuiObject)
    local rand = math.random(1, 1000)
    Counter = Counter + 1
    local txdId = ("custom_txd_%s%s"):format(Counter, rand)
    local txd = CreateRuntimeTxd(txdId)
    local textureId = ("custom_texture_%s%s"):format(Counter, rand)

    CreateRuntimeTextureFromDuiHandle(txd, textureId, duiHandle)
    SetNuiFocus(false, true)
    local OD = atmData.OriginalDict
    local OT = atmData.OriginalTexture
    RemoveReplaceTexture(OD, OT)
    AddReplaceTexture(OD, OT, txdId, textureId)
    NewDict = txdId
    NewTexture = textureId
    setCam(atmEntity)
    disableScorched(atmEntity)
    startInputThread() 
end

-- NUI handlers

RegisterNUICallback("duiIsReady", function(_, cb)
    DuiIsReady = true
    cb({ok = true})
end)

