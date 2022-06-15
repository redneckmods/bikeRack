local lastVehicle, lastBike, vehicleId, bikeId = nil, nil, nil, nil

function GetBike(hash)
    for i=1, #config.bike do
        if config.bike[i].bike == hash then
            bikeId = i
            return i
        end
    end
end

function GetVehicle(hash)
    for i=1, #config.vehicle do
        if config.vehicle[i].vehicle == hash then
            vehicleId = i
            return i
        end
    end
end

AddEventHandler("gameEventTriggered", function(name)
    if name == 'CEventNetworkPlayerEnteredVehicle' then
        local sleeptime = 1500
        local CurrentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if GetBike(GetEntityModel(CurrentVehicle)) or GetVehicle(GetEntityModel(CurrentVehicle)) then
            while true do
                local Ped = PlayerPedId()
                if GetVehiclePedIsIn(Ped) == CurrentVehicle then
                    if GetEntitySpeed(CurrentVehicle) <= 2.0 then
                        if GetBike(GetEntityModel(CurrentVehicle)) then
                            lastBike = CurrentVehicle
                            if lastVehicle and GetEntityAttachedTo(lastBike) == 0 then
                                if #(GetEntityCoords(lastVehicle) - GetEntityCoords(lastBike)) <= 10.0 then
                                    DrawMessage('Press ~g~K~s~ to attach')
                                    sleeptime = 5
                                    if IsControlJustPressed(0, 311) then
                                        TaskLeaveVehicle(Ped, lastBike, 0)
                                        Wait(1500)
                                        AttachEntityToEntity(lastBike, lastVehicle, GetEntityBoneIndexByName(lastVehicle, 'mod_col_2'), config.vehicle[vehicleId].offset, config.bike[bikeId].rot, 0, 0, 1, 0, 1, 1)
                                    end
                                end
                            end
                        elseif GetVehicle(GetEntityModel(CurrentVehicle)) then
                            lastVehicle = CurrentVehicle
                            SetVehicleModKit(CurrentVehicle, 0)
                            if GetVehicleMod(CurrentVehicle, config.vehicle[vehicleId].mType) == config.vehicle[vehicleId].mId then
                                lastVehicle = CurrentVehicle
                                local Vehs = GetGamePool('CVehicle')
                                if GetEntityAttachedTo(lastBike) == lastVehicle then
                                    sleeptime = 5
                                    DrawMessage('Press ~g~K~s~ to detach')
                                    if IsControlJustPressed(0, 311) then
                                        local Coords = GetEntityCoords(lastVehicle)
                                        DetachEntity(lastBike, 0, 0)
                                        SetEntityCoords(lastBike,Coords.x,Coords.y+3.0,Coords.z-5.0,false, false, false,false)
                                        sleeptime = 1500
                                    end
                                else
                                    for i=1, #Vehs do
                                        if GetEntityAttachedTo(Vehs[i]) == lastVehicle then
                                            sleeptime = 5
                                            DrawMessage('Press ~g~K~s~ to detach')
                                            if IsControlJustPressed(0, 311) then
                                                local Coords = GetEntityCoords(lastVehicle)
                                                DetachEntity(Vehs[i], 0, 0)
                                                SetEntityCoords(Vehs[i],Coords.x,Coords.y+3.0,Coords.z-5.0,false, false, false,false)
                                                sleeptime = 1500
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            lastVehicle = nil
                            vehicleId = nil
                        end
                    end
                else
                    break
                end
                Wait(sleeptime)
            end
        end
    end
end)

function DrawMessage(message)
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