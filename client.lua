
local lastVehicle = nil
local lastBike = nil
Citizen.CreateThread(function()
    local sleeptime = 1500
    while true do
        if IsPedInAnyVehicle(PlayerPedId(),true) then
            if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) <=2.0 then
                if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == config.vehicle or GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == config.bicycle then
                    if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == config.bicycle then
                        lastBike = GetVehiclePedIsIn(PlayerPedId())
                        if lastVehicle ~= nil and GetEntityAttachedTo(lastBike) == 0 then
                            if #(GetEntityCoords(lastVehicle)-GetEntityCoords(lastBike)) <= 10.0 then
                                DrawMessage('Press ~g~E~w~ to attach')
                                sleeptime = 5
                                if IsControlJustPressed(0,38) then
                                    TaskLeaveVehicle(PlayerPedId(),lastBike,0)
                                    Wait(1500)
                                    AttachEntityToEntity(lastBike,lastVehicle,GetEntityBoneIndexByName(lastVehicle,'mod_col_2'),0.0,-1.0,2.2,0.0,0.0,0.0,0,0,1,0,1,1)
                                end
                            end
                        end
                    else
                        SetVehicleModKit(GetVehiclePedIsIn(PlayerPedId()),0)
                        if GetVehicleMod(GetVehiclePedIsIn(PlayerPedId()),config.modkitType) == config.modkit then
                            lastVehicle = GetVehiclePedIsIn(PlayerPedId())
                            local vehs = GetGamePool('CVehicle')
                            for i=1,#vehs,1 do
                                if GetEntityAttachedTo(vehs[i]) == lastVehicle then
                                    sleeptime = 5
                                    DrawMessage('Press ~g~E~w~ to attach')
                                    if IsControlJustPressed(0,38) then
                                        local coords = GetEntityCoords(lastVehicle)
                                        DetachEntity(vehs[i],0,0)
                                        SetEntityCoords(vehs[i],coords.x,coords.y+3.0,coords.z-5.0,false, false, false,false)
                                    end
                                break
                                end
                            end
                        else
                            lastVehicle = nil
                        end
                    end
                end
                if sleeptime == 1500 then
                    sleeptime = 2500
                end
            end
            else
                sleeptime = 1500
            end
        Wait(sleeptime)
    end
end)
function DrawMessage (message)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(255, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(message)
    DrawText(0.035, 0.755)
end